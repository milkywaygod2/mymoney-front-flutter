import 'package:flutter/material.dart';

import '../../app/theme/AppColors.dart';
import '../../app/theme/AppMotion.dart';
import '../../app/theme/AppRadius.dart';
import '../../app/theme/AppSpacing.dart';
import '../../app/theme/AppTextStyles.dart';

/// 필터/렌즈 스위처용 칩 위젯
class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.leadingIcon,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppMotion.fast,
        curve: AppMotion.standard,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sp3,
          vertical: AppSpacing.sp2,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.darkPrimaryContainer : AppColors.darkSurface2,
          borderRadius: AppRadius.bFull,
          border: Border.all(
            color: selected ? AppColors.darkPrimary : AppColors.darkOutline,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leadingIcon != null) ...[
              Icon(
                leadingIcon,
                size: 14,
                color: selected ? AppColors.darkOnPrimaryContainer : AppColors.darkFg3,
              ),
              const SizedBox(width: AppSpacing.sp1),
            ],
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: selected
                    ? AppColors.darkOnPrimaryContainer
                    : AppColors.darkFg2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
