import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ReportBloc.dart';
import '../usecase/GenerateBalanceSheet.dart';
import '../data/ReportQueryService.dart';

/// B/S 차트 — 자산/부채/자본 누적 가로 막대 차트
class BSChart extends StatelessWidget {
  const BSChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportBloc, ReportState>(
      buildWhen: (prev, curr) => prev.balanceSheet != curr.balanceSheet,
      builder: (context, state) {
        final bs = state.balanceSheet;
        if (bs == null) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '재무상태표',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _BalanceBar(
                label: '자산',
                value: bs.totalAssets,
                // TODO: U1 머지 후 AppColors로 교체
                color: const Color(0xFF4CAF50),
                maxValue: bs.totalAssets,
              ),
              const SizedBox(height: 6),
              _BalanceBar(
                label: '부채',
                value: bs.totalLiabilities,
                color: const Color(0xFFF44336),
                maxValue: bs.totalAssets,
              ),
              const SizedBox(height: 6),
              _BalanceBar(
                label: '자본',
                value: bs.totalEquity,
                color: const Color(0xFF9C27B0),
                maxValue: bs.totalAssets,
              ),
              const SizedBox(height: 8),
              _BalanceEquation(bs: bs),
              const SizedBox(height: 12),
              _BSDetailSection(bs: bs),
            ],
          ),
        );
      },
    );
  }
}

class _BalanceBar extends StatelessWidget {
  const _BalanceBar({
    required this.label,
    required this.value,
    required this.color,
    required this.maxValue,
  });

  final String label;
  final int value;
  final Color color;
  final int maxValue;

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
            _formatAmount(value),
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

  String _formatAmount(int v) {
    if (v.abs() >= 100000000) {
      return '${(v / 100000000).toStringAsFixed(1)}억';
    } else if (v.abs() >= 10000) {
      return '${(v / 10000).toStringAsFixed(0)}만';
    }
    return '₩${v.toString()}';
  }
}

/// 대차균형 수식 표시 (자산 = 부채 + 자본)
class _BalanceEquation extends StatelessWidget {
  const _BalanceEquation({required this.bs});
  final BalanceSheet bs;

  @override
  Widget build(BuildContext context) {
    final isBalanced = bs.isBalanced;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          isBalanced ? Icons.check_circle_outline : Icons.warning_amber,
          size: 16,
          color: isBalanced ? Colors.green : Colors.orange,
        ),
        const SizedBox(width: 4),
        Text(
          isBalanced ? '대차균형' : '불균형 — 검토 필요',
          style: TextStyle(
            fontSize: 11,
            color: isBalanced ? Colors.green : Colors.orange,
          ),
        ),
      ],
    );
  }
}

/// B/S 항목 세부 내역 섹션
class _BSDetailSection extends StatefulWidget {
  const _BSDetailSection({required this.bs});
  final BalanceSheet bs;

  @override
  State<_BSDetailSection> createState() => _BSDetailSectionState();
}

class _BSDetailSectionState extends State<_BSDetailSection> {
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
          _EntryList(
            title: '자산',
            entries: widget.bs.listAssets,
            color: const Color(0xFF4CAF50),
          ),
          const SizedBox(height: 4),
          _EntryList(
            title: '부채',
            entries: widget.bs.listLiabilities,
            color: const Color(0xFFF44336),
          ),
          const SizedBox(height: 4),
          _EntryList(
            title: '자본',
            entries: widget.bs.listEquities,
            color: const Color(0xFF9C27B0),
          ),
        ],
      ],
    );
  }
}

class _EntryList extends StatelessWidget {
  const _EntryList({
    required this.title,
    required this.entries,
    required this.color,
  });

  final String title;
  final List<BalanceSheetEntry> entries;
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
                  _fmt(e.balance),
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
    final s = v.abs().toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return v < 0 ? '-₩${buf.toString()}' : '₩${buf.toString()}';
  }
}
