import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/theme/AppColors.dart';
import 'ReportBloc.dart';
import '../usecase/GenerateBalanceSheet.dart';
import '../data/ReportQueryService.dart';

/// B/S 차트 — FiveAccountBox 스타일: 좌(자산) vs 우(부채+자본) 두 기둥 비교
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
              // FiveAccountBox: 자산 기둥 vs 부채+자본 기둥
              _FiveAccountBox(bs: bs),
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

/// 자산(좌) vs 부채+자본(우) 두 기둥을 나란히 배치
class _FiveAccountBox extends StatelessWidget {
  const _FiveAccountBox({required this.bs});
  final BalanceSheet bs;

  @override
  Widget build(BuildContext context) {
    final total = bs.totalAssets > 0 ? bs.totalAssets : 1;
    final liabilityRatio = (bs.totalLiabilities / total).clamp(0.0, 1.0);
    final equityRatio = (bs.totalEquity / total).clamp(0.0, 1.0);

    return SizedBox(
      height: 160,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 좌: 자산 기둥
          Expanded(
            child: _AccountColumn(
              label: '자산',
              amount: bs.totalAssets,
              color: AppColors.natureAsset,
              fillRatio: 1.0,
              segments: const [],
            ),
          ),
          const SizedBox(width: 8),
          // 우: 부채 + 자본 누적 기둥
          Expanded(
            child: _StackedColumn(
              segments: [
                _StackedSegment(
                  label: '부채',
                  amount: bs.totalLiabilities,
                  color: AppColors.natureLiability,
                  ratio: liabilityRatio,
                ),
                _StackedSegment(
                  label: '자본',
                  amount: bs.totalEquity,
                  color: AppColors.natureEquity,
                  ratio: equityRatio,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountColumn extends StatelessWidget {
  const _AccountColumn({
    required this.label,
    required this.amount,
    required this.color,
    required this.fillRatio,
    required this.segments,
  });

  final String label;
  final int amount;
  final Color color;
  final double fillRatio;
  final List<dynamic> segments;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const Spacer(),
          Text(
            _fmt(amount),
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

  String _fmt(int v) {
    if (v.abs() >= 100000000) return '${(v / 100000000).toStringAsFixed(1)}억';
    if (v.abs() >= 10000) return '${(v / 10000).toStringAsFixed(0)}만';
    return '₩$v';
  }
}

class _StackedSegment {
  const _StackedSegment({
    required this.label,
    required this.amount,
    required this.color,
    required this.ratio,
  });

  final String label;
  final int amount;
  final Color color;
  final double ratio;
}

class _StackedColumn extends StatelessWidget {
  const _StackedColumn({required this.segments});
  final List<_StackedSegment> segments;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: segments.map((seg) {
          return Flexible(
            flex: (seg.ratio * 1000).round().clamp(1, 1000),
            child: Container(
              color: seg.color.withValues(alpha: 0.85),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    seg.label,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    _fmt(seg.amount),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _fmt(int v) {
    if (v.abs() >= 100000000) return '${(v / 100000000).toStringAsFixed(1)}억';
    if (v.abs() >= 10000) return '${(v / 10000).toStringAsFixed(0)}만';
    return '₩$v';
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
            color: AppColors.natureAsset,
          ),
          const SizedBox(height: 4),
          _EntryList(
            title: '부채',
            entries: widget.bs.listLiabilities,
            color: AppColors.natureLiability,
          ),
          const SizedBox(height: 4),
          _EntryList(
            title: '자본',
            entries: widget.bs.listEquities,
            color: AppColors.natureEquity,
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
