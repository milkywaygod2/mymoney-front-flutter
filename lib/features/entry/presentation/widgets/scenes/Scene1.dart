import 'package:flutter/material.dart';

import 'scene_common.dart';

/// Scene 1 — 카페 커피 · 현금결제
/// 분개: (차) 외식비 / (대) 보통예금
class Scene1 extends StatelessWidget {
  const Scene1({super.key, required this.controller});
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final t = controller.value;

        // 페이즈 비율
        final pEnter  = (t / 0.22).clamp(0.0, 1.0);
        final pFly    = t > 0.22 ? ((t - 0.22) / 0.50).clamp(0.0, 1.0) : 0.0;
        final pArrive = t > 0.72 ? ((t - 0.72) / 0.22).clamp(0.0, 1.0) : 0.0;

        final flyEase = easeInOutCubic(pFly);

        // arrival pulse: scale 1.0 → 1.25 → 1.0
        final arrivalScale = t > 0.72 && t < 0.94
            ? 1.0 + Math.sin(pArrive * 3.14159265) * 0.25
            : 1.0;

        // FlyingPiece 위치 (CR→DR 포물선)
        final flyPos = arch(
          from: const Offset(crX, rowY),
          to: const Offset(drX, rowY),
          t: pFly,
          h: 40,
        );

        return SizedBox(
          width: stageW,
          height: stageH,
          child: Stack(
            children: [
              // CR: MetaDollar (fly 후 사라짐)
              Anchor(
                x: crX,
                opacity: pEnter * (1.0 - pFly * 0.8),
                child: const MetaDollar(size: 64),
              ),
              // DR: MetaBag → AssetCoffee 도착
              Anchor(
                x: drX,
                opacity: pEnter,
                scale: arrivalScale,
                child: t < 0.72
                    ? const MetaBag(size: 64)
                    : const AssetCoffee(size: 64),
              ),
              // FlyingPiece: MetaDollar CR→DR
              if (pFly > 0 && pFly < 1)
                FlyingPiece(
                  x: flyPos.dx,
                  y: flyPos.dy,
                  rotate: flyEase * 15,
                  opacity: 1.0 - (pFly > 0.8 ? (pFly - 0.8) / 0.2 : 0.0),
                  child: const MetaDollar(size: 34),
                ),
              // 라벨
              SideLabel(x: crX, side: '대변 · 자산↓', label: '보통예금'),
              SideLabel(x: drX, side: '차변 · 비용', label: '외식비'),
            ],
          ),
        );
      },
    );
  }
}
