import 'package:flutter/material.dart';

import '../../app/theme/AppColors.dart';

/// 2px 레인보우 브랜드 라인 (--grad-kicker 그래디언트)
class KickerBar extends StatelessWidget {
  const KickerBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(2)),
        gradient: LinearGradient(
          colors: [
            AppColors.gradKickerStart,
            AppColors.gradKickerMid1,
            AppColors.gradKickerMid2,
            AppColors.gradKickerEnd,
          ],
          stops: [0.0, 0.30, 0.65, 1.0],
        ),
      ),
    );
  }
}
