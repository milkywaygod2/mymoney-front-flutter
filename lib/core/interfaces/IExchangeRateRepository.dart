import '../models/TypedId.dart';
import '../models/CurrencyCode.dart';

// ExchangeRate는 Ryan 워크트리에서 동시 작성 중
// import '../domain/ExchangeRate.dart';

/// 환율(ExchangeRate) 저장소 인터페이스.
/// External Parameter BC — 환율 조회/저장.
abstract interface class IExchangeRateRepository {
  /// 특정 날짜의 환율 조회 (from→to)
  Future<dynamic> findRate(
    CurrencyCode from,
    CurrencyCode to,
    DateTime date,
  );

  /// 최신 환율 조회 (일상 조회 시 미실현 손익 계산용)
  Future<dynamic> getLatestRate(
    CurrencyCode from,
    CurrencyCode to,
  );

  /// 환율 저장
  Future<void> save(dynamic exchangeRate);
}
