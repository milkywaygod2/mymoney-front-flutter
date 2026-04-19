import '../../../core/errors/DomainErrors.dart';
import '../../../core/interfaces/IExchangeRateRepository.dart';
import '../../../core/models/CurrencyCode.dart';
import '../../../core/models/ExchangeRateValue.dart';
import '../../../core/models/Money.dart';

/// ConvertCurrency — 통화 환산 UseCase
///
/// 거래 입력 시 original_currency ≠ base_currency인 경우,
/// 거래 시점 환율을 조회하여 base_amount를 계산한다.
///
/// [아키텍처 근거]
/// - 거래의 실질은 거래원화 금액 (original_amount).
/// - base_amount는 파생값 — 환율이 확정된 후 계산.
/// - 환율 미존재 시 거래 저장 불가 (에러 발생).
class ConvertCurrency {
  ConvertCurrency(this._exchangeRateRepository);
  final IExchangeRateRepository _exchangeRateRepository;

  /// 거래 시점 환율 기준 환산
  ///
  /// [amount] 환산할 금액 (original_currency 기준 최소 단위)
  /// [from] 원본 통화
  /// [to] 목표 통화 (base_currency)
  /// [tradeDate] 거래일 — 해당 날짜 이전 가장 최신 환율 사용
  ///
  /// Returns: (환산 금액, 적용 환율 VO) 튜플
  /// Throws: [ExchangeRateNotFoundError] 환율 미존재 시
  Future<({int convertedAmount, ExchangeRateValue appliedRate})> execute({
    required int amount,
    required CurrencyCode from,
    required CurrencyCode to,
    required DateTime tradeDate,
  }) async {
    // 같은 통화면 환산 불필요
    if (from == to) {
      return (
        convertedAmount: amount,
        appliedRate: ExchangeRateValue(
          fromCurrency: from,
          toCurrency: to,
          // 1:1 환율 = kExchangeRateMultiplier
          rate: kExchangeRateMultiplier,
        ),
      );
    }

    final rate = await _exchangeRateRepository.findRate(from, to, tradeDate);
    if (rate == null) {
      throw ExchangeRateNotFoundError(
        from: from,
        to: to,
        date: tradeDate,
      );
    }

    final convertedAmount = rate.convert(amount);
    return (convertedAmount: convertedAmount, appliedRate: rate);
  }

  /// Money VO를 받아 환산 — 편의 오버로드
  Future<({Money convertedMoney, ExchangeRateValue appliedRate})> executeFromMoney({
    required Money money,
    required CurrencyCode to,
    required DateTime tradeDate,
  }) async {
    final result = await execute(
      amount: money.amountMinorUnits,
      from: money.currency,
      to: to,
      tradeDate: tradeDate,
    );
    return (
      convertedMoney: Money(
        amountMinorUnits: result.convertedAmount,
        currency: to,
      ),
      appliedRate: result.appliedRate,
    );
  }
}

/// 환율 데이터 미존재 에러
/// ConvertCurrency, EvaluateUnrealizedFxGain 모두에서 사용
class ExchangeRateNotFoundError extends DomainError {
  ExchangeRateNotFoundError({
    required CurrencyCode from,
    required CurrencyCode to,
    required DateTime date,
  }) : super(
          '환율 데이터 없음: ${from.name}→${to.name} '
          '(${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}). '
          '환율을 먼저 등록하세요.',
        );
}
