import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/theme/AppColors.dart';
import 'ReportBloc.dart';
import '../usecase/GenerateIncomeStatement.dart';
import '../data/ReportQueryService.dart';

/// P/L 차트 — 수익/비용/순이익 시각화
class PLChart extends StatelessWidget {
  const PLChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportBloc, ReportState>(
      buildWhen: (prev, curr) =>
          prev.incomeStatement != curr.incomeStatement,
      builder: (context, state) {
        final pl = state.incomeStatement;
        if (pl == null) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '손익계산서',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _PLBarChart(pl: pl),
              const SizedBox(height: 12),
              _NetIncomeChip(netIncome: pl.netIncome),
              const SizedBox(height: 12),
              _PLDetailSection(pl: pl),
            ],
          ),
        );
      },
    );
  }
}

/// 수익/비용 비교 막대 차트
class _PLBarChart extends StatelessWidget {
  const _PLBarChart({required this.pl});
  final IncomeStatement pl;

  @override
  Widget build(BuildContext context) {
    final maxVal =
        pl.totalRevenue > pl.totalExpense ? pl.totalRevenue : pl.totalExpense;

    return Column(
      children: [
        _Bar(
          label: '수익',
          value: pl.totalRevenue,
          maxValue: maxVal,
          color: AppColors.revenueDeep,
        ),
        const SizedBox(height: 6),
        _Bar(
          label: '비용',
          value: pl.totalExpense,
          maxValue: maxVal,
          color: AppColors.natureExpense,
        ),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.label,
    required this.value,
    required this.maxValue,
    required this.color,
  });

  final String label;
  final int value;
  final int maxValue;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ratio = maxValue > 0 ? value / maxValue : 0.0;

    return Row(
      children: [
        SizedBox(
          width: 36,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio.clamp(0.0, 1.0),
              minHeight: 20,
              backgroundColor: color.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 80,
          child: Text(
            _fmt(value),
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  String _fmt(int v) {
    if (v.abs() >= 100000000) return '${(v / 100000000).toStringAsFixed(1)}억';
    if (v.abs() >= 10000) return '${(v / 10000).toStringAsFixed(0)}만';
    return '₩$v';
  }
}

class _NetIncomeChip extends StatelessWidget {
  const _NetIncomeChip({required this.netIncome});
  final int netIncome;

  @override
  Widget build(BuildContext context) {
    final isProfit = netIncome >= 0;
    final color = isProfit ? AppColors.stateSuccess : AppColors.stateError;
    final label = isProfit ? '당기순이익' : '당기순손실';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          Text(
            _fmtFull(netIncome.abs()),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _fmtFull(int v) {
    final s = v.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return '₩${buf.toString()}';
  }
}

/// P/L 세부 항목 섹션
class _PLDetailSection extends StatefulWidget {
  const _PLDetailSection({required this.pl});
  final IncomeStatement pl;

  @override
  State<_PLDetailSection> createState() => _PLDetailSectionState();
}

class _PLDetailSectionState extends State<_PLDetailSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Row(
            children: [
              const Text(
                '항목 세부 내역',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const Spacer(),
              Icon(
                _expanded ? Icons.expand_less : Icons.expand_more,
                size: 18,
                color: Colors.grey,
              ),
            ],
          ),
        ),
        if (_expanded) ...[
          const SizedBox(height: 8),
          _PLEntryList(
            title: '수익',
            entries: widget.pl.listRevenues,
            color: AppColors.revenueDeep,
          ),
          const SizedBox(height: 4),
          _PLEntryList(
            title: '비용',
            entries: widget.pl.listExpenses,
            color: AppColors.natureExpense,
          ),
        ],
      ],
    );
  }
}

class _PLEntryList extends StatelessWidget {
  const _PLEntryList({
    required this.title,
    required this.entries,
    required this.color,
  });

  final String title;
  final List<IncomeStatementEntry> entries;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        ...entries.map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    e.accountName,
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
                Text(
                  _fmt(e.amount),
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _fmt(int v) {
    final s = v.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return '₩${buf.toString()}';
  }
}
