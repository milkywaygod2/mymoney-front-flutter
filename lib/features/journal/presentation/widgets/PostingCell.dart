import 'package:flutter/material.dart';

// TODO: U1 머지 후 AppColors로 교체
Color _kindColor(String kind) => switch (kind) {
      'asset' => const Color(0xFF10B981),
      'liability' => const Color(0xFF6B2E9E),
      'equity' => const Color(0xFF1D4E8C),
      'revenue' => const Color(0xFFBAE6FD),
      'expense' => const Color(0xFFEF4444),
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

/// V2 분개장용 셀 (날짜|차변|대변 3col)
class PostingCell extends StatelessWidget {
  const PostingCell({
    super.key,
    required this.accountName,
    required this.kind,
    required this.icon,
    required this.amount,
    required this.side,
  });

  final String accountName;
  final String kind;
  final String icon;
  final int amount;
  final String side; // '차' or '대'

  @override
  Widget build(BuildContext context) {
    final c = _kindColor(kind);
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: c, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 11)),
              const SizedBox(width: 4),
              Text(
                _kindLabel(kind),
                style: TextStyle(fontSize: 9, color: c, fontWeight: FontWeight.w700, letterSpacing: 0.04 * 9),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            accountName,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, height: 1.2),
          ),
          const SizedBox(height: 4),
          Text(
            '₩${_fmt(amount)}',
            textAlign: TextAlign.right,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12, fontWeight: FontWeight.w700),
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
