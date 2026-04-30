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

/// V3 흐름 노드
class FlowNode extends StatelessWidget {
  const FlowNode({
    super.key,
    required this.accountName,
    required this.kind,
    required this.icon,
    required this.side,
  });

  final String accountName;
  final String kind;
  final String icon;
  final String side; // 'from' or 'to'

  @override
  Widget build(BuildContext context) {
    final c = _kindColor(kind);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: c.withValues(alpha: 0.27)),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22, height: 1)),
          const SizedBox(height: 4),
          Text(
            '${side == 'from' ? '에서' : '로'} · ${_kindLabel(kind)}',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 9.5, color: c, fontWeight: FontWeight.w700, letterSpacing: 0.04 * 9.5),
          ),
          const SizedBox(height: 3),
          Text(
            accountName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, height: 1.25),
          ),
        ],
      ),
    );
  }
}
