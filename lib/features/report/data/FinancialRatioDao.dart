import 'package:drift/drift.dart';

import '../../../infrastructure/database/AppDatabase.dart';
import '../../../infrastructure/database/tables/FinancialRatioSnapshotTable.dart';

part 'FinancialRatioDao.g.dart';

/// FinancialRatioSnapshots Drift DAO — 재무비율 스냅샷 CRUD
@DriftAccessor(tables: [FinancialRatioSnapshots])
class FinancialRatioDao extends DatabaseAccessor<AppDatabase>
    with _$FinancialRatioDaoMixin {
  FinancialRatioDao(super.db);

  /// 특정 결산기간의 전체 비율 조회
  Future<List<FinancialRatioSnapshot>> findByPeriod(int periodId) {
    return (select(financialRatioSnapshots)
          ..where((r) => r.periodId.equals(periodId))
          ..orderBy([(r) => OrderingTerm.asc(r.ratioCode)]))
        .get();
  }

  /// 특정 결산기간의 특정 비율 조회
  Future<FinancialRatioSnapshot?> findByPeriodAndCode(int periodId, String ratioCode) {
    return (select(financialRatioSnapshots)
          ..where((r) => r.periodId.equals(periodId))
          ..where((r) => r.ratioCode.equals(ratioCode))
          ..limit(1))
        .getSingleOrNull();
  }

  /// 특정 비율의 기간별 추이 (최근 limit건)
  Future<List<FinancialRatioSnapshot>> findTrend(String ratioCode, {int limit = 12}) {
    return (select(financialRatioSnapshots)
          ..where((r) => r.ratioCode.equals(ratioCode))
          ..orderBy([(r) => OrderingTerm.desc(r.periodId)])
          ..limit(limit))
        .get();
  }

  /// 단일 비율 저장 (upsert)
  Future<void> saveRatio(FinancialRatioSnapshotsCompanion entry) {
    return into(financialRatioSnapshots).insertOnConflictUpdate(entry);
  }

  /// 전체 비율 일괄 저장
  Future<void> saveAll(List<FinancialRatioSnapshotsCompanion> listEntries) async {
    await batch((b) {
      for (final entry in listEntries) {
        b.insert(financialRatioSnapshots, entry, onConflict: DoUpdate((_) => entry));
      }
    });
  }
}
