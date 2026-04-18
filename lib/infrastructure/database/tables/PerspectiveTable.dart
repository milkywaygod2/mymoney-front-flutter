import 'package:drift/drift.dart';

import 'OwnerTable.dart';

/// 관점 프리셋 — 필터 조합을 저장하여 원탭 전환
class Perspectives extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get ownerId => integer().references(Owners, #id)();
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
  /// T1/T2 분류축 필터 (JSON)
  TextColumn get dimensionFilters => text().withDefault(const Constant('{}'))();
  /// 계정 속성 필터 — 상품구분/금융사 (JSON)
  TextColumn get accountAttributeFilters => text().withDefault(const Constant('{}'))();
  /// T3 태그 필터 (JSON)
  TextColumn get tagFilters => text().withDefault(const Constant('[]'))();
  /// NORMAL | INVERTED (정부회계)
  TextColumn get recordingDirection => text().withDefault(const Constant('NORMAL'))();
  TextColumn get baseCurrency => text().nullable()();
  /// FULL | READ_ONLY | RESTRICTED
  TextColumn get permissionLevel => text().withDefault(const Constant('FULL'))();
}
