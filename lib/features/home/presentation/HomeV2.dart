import 'package:flutter/material.dart';

import '../../../../app/theme/AppColors.dart';
import '../../../../shared/widgets/GrowthTree.dart';
import '../../../../shared/widgets/LiquidGauge.dart';
import 'HomeBloc.dart';

/// HomeV2 — 나무·물 은유 (GrowthTree + LiquidGauge × 3)
class HomeV2 extends StatelessWidget {
  const HomeV2({super.key, required this.vm});

  final HomeViewModel vm;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TreeHero(netWorth: vm.netWorth, spark7d: vm.spark7d),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionLabel(text: '액체 축 · 이번 달'),
                const SizedBox(height: 14),
                _LiquidAxisPanel(
                  assets: vm.assets,
                  revenue: vm.revenue,
                  equity: vm.equity,
                  liabilities: vm.liabilities,
                ),
                const SizedBox(height: 10),
                _EquationHint(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TreeHero extends StatelessWidget {
  const _TreeHero({required this.netWorth, required this.spark7d});
  final int netWorth;
  final List<int> spark7d;

  // 순자산 1억 = growthRatio 0.5, 10억 = 1.0 기준 (log 스케일)
  static double _growthRatio(int netWorth) {
    if (netWorth <= 0) return 0.1;
    const ref = 1000000000.0; // 10억 기준
    final r = (netWorth / ref).clamp(0.0, 1.0);
    return (0.15 + r * 0.85).clamp(0.15, 1.0);
  }

  // 주간 변동률: spark7d 첫날 대비 마지막 날 변동액 기준
  double? _weeklyChange() {
    if (spark7d.isEmpty || spark7d.every((v) => v == 0)) return null;
    final first = spark7d.first;
    final last = spark7d.last;
    final base = first.abs() < 1 ? 1 : first.abs();
    return (last - first) / base * 100;
  }

  @override
  Widget build(BuildContext context) {
    final change = _weeklyChange();
    final isPositive = (change ?? 0) >= 0;
    final chipColor = isPositive ? AppColors.stateSuccess : AppColors.stateError;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.natureAsset.withValues(alpha: 0.08),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: [
          GrowthTree(growthRatio: _growthRatio(netWorth), size: 80),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '순자산',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    letterSpacing: 0.05 * 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '₩${_fmt(netWorth)}',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.02 * 28,
                  ),
                ),
                if (change != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: chipColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPositive ? Icons.trending_up : Icons.trending_down,
                          size: 13,
                          color: chipColor,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${isPositive ? "+" : ""}${change.toStringAsFixed(1)}% ${isPositive ? "자라는 중" : "줄어드는 중"}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: chipColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(int v) {
    final str = v.toString();
    final buf = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buf.write(',');
      buf.write(str[i]);
    }
    return buf.toString();
  }
}

class _LiquidAxisPanel extends StatelessWidget {
  const _LiquidAxisPanel({
    required this.assets,
    required this.revenue,
    required this.equity,
    required this.liabilities,
  });
  final int assets;
  final int revenue;
  final int equity;
  final int liabilities;

  @override
  Widget build(BuildContext context) {
    final base = assets == 0 ? 1 : assets;
    final items = [
      _LiquidItem(label: '수익 · 물 한 컵', value: revenue, fill: (revenue / base).clamp(0.05, 1.0), color: AppColors.equitySoft),
      _LiquidItem(label: '자본 · 물 한 통', value: equity, fill: (equity / base).clamp(0.05, 1.0), color: AppColors.natureEquity),
      _LiquidItem(label: '부채 · 포도주', value: liabilities, fill: (liabilities / base).clamp(0.05, 1.0), color: AppColors.natureLiability),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: items
            .map((item) => Expanded(
                  child: _LiquidColumn(item: item),
                ))
            .toList(),
      ),
    );
  }
}

class _LiquidItem {
  const _LiquidItem({required this.label, required this.value, required this.fill, required this.color});
  final String label;
  final int value;
  final double fill;
  final Color color;
}

class _LiquidColumn extends StatelessWidget {
  const _LiquidColumn({required this.item});
  final _LiquidItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LiquidGauge(fillRatio: item.fill, size: 58, liquidColor: item.color),
        const SizedBox(height: 10),
        Text(
          item.label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10, color: item.color, fontWeight: FontWeight.w700, letterSpacing: 0.03 * 10),
        ),
        const SizedBox(height: 3),
        Text(
          _fmtCompact(item.value),
          style: const TextStyle(fontFamily: 'monospace', fontSize: 13, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  String _fmtCompact(int v) {
    if (v >= 100000000) return '${(v / 100000000).toStringAsFixed(1)}억';
    if (v >= 10000) return '${(v / 10000).toStringAsFixed(0)}만';
    return v.toString();
  }
}

class _EquationHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      decoration: BoxDecoration(
        color: AppColors.revenueDeep.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.revenueDeep.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 16, color: AppColors.natureEquity),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface),
                children: const [
                  TextSpan(text: '수익 한 컵', style: TextStyle(color: AppColors.equitySoft, fontWeight: FontWeight.w700)),
                  TextSpan(text: '이 '),
                  TextSpan(text: '자본 통', style: TextStyle(color: AppColors.natureEquity, fontWeight: FontWeight.w700)),
                  TextSpan(text: '에 들어가고, '),
                  TextSpan(text: '부채 한 병', style: TextStyle(color: AppColors.natureLiability, fontWeight: FontWeight.w700)),
                  TextSpan(text: '은 옆에 따로 서 있어요.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 20),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.08 * 11,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
