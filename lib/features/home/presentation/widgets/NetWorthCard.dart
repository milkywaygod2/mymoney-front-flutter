import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../../app/theme/AppColors.dart';
import '../../../../../shared/widgets/Sparkline.dart';

/// 순자산 카드 (HomeV1용)
class NetWorthCard extends StatelessWidget {
  const NetWorthCard({
    super.key,
    required this.netWorth,
    required this.spark7d,
    this.periodLabel = '',
  });

  final int netWorth;
  final List<int> spark7d;
  final String periodLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.surfaceContainerHigh,
            Theme.of(context).colorScheme.surface,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '내 순자산',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  letterSpacing: 0.06 * 12,
                ),
              ),
              if (periodLabel.isNotEmpty) ...[
                const SizedBox(width: 6),
                Text(
                  periodLabel,
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '₩ ${_formatAmount(netWorth)}',
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 34,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.02 * 34,
            ),
          ),
          const SizedBox(height: 10),
          Builder(builder: (context) {
            final change = _weeklyChange();
            if (change == null) return const SizedBox.shrink();
            final isPositive = change >= 0;
            final chipColor = isPositive ? AppColors.stateSuccess : AppColors.stateError;
            final sign = isPositive ? '+' : '';
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
              decoration: BoxDecoration(
                color: chipColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '$sign${change.toStringAsFixed(1)}%',
                style: TextStyle(
                  color: chipColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
          Sparkline(
            values: spark7d.map((v) => v.toDouble()).toList(),
            color: AppColors.natureAsset,
            width: double.infinity,
            height: 44,
            strokeWidth: 2.0,
          ),
        ],
      ),
    );
  }

  double? _weeklyChange() {
    if (spark7d.isEmpty || spark7d.every((v) => v == 0)) return null;
    final first = spark7d.first;
    final last = spark7d.last;
    final base = max(first.abs(), 1);
    return (last - first) / base * 100;
  }

  String _formatAmount(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write(',');
      buffer.write(str[i]);
    }
    return buffer.toString();
  }
}
