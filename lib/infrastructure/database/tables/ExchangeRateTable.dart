import 'package:drift/drift.dart';

/// 환율 — 시계열 이력
class ExchangeRates extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get fromCurrency => text().withLength(min: 3, max: 3)();
  TextColumn get toCurrency => text().withLength(min: 3, max: 3)();
  /// 환율 (배율 kExchangeRateMultiplier=1,000,000)
  IntColumn get rate => integer()();
  DateTimeColumn get effectiveDate => dateTime()();
  /// 출처 (예: "한국은행", "서울외국환중개")
  TextColumn get source => text()();
  /// 회계용/세무용 구분 (해외 확장 예약)
  TextColumn get purpose => text().withDefault(const Constant('ACCOUNTING'))();
}
