import 'package:drift/drift.dart';

import 'FiscalPeriodTable.dart';

/// 결산 스냅샷 — 결산 Step5에서 6종 보고서 결과를 JSON으로 영구 저장
/// snapshotType: BS | PL | CF | CE | TAX | RATIO
class SettlementSnapshots extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get periodId => integer().references(FiscalPeriods, #id)();
  /// 스냅샷 유형: BS | PL | CF | CE | TAX | RATIO
  TextColumn get snapshotType => text()();
  /// 스냅샷 생성 일시
  DateTimeColumn get snapshotDate => dateTime().withDefault(currentDateAndTime)();
  /// 보고서 데이터 (JSON)
  TextColumn get data => text()();
}
