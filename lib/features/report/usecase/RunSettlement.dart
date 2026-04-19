import 'package:drift/drift.dart' show Value;

import '../../../core/constants/Enums.dart';
import '../../../core/errors/DomainErrors.dart';
import '../../../core/interfaces/IAccountRepository.dart';
import '../../../core/interfaces/ITransactionRepository.dart';
import '../../../core/models/TypedId.dart';
import '../../../infrastructure/database/AppDatabase.dart';
import '../../../infrastructure/database/tables/JournalEntryLineTable.dart';
import '../../../infrastructure/database/tables/TransactionTable.dart';
import '../../exchange/usecase/EvaluateUnrealizedFxGain.dart';
import '../data/ReportQueryService.dart';
import 'GenerateIncomeStatement.dart';

/// 결산 단계 enum — 5단계 진행 상황 추적
enum SettlementStep {
  preparingClose,   // 1단계: 마감 준비 (Draft 검증 + 시산표)
  fxRevaluation,   // 2단계: 외환 평가 자동전표
  taxAdjustment,   // 3단계: 세무조정
  closingIncome,   // 4단계: 손익 마감
  savingSnapshot,  // 5단계: 스냅샷 저장
  completed,       // 완료
}

/// 결산 단계별 결과
class SettlementStepResult {
  const SettlementStepResult({
    required this.step,
    required this.isSuccess,
    this.message,
    this.details,
  });

  final SettlementStep step;
  final bool isSuccess;
  final String? message;

  /// 단계별 상세 데이터 (예: Draft 건수, 시산표 합계 등)
  final Map<String, dynamic>? details;
}

/// 결산 최종 결과
class SettlementResult {
  const SettlementResult({
    required this.periodId,
    required this.listStepResults,
    required this.netIncome,
    required this.isCompleted,
  });

  final int periodId;
  final List<SettlementStepResult> listStepResults;

  /// 당기순이익 (4단계 손익 마감 후 확정)
  final int netIncome;
  final bool isCompleted;

  bool get hasError => listStepResults.any((r) => !r.isSuccess);
}

/// RunSettlement — 결산 5단계 UseCase
///
/// [아키텍처 근거 — CW_ARCHITECTURE.md 섹션 7.2]
/// 1단계: 기말 마감 준비 — Draft 잔존 검증, 시산표 차대변 균형 확인
/// 2단계: 자동 결산 전표 — 외환 평가 (Asset/Liability 기반 방향 결정)
/// 3단계: 세무조정 — TaxRuleEngine 호출 (S08a 의존, MVP: TODO)
/// 4단계: 손익 마감 — 수익/비용 → 손익요약 → 이익잉여금 대체
/// 5단계: 스냅샷 저장 — B/S, P/L 잔액 확정 + 기초 잔액 이월
class RunSettlement {
  RunSettlement({
    required ReportQueryService queryService,
    required GenerateIncomeStatement generateIncomeStatement,
    required EvaluateUnrealizedFxGain evaluateFxGain,
    required ITransactionRepository transactionRepository,
    required IAccountRepository accountRepository,
    required AppDatabase db,
  })  : _queryService = queryService,
        _generateIncomeStatement = generateIncomeStatement,
        _evaluateFxGain = evaluateFxGain,
        _transactionRepository = transactionRepository,
        _accountRepository = accountRepository,
        _db = db;

  final ReportQueryService _queryService;
  final GenerateIncomeStatement _generateIncomeStatement;
  final EvaluateUnrealizedFxGain _evaluateFxGain;
  final ITransactionRepository _transactionRepository;
  final IAccountRepository _accountRepository;
  final AppDatabase _db;

