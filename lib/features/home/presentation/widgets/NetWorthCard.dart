import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../../app/theme/AppColors.dart';
import '../../../../../shared/widgets/Sparkline.dart';

/// 순자산 카드 (HomeV1용)
class NetWorthCard extends StatefulWidget {
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
  State<NetWorthCard> createState() => _NetWorthCardState();
}

class _NetWorthCardState extends State<NetWorthCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _animation = Tween<double>(begin: 0, end: widget.netWorth.toDouble())
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart));
    _controller.forward();
  }

  @override
  void didUpdateWidget(NetWorthCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.netWorth != widget.netWorth) {
      _animation = Tween<double>(begin: 0, end: widget.netWorth.toDouble())
          .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart));
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.surfaceContainerHighest,
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
              if (widget.periodLabel.isNotEmpty) ...[
                const SizedBox(width: 6),
                Text(
                  widget.periodLabel,
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          AnimatedBuilder(
            animation: _animation,
            builder: (_, __) => Text(
              '₩ ${_formatAmount(_animation.value.round())}',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 34,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.02 * 34,
              ),
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
            values: widget.spark7d.map((v) => v.toDouble()).toList(),
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
    if (widget.spark7d.isEmpty || widget.spark7d.every((v) => v == 0)) return null;
    final first = widget.spark7d.first;
    final last = widget.spark7d.last;
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
