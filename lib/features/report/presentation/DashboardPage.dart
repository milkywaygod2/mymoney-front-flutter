import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/theme/AppColors.dart';
import '../../../core/models/PeriodComparison.dart';
import 'ReportBloc.dart';
import 'RatioGrid.dart';
import 'BSChart.dart';
import 'PLChart.dart';
import 'CFWaterfall.dart';
import 'CETable.dart';

/// 대시보드 페이지 — 재무비율 + B/S + P/L + CF + CE 통합 보기
/// Wave U6 재작성 (기존 순자산 요약 카드 페이지를 풀 대시보드로 확장)
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  /// 기간 비교 토글 — MOM / QOQ / YOY
  String _comparisonType = 'mom';

  static const _kComparisonLabels = {
    'mom': '전월',
    'qoq': '전분기',
    'yoy': '전년동기',
  };

  @override
  void initState() {
    super.initState();
    context.read<ReportBloc>().add(const LoadDashboard());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('재무 대시보드'),
        actions: [
          _ComparisonToggle(
            selected: _comparisonType,
            labels: _kComparisonLabels,
            onChanged: (v) {
              setState(() => _comparisonType = v);
              _onComparisonChanged(v);
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: '새로고침',
            onPressed: _onRefresh,
          ),
        ],
      ),
      body: BlocListener<ReportBloc, ReportState>(
        listenWhen: (prev, curr) =>
            prev.activePeriodId == null && curr.activePeriodId != null,
        listener: (context, state) => _onRefresh(),
        child: BlocBuilder<ReportBloc, ReportState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.errorMessage != null) {
            return _ErrorView(
              message: state.errorMessage!,
              onRetry: _onRefresh,
            );
          }
          if (state.dashboard == null) {
            return _EmptyView(onLoad: _onRefresh);
          }

          return RefreshIndicator(
            onRefresh: () async => _onRefresh(),
            child: ListView(
              children: [
                // 1. 요약 헤더 (순자산 + 수입/지출)
                _SummaryHeader(
                  comparisonType: _comparisonType,
                ),
                const Divider(height: 1),

                // 1-1. 기간 비교 변화율 카드
                _PeriodComparisonCard(comparisonType: _comparisonType),
                const Divider(height: 1),

                // 2. 재무비율 그리드 (29종)
                const RatioGrid(),
                const Divider(height: 1),

                // 3. B/S 차트
                const BSChart(),
                const Divider(height: 1),

                // 4. P/L 차트
                const PLChart(),
                const Divider(height: 1),

                // 5. CF 폭포 차트
                const _CFSection(),
                const Divider(height: 1),

                // 6. 자본변동표
                const _CESection(),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
        ),
      ),
    );
  }

  void _onRefresh() {
    final bloc = context.read<ReportBloc>();
    bloc.add(const LoadDashboard());
    if (bloc.state.activePeriodId != null) {
      final pid = bloc.state.activePeriodId!;
      final now = DateTime.now();
      bloc.add(LoadFinancialRatios(periodId: pid, asOfDate: now));
      bloc.add(LoadBalanceSheet(snapshotDate: now));
      bloc.add(LoadIncomeStatement(periodId: pid));
      bloc.add(LoadComprehensiveIncome(periodId: pid));
      bloc.add(LoadPeriodComparisons(asOfDate: now, currentPeriodId: pid));
      bloc.add(LoadCashFlowStatement(periodId: pid, snapshotDate: now));
      bloc.add(LoadEquityChangeStatement(periodId: pid, snapshotDate: now));
    }
  }

  void _onComparisonChanged(String type) {
    final bloc = context.read<ReportBloc>();
    if (bloc.state.activePeriodId != null) {
      bloc.add(LoadPeriodComparisons(
        asOfDate: DateTime.now(),
        currentPeriodId: bloc.state.activePeriodId!,
      ));
    }
  }
}

/// 기간 비교 유형 토글 위젯
class _ComparisonToggle extends StatelessWidget {
  const _ComparisonToggle({
    required this.selected,
    required this.labels,
    required this.onChanged,
  });

  final String selected;
  final Map<String, String> labels;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: SegmentedButton<String>(
        segments: labels.entries
            .map(
              (e) => ButtonSegment<String>(
                value: e.key,
                label: Text(e.value, style: const TextStyle(fontSize: 11)),
              ),
            )
            .toList(),
        selected: {selected},
        onSelectionChanged: (s) => onChanged(s.first),
        style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 4),
          ),
        ),
      ),
    );
  }
}

