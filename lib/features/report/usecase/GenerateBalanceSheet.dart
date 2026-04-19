import '../../../core/constants/Enums.dart';
import '../../../core/domain/Perspective.dart';
import '../data/ReportQueryService.dart';

/// B/S(재무상태표) 집계 결과
class BalanceSheet {
  const BalanceSheet({
    required this.snapshotDate,
    required this.listAssets,
    required this.listLiabilities,
    required this.listEquities,
    required this.totalAssets,
    required this.totalLiabilities,
    required this.totalEquity,
  });

  final DateTime snapshotDate;

  /// 자산 항목 목록
  final List<BalanceSheetEntry> listAssets;

  /// 부채 항목 목록
  final List<BalanceSheetEntry> listLiabilities;

  /// 자본 항목 목록
  final List<BalanceSheetEntry> listEquities;

  final int totalAssets;
  final int totalLiabilities;
  final int totalEquity;

  /// 순자산 (자산 - 부채) — 대차 균형 검증용
  int get netAssets => totalAssets - totalLiabilities;

  /// 대차균형 여부 (자산 = 부채 + 자본)
  bool get isBalanced => totalAssets == totalLiabilities + totalEquity;
}

/// GenerateBalanceSheet — 재무상태표 생성 UseCase
///
/// [아키텍처 근거 — CW_ARCHITECTURE.md 섹션 7.1]
/// B/S는 JEL 누적 집계. snapshotDate까지의 Posted 거래 기준.
/// Perspective 필터 적용으로 "가구원별" 또는 "전체" 재무상태표 생성 가능.
class GenerateBalanceSheet {
  GenerateBalanceSheet(this._queryService);
  final ReportQueryService _queryService;

  /// B/S 생성
  ///
  /// [snapshotDate] 기준일 (기말 마감일 또는 현재 시각)
  /// [perspective] 관점 필터 (null = 전체)
  Future<BalanceSheet> execute({
    required DateTime snapshotDate,
    Perspective? perspective,
  }) async {
    final listEntries = await _queryService.calculateBalanceSheet(
      snapshotDate: snapshotDate,
      perspective: perspective,
    );

    // 성격별 분류
    final listAssets = listEntries
        .where((e) => e.nature == AccountNature.asset)
        .toList();
    final listLiabilities = listEntries
        .where((e) => e.nature == AccountNature.liability)
        .toList();
    final listEquities = listEntries
        .where((e) => e.nature == AccountNature.equity)
        .toList();

    // 합계 계산
    // 자산: 차변 잔액이 양수 → balance 그대로
    // 부채/자본: 대변 잔액이 정상 → DB에서 (차변-대변) 이므로 음수가 정상
    //           표시용으로는 절댓값 사용
    final totalAssets = listAssets.fold<int>(0, (sum, e) => sum + e.balance);
    final totalLiabilities =
        listLiabilities.fold<int>(0, (sum, e) => sum + e.balance.abs());
    final totalEquity =
        listEquities.fold<int>(0, (sum, e) => sum + e.balance.abs());

    return BalanceSheet(
      snapshotDate: snapshotDate,
      listAssets: listAssets,
      listLiabilities: listLiabilities,
      listEquities: listEquities,
      totalAssets: totalAssets,
      totalLiabilities: totalLiabilities,
      totalEquity: totalEquity,
    );
  }
}
