import 'package:drift/drift.dart';

/// 결산기간 (손익귀속기간)
class FiscalPeriods extends Table {
  IntColumn get id => integer().autoIncrement()();
  /// 기간명 (예: "2026년 2분기")
  TextColumn get name => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  /// 결산 마감 여부 — true면 해당 기간 수정 불가
  BoolColumn get isClosed => boolean().withDefault(const Constant(false))();
  /// 결산 코멘트 — 비정형 메모 (예: "LINE Mobile 지분율 변동으로 인한 처분이익 반영")
  TextColumn get note => text().nullable()();
}
