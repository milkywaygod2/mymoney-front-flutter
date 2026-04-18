import 'package:drift/drift.dart';

import 'CounterpartyTable.dart';

/// OCR 표기 변형 — 거래처 자동 매칭에 사용
class CounterpartyAliases extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get counterpartyId => integer().references(Counterparties, #id)();
  /// 별칭 (예: "스타벅스", "STARBUCKS GANGNAM")
  TextColumn get alias => text()();
}
