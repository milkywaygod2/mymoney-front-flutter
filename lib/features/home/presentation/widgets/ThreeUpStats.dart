import 'package:flutter/material.dart';

import '../../../../../app/theme/AppColors.dart';

/// 자산/부채/자본 3분할 미니 스탯 (HomeV1용)
class ThreeUpStats extends StatelessWidget {
  const ThreeUpStats({
    super.key,
    required this.assets,
    required this.liabilities,
    required this.equity,
  });

  final int assets;
  final int liabilities;
  final int equity;

  @override
  Widget build(BuildContext context) {
    final items = [
      _StatItem(label: '자산', value: assets, color: AppColors.natureAsset, bg: AppColors.natureAsset.withValues(alpha: 0.08)),
      _StatItem(label: '부채', value: liabilities, color: AppColors.natureLiability, bg: AppColors.natureLiability.withValues(alpha: 0.14)),
      _StatItem(label: '자본', value: equity, color: AppColors.natureEquity, bg: AppColors.natureEquity.withValues(alpha: 0.28)),
    ];

    return Row(
      children: items
          .map((item) => Expanded(
                child: _StatCard(item: item),
              ))
          .toList(),
    );
  }
}

class _StatItem {
  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
    required this.bg,
  });
  final String label;
  final int value;
  final Color color;
  final Color bg;
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.item});

  final _StatItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: item.bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: item.color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.label,
            style: TextStyle(
              fontSize: 10,
              color: item.color,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.05 * 10,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _fmtCompact(item.value),
            style: const TextStyle(
              fontFamily: 'monospace',
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  String _fmtCompact(int value) {
    if (value == 0) return '-';
    if (value >= 100000000) return '${(value / 100000000).toStringAsFixed(1)}억';
    if (value >= 10000) return '${(value / 10000).toStringAsFixed(0)}만';
    return value.toString();
  }
}
