import '../../../core/constants/Enums.dart';
import '../../../core/interfaces/ICashFlowCodeRepository.dart';
import '../../../infrastructure/database/AppDatabase.dart';
import 'CashFlowCodeDao.dart';

/// ICashFlowCodeRepository 구현체 — Drift DAO 래핑
class CashFlowCodeRepository implements ICashFlowCodeRepository {
  CashFlowCodeRepository({required CashFlowCodeDao dao}) : _dao = dao;

  final CashFlowCodeDao _dao;

  @override
  Future<List<CashFlowCodeDto>> findAll() async {
    final listRows = await _dao.findAll();
    return listRows.map(_toDto).toList();
  }

  @override
  Future<CashFlowCodeDto?> findByCode(String code) async {
    final row = await _dao.findByCode(code);
    return row != null ? _toDto(row) : null;
  }

  @override
  Future<List<CashFlowCodeDto>> findByParent(String parentCode) async {
    final listRows = await _dao.findByParent(parentCode);
    return listRows.map(_toDto).toList();
  }

  @override
  Future<List<CashFlowCodeDto>> findByLevel(int level) async {
    final listRows = await _dao.findByLevel(level);
    return listRows.map(_toDto).toList();
  }

  @override
  Future<List<CashFlowCodeDto>> findByIndexType(CfAccountIndex indexType) async {
    final listRows = await _dao.findByIndexType(indexType.name);
    return listRows.map(_toDto).toList();
  }

  CashFlowCodeDto _toDto(CashFlowCode row) {
    return CashFlowCodeDto(
      id: row.id,
      code: row.code,
      name: row.name,
      parentCode: row.parentCode,
      indexType: CfAccountIndex.values.byName(row.indexType),
      level: row.level,
      sortOrder: row.sortOrder,
    );
  }
}
