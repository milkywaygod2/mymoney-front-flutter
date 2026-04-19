import 'package:drift/drift.dart';

import '../../../infrastructure/database/AppDatabase.dart';
import '../../../infrastructure/database/tables/LegalParameterTable.dart';

part 'LegalParameterDao.g.dart';

/// LegalParameter Drift DAO — 법률 변수 조회/저장
@DriftAccessor(tables: [LegalParameters])
class LegalParameterDao extends DatabaseAccessor<AppDatabase>
    with _$LegalParameterDaoMixin {
  LegalParameterDao(super.db);

  /// 특정 시점에 유효한 법률 변수 조회
  ///
  /// 조건: effectiveFrom <= asOfDate AND (effectiveTo IS NULL OR effectiveTo > asOfDate)
  /// [key]: 변수 키
  /// [asOfDate]: 기준일
  /// [countryCode]: 국가 코드 (기본 "KR")
  Future<LegalParameter?> findEffective(
    String key,
    DateTime asOfDate, {
    String countryCode = 'KR',
  }) async {
    return (select(legalParameters)
          ..where((p) =>
              p.key.equals(key) &
              p.countryCode.equals(countryCode) &
              p.effectiveFrom.isSmallerOrEqualValue(asOfDate) &
              (p.effectiveTo.isNull() | p.effectiveTo.isBiggerThanValue(asOfDate)))
          ..orderBy([(p) => OrderingTerm.desc(p.effectiveFrom)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// 법률 변수 저장 (insert or replace)
  Future<int> upsert(LegalParametersCompanion entry) {
    return into(legalParameters).insertOnConflictUpdate(entry);
  }
}
