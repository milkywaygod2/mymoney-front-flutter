import 'package:flutter/material.dart';

import '../../app/theme/AppColors.dart';

/// 가로 진행 바 — 액체 채움 느낌 (wave-1 §7)
class LiquidBar extends StatelessWidget {
  const LiquidBar({
    super.key,
    required this.value,
    this.height = 8,
    this.kind = 'leaf',
  });

  /// 채움 비율 0.0~1.0
  final double value;
  final double height;
  /// 'water-light' | 'water-dark' | 'wine' | 'leaf' | 'apple'
  final String kind;

  static Color _color(String kind) {
    switch (kind) {
      case 'water-light': return AppColors.natureRevenue;
      case 'water-dark':  return AppColors.natureEquity;
      case 'wine':        return AppColors.natureLiability;
      case 'apple':       return AppColors.natureExpense;
      case 'leaf':
      default:            return AppColors.natureAsset;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color(kind);
    final clamped = value.clamp(0.0, 1.0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: Container(
        height: height,
        color: color.withValues(alpha: 0.15),
        child: Align(
          alignment: Alignment.centerLeft,
          child: AnimatedFractionallySizedBox(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            widthFactor: clamped,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
