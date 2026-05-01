import 'package:flutter/material.dart';
import 'scene_common.dart';

/// Scene6 — 대출 상환: (차)장기차입금 / (대)보통예금
class Scene6 extends StatelessWidget {
  const Scene6({super.key, required this.progress});

  final double progress;

  double _interval(double t, double start, double end) {
    if (t <= start) return 0.0;
    if (t >= end) return 1.0;
    return (t - start) / (end - start);
  }

  @override
  Widget build(BuildContext context) {
    // 0.00~0.22 draw bow: CR scale 0.8→1.0
    final drawT = _interval(progress, 0.00, 0.22);
    final bowScale = 0.8 + drawT * 0.2;

    // 0.22~0.28 release snap
    final snapT = _interval(progress, 0.22, 0.28);
    final snapScale = snapT < 0.5
        ? 1.0 + snapT * 2 * 0.15
        : 1.15 - (snapT * 2 - 1) * 0.15;

    final crScale = progress < 0.22
        ? bowScale
        : (progress < 0.28 ? snapScale : 1.0);

    // 0.22~0.70 arrow fly
    final arrowT = _interval(progress, 0.22, 0.70);

    // 0.70~0.80 impact: DR translateX ±3px 2회 흔들림
    final impactT = _interval(progress, 0.70, 0.80);
    final shakeX = progress >= 0.70 && progress < 0.80
        ? (3.0 * (1 - impactT) * ((impactT * 4).floor() % 2 == 0 ? 1 : -1))
        : 0.0;

    final enterT = _interval(progress, 0.0, 0.22);
    final arrowPos = progress >= 0.22
        ? arch(
            from: const Offset(crX, rowY),
            to: const Offset(drX, rowY),
            t: arrowT,
            h: 60,
          )
        : null;

    return SizedBox(
      width: stageW,
      height: stageH,
      child: Stack(
        children: [
          Anchor(x: crX, opacity: enterT, scale: crScale, child: const AssetBow()),
          Anchor(x: drX + shakeX, opacity: enterT, child: const MetaBank()),
          if (arrowPos != null && arrowT < 1.0)
            FlyingPiece(
              x: arrowPos.dx,
              y: arrowPos.dy,
              child: const MetaDollar(size: 34),
            ),
          SideLabel(x: drX, side: '차변 · 부채↓', label: '장기차입금'),
          SideLabel(x: crX, side: '대변 · 자산↓', label: '보통예금'),
        ],
      ),
    );
  }
}
