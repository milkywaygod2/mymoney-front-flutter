import 'package:flutter/material.dart';

import 'scene_common.dart';

/// Scene 4 — 대출 받음
/// 분개: (차) 보통예금 / (대) 장기차입금
class Scene4 extends StatelessWidget {
  const Scene4({super.key, required this.controller});
  final AnimationController controller;

  static const List<double> _stagger = [0.0, 0.08, 0.16, 0.24];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final t = controller.value;

        // 0.00~0.20: Enter — CR MetaBank, DR MetaDollar
        final pEnter = (t / 0.20).clamp(0.0, 1.0);

        // 0.20~0.40: Door open — MetaBank scale 0.8→1.1→1.0
        final pDoor = t > 0.20 ? ((t - 0.20) / 0.20).clamp(0.0, 1.0) : 0.0;
        final bankScale = pDoor < 0.5
            ? 0.8 + pDoor * 2 * 0.3    // 0.8 → 1.1
            : 1.1 - (pDoor * 2 - 1) * 0.1; // 1.1 → 1.0

        // 0.25~0.95: Bill shower — 4장, archOffset (i-1.5)*8
        // 0.70~1.00: DR MetaDollar scale bounce 1→1.2→1.1
        final pArrive = t > 0.70 ? ((t - 0.70) / 0.30).clamp(0.0, 1.0) : 0.0;
        final drScale = pArrive < 0.5
            ? 1.0 + pArrive * 2 * 0.2
            : 1.2 - (pArrive * 2 - 1) * 0.1;

        return SizedBox(
          width: stageW,
          height: stageH,
          child: Stack(
            children: [
              // CR: MetaBank (은행 — 대변 부채↑)
              Anchor(
                x: crX,
                opacity: pEnter,
                scale: bankScale,
                child: const MetaBank(size: 64),
              ),
              // DR: MetaDollar (보통예금 — 차변 자산↑)
              Anchor(
                x: drX,
                opacity: pEnter,
                scale: drScale,
                child: const MetaDollar(size: 64),
              ),
              // Bill shower — 4장
              ..._stagger.indexed.map((entry) {
                final (i, delay) = entry;
                final start = 0.25 + delay;
                if (t < start) return const SizedBox.shrink();
                final local = ((t - start) / (0.70 - delay)).clamp(0.0, 1.0);
                if (local >= 1.0) return const SizedBox.shrink();
                final archOffsetX = (i - 1.5) * 8.0;
                final pos = arch(
                  from: Offset(crX + archOffsetX, rowY),
                  to: Offset(drX + archOffsetX, rowY),
                  t: local,
                  h: 35,
                );
                return FlyingPiece(
                  key: ValueKey('bill4_$i'),
                  x: pos.dx,
                  y: pos.dy,
                  opacity: 1.0 - (local > 0.8 ? (local - 0.8) / 0.2 : 0.0),
                  child: const MetaDollar(size: 28),
                );
              }),
              SideLabel(x: drX, side: '차변 · 자산↑', label: '보통예금'),
              SideLabel(x: crX, side: '대변 · 부채↑', label: '장기차입금'),
            ],
          ),
        );
      },
    );
  }
}
