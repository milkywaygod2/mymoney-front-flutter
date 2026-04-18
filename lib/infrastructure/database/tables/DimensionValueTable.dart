import 'package:drift/drift.dart';

/// 분류축 값 (T1/T2 트리 노드)
/// 자산/부채/유동/비유동 등 계층적 분류값을 저장하는 통합 테이블
class DimensionValues extends Table {
  IntColumn get id => integer().autoIncrement()();
  /// EQUITY_TYPE | LIQUIDITY | ASSET_TYPE | ACTIVITY_TYPE | INCOME_TYPE
  TextColumn get dimensionType => text()();
  /// 코드값 (예: "ASSET", "CURRENT", "CASH")
  TextColumn get code => text()();
  /// 표시명 (예: "자산", "유동", "현금성")
  TextColumn get name => text()();
  /// 트리 자기참조 — 상위 노드 (null = 루트)
  IntColumn get parentId => integer().nullable().references(DimensionValues, #id)();
  /// Materialized Path 캐시 (예: "ASSET.CURRENT.CASH")
  TextColumn get path => text()();
  /// 회계주체 유형별 필터 (ALL | HOUSEHOLD | CORPORATE | GOVERNMENT)
  TextColumn get entityType => text().withDefault(const Constant('ALL'))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
