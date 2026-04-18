import 'dart:math' show pow;

/// ISO 4217 통화 코드 + 최소 단위 소수점 자릿수
/// 금액은 항상 최소 단위 int로 저장 (KRW: 원, USD: cent)
enum CurrencyCode {
  KRW(decimals: 0, symbol: '₩'),
  USD(decimals: 2, symbol: '\$'),
  EUR(decimals: 2, symbol: '€'),
  JPY(decimals: 0, symbol: '¥'),
  GBP(decimals: 2, symbol: '£'),
  CNY(decimals: 2, symbol: '¥');

  const CurrencyCode({required this.decimals, required this.symbol});

  /// 소수점 자릿수 (KRW=0, USD=2)
  final int decimals;

  /// 통화 기호
  final String symbol;

  /// 최소 단위 배율 (KRW=1, USD=100, EUR=100)
  int get minorUnitMultiplier =>
      decimals == 0 ? 1 : pow(10, decimals).toInt();
}
