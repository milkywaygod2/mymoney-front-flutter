import 'package:drift/drift.dart';

import 'CounterpartyTable.dart';

/// 거래 — Aggregate Root
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  /// 적요
  TextColumn get description => text()();
  /// DRAFT | POSTED | VOIDED
  TextColumn get status => text().withDefault(const Constant('DRAFT'))();
  /// 역분개 추적 — 이 거래를 무효로 만든 거래 ID
  IntColumn get voidedBy => integer().nullable().references(Transactions, #id)();
  IntColumn get counterpartyId => integer().nullable().references(Counterparties, #id)();
  /// 거래처명 비정규화 캐시 (기록시점 유지, 감사 추적)
  TextColumn get counterpartyName => text().nullable()();
  /// MANUAL | OCR | CARD_API | CSV_IMPORT | NTS_IMPORT | SYSTEM_SETTLEMENT
  TextColumn get source => text()();
  /// AI 분류 신뢰도 (0.0~1.0)
  RealColumn get confidence => real().nullable()();
  /// 손익귀속기간 FK
  IntColumn get periodId => integer().nullable()();
  /// SYNCED | PENDING | SENDING | CONFLICT | FAILED
  TextColumn get syncStatus => text().withDefault(const Constant('SYNCED'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
