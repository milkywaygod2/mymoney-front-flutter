import 'package:flutter/material.dart';

import 'scene_common.dart';

/// Scene 7 — 이자 수익
/// 분개: (차) 보통예금 / (대) 이자수익
class Scene7 extends StatelessWidget {
  const Scene7({super.key, required this.controller});
  final AnimationController controller;

  static const List<double> _stagger = [0.0, 0.13, 0.26];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final t = controller.value;

        // 0.00~0.20: Enter — CR AssetContract, DR MetaDollar
        final pEnter = (t / 0.20).clamp(0.0, 1.0);

        // 0.20~0.50: Signature stroke — pathLength 0→1
        final pSign = t > 0.20 ? ((t - 0.20) / 0.30).clamp(0.0, 1.0) : 0.0;

        // 0.85~1.00: DR pulse
        final pPulse = t > 0.85 ? ((t - 0.85) / 0.15).clamp(0.0, 1.0) : 0.0;
        final drScale = pPulse < 0.5
            ? 1.0 + pPulse * 2 * 0.22
            : 1.22 - (pPulse * 2 - 1) * 0.12;

        return SizedBox(
          width: stageW,
          height: stageH,
          child: Stack(
            children: [
              // CR: AssetContract (계약서 — 대변 수익↑)
              Anchor(
                x: crX,
                opacity: pEnter,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const AssetContract(size: 64),
                    if (pSign > 0)
                      CustomPaint(
                        size: const Size(64, 64),
                        painter: _SignaturePainter(pSign),
                      ),
                  ],
                ),
              ),
              // DR: MetaDollar (보통예금 — 차변 자산↑)
              Anchor(
                x: drX,
                opacity: pEnter,
                scale: drScale,
                child: const MetaDollar(size: 64),
              ),
              // Bill shower — 3장 CR→DR
              ..._stagger.indexed.map((entry) {
                final (i, delay) = entry;
                final start = 0.50 + delay;
                if (t < start) return const SizedBox.shrink();
                final end = (start + 0.35).clamp(0.0, 0.92);
                final local = ((t - start) / (end - start)).clamp(0.0, 1.0);
                if (local >= 1.0) return const SizedBox.shrink();
                final pos = arch(
                  from: const Offset(crX, rowY),
                  to: const Offset(drX, rowY),
                  t: local,
                  h: 25 + i * 8.0,
                );
                return FlyingPiece(
                  key: ValueKey('bill7_$i'),
                  x: pos.dx,
                  y: pos.dy,
                  opacity: 1.0 - (local > 0.8 ? (local - 0.8) / 0.2 : 0.0),
                  child: const MetaDollar(size: 28),
                );
              }),
              SideLabel(x: drX, side: '차변 · 자산↑', label: '보통예금'),
              SideLabel(x: crX, side: '대변 · 수익↑', label: '이자수익'),
            ],
          ),
        );
      },
    );
  }
}

/// 계약서 서명 획 (pathLength 0→1)
class _SignaturePainter extends CustomPainter {
  const _SignaturePainter(this.pathLength);
  final double pathLength;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4FC3F7).withValues(alpha: 0.85)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.18, size.height * 0.62)
      ..cubicTo(
        size.width * 0.34, size.height * 0.42,
        size.width * 0.56, size.height * 0.74,
        size.width * 0.82, size.height * 0.52,
      );

    final metrics = path.computeMetrics().first;
    canvas.drawPath(
      metrics.extractPath(0, metrics.length * pathLength),
      paint,
    );
  }

  @override
  bool shouldRepaint(_SignaturePainter old) => old.pathLength != pathLength;
}