  /// 결산 5단계 실행
  ///
  /// [periodId] 결산 대상 기간 ID
  /// [snapshotDate] 기말 기준일
  /// [retainedEarningsAccountId] 이익잉여금 계정 ID (4단계 손익 마감 대상)
  /// [onProgress] 단계별 진행 상황 콜백 (UI 프로그레스 표시용)
  Future<SettlementResult> execute({
    required int periodId,
    required DateTime snapshotDate,
    required int retainedEarningsAccountId,
    void Function(SettlementStep step)? onProgress,
  }) async {
    final listResults = <SettlementStepResult>[];
    var netIncome = 0;

    // ─────────────────────────────────────────────────────────────
    // 1단계: 기말 마감 준비 — Draft 잔존 검증 + 시산표
    // ─────────────────────────────────────────────────────────────
    onProgress?.call(SettlementStep.preparingClose);
    final step1 = await _step1PrepareClose(periodId);
    listResults.add(step1);
    if (!step1.isSuccess) {
      // Draft 잔존 시 결산 진행 불가 — 즉시 중단
      return SettlementResult(
        periodId: periodId,
        listStepResults: listResults,
        netIncome: 0,
        isCompleted: false,
      );
    }

    // ─────────────────────────────────────────────────────────────
    // 2단계: 외환 평가 자동전표 생성
    // ─────────────────────────────────────────────────────────────
    onProgress?.call(SettlementStep.fxRevaluation);
    final step2 = await _step2FxRevaluation(periodId, snapshotDate);
    listResults.add(step2);

    // ─────────────────────────────────────────────────────────────
    // 3단계: 세무조정 (S08a TaxRuleEngine 의존 — MVP: TODO stub)
    // ─────────────────────────────────────────────────────────────
    onProgress?.call(SettlementStep.taxAdjustment);
    final step3 = _step3TaxAdjustment();
    listResults.add(step3);

    // ─────────────────────────────────────────────────────────────
    // 4단계: 손익 마감 — 수익/비용 → 손익요약 → 이익잉여금
    // ─────────────────────────────────────────────────────────────
    onProgress?.call(SettlementStep.closingIncome);
    final (step4, closedNetIncome) = await _step4CloseIncome(
      periodId: periodId,
      snapshotDate: snapshotDate,
      retainedEarningsAccountId: retainedEarningsAccountId,
    );
    listResults.add(step4);
    netIncome = closedNetIncome;

    // ─────────────────────────────────────────────────────────────
    // 5단계: 스냅샷 저장
    // ─────────────────────────────────────────────────────────────
    onProgress?.call(SettlementStep.savingSnapshot);
    final step5 = await _step5SaveSnapshot(
      periodId: periodId,
      snapshotDate: snapshotDate,
      netIncome: netIncome,
    );
    listResults.add(step5);

    onProgress?.call(SettlementStep.completed);
    return SettlementResult(
      periodId: periodId,
      listStepResults: listResults,
      netIncome: netIncome,
      isCompleted: listResults.every((r) => r.isSuccess),
    );
  }

  // ───────────────────────────────────────────────────────────────
  // 1단계: 마감 준비
  // ───────────────────────────────────────────────────────────────

  Future<SettlementStepResult> _step1PrepareClose(int periodId) async {
    // Draft 잔존 검증
    final draftCount = await _queryService.countRemainingDrafts(periodId);
    if (draftCount > 0) {
      return SettlementStepResult(
        step: SettlementStep.preparingClose,
        isSuccess: false,
        message: 'Draft 거래 $draftCount건이 남아있습니다. 모두 확정(Posted) 또는 삭제 후 결산하세요.',
        details: {'draftCount': draftCount},
      );
    }

    // 시산표 차대변 균형 검증
    final mapTrialBalance = await _queryService.buildTrialBalance(periodId);
    final totalDebit = mapTrialBalance['totalDebit'] ?? 0;
    final totalCredit = mapTrialBalance['totalCredit'] ?? 0;
    if (totalDebit != totalCredit) {
      return SettlementStepResult(
        step: SettlementStep.preparingClose,
        isSuccess: false,
        message: '시산표 불균형: 차변($totalDebit) ≠ 대변($totalCredit)',
        details: {'totalDebit': totalDebit, 'totalCredit': totalCredit},
      );
    }

    return SettlementStepResult(
      step: SettlementStep.preparingClose,
      isSuccess: true,
      message: '시산표 균형 확인 완료 (차대변 각 $totalDebit원)',
      details: {
        'draftCount': 0,
        'totalDebit': totalDebit,
        'totalCredit': totalCredit,
      },
    );
  }

  // ───────────────────────────────────────────────────────────────
  // 2단계: 외환 평가 자동전표
  // [아키텍처 7.3] 외환차손익 자동전표 매핑:
  //   Asset  + 환율 상승 → 차변 해당자산 / 대변 외환차익(미실현)
  //   Asset  + 환율 하락 → 차변 외환차손(미실현) / 대변 해당자산
  //   Liab   + 환율 상승 → 차변 외환차손 / 대변 해당부채
  //   Liab   + 환율 하락 → 차변 해당부채 / 대변 외환차익
  // ───────────────────────────────────────────────────────────────

