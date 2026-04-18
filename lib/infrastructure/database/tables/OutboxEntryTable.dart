import 'package:drift/drift.dart';

/// 오프라인 동기화 큐 (Outbox 패턴)
/// FIFO 순차 전송, Server-Wins 충돌 해소
class OutboxEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  /// TRANSACTION | ACCOUNT | COUNTERPARTY 등
  TextColumn get entityType => text()();
  IntColumn get entityId => integer()();
  /// CREATE | UPDATE | DELETE
  TextColumn get operation => text()();
  /// 변경 내용 (JSON)
  TextColumn get payload => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSent => boolean().withDefault(const Constant(false))();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
}
