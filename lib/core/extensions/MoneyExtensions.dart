import '../errors/DomainErrors.dart';

/// int 금액 포맷팅 확장
/// Money VO가 내부적으로 int(최소 단위)를 사용하므로,
/// 표시 시 천단위 콤마 포맷팅이 필요
extension AmountFormatExtension on int {
  /// 천단위 콤마 포맷팅
  /// 4500 → "4,500" / -4500 → "-4,500" / 0 → "0"
  String toFormattedAmount() {
    final isNegative = this < 0;
    final absValue = isNegative ? -this : this;
    final str = absValue.toString();
    final buffer = StringBuffer();

    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(str[i]);
    }

    return isNegative ? '-${buffer.toString()}' : buffer.toString();
  }
}

/// int 리스트 합산 + 통화 검증 유틸리티
/// Money VO 리스트를 합산할 때 사용할 헬퍼
/// (Money 모델 완성 후 Money 타입 확장으로 전환 예정)
extension IntListSumExtension on Iterable<int> {
  /// int 금액 리스트 합산 — 빈 리스트는 0 반환
  int sumAmounts() {
    var total = 0;
    for (final amount in this) {
      total += amount;
    }
    return total;
  }
}

/// 환율 배율 변환 확장
extension ExchangeRateExtension on int {
  /// 배율 적용된 환율 → double 변환 (표시용)
  /// 1350123456 → 1350.123456
  double toExchangeRate() => this / 1000000.0;
}

/// 지분율 배율 변환 확장
extension ShareRatioExtension on int {
  /// 배율 적용된 지분율 → 퍼센트 double 변환 (표시용)
  /// 3333 → 33.33
  double toSharePercent() => this / 100.0;

  /// 지분율 합계 검증 — 10000(100%)과 일치하는지
  static void validateShares(Iterable<int> shares) {
    final total = shares.fold(0, (sum, s) => sum + s);
    if (total != 10000) {
      throw InvariantViolationError(
        '지분율 합계는 100%(10000)이어야 합니다 (현재: $total)',
      );
    }
  }
}
