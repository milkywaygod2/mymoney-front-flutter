import 'package:drift/drift.dart';

import '../../../core/interfaces/IFinancialRatioRepository.dart';
import '../../../core/models/FinancialRatio.dart';
import '../../../infrastructure/database/AppDatabase.dart';
import '../../../infrastructure/database/tables/FinancialRatioSnapshotTable.dart';
import 'FinancialRatioDao.dart';

/// IFinancialRatioRepository 구현체 — Drift 기반 (v2.0)
class FinancialRatioRepository implements IFinancialRatioRepository {
  FinancialRatioRepository(this._dao);
  final FinancialRatioDao _dao;

  @override
  Future<List<FinancialRatio>> findByPeriod(int periodId) async {
    final rows = await _dao.findByPeriod(periodId);
    return rows.map(_toVO).toList();
  }

  @override
  Future<FinancialRatio?> findByPeriodAndCode(int periodId, String ratioCode) async {
    final row = await _dao.findByPeriodAndCode(periodId, ratioCode);
    return row != null ? _toVO(row) : null;
  }

  @override
  Future<List<FinancialRatio>> findTrend(String ratioCode, {int limit = 12}) async {
    final rows = await _dao.findTrend(ratioCode, limit: limit);
    return rows.map(_toVO).toList();
  }

  @override
  Future<void> save(FinancialRatio ratio) async {
    await _dao.saveRatio(_toCompanion(ratio));
  }

  @override
  Future<void> saveAll(List<FinancialRatio> listRatios) async {
    await _dao.saveAll(listRatios.map(_toCompanion).toList());
  }

  // --- Row ↔ VO 변환 ---

  FinancialRatio _toVO(FinancialRatioSnapshot row) {
    return FinancialRatio(
      ratioCode: row.ratioCode,
      category: row.category,
      periodId: row.periodId,
      numerator: row.numerator,
      denominator: row.denominator,
      ratioValue: row.ratioValue,
      calculatedAt: row.calculatedAt,
    );
  }

  FinancialRatioSnapshotsCompanion _toCompanion(FinancialRatio vo) {
    return FinancialRatioSnapshotsCompanion(
      periodId: Value(vo.periodId),
      ratioCode: Value(vo.ratioCode),
      category: Value(vo.category),
      numerator: Value(vo.numerator),
      denominator: Value(vo.denominator),
      ratioValue: Value(vo.ratioValue),
      calculatedAt: Value(vo.calculatedAt ?? DateTime.now()),
    );
  }
}
