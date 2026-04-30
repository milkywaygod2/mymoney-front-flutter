import 'package:flutter/material.dart';

import '../../app/theme/AppColors.dart';
import '../../app/theme/AppMotion.dart';

/// 36px 라운드 아이콘 버튼 (Material Symbols Rounded 기반)
class IconBtn extends StatelessWidget {
  const IconBtn({
    super.key,
    required this.icon,
    required this.onTap,
    this.color,
    this.size = 36,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? AppColors.darkFg2;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppMotion.fast,
        curve: AppMotion.standard,
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
        child: Icon(icon, color: iconColor, size: size * 0.55),
      ),
    );
  }
}
