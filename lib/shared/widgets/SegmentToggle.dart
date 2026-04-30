import 'package:flutter/material.dart';

import '../../app/theme/AppColors.dart';
import '../../app/theme/AppMotion.dart';
import '../../app/theme/AppRadius.dart';
import '../../app/theme/AppSpacing.dart';
import '../../app/theme/AppTextStyles.dart';

/// 단식/복식, V1/V2/V3 전환용 세그먼트 컨트롤 위젯
class SegmentToggle extends StatelessWidget {
  const SegmentToggle({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppColors.darkSurface2,
        borderRadius: AppRadius.bFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(items.length, (i) {
          final isSelected = i == selectedIndex;
          return GestureDetector(
            onTap: () => onChanged(i),
            child: AnimatedContainer(
              duration: AppMotion.mid,
              curve: AppMotion.standard,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sp3,
                vertical: AppSpacing.sp2,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.darkPrimary : Colors.transparent,
                borderRadius: AppRadius.bFull,
              ),
              child: Text(
                items[i],
                style: AppTextStyles.labelMedium.copyWith(
                  color: isSelected
                      ? AppColors.darkOnPrimary
                      : AppColors.darkFg3,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
