import 'package:drift/drift.dart';

import 'AccountTable.dart';
import 'CounterpartyTable.dart';

/// 분류 규칙 (로직트리) — OCR 텍스트 → 계정과목 자동 매핑
/// 시스템 규칙과 사용자 규칙을 priority로 구분
class ClassificationRules extends Table {
  IntColumn get id => integer().autoIncrement()();
  /// 매칭 패턴 (예: "스타벅스", "STARBUCKS*")
  TextColumn get pattern => text()();
  /// EXACT | CONTAINS | REGEX
  TextColumn get patternType => text()();
  IntColumn get accountId => integer().references(Accounts, #id)();
  IntColumn get counterpartyId => integer().nullable().references(Counterparties, #id)();
  /// 우선순위 (높을수록 우선, 사용자 규칙 > 시스템 규칙)
  IntColumn get priority => integer().withDefault(const Constant(0))();
  BoolColumn get isSystemRule => boolean().withDefault(const Constant(false))();
  BoolColumn get isUserRule => boolean().withDefault(const Constant(true))();
}
