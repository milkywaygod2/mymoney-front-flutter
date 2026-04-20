import 'package:drift/drift.dart';

import '../../../infrastructure/database/AppDatabase.dart';
import '../../../infrastructure/database/tables/CashFlowCodeTable.dart';

part 'CashFlowCodeDao.g.dart';

/// CashFlowCodes Drift DAO — CF 코드 마스터 읽기 전용 접근
@DriftAccessor(tables: [CashFlowCodes])
class CashFlowCodeDao extends DatabaseAccessor<AppDatabase>
    with _$CashFlowCodeDaoMixin {
  CashFlowCodeDao(super.db);

  /// 전체 CF 코드 목록 (sortOrder 순)
  Future<List<CashFlowCode>> findAll() {
    return (select(cashFlowCodes)..orderBy([(c) => OrderingTerm.asc(c.sortOrder)])).get();
  }

  /// 특정 코드 조회
  Future<CashFlowCode?> findByCode(String code) {
    return (select(cashFlowCodes)..where((c) => c.code.equals(code))).getSingleOrNull();
  }

  /// 상위 코드 기준 하위 목록
  Future<List<CashFlowCode>> findByParent(String parentCode) {
    return (select(cashFlowCodes)
          ..where((c) => c.parentCode.equals(parentCode))
          ..orderBy([(c) => OrderingTerm.asc(c.sortOrder)]))
        .get();
  }

  /// 계층 깊이 기준 조회
  Future<List<CashFlowCode>> findByLevel(int level) {
    return (select(cashFlowCodes)
          ..where((c) => c.level.equals(level))
          ..orderBy([(c) => OrderingTerm.asc(c.sortOrder)]))
        .get();
  }

  /// 인덱스 유형 기준 조회
  Future<List<CashFlowCode>> findByIndexType(String indexType) {
    return (select(cashFlowCodes)
          ..where((c) => c.indexType.equals(indexType))
          ..orderBy([(c) => OrderingTerm.asc(c.sortOrder)]))
        .get();
  }
}