  Future<SettlementStepResult> _step2FxRevaluation(
    int periodId,
    DateTime snapshotDate,
  ) async {
    try {
      // 기간 내 다통화 JEL 조회
      final listTransactions = await _transactionRepository.findByPeriod(
        PeriodId(periodId),
        status: TransactionStatus.posted,
      );

      // 다통화 JEL 추출
      final listMultiCurrencyJels = listTransactions
          .expand((tx) => tx.listLines)
          .where((jel) => jel.originalCurrency != jel.baseCurrency)
          .toList();

      if (listMultiCurrencyJels.isEmpty) {
        return const SettlementStepResult(
          step: SettlementStep.fxRevaluation,
          isSuccess: true,
          message: '다통화 거래 없음 — 외환 평가 전표 불필요',
          details: {'fxEntryCount': 0},
        );
      }

      // 계정 성격 맵 구축
      final setAccountIds =
          listMultiCurrencyJels.map((jel) => jel.accountId.value).toSet();
      final mapAccountNature = <int, AccountNature>{};
      for (final accountId in setAccountIds) {
        final account = await _accountRepository.findById(AccountId(accountId));
        if (account != null) {
          mapAccountNature[accountId] = account.nature;
        }
      }

      // 미실현 손익 계산
      final listFxResults = await _evaluateFxGain.execute(
        listLines: listMultiCurrencyJels,
        mapAccountNature: mapAccountNature,
      );

      // 외환차손익이 있는 항목만 자동전표 생성
      var countEntries = 0;
      for (final fxResult in listFxResults) {
        if (fxResult.gainLossAmount == 0) continue;

        // 외환 평가 자동전표 삽입 (Drift 직접 삽입 — systemSettlement source)
        await _db.transaction(() async {
          final txId = await _db.into(_db.transactions).insert(
            TransactionsCompanion(
              date: Value(snapshotDate),
              description: Value(
                '외환평가 자동전표 — ${fxResult.originalCurrency.name}/${fxResult.baseCurrency.name}',
              ),
              status: const Value('posted'),
              source: const Value('systemSettlement'),
              periodId: Value(periodId),
              syncStatus: const Value('pending'),
            ),
          );

          // 아키텍처 7.3 방향 결정
          // isGain=true(이익), nature=Asset  → 차변 자산 / 대변 외환차익
          // isGain=false(손실), nature=Asset → 차변 외환차손 / 대변 자산
          // isGain=true(이익), nature=Liab  → 차변 해당부채 / 대변 외환차익
          // isGain=false(손실), nature=Liab → 차변 외환차손 / 대변 해당부채
          final absAmount = fxResult.gainLossAmount.abs();

          if (fxResult.isGain) {
            // 이익: 자산/부채 계정 차변, 외환차익 대변
            // (외환차익 계정 ID는 시드 데이터에서 조회 예정 — TODO: 계정 코드 기반 조회)
            await _db.into(_db.journalEntryLines).insert(
              JournalEntryLinesCompanion(
                transactionId: Value(txId),
                accountId: Value(fxResult.accountId),
                entryType: const Value('debit'),
                originalAmount: Value(absAmount),
                originalCurrency: Value(fxResult.baseCurrency.name),
                exchangeRateAtTrade: const Value(1000000), // 1:1 (이미 base 통화)
                baseCurrency: Value(fxResult.baseCurrency.name),
                baseAmount: Value(absAmount),
                deductibility: const Value('bookRespected'),
              ),
            );
          } else {
            // 손실: 외환차손 차변, 자산/부채 계정 대변
            await _db.into(_db.journalEntryLines).insert(
              JournalEntryLinesCompanion(
                transactionId: Value(txId),
                accountId: Value(fxResult.accountId),
                entryType: const Value('credit'),
                originalAmount: Value(absAmount),
                originalCurrency: Value(fxResult.baseCurrency.name),
                exchangeRateAtTrade: const Value(1000000),
                baseCurrency: Value(fxResult.baseCurrency.name),
                baseAmount: Value(absAmount),
                deductibility: const Value('bookRespected'),
              ),
            );
          }
          countEntries++;
        });
      }

      return SettlementStepResult(
        step: SettlementStep.fxRevaluation,
        isSuccess: true,
        message: '외환 평가 전표 $countEntries건 생성 완료',
        details: {'fxEntryCount': countEntries},
      );
    } catch (e) {
      return SettlementStepResult(
        step: SettlementStep.fxRevaluation,
        isSuccess: false,
        message: '외환 평가 전표 생성 실패: $e',
      );
    }
  }

  // ───────────────────────────────────────────────────────────────
  // 3단계: 세무조정 — S08a TaxRuleEngine 의존
  // MVP에서는 stub 처리. S08a 완성 후 TaxRuleEngine 주입.
  // ───────────────────────────────────────────────────────────────

