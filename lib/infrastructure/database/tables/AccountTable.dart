import 'package:drift/drift.dart';

import 'DimensionValueTable.dart';
import 'OwnerTable.dart';

/// 계정과목 — 5대 성격(ASSET/LIABILITY/EQUITY/REVENUE/EXPENSE) 분류
/// T1 구조축은 이중 저장 (FK=쓰기 정합성, Path=읽기 성능)
class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  /// 계정명 (예: "우리은행 보통예금")
  TextColumn get name => text()();
  /// 계정 성격: ASSET | LIABILITY | EQUITY | REVENUE | EXPENSE
  TextColumn get nature => text()();

  // --- T1 구조축 이중 저장 ---
  IntColumn get equityTypeId => integer().references(DimensionValues, #id)();
  TextColumn get equityTypePath => text()();
  IntColumn get liquidityId => integer().references(DimensionValues, #id)();
  TextColumn get liquidityPath => text()();
  IntColumn get assetTypeId => integer().references(DimensionValues, #id)();
  TextColumn get assetTypePath => text()();

  // --- T2 제도축 기본값 ---
  IntColumn get defaultActivityTypeId => integer().nullable().references(DimensionValues, #id)();
  IntColumn get defaultIncomeTypeId => integer().nullable().references(DimensionValues, #id)();
  IntColumn get ownerId => integer().references(Owners, #id)();

  // --- Account 속성 ---
  /// 상품구분 (예: 예금, 적금, 주식, 보험)
  TextColumn get productType => text().nullable()();
  /// 금융사 (예: 우리은행, 국민은행)
  TextColumn get financialInstitution => text().nullable()();
  /// 국가별 추가 정보 (JSON, 확장 예약)
  TextColumn get countrySpecific => text().nullable()();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
