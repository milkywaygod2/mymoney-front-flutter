import 'package:drift/drift.dart' show Value;

import '../../../core/constants/Enums.dart';
import '../../../infrastructure/database/AppDatabase.dart';
import 'RunSettlement.dart';

/// DepreciationPlugin — 유형/무형자산 감가상각 자동전표 생성
///
/// [아키텍처 근거 — CW_ARCHITECTURE.md §7.2]
/// 결산 Step2 플러그인 (order=30)
/// 정액법 기본: 월 상각액 = 취득원가 / (내용연수 × 12)
/// 대상: ASSET.NON_CURRENT.TANGIBLE.* + ASSET.NON_CURRENT.INTANGIBLE.* 계정
class DepreciationPlugin implements SettlementPlugin {
  DepreciationPlugin({
    required AppDatabase db,
  }) : _db = db;

  final AppDatabase _db;

  @override
  String get name => 'DepreciationPlugin';

  @override
  int get order => 30;

  @override
  Future<SettlementStepResult> execute({
    required int periodId,
    required DateTime snapshotDate,
  }) async {
    try {
      // 1. 유형/무형 자산 계정 조회 (감가상각 대상)
      final listAssetAccounts = await (
        _db.select(_db.accounts)
          ..where((a) =>
            a.equityTypePath.like('ASSET.NON_CURRENT.TANGIBLE.%') |
            a.equityTypePath.like('ASSET.NON_CURRENT.INTANGIBLE.%'))
          ..where((a) => a.isActive.equals(true))
      ).get();

      if (listAssetAccounts.isEmpty) {
        return const SettlementStepResult(
          step: SettlementStep.executingPlugins,
          isSuccess: true,
          message: '감가상각 대상 자산 없음',
          details: {'depreciationEntryCount': 0},
        );
      }

      // 2. 감가상각비/무형자산상각비 계정 조회
      final depTangibleAccountId = await _findAccountIdByPath('EXPENSE.DEPRECIATION.TANGIBLE');
      final depIntangibleAccountId = await _findAccountIdByPath('EXPENSE.DEPRECIATION.INTANGIBLE');

      var countEntries = 0;

      for (final asset in listAssetAccounts) {
        // 3. 해당 자산의 현재 잔액(취득원가) 조회
        final listJels = await (_db.select(_db.journalEntryLines)
              ..where((j) => j.accountId.equals(asset.id)))
            .get();

        if (listJels.isEmpty) continue;

        // 차변 합계 - 대변 합계 = 순 장부가
        var bookValue = 0;
        for (final jel in listJels) {
          if (jel.entryType == 'DEBIT') {
            bookValue += jel.baseAmount;
          } else {
            bookValue -= jel.baseAmount;
          }
        }

        if (bookValue <= 0) continue; // 이미 완전 상각

        // 4. 정액법 월 상각: countrySpecific JSON에서 usefulLifeMonths 추출
        // 기본 내용연수: 유형자산 60개월(5년), 무형자산 60개월(5년)
        const defaultUsefulLifeMonths = 60;
        final monthlyDepreciation = bookValue ~/ defaultUsefulLifeMonths;

        if (monthlyDepreciation <= 0) continue;

        // 5. 감가상각 자동전표 생성
        final isTangible = asset.equityTypePath.startsWith('ASSET.NON_CURRENT.TANGIBLE');
        final depAccountId = isTangible ? depTangibleAccountId : depIntangibleAccountId;
        if (depAccountId == null) continue;

        await _db.transaction(() async {
          final txId = await _db.into(_db.transactions).insert(
            TransactionsCompanion(
              date: Value(snapshotDate),
              description: Value('감가상각 자동전표 — ${asset.name}'),
              status: const Value('POSTED'),
              source: Value(TransactionSource.systemSettlement.name),
              periodId: Value(periodId),
              syncStatus: const Value('PENDING'),
            ),
          );

          // 차변: 감가상각비 (비용 증가)
          await _db.into(_db.journalEntryLines).insert(
            JournalEntryLinesCompanion(
              transactionId: Value(txId),
              accountId: Value(depAccountId),
              entryType: const Value('DEBIT'),
              originalAmount: Value(monthlyDepreciation),
              originalCurrency: const Value('KRW'),
              exchangeRateAtTrade: const Value(1000000),
              baseCurrency: const Value('KRW'),
              baseAmount: Value(monthlyDepreciation),
              deductibility: Value(Deductibility.bookRespected.name),
            ),
          );

          // 대변: 해당 자산 계정 (자산 감소)
          await _db.into(_db.journalEntryLines).insert(
            JournalEntryLinesCompanion(
              transactionId: Value(txId),
              accountId: Value(asset.id),
              entryType: const Value('CREDIT'),
              originalAmount: Value(monthlyDepreciation),
              originalCurrency: const Value('KRW'),
              exchangeRateAtTrade: const Value(1000000),
              baseCurrency: const Value('KRW'),
              baseAmount: Value(monthlyDepreciation),
              deductibility: Value(Deductibility.bookRespected.name),
            ),
          );

          countEntries++;
        });
      }

      return SettlementStepResult(
        step: SettlementStep.executingPlugins,
        isSuccess: true,
        message: '감가상각 전표 $countEntries건 생성 완료',
        details: {'depreciationEntryCount': countEntries},
      );
    } catch (e) {
      return SettlementStepResult(
        step: SettlementStep.executingPlugins,
        isSuccess: false,
        message: '감가상각 전표 생성 실패: $e',
      );
    }
  }

  Future<int?> _findAccountIdByPath(String path) async {
    final listRows = await (_db.select(_db.accounts)
          ..where((a) => a.equityTypePath.equals(path))
          ..limit(1))
        .get();
    if (listRows.isEmpty) return null;
    return listRows.first.id;
  }
}
