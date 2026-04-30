import '../../../core/constants/Enums.dart';
import '../../../core/models/PeriodComparison.dart';
import '../data/ReportQueryService.dart';

/// 기간 비교 UseCase (v2.0 §7.5)
///
/// MOM/QOQ/YOY/YOY_ANNUAL 4종 증감 계산
/// 입력: 두 기간의 B/S 또는 P/L 잔액
/// 출력: 계정 경로별 증감액/증감률 (배율 10000)
class ComparePeriods {
  ComparePeriods(this._queryService);
  final ReportQueryService _queryService;

  /// B/S 기간 비교 — 두 시점의 잔액 증감
  Future<List<PeriodComparison>> compareBalanceSheet({
    required DateTime currentDate,
    required DateTime previousDate,
    required String comparisonType,
  }) async {
    final listCurrent = await _queryService.calculateBalanceSheet(snapshotDate: currentDate);
    final listPrevious = await _queryService.calculateBalanceSheet(snapshotDate: previousDate);

    // path 기준으로 매핑
    final mapPrevious = <String, int>{};
    for (final entry in listPrevious) {
      mapPrevious[entry.equityTypePath] = (mapPrevious[entry.equityTypePath] ?? 0) + entry.balance;
    }

    final mapCurrent = <String, int>{};
    for (final entry in listCurrent) {
      mapCurrent[entry.equityTypePath] = (mapCurrent[entry.equityTypePath] ?? 0) + entry.balance;
    }

    // 전체 path 집합
    final setPaths = {...mapCurrent.keys, ...mapPrevious.keys};
    final listResults = <PeriodComparison>[];

    for (final path in setPaths) {
      final current = mapCurrent[path] ?? 0;
      final previous = mapPrevious[path] ?? 0;
      listResults.add(_buildComparison(current, previous, comparisonType, label: path));
    }

    return listResults;
  }

  /// P/L 기간 비교 — 두 기간의 발생액 증감
  Future<List<PeriodComparison>> compareIncomeStatement({
    required int currentPeriodId,
    required int previousPeriodId,
    required String comparisonType,
  }) async {
    final listCurrent = await _queryService.calculateIncomeStatement(periodId: currentPeriodId);
    final listPrevious = await _queryService.calculateIncomeStatement(periodId: previousPeriodId);

    final mapPrevious = <String, int>{};
    for (final entry in listPrevious) {
      mapPrevious[entry.equityTypePath] = (mapPrevious[entry.equityTypePath] ?? 0) + entry.amount;
    }

    final mapCurrent = <String, int>{};
    for (final entry in listCurrent) {
      mapCurrent[entry.equityTypePath] = (mapCurrent[entry.equityTypePath] ?? 0) + entry.amount;
    }

    final setPaths = {...mapCurrent.keys, ...mapPrevious.keys};
    final listResults = <PeriodComparison>[];

    for (final path in setPaths) {
      final current = mapCurrent[path] ?? 0;
      final previous = mapPrevious[path] ?? 0;
      listResults.add(_buildComparison(current, previous, comparisonType, label: path));
    }

    return listResults;
  }

  /// 4종 비교를 한번에 (대시보드용)
  /// 반환: comparisonType → `List<PeriodComparison>`
  Future<Map<String, List<PeriodComparison>>> compareAllTypes({
    required DateTime asOfDate,
    required int currentPeriodId,
  }) async {
    final results = <String, List<PeriodComparison>>{};

    // MOM: 전월 대비
    final momPrev = DateTime(asOfDate.year, asOfDate.month - 1, asOfDate.day);
    results[ComparisonType.mom.name] = await compareBalanceSheet(
      currentDate: asOfDate,
      previousDate: momPrev,
      comparisonType: ComparisonType.mom.name,
    );

    // QOQ: 전분기 대비
    final qoqPrev = DateTime(asOfDate.year, asOfDate.month - 3, asOfDate.day);
    results[ComparisonType.qoq.name] = await compareBalanceSheet(
      currentDate: asOfDate,
      previousDate: qoqPrev,
      comparisonType: ComparisonType.qoq.name,
    );

    // YOY: 전년동기 대비
    final yoyPrev = DateTime(asOfDate.year - 1, asOfDate.month, asOfDate.day);
    results[ComparisonType.yoy.name] = await compareBalanceSheet(
      currentDate: asOfDate,
      previousDate: yoyPrev,
      comparisonType: ComparisonType.yoy.name,
    );

    return results;
  }

  PeriodComparison _buildComparison(int current, int previous, String comparisonType, {required String label}) {
    final changeAmount = current - previous;
    final changeRatio = previous != 0
        ? (changeAmount * kRatioMultiplier) ~/ previous
        : 0;
    return PeriodComparison(
      currentValue: current,
      previousValue: previous,
      changeAmount: changeAmount,
      label: label,
      changeRatio: changeRatio,
      comparisonType: comparisonType,
    );
  }
}
