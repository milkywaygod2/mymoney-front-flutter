import 'package:freezed_annotation/freezed_annotation.dart';

import 'CurrencyCode.dart';

part 'Money.freezed.dart';

/// 금액 값 객체 — int 기반 정밀 연산, double 사용 금지
/// amountMinorUnits는 통화의 최소 단위 (KRW: 원, USD: cent)
@freezed
class Money with _$Money {
  const Money._();

  const factory Money({
    required int amountMinorUnits,
    required CurrencyCode currency,
  }) = _Money;

  /// 같은 통화만 합산 — 다른 통화 시 ArgumentError throw
  Money operator +(Money other) {
    _assertSameCurrency(other);
    return Money(
      amountMinorUnits: amountMinorUnits + other.amountMinorUnits,
      currency: currency,
    );
  }

  Money operator -(Money other) {
    _assertSameCurrency(other);
    return Money(
      amountMinorUnits: amountMinorUnits - other.amountMinorUnits,
      currency: currency,
    );
  }

  /// 부호 반전
  Money operator -() => Money(
        amountMinorUnits: -amountMinorUnits,
        currency: currency,
      );

  bool get isNegative => amountMinorUnits < 0;
  bool get isZero => amountMinorUnits == 0;
  bool get isPositive => amountMinorUnits > 0;

  /// 제로 팩토리
  static Money zero(CurrencyCode currency) =>
      Money(amountMinorUnits: 0, currency: currency);

  /// 표시용 문자열 (KRW: "₩4,500", USD: "$45.67")
  String toDisplayString() {
    final int multiplier = currency.minorUnitMultiplier;
    final int integerPart = amountMinorUnits ~/ multiplier;
    final int decimalPart = (amountMinorUnits % multiplier).abs();

    // 천 단위 구분자 적용
    final String formattedInteger = _formatWithCommas(integerPart.abs());
    final String sign = amountMinorUnits < 0 ? '-' : '';

    if (currency.decimals == 0) {
      return '$sign${currency.symbol}$formattedInteger';
    }

    final String formattedDecimal =
        decimalPart.toString().padLeft(currency.decimals, '0');
    return '$sign${currency.symbol}$formattedInteger.$formattedDecimal';
  }

  void _assertSameCurrency(Money other) {
    if (currency != other.currency) {
      throw ArgumentError(
        '통화 불일치: ${currency.name} != ${other.currency.name}. '
        '다른 통화 간 연산은 환율 변환 후 수행해야 합니다.',
      );
    }
  }

  static String _formatWithCommas(int value) {
    final String str = value.toString();
    final StringBuffer buffer = StringBuffer();
    final int length = str.length;

    for (int i = 0; i < length; i++) {
      if (i > 0 && (length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(str[i]);
    }

    return buffer.toString();
  }
}
