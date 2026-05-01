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
    // 0.00~0.20 enter
    final enterT = _interval(progress, 0.0, 0.20);
    // 0.20~0.90 bill shower — 5장, stagger 0.10s
    const billCount = 5;
    const crOffset = Offset(20, 60);
    const drOffset = Offset(220, 60);

    // 0.75~1.00 DR pulse + scale bounce
    final pulseT = _interval(progress, 0.75, 1.0);
    final drScale = 1.0 + (pulseT < 0.5 ? pulseT * 2 * 0.25 : (1 - (pulseT - 0.5) * 2) * 0.25 + 0.05);

    return SceneFrame(
      animArea: Stack(
        children: [
          // CR: MetaPayroll (급여명세서)
          Positioned(
            left: 0,
            top: 20,
            child: Opacity(
              opacity: enterT.clamp(0.0, 1.0),
              child: const Anchor(emoji: metaPayroll, label: '급여'),
            ),
          ),
          // DR: MetaDollar (지갑)
          Positioned(
            right: 0,
            top: 20,
            child: Opacity(
              opacity: enterT.clamp(0.0, 1.0),
              child: Anchor(emoji: metaDollar, label: '보통예금', scale: drScale),
            ),
          ),
          // Bill shower — 5장
          for (var i = 0; i < billCount; i++) ...[
            Builder(builder: (ctx) {
              final billStart = 0.20 + i * 0.10;
              final billEnd = (billStart + 0.55).clamp(0.0, 0.90);
              final billT = _interval(progress, billStart, billEnd);
              return FlyingPiece(
                emoji: metaDollar,
                progress: billT,
                startOffset: crOffset,
                endOffset: drOffset,
                archHeight: -55,
                archOffsetX: (i - 2) * 6.0,
                visible: progress >= billStart,
              );
            }),
          ],
        ],
      ),
      sideLabel: const SideLabel(
        drTitle: '차변 · 자산↑',
        drSub: '보통예금',
        crTitle: '대변 · 수익↑',
        crSub: '급여',
      ),
    );
  }
}
