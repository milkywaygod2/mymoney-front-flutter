import '../models/TypedId.dart';

/// 거래처 매칭 결과 VO
class CounterpartyMatch {
  final CounterpartyId counterpartyId;
  final String matchedAlias;

  /// 매칭 신뢰도 (0.0 ~ 1.0)
  final double confidence;

  const CounterpartyMatch({
    required this.counterpartyId,
    required this.matchedAlias,
    required this.confidence,
  });
}

/// OCR/CSV 원시 텍스트에서 거래처를 자동 매칭하는 서비스 인터페이스.
/// Classification BC → Counterparty BC 연동 계약.
abstract interface class ICounterpartyMatcher {
  /// 원시 텍스트(가맹점명 등)로 거래처 매칭 시도
  Future<CounterpartyMatch?> matchByText(String rawText);
}