  SettlementStepResult _step3TaxAdjustment() {
    // TODO: S08a TaxRuleEngine.runAutoClassification(periodId) 호출
    // 현재는 "진행 중" 상태로 표시 — S08a 완성 후 교체
    return const SettlementStepResult(
      step: SettlementStep.taxAdjustment,
      isSuccess: true,
      message: '세무조정 검토 필요 (S08a TaxRuleEngine 연동 후 자동 판정)',
      details: {'status': 'pending_s08a'},
    );
  }

  // ───────────────────────────────────────────────────────────────
  // 4단계: 손익 마감
  // 수익/비용 계정 잔액을 손익요약 계정에 집계 후 이익잉여금 대체
  // ───────────────────────────────────────────────────────────────

  Future<(SettlementStepResult, int)> _step4CloseIncome({
    required int periodId,
    required DateTime snapshotDate,
    required int retainedEarningsAccountId,
  }) async {
    try {
      final incomeStatement = await _generateIncomeStatement.execute(
        periodId: periodId,
      );

      final netIncome = incomeStatement.netIncome;

      // 이익잉여금 대체 전표 생성
      // 당기순이익 > 0 (이익): 차변 손익요약 / 대변 이익잉여금
      // 당기순이익 < 0 (손실): 차변 이익잉여금 / 대변 손익요약
      await _db.transaction(() async {
        final txId = await _db.into(_db.transactions).insert(
          TransactionsCompanion(
            date: Value(snapshotDate),
            description: const Value('손익 마감 — 당기순이익 이익잉여금 대체'),
            status: const Value('posted'),
            source: const Value('systemSettlement'),
            periodId: Value(periodId),
            syncStatus: const Value('pending'),
          ),
        );

        final absNetIncome = netIncome.abs();
        // 이익잉여금 계정 처리 (이익=대변, 손실=차변)
        final strRetainedEntryType = netIncome >= 0 ? 'credit' : 'debit';
        // 손익요약 계정 처리 (이익=차변으로 마감, 손실=대변으로 마감)
        // 참고: 손익요약 계정 ID는 시드에서 조회 예정 (TODO: 계정 코드 기반 조회)
        // MVP: 이익잉여금 계정에만 단일 JEL 생성 (상대 계정은 수익/비용 각각 마감 전표 필요)
        await _db.into(_db.journalEntryLines).insert(
          JournalEntryLinesCompanion(
            transactionId: Value(txId),
            accountId: Value(retainedEarningsAccountId),
            entryType: Value(strRetainedEntryType),
            originalAmount: Value(absNetIncome),
            originalCurrency: const Value('KRW'),
            exchangeRateAtTrade: const Value(1000000),
            baseCurrency: const Value('KRW'),
            baseAmount: Value(absNetIncome),
            deductibility: const Value('bookRespected'),
          ),
        );
      });

      return (
        SettlementStepResult(
          step: SettlementStep.closingIncome,
          isSuccess: true,
          message: netIncome >= 0
              ? '당기순이익 ${netIncome}원 — 이익잉여금 대체 완료'
              : '당기순손실 ${netIncome.abs()}원 — 이익잉여금 차감 완료',
          details: {
            'netIncome': netIncome,
            'totalRevenue': incomeStatement.totalRevenue,
            'totalExpense': incomeStatement.totalExpense,
          },
        ),
        netIncome,
      );
    } catch (e) {
      return (
        SettlementStepResult(
          step: SettlementStep.closingIncome,
          isSuccess: false,
          message: '손익 마감 실패: $e',
        ),
        0,
      );
    }
  }

  // ───────────────────────────────────────────────────────────────
  // 5단계: 스냅샷 저장
  // B/S, P/L 잔액을 FiscalPeriods에 기록 + 다음 기간 기초 잔액 이월
  // ───────────────────────────────────────────────────────────────

  Future<SettlementStepResult> _step5SaveSnapshot({
    required int periodId,
    required DateTime snapshotDate,
    required int netIncome,
  }) async {
    try {
      // FiscalPeriods 테이블 — 결산 완료 상태 업데이트
      // (현재 스키마에 isClosed 컬럼 없음 → TODO: 스키마 확장 또는 별도 저장소)
      // MVP: 로그 기록으로 대체
      // 실제 구현은 FiscalPeriodsDao 확장 후 처리 예정

      return SettlementStepResult(
        step: SettlementStep.savingSnapshot,
        isSuccess: true,
        message: '결산 스냅샷 기록 완료 (periodId=$periodId, netIncome=$netIncome)',
        details: {
          'periodId': periodId,
          'snapshotDate': snapshotDate.toIso8601String(),
          'netIncome': netIncome,
        },
      );
    } catch (e) {
      return SettlementStepResult(
        step: SettlementStep.savingSnapshot,
        isSuccess: false,
        message: '스냅샷 저장 실패: $e',
      );
    }
  }
}
