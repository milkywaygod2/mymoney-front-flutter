import 'package:flutter/material.dart';

import '../../../../../app/theme/AppColors.dart';

/// 출처→도착 칩 — 복식부기 차변/대변 계정 시각화
class FromToFlow extends StatelessWidget {
  const FromToFlow({
    super.key,
    required this.fromLabel,
    required this.toLabel,
    this.onFromTap,
    this.onToTap,
  });

  final String fromLabel;
  final String toLabel;
  final VoidCallback? onFromTap;
  final VoidCallback? onToTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _AccountChip(
            label: fromLabel,
            isSource: true,
            onTap: onFromTap,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Icon(Icons.arrow_forward, size: 20, color: Colors.grey),
        ),
        Expanded(
          child: _AccountChip(
            label: toLabel,
            isSource: false,
            onTap: onToTap,
          ),
        ),
      ],
    );
  }
}

class _AccountChip extends StatelessWidget {
  const _AccountChip({
    required this.label,
    required this.isSource,
    this.onTap,
  });

  final String label;
  final bool isSource;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSource
        ? AppColors.natureExpense // 출처 — 대변 계정
        : AppColors.natureAsset;  // 도착 — 차변 계정

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSource ? Icons.remove_circle_outline : Icons.add_circle_outline,
              size: 14,
              color: color,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
