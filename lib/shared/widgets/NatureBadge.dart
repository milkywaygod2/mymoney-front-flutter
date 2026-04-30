import 'package:flutter/material.dart';

import '../../app/theme/AppColors.dart';
import '../../app/theme/AppRadius.dart';
import '../../app/theme/AppSpacing.dart';
import '../../app/theme/AppTextStyles.dart';

enum AccountNature { asset, expense, revenue, liability, equity }

/// 자산/부채/자본/수익/비용 5대 계정 뱃지
class NatureBadge extends StatelessWidget {
  const NatureBadge(this.nature, {super.key, this.compact = false});

  final AccountNature nature;
  final bool compact;

  static const Map<AccountNature, (Color, Color, String)> _config = {
    AccountNature.asset: (AppColors.darkAssetSurface, AppColors.natureAsset, '자산'),
    AccountNature.expense: (AppColors.darkExpenseSurface, AppColors.natureExpense, '비용'),
    AccountNature.revenue: (AppColors.darkRevenueSurface, AppColors.revenueDeep, '수익'),
    AccountNature.liability: (AppColors.darkLiabilitySurface, AppColors.liabilitySoft, '부채'),
    AccountNature.equity: (AppColors.darkEquitySurface, AppColors.equitySoft, '자본'),
  };

  @override
  Widget build(BuildContext context) {
    final (bg, fg, label) = _config[nature]!;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.sp2 : AppSpacing.sp3,
        vertical: compact ? 2 : AppSpacing.sp1,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.bFull,
      ),
      child: Text(label, style: AppTextStyles.labelSmall.copyWith(color: fg)),
    );
  }
}
