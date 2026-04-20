import '../../../core/constants/Enums.dart';
import '../../../core/models/EquityChangeItem.dart';
import '../data/ReportQueryService.dart';
import 'GenerateIncomeStatement.dart';

/// 자본변동표(CE) 생성 결과
class EquityChangeStatement {
  const EquityChangeStatement({
    required this.periodId,
    required this.listItems,
  });

  final int periodId;
  final List<EquityChangeItem> listItems;

  /// 기초잔액 행
  EquityChangeItem get beginningBalance =>
      listItems.firstWhere((i) => i.changeType == EquityChangeType.beginningBalance);

  /// 기말잔액 행
  EquityChangeItem get endingBalance =>
      listItems.firstWhere((i) => i.changeType == EquityChangeType.endingBalance);

  /// 자본 총 변동액
  int get totalChange => endingBalance.total - beginningBalance.total;
}

/// GenerateEquityChangeStatement — 자본변동표 생성 UseCase
///
/// [아키텍처 근거 — CW_ARCHITECTURE.md §7.7]
/// 5구성요소 (자본금/자본잉여금/기타자본/AOCI/이익잉여금) 롤포워드
/// 기초잔액 + 당기순이익 + OCI변동 + 배당 + 기타 = 기말잔액
class GenerateEquityChangeStatement {
  GenerateEquityChangeStatement({
    required ReportQueryService queryService,
    required GenerateIncomeStatement generateIncomeStatement,
  })  : _queryService = queryService,
        _generateIncomeStatement = generateIncomeStatement;

  final ReportQueryService _queryService;
  final GenerateIncomeStatement _generateIncomeStatement;

  /// CE 생성
  ///
  /// [periodId] 결산 기간 ID
  Future<EquityChangeStatement> execute({
    required int periodId,
  }) async {
    final listItems = <EquityChangeItem>[];

    // 1. 기말 자본 잔액 조회 (B/S에서 EQUITY 계정 추출)
    final listBsEntries = await _queryService.calculateBalanceSheet(periodId);

    // 자본 5구성요소별 기말 잔액 집계
    var capitalStock = 0;
    var capitalSurplus = 0;
    var otherCapital = 0;
    var aoci = 0;
    var retainedEarnings = 0;

    for (final entry in listBsEntries) {
      final path = entry.equityTypePath;
      if (path.startsWith('EQUITY.CAPITAL_SURPLUS')) {
        capitalSurplus += entry.balance;
      } else if (path.startsWith('EQUITY.CAPITAL')) {
        capitalStock += entry.balance;
      } else if (path.startsWith('EQUITY.OCI_ACCUMULATED')) {
        aoci += entry.balance;
      } else if (path.startsWith('EQUITY.RETAINED')) {
        retainedEarnings += entry.balance;
      } else if (path.startsWith('EQUITY.OTHER')) {
        otherCapital += entry.balance;
      }
    }

    // 2. 당기순이익
    final incomeStatement = await _generateIncomeStatement.execute(periodId: periodId);
    final netIncome = incomeStatement.netIncome;

    // 3. 기초잔액 = 기말잔액 - 당기 변동
    // 간이 계산: 기초 이익잉여금 = 기말 - 당기순이익 (배당/기타 무시 — P3에서 정밀화)
    final beginningRetainedEarnings = retainedEarnings - netIncome;

    // 기초잔액 행
    listItems.add(EquityChangeItem(
      changeType: EquityChangeType.beginningBalance,
      capitalStock: capitalStock,
      capitalSurplus: capitalSurplus,
      otherCapital: otherCapital,
      aoci: aoci,
      retainedEarnings: beginningRetainedEarnings,
    ));

    // 당기순이익 행 (이익잉여금에만 반영)
    listItems.add(EquityChangeItem(
      changeType: EquityChangeType.netIncome,
      capitalStock: 0,
      capitalSurplus: 0,
      otherCapital: 0,
      aoci: 0,
      retainedEarnings: netIncome,
    ));

    // OCI 변동 행 — 5항목 각각
    // TODO: OCI 계정별 당기 변동 분해 (P2에서 정밀화)
    // 현재는 AOCI 전체를 otherOci로 합산
    for (final ociCat in OciCategory.values) {
      listItems.add(EquityChangeItem(
        changeType: EquityChangeType.ociChange,
        ociCategory: ociCat,
        capitalStock: 0,
        capitalSurplus: 0,
        otherCapital: 0,
        aoci: 0, // P2에서 OCI 계정별 변동 분해
        retainedEarnings: 0,
      ));
    }

    // 배당 행
    // TODO: 배당 거래 조회 (P3에서 구현)
    listItems.add(const EquityChangeItem(
      changeType: EquityChangeType.dividends,
      capitalStock: 0,
      capitalSurplus: 0,
      otherCapital: 0,
      aoci: 0,
      retainedEarnings: 0, // 배당 금액 (음수)
    ));

    // 기타 자본거래 행
    listItems.add(const EquityChangeItem(
      changeType: EquityChangeType.other,
      capitalStock: 0,
      capitalSurplus: 0,
      otherCapital: 0,
      aoci: 0,
      retainedEarnings: 0,
    ));

    // 기말잔액 행
    listItems.add(EquityChangeItem(
      changeType: EquityChangeType.endingBalance,
      capitalStock: capitalStock,
      capitalSurplus: capitalSurplus,
      otherCapital: otherCapital,
      aoci: aoci,
      retainedEarnings: retainedEarnings,
    ));

    return EquityChangeStatement(
      periodId: periodId,
      listItems: listItems,
    );
  }
}
