import '../../report/data/ReportQueryService.dart';

/// 통화별 순포지션 뷰 UseCase (v2.0 §7.3 확장)
///
/// JEL의 originalCurrency별로 자산/부채 잔액을 집계하여
/// 통화별 FX 리스크 매트릭스를 생성
///
/// 기능통화(baseCurrency)와 다른 통화의 포지션만 표시
class CalculateFxExposure {
  CalculateFxExposure(this._queryService);
  final ReportQueryService _queryService;

  /// 통화별 FX 익스포저 계산
  ///
  /// baseCurrency와 동일한 통화는 제외 (FX 리스크 없음)
  /// 순포지션 절대값 기준 내림차순 정렬
  Future<List<FxExposureEntry>> execute({
    required DateTime snapshotDate,
    required String baseCurrency,
  }) async {
    final listFxEntries = await _queryService.calculateFxExposure(
      snapshotDate: snapshotDate,
    );

    // baseCurrency 제외
    final listResults = listFxEntries
        .where((e) => e.currency != baseCurrency)
        .toList();

    // 순포지션 절대값 기준 내림차순 정렬 (가장 큰 익스포저 우선)
    listResults.sort((a, b) => b.netPosition.abs().compareTo(a.netPosition.abs()));

    return listResults;
  }
}
