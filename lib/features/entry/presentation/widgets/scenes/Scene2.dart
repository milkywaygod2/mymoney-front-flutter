import 'package:flutter/material.dart';

import '../../../../../app/theme/AppColors.dart';
import 'scene_common.dart';

/// Scene 2 — 카페 커피 · 카드결제
/// 분개: (차) 외식비 / (대) 카드미지급금
class Scene2 extends StatelessWidget {
  const Scene2({super.key, required this.controller});
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final t = controller.value;

        // 0.00~0.25: Tap — MetaCard 30px 전진 (CR→DR 방향)
        final pTap     = (t / 0.25).clamp(0.0, 1.0);
        // 0.25~0.40: Pull back
        final pPull    = t > 0.25 ? ((t - 0.25) / 0.15).clamp(0.0, 1.0) : 0.0;
        // 0.40~0.80: Coffee fly CR→DR
        final pCoffee  = t > 0.40 ? ((t - 0.40) / 0.40).clamp(0.0, 1.0) : 0.0;
        // 0.55~0.95: Debt balloon
        final pBalloon = t > 0.55 ? ((t - 0.55) / 0.40).clamp(0.0, 1.0) : 0.0;
        // 0.90~1.00: Arrival pulse
        final pArrive  = t > 0.90 ? ((t - 0.90) / 0.10).clamp(0.0, 1.0) : 0.0;

        // MetaCard 전진/복귀 오프셋
        final tapOffset = pTap * 30 * (1 - pPull);

        // Coffee 포물선
        final coffeePos = arch(
          from: const Offset(crX, rowY),
          to: const Offset(drX, rowY),
          t: easeInOutCubic(pCoffee),
          h: 35,
        );

        // balloon scale: 0 → 1.3 → 1.0
        final balloonScale = pBalloon < 0.7
            ? pBalloon / 0.7 * 1.3
            : 1.3 - (pBalloon - 0.7) / 0.3 * 0.3;

        // arrival pulse on DR
        final arrivalScale = t > 0.90
            ? 1.0 + Math.sin(pArrive * 3.14159265) * 0.2
            : 1.0;

        return SizedBox(
          width: stageW,
          height: stageH,
          child: Stack(
            children: [
              // CR: MetaCard (tap 전진)
              Positioned(
                left: crX - 48 + tapOffset,
                top: rowY - 48,
                child: SizedBox(
                  width: 96,
                  height: 96,
                  child: const MetaCard(size: 64),
                ),
              ),
              // Debt balloon (CR 뒤)
              if (pBalloon > 0)
                Positioned(
                  left: crX - 40,
                  top: rowY - 40,
                  child: Opacity(
                    opacity: (pBalloon * 2).clamp(0.0, 1.0),
                    child: Transform.scale(
                      scale: balloonScale,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.natureLiability.withValues(alpha: 0.2),
                        ),
                      ),
                    ),
                  ),
                ),
              // DR: MetaBag
              Anchor(
                x: drX,
                scale: arrivalScale,
                child: const MetaBag(size: 64),
              ),
              // Flying coffee CR→DR
              if (pCoffee > 0 && pCoffee < 1)
                FlyingPiece(
                  x: coffeePos.dx,
                  y: coffeePos.dy,
                  opacity: 1.0,
                  child: const AssetCoffee(size: 34),
                ),
              SideLabel(x: drX, side: '차변 · 비용', label: '외식비'),
              SideLabel(x: crX, side: '대변 · 부채↑', label: '카드미지급금'),
            ],
          ),
        );
      },
    );
  }
}
