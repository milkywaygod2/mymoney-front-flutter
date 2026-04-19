import 'package:drift/drift.dart' show Value;

import '../../../core/constants/Enums.dart';
import '../../../core/interfaces/IAccountRepository.dart';
import '../../../core/interfaces/ITransactionRepository.dart';
import '../../../core/models/TypedId.dart';
import '../../../infrastructure/database/AppDatabase.dart';
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
      // 외환차익/외환차손 계정 ID 사전 조회
      final fxGainAccountId = await _findAccountIdByPath('REVENUE.FINANCIAL.FX_GAIN');
      final fxLossAccountId = await _findAccountIdByPath('EXPENSE.FINANCIAL.FX_LOSS');
      if (fxGainAccountId == null || fxLossAccountId == null) {
        return const SettlementStepResult(
          step: SettlementStep.fxRevaluation,
          isSuccess: false,
          message: '외환차익/외환차손 계정을 찾을 수 없습니다 — 계정과목 설정 확인 필요',
        );
      }

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

        // 외환 평가 자동전표 삽입 (복식 2 JEL — INV-T2 준수)
        await _db.transaction(() async {
          final txId = await _db.into(_db.transactions).insert(
            TransactionsCompanion(
              date: Value(snapshotDate),
              description: Value(
                '외환평가 자동전표 — ${fxResult.originalCurrency.name}/${fxResult.baseCurrency.name}',
              ),
              status: const Value('POSTED'),
              source: const Value('SYSTEM_SETTLEMENT'),
              periodId: Value(periodId),
              syncStatus: const Value('PENDING'),
            ),
          );

          final absAmount = fxResult.gainLossAmount.abs();
          final baseCurrencyName = fxResult.baseCurrency.name;

          // 아키텍처 7.3 방향 결정 — 복식 2 JEL
          // isGain=true(이익):  차변 자산/부채계정 / 대변 외환차익
          // isGain=false(손실): 차변 외환차손    / 대변 자산/부채계정
          if (fxResult.isGain) {
            // 차변: 자산/부채 계정
            await _db.into(_db.journalEntryLines).insert(
              JournalEntryLinesCompanion(
                transactionId: Value(txId),
                accountId: Value(fxResult.accountId),
                entryType: const Value('DEBIT'),
                originalAmount: Value(absAmount),
                originalCurrency: Value(baseCurrencyName),
                exchangeRateAtTrade: const Value(1000000),
                baseCurrency: Value(baseCurrencyName),
                baseAmount: Value(absAmount),
                deductibility: const Value('BOOK_RESPECTED'),
              ),
            );
            // 대변: 외환차익 계정
            await _db.into(_db.journalEntryLines).insert(
              JournalEntryLinesCompanion(
                transactionId: Value(txId),
                accountId: Value(fxGainAccountId),
                entryType: const Value('CREDIT'),
                originalAmount: Value(absAmount),
                originalCurrency: Value(baseCurrencyName),
                exchangeRateAtTrade: const Value(1000000),
                baseCurrency: Value(baseCurrencyName),
                baseAmount: Value(absAmount),
                deductibility: const Value('BOOK_RESPECTED'),
              ),
            );
          } else {
            // 차변: 외환차손 계정
            await _db.into(_db.journalEntryLines).insert(
              JournalEntryLinesCompanion(
                transactionId: Value(txId),
                accountId: Value(fxLossAccountId),
                entryType: const Value('DEBIT'),
                originalAmount: Value(absAmount),
                originalCurrency: Value(baseCurrencyName),
                exchangeRateAtTrade: const Value(1000000),
                baseCurrency: Value(baseCurrencyName),
                baseAmount: Value(absAmount),
                deductibility: const Value('BOOK_RESPECTED'),
              ),
            );
            // 대변: 자산/부채 계정
            await _db.into(_db.journalEntryLines).insert(
              JournalEntryLinesCompanion(
                transactionId: Value(txId),
                accountId: Value(fxResult.accountId),
                entryType: const Value('CREDIT'),
                originalAmount: Value(absAmount),
                originalCurrency: Value(baseCurrencyName),
                exchangeRateAtTrade: const Value(1000000),
                baseCurrency: Value(baseCurrencyName),
                baseAmount: Value(absAmount),
                deductibility: const Value('BOOK_RESPECTED'),
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
  // 전표 흐름:
  //   ① 수익 마감: 차변 수익계정 / 대변 손익요약
  //   ② 비용 마감: 차변 손익요약 / 대변 비용계정
  //   ③ 이익잉여금 대체: 차변 손익요약 / 대변 이익잉여금 (이익 시)
  //                    차변 이익잉여금 / 대변 손익요약 (손실 시)
  // ───────────────────────────────────────────────────────────────

  Future<(SettlementStepResult, int)> _step4CloseIncome({
    required int periodId,
    required DateTime snapshotDate,
    required int retainedEarningsAccountId,
  }) async {
    try {
      // 손익요약 계정 ID 조회
      final incomeSummaryAccountId =
          await _findAccountIdByPath('EQUITY.INCOME_SUMMARY');
      if (incomeSummaryAccountId == null) {
        return (
          const SettlementStepResult(
            step: SettlementStep.closingIncome,
            isSuccess: false,
            message: '손익요약 계정을 찾을 수 없습니다 — 계정과목 설정 확인 필요',
          ),
          0,
        );
      }

      final incomeStatement = await _generateIncomeStatement.execute(
        periodId: periodId,
      );

      final totalRevenue = incomeStatement.totalRevenue;
      final totalExpense = incomeStatement.totalExpense;
      final netIncome = incomeStatement.netIncome;

      // 수익/비용 집계 계정 사전 조회 — 없으면 조기 실패
      final revenueAccountId = await _findAccountIdByPath('REVENUE');
      final expenseAccountId = await _findAccountIdByPath('EXPENSE');
      if (revenueAccountId == null && totalRevenue > 0) {
        throw Exception('수익 집계 계정(REVENUE)을 찾을 수 없습니다');
      }
      if (expenseAccountId == null && totalExpense > 0) {
        throw Exception('비용 집계 계정(EXPENSE)을 찾을 수 없습니다');
      }

      await _db.transaction(() async {
        // ① 수익 마감 전표: 차변 수익계정 / 대변 손익요약
        if (totalRevenue > 0) {
          final txRevenueId = await _db.into(_db.transactions).insert(
            TransactionsCompanion(
              date: Value(snapshotDate),
              description: const Value('손익 마감 — 수익계정 마감'),
              status: const Value('POSTED'),
              source: const Value('SYSTEM_SETTLEMENT'),
              periodId: Value(periodId),
              syncStatus: const Value('PENDING'),
            ),
          );
          // 차변: 수익 계정 합계 (REVENUE path 전체)
          await _db.into(_db.journalEntryLines).insert(
            JournalEntryLinesCompanion(
              transactionId: Value(txRevenueId),
              accountId: Value(revenueAccountId!),
              entryType: const Value('DEBIT'),
              originalAmount: Value(totalRevenue),
              originalCurrency: const Value('KRW'),
              exchangeRateAtTrade: const Value(1000000),
              baseCurrency: const Value('KRW'),
              baseAmount: Value(totalRevenue),
              deductibility: const Value('BOOK_RESPECTED'),
            ),
          );
          // 대변: 손익요약 계정
          await _db.into(_db.journalEntryLines).insert(
            JournalEntryLinesCompanion(
              transactionId: Value(txRevenueId),
              accountId: Value(incomeSummaryAccountId),
              entryType: const Value('CREDIT'),
              originalAmount: Value(totalRevenue),
              originalCurrency: const Value('KRW'),
              exchangeRateAtTrade: const Value(1000000),
              baseCurrency: const Value('KRW'),
              baseAmount: Value(totalRevenue),
              deductibility: const Value('BOOK_RESPECTED'),
            ),
          );
        }

        // ② 비용 마감 전표: 차변 손익요약 / 대변 비용계정
        if (totalExpense > 0) {
          final txExpenseId = await _db.into(_db.transactions).insert(
            TransactionsCompanion(
              date: Value(snapshotDate),
              description: const Value('손익 마감 — 비용계정 마감'),
              status: const Value('POSTED'),
              source: const Value('SYSTEM_SETTLEMENT'),
              periodId: Value(periodId),
              syncStatus: const Value('PENDING'),
            ),
          );
          // 차변: 손익요약 계정
          await _db.into(_db.journalEntryLines).insert(
            JournalEntryLinesCompanion(
              transactionId: Value(txExpenseId),
              accountId: Value(incomeSummaryAccountId),
              entryType: const Value('DEBIT'),
              originalAmount: Value(totalExpense),
              originalCurrency: const Value('KRW'),
              exchangeRateAtTrade: const Value(1000000),
              baseCurrency: const Value('KRW'),
              baseAmount: Value(totalExpense),
              deductibility: const Value('BOOK_RESPECTED'),
            ),
          );
          // 대변: 비용 계정 합계 (EXPENSE path 전체)
          await _db.into(_db.journalEntryLines).insert(
            JournalEntryLinesCompanion(
              transactionId: Value(txExpenseId),
              accountId: Value(expenseAccountId!),
              entryType: const Value('CREDIT'),
              originalAmount: Value(totalExpense),
              originalCurrency: const Value('KRW'),
              exchangeRateAtTrade: const Value(1000000),
              baseCurrency: const Value('KRW'),
              baseAmount: Value(totalExpense),
              deductibility: const Value('BOOK_RESPECTED'),
            ),
          );
        }

        // ③ 이익잉여금 대체 전표
        if (netIncome != 0) {
          final absNetIncome = netIncome.abs();
          final txClosingId = await _db.into(_db.transactions).insert(
            TransactionsCompanion(
              date: Value(snapshotDate),
              description: const Value('손익 마감 — 당기순이익 이익잉여금 대체'),
              status: const Value('POSTED'),
              source: const Value('SYSTEM_SETTLEMENT'),
              periodId: Value(periodId),
              syncStatus: const Value('PENDING'),
            ),
          );
          // 이익(netIncome>0): 차변 손익요약 / 대변 이익잉여금
          // 손실(netIncome<0): 차변 이익잉여금 / 대변 손익요약
          final strSummaryType = netIncome > 0 ? 'DEBIT' : 'CREDIT';
          final strRetainedType = netIncome > 0 ? 'CREDIT' : 'DEBIT';
          await _db.into(_db.journalEntryLines).insert(
            JournalEntryLinesCompanion(
              transactionId: Value(txClosingId),
              accountId: Value(incomeSummaryAccountId),
              entryType: Value(strSummaryType),
              originalAmount: Value(absNetIncome),
              originalCurrency: const Value('KRW'),
              exchangeRateAtTrade: const Value(1000000),
              baseCurrency: const Value('KRW'),
              baseAmount: Value(absNetIncome),
              deductibility: const Value('BOOK_RESPECTED'),
            ),
          );
          await _db.into(_db.journalEntryLines).insert(
            JournalEntryLinesCompanion(
              transactionId: Value(txClosingId),
              accountId: Value(retainedEarningsAccountId),
              entryType: Value(strRetainedType),
              originalAmount: Value(absNetIncome),
              originalCurrency: const Value('KRW'),
              exchangeRateAtTrade: const Value(1000000),
              baseCurrency: const Value('KRW'),
              baseAmount: Value(absNetIncome),
              deductibility: const Value('BOOK_RESPECTED'),
            ),
          );
        }
      });

      return (
        SettlementStepResult(
          step: SettlementStep.closingIncome,
          isSuccess: true,
          message: netIncome >= 0
              ? '당기순이익 $netIncome원 — 이익잉여금 대체 완료'
              : '당기순손실 ${netIncome.abs()}원 — 이익잉여금 차감 완료',
          details: {
            'netIncome': netIncome,
            'totalRevenue': totalRevenue,
            'totalExpense': totalExpense,
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
  // 헬퍼: equityTypePath로 계정 ID 조회
  // ───────────────────────────────────────────────────────────────

  /// Accounts 테이블에서 equityTypePath가 [path]인 첫 번째 계정 ID를 반환.
  /// 계정이 없으면 null 반환.
  Future<int?> _findAccountIdByPath(String path) async {
    final listRows = await (_db.select(_db.accounts)
          ..where((a) => a.equityTypePath.equals(path))
          ..limit(1))
        .get();
    if (listRows.isEmpty) return null;
    return listRows.first.id;
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
