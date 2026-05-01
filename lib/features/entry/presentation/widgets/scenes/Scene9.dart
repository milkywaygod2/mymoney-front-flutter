import 'package:flutter/material.dart';

import 'scene_common.dart';

/// Scene 9 — 출자·증자
/// 분개: (차) 보통예금 / (대) 자본금
class Scene9 extends StatelessWidget {
  const Scene9({super.key, required this.controller});
  final AnimationController controller;

  static const List<double> _stagger = [0.0, 0.09, 0.18, 0.27, 0.36];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final t = controller.value;

        // 0.00~0.20: Enter — CR AssetCheck, DR MetaDollar
        final pEnter = (t / 0.20).clamp(0.0, 1.0);

        // 0.00~0.30: Check stroke draw — pathLength 0→1
        final pCheck = (t / 0.30).clamp(0.0, 1.0);

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
              // CR: AssetCheck (확약서 — 대변 자본↑)
              Anchor(
                x: crX,
                opacity: pEnter,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const AssetCheck(size: 64),
                    if (pCheck > 0)
                      CustomPaint(
                        size: const Size(64, 64),
                        painter: _CheckPainter(pCheck),
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
              // Bills stack — 5장 stagger + arch
              ..._stagger.indexed.map((entry) {
                final (i, delay) = entry;
                final start = 0.30 + delay;
                if (t < start) return const SizedBox.shrink();
                final end = (start + 0.42).clamp(0.0, 0.86);
                final local = ((t - start) / (end - start)).clamp(0.0, 1.0);
                if (local >= 1.0) return const SizedBox.shrink();
                final offsetX = (i - 2) * 5.0;
                final pos = arch(
                  from: Offset(crX + offsetX, rowY + i * 3.0),
                  to: Offset(drX + offsetX, rowY + i * 3.0),
                  t: local,
                  h: 28 + i * 6.0,
                );
                return FlyingPiece(
                  key: ValueKey('bill9_$i'),
                  x: pos.dx,
                  y: pos.dy,
                  opacity: 1.0 - (local > 0.8 ? (local - 0.8) / 0.2 : 0.0),
                  child: const MetaDollar(size: 28),
                );
              }),
              SideLabel(x: drX, side: '차변 · 자산↑', label: '보통예금'),
              SideLabel(x: crX, side: '대변 · 자본↑', label: '자본금'),
            ],
          ),
        );
      },
    );
  }
}

/// 확약 체크 획 (pathLength 0→1)
class _CheckPainter extends CustomPainter {
  const _CheckPainter(this.pathLength);
  final double pathLength;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF81C784).withValues(alpha: 0.90)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(size.width * 0.18, size.height * 0.52)
      ..lineTo(size.width * 0.42, size.height * 0.72)
      ..lineTo(size.width * 0.80, size.height * 0.30);

    final metrics = path.computeMetrics().first;
    canvas.drawPath(
      metrics.extractPath(0, metrics.length * pathLength),
      paint,
    );
  }

  @override
  bool shouldRepaint(_CheckPainter old) => old.pathLength != pathLength;
}
