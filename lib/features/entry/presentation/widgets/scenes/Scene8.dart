import 'package:flutter/material.dart';

import 'scene_common.dart';

/// Scene 8 — 부동산 매입
/// 분개: (차) 건물 / (대) 보통예금
class Scene8 extends StatelessWidget {
  const Scene8({super.key, required this.controller});
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final t = controller.value;

        // 0.00~0.20: Enter — CR MetaDollar
        final pEnter = (t / 0.20).clamp(0.0, 1.0);

        // 0.20~0.70: Money burn — CR MetaDollar opacity 1→0
        final pBurn = t > 0.20 ? ((t - 0.20) / 0.50).clamp(0.0, 1.0) : 0.0;
        final crOpacity = pEnter * (1.0 - pBurn);

        // 0.50~1.00: Building rise — translateY 80→0, scale 0.3→1
        final pRise = t > 0.50 ? ((t - 0.50) / 0.50).clamp(0.0, 1.0) : 0.0;
        final riseEase = easeInOutCubic(pRise);
        final buildingY = rowY + (1 - riseEase) * 80.0;
        final buildingScale = 0.3 + riseEase * 0.7;

        // 0.90~1.00: DR pulse
        final pPulse = t > 0.90 ? ((t - 0.90) / 0.10).clamp(0.0, 1.0) : 0.0;
        final pulseExtra = pPulse < 0.5 ? pPulse * 2 * 0.18 : (1 - (pPulse - 0.5) * 2) * 0.18;
        final finalScale = buildingScale * (1.0 + pulseExtra);

        return SizedBox(
          width: stageW,
          height: stageH,
          child: Stack(
            children: [
              // CR: MetaDollar (보통예금 — 대변 자산↓, 타오름)
              Anchor(
                x: crX,
                opacity: crOpacity.clamp(0.0, 1.0),
                child: const MetaDollar(size: 64),
              ),
              // DR: AssetBuildingSmall (건물 — 차변 자산↑, 솟아오름)
              if (pRise > 0)
                Positioned(
                  left: drX - 48,
                  top: buildingY - 48,
                  child: Opacity(
                    opacity: riseEase.clamp(0.0, 1.0),
                    child: Transform.scale(
                      scale: finalScale,
                      child: const SizedBox(
                        width: 96,
                        height: 96,
                        child: AssetBuildingSmall(size: 64),
                      ),
                    ),
                  ),
                ),
              SideLabel(x: drX, side: '차변 · 자산↑', label: '건물'),
              SideLabel(x: crX, side: '대변 · 자산↓', label: '보통예금'),
            ],
          ),
        );
      },
    );
  }
}
