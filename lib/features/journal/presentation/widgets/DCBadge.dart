import 'package:flutter/material.dart';

import '../../../../../app/theme/AppColors.dart';

/// 차/대 뱃지
class DCBadge extends StatelessWidget {
  const DCBadge({super.key, required this.side});

  /// '차' or '대'
  final String side;

  @override
  Widget build(BuildContext context) {
    final isDebit = side == '차';
    final color = isDebit ? AppColors.natureAsset : AppColors.equitySoft;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        '$side변',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: color,
          letterSpacing: 0.04 * 10,
        ),
      ),
    );
  }
}
