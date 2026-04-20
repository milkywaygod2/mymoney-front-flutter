import '../data/ReportQueryService.dart';

/// OCI 개별 항목
class OciItem {
  const OciItem({
    required this.path,
    required this.name,
    required this.amount,
  });
  final String path;
  final String name;
  final int amount;
}

/// 총포괄이익 계산 결과
class ComprehensiveIncomeResult {
  const ComprehensiveIncomeResult({
    required this.netIncome,
    required this.listOciItems,
    required this.totalOci,
    required this.comprehensiveIncome,
  });

  /// 당기순이익 (P/L)
  final int netIncome;
  /// OCI 개별 항목 목록 (5종)
  final List<OciItem> listOciItems;
  /// OCI 합계
  final int totalOci;
  /// 총포괄이익 = 당기순이익 + OCI
  final int comprehensiveIncome;
}

/// GenerateComprehensiveIncome — 총포괄이익 계산 UseCase (v2.0 §12.1a)
///
/// 당기순이익(P/L) + OCI 5항목 합계 = 총포괄이익
/// OCI 5항목:
///   1. FVOCI 평가손익 (EQUITY.OCI_ACCUMULATED.FVOCI_VALUATION)
///   2. 해외사업환산손익 (EQUITY.OCI_ACCUMULATED.FOREIGN_CURRENCY_TRANSLATION)
///   3. 지분법자본변동 (EQUITY.OCI_ACCUMULATED.EQUITY_METHOD_CHANGES)
///   4. 보험수리적손익 (EQUITY.OCI_ACCUMULATED.ACTUARIAL)
///   5. 기타포괄손익 (EQUITY.OCI_ACCUMULATED.OTHER_OCI)
class GenerateComprehensiveIncome {
  GenerateComprehensiveIncome(this._queryService);
  final ReportQueryService _queryService;

  /// OCI 5종 Path → 표시명 매핑
  static const Map<String, String> _kOciPaths = {
    'EQUITY.OCI_ACCUMULATED.FVOCI_VALUATION': 'FVOCI 평가손익',
    'EQUITY.OCI_ACCUMULATED.FOREIGN_CURRENCY_TRANSLATION': '해외사업환산손익',
    'EQUITY.OCI_ACCUMULATED.EQUITY_METHOD_CHANGES': '지분법자본변동',
    'EQUITY.OCI_ACCUMULATED.ACTUARIAL': '보험수리적손익',
    'EQUITY.OCI_ACCUMULATED.OTHER_OCI': '기타포괄손익',
  };

  Future<ComprehensiveIncomeResult> execute({
    required int periodId,
  }) async {
    // P/L에서 당기순이익 조회
    final listPl = await _queryService.calculateIncomeStatement(periodId: periodId);
    int totalRevenue = 0;
    int totalExpense = 0;
    for (final entry in listPl) {
      if (entry.equityTypePath.startsWith('REVENUE')) {
        totalRevenue += entry.balance;
      } else if (entry.equityTypePath.startsWith('EXPENSE')) {
        totalExpense += entry.balance;
      }
    }
    final netIncome = totalRevenue - totalExpense;

    // B/S에서 OCI 계정 잔액 조회 — 당기 변동분
    // OCI 누계액은 B/S 자본 항목이므로 calculateBalanceSheet에서 조회
    final listBs = await _queryService.calculateBalanceSheet(
      snapshotDate: DateTime.now(),
    );

    final listOciItems = <OciItem>[];
    int totalOci = 0;

    for (final entry in _kOciPaths.entries) {
      final path = entry.key;
      final name = entry.value;
      // OCI 경로에 해당하는 잔액 합산
      final amount = listBs
          .where((e) => e.equityTypePath == path)
          .fold(0, (sum, e) => sum + e.balance);
      listOciItems.add(OciItem(path: path, name: name, amount: amount));
      totalOci += amount;
    }

    return ComprehensiveIncomeResult(
      netIncome: netIncome,
      listOciItems: listOciItems,
      totalOci: totalOci,
      comprehensiveIncome: netIncome + totalOci,
    );
  }
}
