import 'package:freezed_annotation/freezed_annotation.dart';

import 'CurrencyCode.dart';

part 'ExchangeRateValue.freezed.dart';

/// 환율 배율 상수 (1,000,000)
/// 1 USD = 1,350.123456 KRW → rate = 1350123456
const int kExchangeRateMultiplier = 1000000;

/// 환율 값 객체 — int 기반 정밀 연산
/// rate는 kExchangeRateMultiplier 배율로 저장
@freezed
class ExchangeRateValue with _$ExchangeRateValue {
  const ExchangeRateValue._();

  const factory ExchangeRateValue({
    required CurrencyCode fromCurrency,
    required CurrencyCode toCurrency,
    required int rate,
  }) = _ExchangeRateValue;

  /// 환산: fromCurrency 최소 단위 금액 → toCurrency 최소 단위 금액
  /// 계산식: result = amount * rate / kExchangeRateMultiplier
  ///         * (toCurrency.minorUnitMultiplier / fromCurrency.minorUnitMultiplier)
  int convert(int amountMinorUnits) {
    // 정수 오버플로우 방지를 위해 BigInt 사용
    final BigInt bigAmount = BigInt.from(amountMinorUnits);
    final BigInt bigRate = BigInt.from(rate);
    final BigInt bigToMultiplier = BigInt.from(toCurrency.minorUnitMultiplier);
    final BigInt bigFromMultiplier =
        BigInt.from(fromCurrency.minorUnitMultiplier);
    final BigInt bigRateMultiplier = BigInt.from(kExchangeRateMultiplier);

    // amount * rate * toMultiplier / (rateMultiplier * fromMultiplier)
    final BigInt numerator = bigAmount * bigRate * bigToMultiplier;
    final BigInt denominator = bigRateMultiplier * bigFromMultiplier;

    return (numerator ~/ denominator).toInt();
  }
}
