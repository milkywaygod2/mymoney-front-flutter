import 'package:drift/drift.dart';

/// 결산기간 (손익귀속기간)
class FiscalPeriods extends Table {
  IntColumn get id => integer().autoIncrement()();
  /// 기간명 (예: "2026년 2분기")
  TextColumn get name => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
}
