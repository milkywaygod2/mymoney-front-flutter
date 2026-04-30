import 'package:flutter/material.dart';

import '../../../../../app/theme/AppColors.dart';
import '../../../../../shared/widgets/Sparkline.dart';

/// 순자산 카드 (HomeV1용)
class NetWorthCard extends StatelessWidget {
  const NetWorthCard({
    super.key,
    required this.netWorth,
    required this.spark7d,
    required this.periodLabel,
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
          Text(
            '내 순자산',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              letterSpacing: 0.06 * 12,
            ),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.natureAsset.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              '+5.1%',
              style: TextStyle(
                color: AppColors.natureAsset,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Sparkline(
            values: spark7d.map((v) => v.toDouble()).toList(),
            color: AppColors.natureAsset,
            width: double.infinity,
            height: 44,
            strokeWidth: 2.0,
          ),
          if (periodLabel.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              periodLabel,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.withValues(alpha: 0.6),
              ),
            ),
          ],
        ],
      ),
    );
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
