import 'package:drift/drift.dart';

import 'FiscalPeriodTable.dart';

/// 재무비율 스냅샷 — 결산 시점 비율 결과 영구 저장
/// 대시보드 온디맨드 계산과 별개로, 결산 5단계에서 확정 비율을 기록
///
/// ratioValue: 배율 10000 (33.33% → 3333)
/// category: PROFITABILITY|STABILITY|ACTIVITY|GROWTH
class FinancialRatioSnapshots extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get periodId => integer().references(FiscalPeriods, #id)();
  /// 비율 코드 — NET_ASSET_GROWTH|SAVINGS_RATE|CURRENT_RATIO|DEBT_RATIO|ROA|ROE|AR_TURNOVER|INTEREST_COVERAGE|...
  TextColumn get ratioCode => text()();
  /// 비율 카테고리
  TextColumn get category => text()();
  /// 분자 (최소단위 int)
  IntColumn get numerator => integer()();
  /// 분모 (최소단위 int)
  IntColumn get denominator => integer()();
  /// 비율 값 (배율 10000)
  IntColumn get ratioValue => integer()();
  DateTimeColumn get calculatedAt => dateTime().withDefault(currentDateAndTime)();
}
