import '../../../core/constants/Enums.dart';
import '../../../core/domain/JournalEntryLine.dart';
import '../../../core/interfaces/IExchangeRateRepository.dart';
import '../../../core/models/CurrencyCode.dart';
import '../../../core/models/ExchangeRateValue.dart';
import 'ConvertCurrency.dart';

/// 미실현 외환차손익 평가 결과
class UnrealizedFxResult {
  const UnrealizedFxResult({
    required this.jelId,
    required this.accountId,
    required this.accountNature,
    required this.originalCurrency,
    required this.baseCurrency,
    required this.originalAmount,
    required this.bookBaseAmount,
    required this.currentBaseAmount,
    required this.gainLossAmount,
    required this.isGain,
    required this.tradeRate,
    required this.currentRate,
  });

  /// 평가 대상 전표 라인 ID
  final int jelId;
  final int accountId;
  final AccountNature accountNature;
  final CurrencyCode originalCurrency;
  final CurrencyCode baseCurrency;

  /// original_currency 기준 원본 금액 (최소 단위 int)
  final int originalAmount;

  /// 장부 base_amount (거래 시점 환율 기준)
  final int bookBaseAmount;

  /// 현재 환율 기준 재평가 금액
  final int currentBaseAmount;

  /// 미실현 손익 금액 (양수 = 이익, 음수 = 손실)
  final int gainLossAmount;

  /// true = 외환차익(이익), false = 외환차손(손실)
  final bool isGain;

  /// 거래 시점 환율 VO
  final ExchangeRateValue tradeRate;

  /// 현재 환율 VO
  final ExchangeRateValue currentRate;
}

/// EvaluateUnrealizedFxGain — 온디맨드 미실현 외환차손익 계산 UseCase
///
/// [아키텍처 근거 — CW_ARCHITECTURE.md 섹션 4 & 7.3]
/// - 외환차손익 전략: Lazy Calculation
///   * 일상 조회: 온디맨드, 저장 안 함
///   * 결산 시: SettlementUseCase에서 자동 전표 생성 + 확정
/// - 자동전표 매핑 (결산용 참고):
///   * Asset + 환율 상승  → 차변 해당자산 / 대변 외환차익(미실현)
///   * Asset + 환율 하락  → 차변 외환차손(미실현) / 대변 해당자산
///   * Liability + 환율 상승 → 차변 외환차손 / 대변 해당부채
///   * Liability + 환율 하락 → 차변 해당부채 / 대변 외환차익
class EvaluateUnrealizedFxGain {
  EvaluateUnrealizedFxGain(this._exchangeRateRepository);
  final IExchangeRateRepository _exchangeRateRepository;

  /// 전표 라인 목록에서 다통화 항목만 추출하여 미실현 손익 계산
  ///
  /// [listLines] 평가 대상 전표 라인 (다통화 JEL만 처리, 동일 통화는 건너뜀)
  /// [accountNatureMap] accountId → AccountNature 매핑 (손익 방향 결정에 필요)
  ///
  /// Returns: 미실현 손익이 있는 라인별 결과 목록 (손익 0인 항목 포함)
  Future<List<UnrealizedFxResult>> execute({
    required List<JournalEntryLine> listLines,
    required Map<int, AccountNature> mapAccountNature,
  }) async {
    final listResults = <UnrealizedFxResult>[];

    for (final jel in listLines) {
      // 동일 통화 JEL은 외환 평가 불필요
      if (jel.originalCurrency == jel.baseCurrency) continue;

      // 현재 환율 조회
      final currentRateVO = await _exchangeRateRepository.getLatestRate(
        jel.originalCurrency,
        jel.baseCurrency,
      );

      // 거래 시점 환율 VO 재구성 (JEL에 저장된 exchangeRateAtTrade 활용)
      final tradeRateVO = ExchangeRateValue(
        fromCurrency: jel.originalCurrency,
        toCurrency: jel.baseCurrency,
        rate: jel.exchangeRateAtTrade,
      );

      // 현재 환율로 재평가한 base_amount
      final currentBaseAmount = currentRateVO.convert(jel.originalAmount);

      // 손익 계산: 현재 재평가액 - 장부가액
      final rawDiff = currentBaseAmount - jel.baseAmount;

      // 계정 성격에 따른 실질 손익 방향 결정
      // [아키텍처 7.3 외환차손익 자동전표 매핑]
      // - Asset: 재평가액 > 장부가 → 이익 (차변 자산 증가)
      // - Liability: 재평가액 > 장부가 → 손실 (대변 부채 증가 = 불리)
      final nature = mapAccountNature[jel.accountId.value];
      final gainLossAmount = switch (nature) {
        AccountNature.asset => rawDiff,
        AccountNature.liability => -rawDiff,
        // 수익/비용/자본은 외환 재평가 대상 외 — 0으로 처리
        _ => 0,
      };

      listResults.add(UnrealizedFxResult(
        jelId: jel.id.value,
        accountId: jel.accountId.value,
        accountNature: nature ?? AccountNature.asset,
        originalCurrency: jel.originalCurrency,
        baseCurrency: jel.baseCurrency,
        originalAmount: jel.originalAmount,
        bookBaseAmount: jel.baseAmount,
        currentBaseAmount: currentBaseAmount,
        gainLossAmount: gainLossAmount,
        isGain: gainLossAmount >= 0,
        tradeRate: tradeRateVO,
        currentRate: currentRateVO,
      ));
    }

    return listResults;
  }

  /// 단일 JEL 평가 — Flow Card 다통화 노드 표시용
  ///
  /// Returns: null이면 동일 통화 (평가 불필요)
  Future<UnrealizedFxResult?> evaluateSingle({
    required JournalEntryLine jel,
    required AccountNature accountNature,
  }) async {
    if (jel.originalCurrency == jel.baseCurrency) return null;

    final currentRateVO = await _exchangeRateRepository.getLatestRate(
      jel.originalCurrency,
      jel.baseCurrency,
    );

    final tradeRateVO = ExchangeRateValue(
      fromCurrency: jel.originalCurrency,
      toCurrency: jel.baseCurrency,
      rate: jel.exchangeRateAtTrade,
    );

    final currentBaseAmount = currentRateVO.convert(jel.originalAmount);
    final rawDiff = currentBaseAmount - jel.baseAmount;
    final gainLossAmount = switch (accountNature) {
      AccountNature.asset => rawDiff,
      AccountNature.liability => -rawDiff,
      _ => 0,
    };

    return UnrealizedFxResult(
      jelId: jel.id.value,
      accountId: jel.accountId.value,
      accountNature: accountNature,
      originalCurrency: jel.originalCurrency,
      baseCurrency: jel.baseCurrency,
      originalAmount: jel.originalAmount,
      bookBaseAmount: jel.baseAmount,
      currentBaseAmount: currentBaseAmount,
      gainLossAmount: gainLossAmount,
      isGain: gainLossAmount >= 0,
      tradeRate: tradeRateVO,
      currentRate: currentRateVO,
    );
  }
}
