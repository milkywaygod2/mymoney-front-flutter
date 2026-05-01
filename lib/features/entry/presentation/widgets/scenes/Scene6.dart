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
    final snapScale = snapT < 0.5 ? 1.0 + snapT * 2 * 0.15 : 1.15 - (snapT * 2 - 1) * 0.15;

    final crScale = progress < 0.22 ? bowScale : (progress < 0.28 ? snapScale : 1.0);

    // 0.22~0.70 arrow fly
    const crOffset = Offset(20, 60);
    const drOffset = Offset(220, 60);
    final arrowT = _interval(progress, 0.22, 0.70);

    // 0.70~0.80 impact: DR translateX ±3px 2회 흔들림
    final impactT = _interval(progress, 0.70, 0.80);
    final shakeX = progress >= 0.70 && progress < 0.80
        ? (3.0 * (1 - impactT) * ((impactT * 4).floor() % 2 == 0 ? 1 : -1))
        : 0.0;

    // 0.80~1.00 settle
    final enterT = _interval(progress, 0.0, 0.22);

    return SceneFrame(
      animArea: Stack(
        children: [
          // CR: AssetBow (지갑 — 대변 자산↓)
          Positioned(
            left: 0,
            top: 20,
            child: Opacity(
              opacity: enterT.clamp(0.0, 1.0),
              child: Anchor(emoji: assetBow, label: '보통예금', scale: crScale),
            ),
          ),
          // DR: MetaBank (은행 — 차변 부채↓)
          Positioned(
            right: 0,
            top: 20,
            child: Opacity(
              opacity: enterT.clamp(0.0, 1.0),
              child: Anchor(emoji: metaBank, label: '장기차입금', translateX: shakeX),
            ),
          ),
          // Arrow fly — MetaDollar CR→DR
          if (progress >= 0.22)
            FlyingPiece(
              emoji: metaDollar,
              progress: arrowT,
              startOffset: crOffset,
              endOffset: drOffset,
              archHeight: -60,
              visible: arrowT < 1.0,
            ),
        ],
      ),
      sideLabel: const SideLabel(
        drTitle: '차변 · 부채↓',
        drSub: '장기차입금',
        crTitle: '대변 · 자산↓',
        crSub: '보통예금',
      ),
    );
  }
}
