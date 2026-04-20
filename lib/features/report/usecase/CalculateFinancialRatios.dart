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
    final listPl = await _queryService.calculateIncomeStatement(periodId: periodId);
    final totalRevenue = _sumPlByNature(listPl, AccountNature.revenue);
    final totalExpense = _sumPlByNature(listPl, AccountNature.expense);
    final netIncome = totalRevenue - totalExpense;

    // 이자비용 (path 기반)
    final interestExpense = _sumPlByPath(listPl, 'EXPENSE.FINANCIAL').abs();
    // 영업이익 (매출 - 영업비용, 금융/기타 제외)
    final operatingExpense = _sumPlByPath(listPl, 'EXPENSE.LIVING') +
        _sumPlByPath(listPl, 'EXPENSE.OPERATING') +
        _sumPlByPath(listPl, 'EXPENSE.DEPRECIATION');
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
    final donations = _sumPlByPath(listPl, 'EXPENSE.OTHER').abs();
    listRatios.add(_buildRatio(
      code: 'DONATION_RATIO',
      category: RatioCategory.activity,
      periodId: periodId,
      numerator: donations,
      denominator: totalRevenue,
    ));

    // === P3 확장 +16종 (총 29종) ===

    // 14. PER = 주가 / EPS (외부 데이터 의존 — 0으로 stub)
    listRatios.add(_buildRatio(code: 'PER', category: RatioCategory.profitability, periodId: periodId, numerator: 0, denominator: 1));

    // 15. EPS = Rolling12M(순이익) / 주식수 (외부 데이터 의존 — 0으로 stub)
    listRatios.add(_buildRatio(code: 'EPS', category: RatioCategory.profitability, periodId: periodId, numerator: netIncome, denominator: 1));

    // 16. ROIC = 세후순영업이익(NOPAT) / 영업투하자본(IC)
    final nopat = operatingIncome; // 간이: 세후 조정 생략
    final investedCapital = currentEquity + currentLiabilities - currentCurrentAssets;
    listRatios.add(_buildRatio(code: 'ROIC', category: RatioCategory.profitability, periodId: periodId, numerator: nopat, denominator: investedCapital));

    // 17. EBITDA 마진율 = (세전이익+이자비용+감���상각비) / 매출
    final depreciation = _sumPlByPath(listPl, 'EXPENSE.DEPRECIATION').abs();
    final ebitda = netIncome + interestExpense + depreciation;
    listRatios.add(_buildRatio(code: 'EBITDA_MARGIN', category: RatioCategory.profitability, periodId: periodId, numerator: ebitda, denominator: totalRevenue));

    // --- 성장성 3종 ---
    // 18. 유동��산��가율
    final prevCurrentAssets = _sumByPath(mapBsPrevious, 'ASSET.CURRENT');
    listRatios.add(_buildRatio(code: 'CURRENT_ASSET_GROWTH', category: RatioCategory.growth, periodId: periodId, numerator: currentCurrentAssets - prevCurrentAssets, denominator: prevCurrentAssets));

    // 19. 유형자산증가율
    final currentTangible = _sumByPath(mapBsCurrent, 'ASSET.NON_CURRENT.TANGIBLE');
    final prevTangible = _sumByPath(mapBsPrevious, 'ASSET.NON_CURRENT.TANGIBLE');
    listRatios.add(_buildRatio(code: 'TANGIBLE_ASSET_GROWTH', category: RatioCategory.growth, periodId: periodId, numerator: currentTangible - prevTangible, denominator: prevTangible));

    // 20. 자기자본증가율
    listRatios.add(_buildRatio(code: 'EQUITY_GROWTH', category: RatioCategory.growth, periodId: periodId, numerator: currentEquity - previousEquity, denominator: previousEquity));

    // --- 안정성 5종 ---
    // 21. 유동부채비율 = 유동부채 / 자본
    listRatios.add(_buildRatio(code: 'CURRENT_LIABILITY_RATIO', category: RatioCategory.stability, periodId: periodId, numerator: currentCurrentLiabilities, denominator: currentEquity));

    // 22. 비유동부채비율 = 비유동부채 / 자본
    final nonCurrentLiabilities = currentLiabilities - currentCurrentLiabilities;
    listRatios.add(_buildRatio(code: 'NON_CURRENT_LIABILITY_RATIO', category: RatioCategory.stability, periodId: periodId, numerator: nonCurrentLiabilities, denominator: currentEquity));

    // 23. 순부채비율 = (부채 - 현금성자산) / 자본
    final cashAssets = _sumByPath(mapBsCurrent, 'ASSET.CURRENT.CASH');
    listRatios.add(_buildRatio(code: 'NET_DEBT_RATIO', category: RatioCategory.stability, periodId: periodId, numerator: currentLiabilities - cashAssets, denominator: currentEquity));

    // 24. 당좌비율 = (유동자산 - 재고) / 유동부채
    final inventories = _sumByPath(mapBsCurrent, 'ASSET.CURRENT.INVENTORY');
    listRatios.add(_buildRatio(code: 'QUICK_RATIO', category: RatioCategory.stability, periodId: periodId, numerator: currentCurrentAssets - inventories, denominator: currentCurrentLiabilities));

    // 25. 금융���부담률 = 이자비용 / 매출
    listRatios.add(_buildRatio(code: 'FINANCIAL_COST_RATIO', category: RatioCategory.stability, periodId: periodId, numerator: interestExpense, denominator: totalRevenue));

    // --- ��동성 5종 ---
    // 26. 재고자산회전율 = 매출 / 평균���고
    final prevInventories = _sumByPath(mapBsPrevious, 'ASSET.CURRENT.INVENTORY');
    final avgInventories = (inventories + prevInventories) ~/ 2;
    listRatios.add(_buildRatio(code: 'INVENTORY_TURNOVER', category: RatioCategory.activity, periodId: periodId, numerator: totalRevenue, denominator: avgInventories));

    // 27. 순운전자본회전율 = 매출 / (유동자산 - 유동부채)
    final nwc = currentCurrentAssets - currentCurrentLiabilities;
    listRatios.add(_buildRatio(code: 'NWC_TURNOVER', category: RatioCategory.activity, periodId: periodId, numerator: totalRevenue, denominator: nwc));

    // 28. 유형자산회전율 = 매출 / 유형자산
    listRatios.add(_buildRatio(code: 'TANGIBLE_ASSET_TURNOVER', category: RatioCategory.activity, periodId: periodId, numerator: totalRevenue, denominator: currentTangible));

    // 29. 매입채무회전율 = 매출원가 / 평균매입채무
    final payables = _sumByPath(mapBsCurrent, 'LIABILITY.CURRENT.PAYABLE');
    final prevPayables = _sumByPath(mapBsPrevious, 'LIABILITY.CURRENT.PAYABLE');
    final avgPayables = (payables + prevPayables) ~/ 2;
    listRatios.add(_buildRatio(code: 'AP_TURNOVER', category: RatioCategory.activity, periodId: periodId, numerator: totalExpense, denominator: avgPayables));

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

  /// P/L nature별 금액 합산 (IncomeStatementEntry 용)
  int _sumPlByNature(List<IncomeStatementEntry> list, AccountNature nature) {
    return list
        .where((e) => e.nature == nature)
        .fold(0, (sum, e) => sum + e.amount);
  }

  /// P/L path prefix별 금액 합산 (IncomeStatementEntry 용)
  int _sumPlByPath(List<IncomeStatementEntry> list, String pathPrefix) {
    return list
        .where((e) => e.equityTypePath.startsWith(pathPrefix))
        .fold(0, (sum, e) => sum + e.amount);
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