/// 요약 헤더 — 순자산 + 수입/지출 + 기간 비교 증감
class _SummaryHeader extends StatelessWidget {
  const _SummaryHeader({required this.comparisonType});
  final String comparisonType;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportBloc, ReportState>(
      builder: (context, state) {
        final d = state.dashboard;
        if (d == null) return const SizedBox.shrink();

        // 기간 비교 데이터 (있으면 표시)
        final mapComp = state.mapPeriodComparisons;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 순자산 카드
              _SummaryCard(
                label: '순자산',
                amount: d.netAssets,
                color: AppColors.darkPrimary,
                changeRatio: _extractChangeRatio(mapComp, comparisonType),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      label: '수입',
                      amount: d.totalRevenue,
                      color: AppColors.natureAsset,
                      changeRatio: d.revenueChangeRatio,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryCard(
                      label: '지출',
                      amount: d.totalExpense,
                      color: AppColors.natureExpense,
                      changeRatio: d.expenseChangeRatio,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _SummaryCard(
                label: d.netIncome >= 0 ? '당기순이익' : '당기순손실',
                amount: d.netIncome.abs(),
                color: d.netIncome >= 0
                    ? AppColors.stateSuccess
                    : AppColors.stateError,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (d.pendingDraftCount > 0)
                    _DraftBanner(count: d.pendingDraftCount),
                  const Spacer(),
                  Text(
                    '기준일: ${_fmtDate(d.snapshotDate)}',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  int? _extractChangeRatio(
    Map<String, List<PeriodComparison>>? mapComp,
    String comparisonType,
  ) {
    if (mapComp == null) return null;
    final list = mapComp[comparisonType];
    if (list == null || list.isEmpty) return null;
    final equityEntry = list.where(
      (c) => c.label.startsWith('EQUITY') || c.label == 'net_assets',
    ).firstOrNull;
    return equityEntry?.changeRatio;
  }

  String _fmtDate(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.color,
    this.changeRatio,
  });

  final String label;
  final int amount;
  final Color color;
  final int? changeRatio;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(color: color, fontWeight: FontWeight.w600),
                ),
                if (changeRatio != null) _ChangeChip(ratio: changeRatio!),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '₩${_fmtAmount(amount)}',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  String _fmtAmount(int v) {
    final s = v.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

class _ChangeChip extends StatelessWidget {
  const _ChangeChip({required this.ratio});
  final int ratio;

  @override
  Widget build(BuildContext context) {
    final isPositive = ratio >= 0;
    final pct = (ratio / 100).toStringAsFixed(1);
    final sign = isPositive ? '+' : '';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isPositive
            ? AppColors.natureAsset.withValues(alpha: 0.1)
            : AppColors.natureExpense.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$sign$pct%',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isPositive ? AppColors.natureAsset : AppColors.natureExpense,
        ),
      ),
    );
  }
}

/// 미확인 Draft 알림 배너
class _DraftBanner extends StatelessWidget {
  const _DraftBanner({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.pending_actions, size: 14, color: Colors.amber),
          const SizedBox(width: 4),
          Text(
            '미확인 Draft $count건',
            style: const TextStyle(fontSize: 11, color: Colors.amber),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('재시도')),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.onLoad});
  final VoidCallback onLoad;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bar_chart, size: 64, color: Colors.grey),
          const SizedBox(height: 12),
          const Text('데이터를 불러오는 중...'),
          const SizedBox(height: 16),
          FilledButton(onPressed: onLoad, child: const Text('새로고침')),
        ],
      ),
    );
  }
}

/// 기간 비교 변화율 카드 — mapPeriodComparisons에서 선택된 타입의 항목을 표시
class _PeriodComparisonCard extends StatelessWidget {
  const _PeriodComparisonCard({required this.comparisonType});
  final String comparisonType;

  static const _typeLabel = {
    'mom': '전월 대비',
    'qoq': '전분기 대비',
    'yoy': '전년동기 대비',
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportBloc, ReportState>(
      buildWhen: (prev, curr) =>
          prev.mapPeriodComparisons != curr.mapPeriodComparisons,
      builder: (context, state) {
        final list = state.mapPeriodComparisons?[comparisonType];
        if (list == null || list.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              '${_typeLabel[comparisonType] ?? comparisonType} 비교 데이터 없음',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _typeLabel[comparisonType] ?? comparisonType,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: list.map((c) => _ComparisonItem(item: c)).toList(),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}

class _ComparisonItem extends StatelessWidget {
  const _ComparisonItem({required this.item});
  final PeriodComparison item;

  @override
  Widget build(BuildContext context) {
    final ratio = item.changeRatio;
    final isPositive = ratio >= 0;
    final pct = (ratio / 100.0).toStringAsFixed(2);
    final sign = isPositive ? '+' : '';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item.label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 6),
          Text(
            '$sign$pct%',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isPositive ? AppColors.natureAsset : AppColors.natureExpense,
            ),
          ),
        ],
      ),
    );
  }
}

/// CF 폭포 차트 섹션 — cashFlowStatement 있으면 CFWaterfallFull, 없으면 CFWaterfall(stub)
class _CFSection extends StatelessWidget {
  const _CFSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportBloc, ReportState>(
      buildWhen: (prev, curr) =>
          prev.cashFlowStatement != curr.cashFlowStatement,
      builder: (context, state) {
        final cf = state.cashFlowStatement;
        if (cf != null) {
          return CFWaterfallFull(listItems: cf.listItems);
        }
        return const CFWaterfall();
      },
    );
  }
}

/// 자본변동표 섹션 — equityChangeStatement 있으면 실데이터, 없으면 stub CETable
class _CESection extends StatelessWidget {
  const _CESection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportBloc, ReportState>(
      buildWhen: (prev, curr) =>
          prev.equityChangeStatement != curr.equityChangeStatement,
      builder: (context, state) {
        final ce = state.equityChangeStatement;
        if (ce != null) {
          return CETableFull(listItems: ce.listItems);
        }
        return const CETable();
      },
    );
  }
}
