import 'package:flutter/material.dart';
import 'scene_common.dart';

/// Scene5 — 월급 입금: (차)보통예금 / (대)급여
class Scene5 extends StatelessWidget {
  const Scene5({super.key, required this.progress});

  final double progress;

  double _interval(double t, double start, double end) {
    if (t <= start) return 0.0;
    if (t >= end) return 1.0;
    return (t - start) / (end - start);
  }

  @override
  Widget build(BuildContext context) {
    final enterT = _interval(progress, 0.0, 0.20);

    // 0.75~1.00 DR pulse + scale bounce
    final pulseT = _interval(progress, 0.75, 1.0);
    final drScale = 1.0 +
        (pulseT < 0.5
            ? pulseT * 2 * 0.25
            : (1 - (pulseT - 0.5) * 2) * 0.25 + 0.05);

    // 0.20~0.90 bill shower — 5장, stagger 0.10s
    const billCount = 5;
    final bills = <Widget>[];
    for (var i = 0; i < billCount; i++) {
      final billStart = 0.20 + i * 0.10;
      final billEnd = (billStart + 0.55).clamp(0.0, 0.90);
      if (progress >= billStart) {
        final billT = _interval(progress, billStart, billEnd);
        final pos = arch(
          from: const Offset(crX, rowY),
          to: const Offset(drX, rowY),
          t: billT,
          h: 55,
        );
        bills.add(FlyingPiece(
          x: pos.dx + (i - 2) * 6.0,
          y: pos.dy,
          child: const MetaDollar(size: 34),
        ));
      }
    }

    return SizedBox(
      width: stageW,
      height: stageH,
      child: Stack(
        children: [
          Anchor(x: crX, opacity: enterT, child: const MetaPayroll()),
          Anchor(x: drX, opacity: enterT, scale: drScale, child: const MetaDollar()),
          ...bills,
          SideLabel(x: drX, side: '차변 · 자산↑', label: '보통예금'),
          SideLabel(x: crX, side: '대변 · 수익↑', label: '급여'),
        ],
      ),
    );
  }
}
