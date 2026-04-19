import '../models/CurrencyCode.dart';
import '../models/ExchangeRateValue.dart';

/// 환율(ExchangeRate) 저장소 인터페이스.
/// External Parameter BC — 환율 조회/저장.
abstract interface class IExchangeRateRepository {
  /// 특정 날짜의 환율 조회 (from→to)
  /// effectiveDate ≤ date 중 가장 최신 레코드 반환, 미존재 시 null
  Future<ExchangeRateValue?> findRate(
    CurrencyCode from,
    CurrencyCode to,
    DateTime date,
  );

  /// 최신 환율 조회 (일상 조회 시 미실현 손익 계산용)
  /// 미존재 시 ExchangeRateNotFoundError 발생
  Future<ExchangeRateValue> getLatestRate(
    CurrencyCode from,
    CurrencyCode to,
  );

  /// 환율 저장
  Future<void> save(ExchangeRateValue exchangeRate);
}
