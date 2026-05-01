import 'package:flutter/material.dart';

import 'scene_common.dart';

/// Scene 6 — 대출 상환
/// 분개: (차) 장기차입금 / (대) 보통예금
class Scene6 extends StatelessWidget {
  const Scene6({super.key, required this.controller});
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final t = controller.value;

        // 0.00~0.22: Draw bow — CR AssetBow scale 0.8→1.0
        final pEnter = (t / 0.22).clamp(0.0, 1.0);
        final bowScale = 0.8 + pEnter * 0.2;

        // 0.22~0.28: Release snap — scale 1.0→1.15→1.0
        final pSnap = t > 0.22 ? ((t - 0.22) / 0.06).clamp(0.0, 1.0) : 0.0;
        final snapScale = pSnap < 0.5
            ? 1.0 + pSnap * 2 * 0.15
            : 1.15 - (pSnap * 2 - 1) * 0.15;
        final crScale = t < 0.22 ? bowScale : (t < 0.28 ? snapScale : 1.0);

        // 0.22~0.70: Arrow fly — MetaDollar CR→DR
        final pFly = t > 0.22 ? ((t - 0.22) / 0.48).clamp(0.0, 1.0) : 0.0;
        final flyEase = easeInOutCubic(pFly);
        final flyPos = arch(
          from: const Offset(crX, rowY),
          to: const Offset(drX, rowY),
          t: pFly,
          h: 45,
        );

        // 0.70~0.80: Impact — MetaBank translateX ±3px 2회 흔들림
        final pImpact = t > 0.70 ? ((t - 0.70) / 0.10).clamp(0.0, 1.0) : 0.0;
        // 0~0.25: +3, 0.25~0.5: -3, 0.5~0.75: +3, 0.75~1: -3
        final shakeX = t > 0.70 && t < 0.80
            ? 3.0 * Math.sin(pImpact * 3.14159265 * 4) * (1 - pImpact)
            : 0.0;

        // 0.80~1.00: Settle — DR scale 정착
        final pSettle = t > 0.80 ? ((t - 0.80) / 0.20).clamp(0.0, 1.0) : 0.0;
        final drSettle = 1.0 + Math.sin(pSettle * 3.14159265) * 0.08;

        return SizedBox(
          width: stageW,
          height: stageH,
          child: Stack(
            children: [
              // CR: AssetBow (보통예금 — 대변 자산↓)
              Anchor(
                x: crX,
                opacity: pEnter,
                scale: crScale,
                child: const AssetBow(size: 64),
              ),
              // DR: MetaBank (장기차입금 — 차변 부채↓)
              Anchor(
                x: drX + shakeX,
                opacity: pEnter,
                scale: t > 0.80 ? drSettle : 1.0,
                child: const MetaBank(size: 64),
              ),
              // Arrow fly: MetaDollar CR→DR (0.22~0.70)
              if (pFly > 0 && pFly < 1)
                FlyingPiece(
                  x: flyPos.dx,
                  y: flyPos.dy,
                  rotate: flyEase * 20,
                  opacity: 1.0 - (pFly > 0.8 ? (pFly - 0.8) / 0.2 : 0.0),
                  child: const MetaDollar(size: 28),
                ),
              SideLabel(x: drX, side: '차변 · 부채↓', label: '장기차입금'),
              SideLabel(x: crX, side: '대변 · 자산↓', label: '보통예금'),
            ],
          ),
        );
      },
    );
  }
}
