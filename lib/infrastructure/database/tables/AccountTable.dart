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

  // --- v2.0 추가 ---
  /// CF 보고서 자동 분류 태그: cash | receivablePayable | revenueExpense
  TextColumn get cashFlowCategory => text().nullable()();
  /// FX 재평가 대상 여부 (결산 외환평가 자동 선별, COA Col19 기반)
  BoolColumn get isFxRevalTarget => boolean().withDefault(const Constant(false))();
  /// 거래처 입력 강제 수준: notSet | optional | required
  TextColumn get vendorRequirement => text().nullable()();
  /// 매출차감 계정 플래그 — 순액 표시 수수료 (INV-A6: nature == EXPENSE만 가능)
  BoolColumn get isRevenueDeduction => boolean().withDefault(const Constant(false))();
  /// 재고 평가 방법 (P3 — 재고 계정만): fifo | weightedAverage | movingAverage | specificIdentification | standardCost
  TextColumn get valuationMethod => text().nullable()();
}
