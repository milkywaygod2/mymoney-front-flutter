import '../../../core/constants/Enums.dart';
import '../../../core/domain/Perspective.dart';
import '../data/ReportQueryService.dart';

/// P/L(손익계산서) 집계 결과
class IncomeStatement {
  const IncomeStatement({
    required this.periodId,
    required this.listRevenues,
    required this.listExpenses,
    required this.totalRevenue,
    required this.totalExpense,
  });

  final int periodId;

  /// 수익 항목 목록
  final List<IncomeStatementEntry> listRevenues;

  /// 비용 항목 목록
  final List<IncomeStatementEntry> listExpenses;

  final int totalRevenue;
  final int totalExpense;

  /// 당기순이익 (수익 - 비용)
  /// 양수 = 이익, 음수 = 손실
  int get netIncome => totalRevenue - totalExpense;

  /// 손익 여부
  bool get isProfit => netIncome >= 0;
}

/// GenerateIncomeStatement — 손익계산서 생성 UseCase
///
/// [아키텍처 근거 — CW_ARCHITECTURE.md 섹션 7.1]
/// P/L은 기간(periodId) 내 수익/비용 계정의 JEL 집계.
/// 결산 5단계에서 손익 마감 전 최종 당기순이익 확정에 사용.
class GenerateIncomeStatement {
  GenerateIncomeStatement(this._queryService);
  final ReportQueryService _queryService;

  /// P/L 생성
  ///
  /// [periodId] 결산 기간 ID
  /// [perspective] 관점 필터 (null = 전체)
  Future<IncomeStatement> execute({
    required int periodId,
    Perspective? perspective,
  }) async {
    final listEntries = await _queryService.calculateIncomeStatement(
      periodId: periodId,
      perspective: perspective,
    );

    final listRevenues = listEntries
        .where((e) => e.nature == AccountNature.revenue)
        .toList();
    final listExpenses = listEntries
        .where((e) => e.nature == AccountNature.expense)
        .toList();

    final totalRevenue =
        listRevenues.fold<int>(0, (sum, e) => sum + e.amount);
    final totalExpense =
        listExpenses.fold<int>(0, (sum, e) => sum + e.amount);

    return IncomeStatement(
      periodId: periodId,
      listRevenues: listRevenues,
      listExpenses: listExpenses,
      totalRevenue: totalRevenue,
      totalExpense: totalExpense,
    );
  }
}
