import 'package:flutter/material.dart';
import 'scene_common.dart';

/// Scene4 — 대출 받음: (차)보통예금 / (대)장기차입금
class Scene4 extends StatelessWidget {
  const Scene4({super.key, required this.progress});

  final double progress;

  double _interval(double t, double start, double end) {
    if (t <= start) return 0.0;
    if (t >= end) return 1.0;
    return (t - start) / (end - start);
  }

  @override
  Widget build(BuildContext context) {
    final enterT = _interval(progress, 0.0, 0.20);
    final doorT = _interval(progress, 0.20, 0.40);
    final bankScale = progress < 0.20
        ? 0.8
        : progress < 0.30
            ? 0.8 + doorT * 2 * 0.3
            : 1.1 - (doorT * 2 - 1).clamp(0.0, 1.0) * 0.1;
    const billStagger = [0.0, 0.08, 0.16, 0.24];
    final arriveT = _interval(progress, 0.70, 1.0);
    final drScale = 1.0 +
        (arriveT < 0.5
            ? arriveT * 2 * 0.2
            : (1 - (arriveT - 0.5) * 2) * 0.2 + 0.1);

    final bills = <Widget>[];
    for (var i = 0; i < 4; i++) {
      final billStart = 0.25 + billStagger[i];
      if (progress >= billStart) {
        final billT = _interval(progress, billStart, 0.95);
        final pos = arch(
          from: const Offset(crX, rowY),
          to: const Offset(drX, rowY),
          t: billT,
          h: 50,
        );
        bills.add(FlyingPiece(
          x: pos.dx + (i - 1.5) * 8,
          y: pos.dy,
          rotate: billT * 15,
          opacity: 1 - _interval(progress, 0.85, 0.95),
          child: const MetaDollar(size: 34),
        ));
      }
    }

    return SizedBox(
      width: stageW,
      height: stageH,
      child: Stack(
        children: [
          Anchor(x: crX, opacity: enterT, scale: bankScale, child: const MetaBank()),
          Anchor(x: drX, opacity: enterT, scale: drScale, child: const MetaDollar()),
          ...bills,
          SideLabel(x: drX, side: '차변 · 자산↑', label: '보통예금'),
          SideLabel(x: crX, side: '대변 · 부채↑', label: '장기차입금'),
        ],
      ),
    );
  }
}
