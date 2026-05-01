import 'package:flutter/material.dart';

import 'scene_common.dart';

/// Scene 5 — 월급 입금
/// 분개: (차) 보통예금 / (대) 급여
class Scene5 extends StatelessWidget {
  const Scene5({super.key, required this.controller});
  final AnimationController controller;

  static const List<double> _stagger = [0.0, 0.10, 0.20, 0.30, 0.40];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final t = controller.value;

        // 0.00~0.20: Enter — CR MetaPayroll, DR MetaDollar
        final pEnter = (t / 0.20).clamp(0.0, 1.0);

        // 0.75~1.00: DR MetaDollar pulse + scale bounce
        final pPulse = t > 0.75 ? ((t - 0.75) / 0.25).clamp(0.0, 1.0) : 0.0;
        final drScale = pPulse < 0.5
            ? 1.0 + pPulse * 2 * 0.25
            : 1.25 - (pPulse * 2 - 1) * 0.15;

        return SizedBox(
          width: stageW,
          height: stageH,
          child: Stack(
            children: [
              // CR: MetaPayroll (급여명세서 — 대변 수익↑)
              Anchor(
                x: crX,
                opacity: pEnter,
                child: const MetaPayroll(size: 64),
              ),
              // DR: MetaDollar (보통예금 — 차변 자산↑)
              Anchor(
                x: drX,
                opacity: pEnter,
                scale: drScale,
                child: const MetaDollar(size: 64),
              ),
              // Bill shower — 5장, stagger 0.10s 간격
              ..._stagger.indexed.map((entry) {
                final (i, delay) = entry;
                final start = 0.20 + delay;
                if (t < start) return const SizedBox.shrink();
                final end = (start + 0.50).clamp(0.0, 0.90);
                final local = ((t - start) / (end - start)).clamp(0.0, 1.0);
                if (local >= 1.0) return const SizedBox.shrink();
                final pos = arch(
                  from: const Offset(crX, rowY),
                  to: const Offset(drX, rowY),
                  t: local,
                  h: 28 + i * 5.0,
                );
                return FlyingPiece(
                  key: ValueKey('bill5_$i'),
                  x: pos.dx,
                  y: pos.dy,
                  opacity: 1.0 - (local > 0.8 ? (local - 0.8) / 0.2 : 0.0),
                  child: const MetaDollar(size: 28),
                );
              }),
              SideLabel(x: drX, side: '차변 · 자산↑', label: '보통예금'),
              SideLabel(x: crX, side: '대변 · 수익↑', label: '급여'),
            ],
          ),
        );
      },
    );
  }
}
