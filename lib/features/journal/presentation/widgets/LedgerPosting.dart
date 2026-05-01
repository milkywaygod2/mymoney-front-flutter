import 'package:flutter/material.dart';

import '../../../../../app/theme/AppColors.dart';
import 'DCBadge.dart';

Color _kindColor(String kind) => switch (kind) {
      'asset' => AppColors.natureAsset,
      'liability' => AppColors.natureLiability,
      'equity' => AppColors.natureEquity,
      'revenue' => AppColors.natureRevenue,
      'expense' => AppColors.natureExpense,
      _ => const Color(0xFF9CA3AF),
    };

String _kindLabel(String kind) => switch (kind) {
      'asset' => '자산',
      'liability' => '부채',
      'equity' => '자본',
      'revenue' => '수익',
      'expense' => '비용',
      _ => kind,
    };

/// V1 펼침 분개 셀
class LedgerPosting extends StatelessWidget {
  const LedgerPosting({
    super.key,
    required this.side,
    required this.accountName,
    required this.kind,
    required this.icon,
    required this.amount,
  });

  final String side; // '차' or '대'
  final String accountName;
  final String kind;
  final String icon;
  final int amount;

  @override
  Widget build(BuildContext context) {
    final c = _kindColor(kind);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: c.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DCBadge(side: side),
              const SizedBox(width: 6),
              Text(
                '$icon ${_kindLabel(kind)}',
                style: TextStyle(fontSize: 10, color: c, fontWeight: FontWeight.w700, letterSpacing: 0.04 * 10),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            accountName,
            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            '₩${_fmt(amount)}',
            style: TextStyle(fontFamily: 'monospace', fontSize: 13, fontWeight: FontWeight.w700, color: c),
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
