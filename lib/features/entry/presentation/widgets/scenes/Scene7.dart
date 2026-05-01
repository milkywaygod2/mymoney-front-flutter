import 'package:flutter/material.dart';
import 'scene_common.dart';

/// Scene7 — 이자 수익: (차)보통예금 / (대)이자수익
class Scene7 extends StatelessWidget {
  const Scene7({super.key, required this.progress});

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

    // 0.20~0.50 signature: AssetContract stroke pathLength 0→1
    final signT = _interval(progress, 0.20, 0.50);

    // 0.50~0.90 small bills — 3장 CR→DR arch
    const billCount = 3;
    const crOffset = Offset(220, 60);
    const drOffset = Offset(20, 60);

    // 0.85~1.00 DR pulse
    final pulseT = _interval(progress, 0.85, 1.0);
    final drScale = 1.0 + (pulseT < 0.5 ? pulseT * 2 * 0.22 : (1 - (pulseT - 0.5) * 2) * 0.22 + 0.04);

    return SceneFrame(
      animArea: Stack(
        children: [
          // CR: 📋 계약서 (이자수익 출처)
          Positioned(
            right: 0,
            top: 20,
            child: Opacity(
              opacity: enterT.clamp(0.0, 1.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      const Text('📋', style: TextStyle(fontSize: 40)),
                      // signature stroke overlay
                      if (signT > 0)
                        CustomPaint(
                          size: const Size(44, 44),
                          painter: _StrokePainter(signT),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '이자수익',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // DR: 💵 보통예금 (지갑)
          Positioned(
            left: 0,
            top: 20,
            child: Opacity(
              opacity: enterT.clamp(0.0, 1.0),
              child: Anchor(emoji: metaDollar, label: '보통예금', scale: drScale),
            ),
          ),
          // Bill shower — 3장 CR→DR
          for (var i = 0; i < billCount; i++) ...[
            Builder(builder: (ctx) {
              final billStart = 0.50 + i * 0.10;
              final billEnd = (billStart + 0.35).clamp(0.0, 0.90);
              final billT = _interval(progress, billStart, billEnd);
              return FlyingPiece(
                emoji: metaDollar,
                progress: billT,
                startOffset: crOffset,
                endOffset: drOffset,
                archHeight: -50,
                archOffsetX: (i - 1) * 7.0,
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
        crSub: '이자수익',
      ),
    );
  }
}

/// 계약서 서명 획 CustomPainter (pathLength 0→1)
class _StrokePainter extends CustomPainter {
  const _StrokePainter(this.pathLength);
  final double pathLength;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withValues(alpha: 0.75)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.20, size.height * 0.60)
      ..cubicTo(
        size.width * 0.35, size.height * 0.40,
        size.width * 0.55, size.height * 0.75,
        size.width * 0.80, size.height * 0.55,
      );

    final pathMetrics = path.computeMetrics().first;
    final extractPath = pathMetrics.extractPath(
      0,
      pathMetrics.length * pathLength,
    );
    canvas.drawPath(extractPath, paint);
  }

  @override
  bool shouldRepaint(_StrokePainter old) => old.pathLength != pathLength;
}
