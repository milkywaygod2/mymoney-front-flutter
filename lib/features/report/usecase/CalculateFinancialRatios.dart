import '../../../core/constants/Enums.dart';
import '../../../core/models/FinancialRatio.dart';
import '../data/ReportQueryService.dart';

/// 재무비율 계산 UseCase (v2.0 §7.4)
///
/// P1 MVP 8종:
///   순자산증가율 / 저축율 / 유동비율 / 부채비율
///   ROA / ROE / 매출채권회전율 / 이자보상비율
///
/// Rolling 12M 패턴:
///   분자(순이익/매출) = SUM(JEL) WHERE date BETWEEN (asOf - 12M) AND asOf
///   분모(평균자산)    = (잔액(asOf) + 잔액(asOf - 12M)) / 2
class CalculateFinancialRatios {
  CalculateFinancialRatios(this._queryService);
  final ReportQueryService _queryService;

  /// 8종 MVP 비율 계산
  Future<List<FinancialRatio>> execute({
    required int periodId,
    required DateTime asOfDate,
  }) async {
    final listRatios = <FinancialRatio>[];
    final now = asOfDate;
    final oneYearAgo = DateTime(now.year - 1, now.month, now.day);

    // --- B/S 시점 잔액 조회 ---
    final mapBsCurrent = await _queryService.calculateBalanceSheet(
      snapshotDate: now,
    );
    final mapBsPrevious = await _queryService.calculateBalanceSheet(
      snapshotDate: oneYearAgo,
    );

    // B/S 집계: nature별 합산
    final currentAssets = _sumByNature(mapBsCurrent, AccountNature.asset);
    final currentLiabilities = _sumByNature(mapBsCurrent, AccountNature.liability);
    final currentEquity = _sumByNature(mapBsCurrent, AccountNature.equity);
    final previousAssets = _sumByNature(mapBsPrevious, AccountNature.asset);
    final previousEquity = _sumByNature(mapBsPrevious, AccountNature.equity);

    // 유동/비유동 분리 (path 기반)
    final currentCurrentAssets = _sumByPath(mapBsCurrent, 'ASSET.CURRENT');
    final currentCurrentLiabilities = _sumByPath(mapBsCurrent, 'LIABILITY.CURRENT');
    final currentReceivables = _sumByPath(mapBsCurrent, 'ASSET.CURRENT.RECEIVABLE');
    final previousReceivables = _sumByPath(mapBsPrevious, 'ASSET.CURRENT.RECEIVABLE');

    final netAssetsCurrent = currentAssets - currentLiabilities;
    final netAssetsPrevious = previousAssets - _sumByNature(mapBsPrevious, AccountNature.liability);

    // --- P/L Rolling 12M 조회 ---
    final mapPl = await _queryService.calculateIncomeStatement(periodId: periodId);
    final totalRevenue = _sumByNature(mapPl, AccountNature.revenue);
    final totalExpense = _sumByNature(mapPl, AccountNature.expense);
    final netIncome = totalRevenue - totalExpense;

    // 이자비용 (path 기반)
    final interestExpense = _sumByPath(mapPl, 'EXPENSE.FINANCIAL').abs();
    // 영업이익 (매출 - 영업비용, 금융/기타 제외)
    final operatingExpense = _sumByPath(mapPl, 'EXPENSE.LIVING') +
        _sumByPath(mapPl, 'EXPENSE.OPERATING') +
        _sumByPath(mapPl, 'EXPENSE.DEPRECIATION');
    final operatingIncome = totalRevenue - operatingExpense;

    // 평균값 (T + T-12) / 2
    final avgTotalAssets = (currentAssets + previousAssets) ~/ 2;
    final avgEquity = (currentEquity + previousEquity) ~/ 2;
    final avgReceivables = (currentReceivables + previousReceivables) ~/ 2;

    // --- 비율 계산 ---

    // 1. 순자산증가율 = (기말순자산 - 기초순자산) / 기초순자산
    listRatios.add(_buildRatio(
      code: 'NET_ASSET_GROWTH',
      category: RatioCategory.growth,
      periodId: periodId,
      numerator: netAssetsCurrent - netAssetsPrevious,
      denominator: netAssetsPrevious,
    ));

    // 2. 저축율 = (수입 - 지출) / 수입
    listRatios.add(_buildRatio(
      code: 'SAVINGS_RATE',
      category: RatioCategory.growth,
      periodId: periodId,
      numerator: netIncome,
      denominator: totalRevenue,
    ));

    // 3. 유동비율 = 유동자산 / 유동부채
    listRatios.add(_buildRatio(
      code: 'CURRENT_RATIO',
      category: RatioCategory.stability,
      periodId: periodId,
      numerator: currentCurrentAssets,
      denominator: currentCurrentLiabilities,
    ));

    // 4. 부채비율 = 부채 / 자기자본
    listRatios.add(_buildRatio(
      code: 'DEBT_RATIO',
      category: RatioCategory.stability,
      periodId: periodId,
      numerator: currentLiabilities,
      denominator: currentEquity,
    ));

    // 5. ROA = Rolling12M(순이익) / 평균(총자산)
    listRatios.add(_buildRatio(
      code: 'ROA',
      category: RatioCategory.profitability,
      periodId: periodId,
      numerator: netIncome,
      denominator: avgTotalAssets,
    ));

    // 6. ROE = Rolling12M(순이익) / 평균(자기자본)
    listRatios.add(_buildRatio(
      code: 'ROE',
      category: RatioCategory.profitability,
      periodId: periodId,
      numerator: netIncome,
      denominator: avgEquity,
    ));

    // 7. 매출채권회전율 = Rolling12M(매출) / 평균(매출채권)
    listRatios.add(_buildRatio(
      code: 'AR_TURNOVER',
      category: RatioCategory.activity,
      periodId: periodId,
      numerator: totalRevenue,
      denominator: avgReceivables,
    ));

    // 8. 이자보상비율 = 영업이익 / 이자비용
    listRatios.add(_buildRatio(
      code: 'INTEREST_COVERAGE',
      category: RatioCategory.stability,
      periodId: periodId,
      numerator: operatingIncome,
      denominator: interestExpense,
    ));

    // === P2 확장 +5종 (총 13종) ===

    // 9. 자본유보율 = (이익잉여금 + 자본잉여금) / 납입자본금 × 100
    final retainedEarnings = _sumByPath(mapBsCurrent, 'EQUITY.RETAINED');
    final capitalSurplus = _sumByPath(mapBsCurrent, 'EQUITY.SURPLUS');
    final capitalStock = _sumByPath(mapBsCurrent, 'EQUITY.CAPITAL');
    listRatios.add(_buildRatio(
      code: 'CAPITAL_RESERVE',
      category: RatioCategory.stability,
      periodId: periodId,
      numerator: retainedEarnings + capitalSurplus,
      denominator: capitalStock,
    ));

    // 10. 총자산회전율 = Rolling12M(매출) / 총자산
    listRatios.add(_buildRatio(
      code: 'ASSET_TURNOVER',
      category: RatioCategory.activity,
      periodId: periodId,
      numerator: totalRevenue,
      denominator: currentAssets,
    ));

    // 11. 자기자본회전율 = Rolling12M(매출) / 자기자본
    listRatios.add(_buildRatio(
      code: 'EQUITY_TURNOVER',
      category: RatioCategory.activity,
      periodId: periodId,
      numerator: totalRevenue,
      denominator: currentEquity,
    ));

    // 12. 채권회수기간 = 365 / 매출채권회전율
    final arTurnoverValue = avgReceivables != 0
        ? (totalRevenue * kRatioMultiplier) ~/ avgReceivables
        : 0;
    final arDays = arTurnoverValue != 0
        ? (365 * kRatioMultiplier * kRatioMultiplier) ~/ arTurnoverValue
        : 0;
    listRatios.add(FinancialRatio(
      ratioCode: 'AR_DAYS',
      category: RatioCategory.activity.name,
      periodId: periodId,
      numerator: 365,
      denominator: arTurnoverValue,
      ratioValue: arDays,
      calculatedAt: DateTime.now(),
    ));

    // 13. 기부금비율 = 기부금 / 매출
    final donations = _sumByPath(mapPl, 'EXPENSE.OTHER').abs();
    listRatios.add(_buildRatio(
      code: 'DONATION_RATIO',
      category: RatioCategory.activity,
      periodId: periodId,
      numerator: donations,
      denominator: totalRevenue,
    ));

    return listRatios;
  }

  // --- 헬퍼 ---

  /// nature별 잔액 합산
  int _sumByNature(List<BalanceSheetEntry> list, AccountNature nature) {
    return list
        .where((e) => e.nature == nature)
        .fold(0, (sum, e) => sum + e.balance);
  }

  /// path prefix별 잔액 합산
  int _sumByPath(List<BalanceSheetEntry> list, String pathPrefix) {
    return list
        .where((e) => e.equityTypePath.startsWith(pathPrefix))
        .fold(0, (sum, e) => sum + e.balance);
  }

  /// FinancialRatio 생성 (0으로 나누기 방어)
  FinancialRatio _buildRatio({
    required String code,
    required RatioCategory category,
    required int periodId,
    required int numerator,
    required int denominator,
  }) {
    // 0으로 나누기 방어 — 분모 0이면 비율 0
    final ratioValue = denominator != 0
        ? (numerator * kRatioMultiplier) ~/ denominator
        : 0;
    return FinancialRatio(
      ratioCode: code,
      category: category.name,
      periodId: periodId,
      numerator: numerator,
      denominator: denominator,
      ratioValue: ratioValue,
      calculatedAt: DateTime.now(),
    );
  }
}
