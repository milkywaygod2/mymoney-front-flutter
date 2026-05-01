import 'package:flutter/material.dart';

import 'scene_common.dart';

/// Scene 3 — 예금 → 적금 이체
/// 분개: (차) 적금 / (대) 보통예금
class Scene3 extends StatelessWidget {
  const Scene3({super.key, required this.controller});
  final AnimationController controller;

  static const List<double> _stagger = [0.0, 0.08, 0.16, 0.24];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final t = controller.value;

        // 0.00~0.20: Enter 양쪽 MetaDollar
        final pEnter  = (t / 0.20).clamp(0.0, 1.0);
        // 0.40~0.90: CR MetaDollar 축소
        final pCrFade = t > 0.40 ? ((t - 0.40) / 0.50).clamp(0.0, 1.0) : 0.0;
        // 0.60~1.00: DR MetaDollar 뿅
        final pDrPop  = t > 0.60 ? ((t - 0.60) / 0.40).clamp(0.0, 1.0) : 0.0;

        final crScale    = 1.0 - pCrFade * 0.3;
        final crOpacity  = 1.0 - pCrFade * 0.5;
        // DR pop: scale 0 → 1.15 → 1.0
        final drScale = pDrPop < 0.7
            ? pDrPop / 0.7 * 1.15
            : 1.15 - (pDrPop - 0.7) / 0.3 * 0.15;

        return SizedBox(
          width: stageW,
          height: stageH,
          child: Stack(
            children: [
              // CR: MetaDollar (예금, 축소)
              Anchor(
                x: crX,
                opacity: pEnter * crOpacity,
                scale: crScale,
                child: const MetaDollar(size: 64),
              ),
              // DR: MetaDollar (적금, 뿅)
              Anchor(
                x: drX,
                opacity: pEnter * (pDrPop > 0 ? 1.0 : 0.3),
                scale: pDrPop > 0 ? drScale : 0.3,
                child: const MetaDollar(size: 64),
              ),
              // Stream: 4개 지폐 순차 flow
              ..._stagger.indexed.map((entry) {
                final (i, delay) = entry;
                // 0.20~0.80 구간 내 stagger
                final start = 0.20 + delay * (0.60 / 0.32);
                if (t < start) return const SizedBox.shrink();
                final local = ((t - start) / (0.60 - delay)).clamp(0.0, 1.0);
                if (local >= 1.0) return const SizedBox.shrink();
                final pos = arch(
                  from: const Offset(crX, rowY),
                  to: const Offset(drX, rowY),
                  t: local,
                  h: 20 + i * 6.0,
                );
                return FlyingPiece(
                  key: ValueKey('bill_$i'),
                  x: pos.dx,
                  y: pos.dy,
                  opacity: 1.0 - (local > 0.8 ? (local - 0.8) / 0.2 : 0.0),
                  child: const MetaDollar(size: 28),
                );
              }),
              SideLabel(x: drX, side: '차변 · 자산↑', label: '적금'),
              SideLabel(x: crX, side: '대변 · 자산↓', label: '보통예금'),
            ],
          ),
        );
      },
    );
  }
}
