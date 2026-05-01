import 'package:flutter/material.dart';
import 'scene_common.dart';

/// Scene9 — 출자·증자: (차)보통예금 / (대)자본금
class Scene9 extends StatelessWidget {
  const Scene9({super.key, required this.progress});

  final double progress;

  double _interval(double t, double start, double end) {
    if (t <= start) return 0.0;
    if (t >= end) return 1.0;
    return (t - start) / (end - start);
  }

  @override
  Widget build(BuildContext context) {
    // 0.00~0.30 check draw: AssetCheck stroke pathLength 0→1
    final checkT = _interval(progress, 0.00, 0.30);

    // 0.30~0.80 bills stack — 5장 arch, y offset stacking
    const billCount = 5;
    const crOffset = Offset(220, 60);
    const drOffset = Offset(20, 60);

    // 0.85~1.00 DR pulse
    final pulseT = _interval(progress, 0.85, 1.0);
    final drScale = 1.0 + (pulseT < 0.5 ? pulseT * 2 * 0.22 : (1 - (pulseT - 0.5) * 2) * 0.22 + 0.04);

    // enter for CR (check symbol)
    final enterT = _interval(progress, 0.0, 0.20);

    return SceneFrame(
      animArea: Stack(
        children: [
          // CR: ✅ 주주 확약서 (자본 출자)
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
                      const Text('📄', style: TextStyle(fontSize: 40)),
                      if (checkT > 0)
                        CustomPaint(
                          size: const Size(44, 44),
                          painter: _CheckPainter(checkT),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '자본금',
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
          // Bills stack — 5장 stagger + y offset
          for (var i = 0; i < billCount; i++) ...[
            Builder(builder: (ctx) {
              final billStart = 0.30 + i * 0.09;
              final billEnd = (billStart + 0.42).clamp(0.0, 0.80);
              final billT = _interval(progress, billStart, billEnd);
              return FlyingPiece(
                emoji: metaDollar,
                progress: billT,
                startOffset: crOffset + Offset(0, i * 4.0),
                endOffset: drOffset + Offset(0, i * 4.0),
                archHeight: -45 - i * 6.0,
                archOffsetX: (i - 2) * 5.0,
                visible: progress >= billStart,
              );
            }),
          ],
        ],
      ),
      sideLabel: const SideLabel(
        drTitle: '차변 · 자산↑',
        drSub: '보통예금',
        crTitle: '대변 · 자본↑',
        crSub: '자본금',
      ),
    );
  }
}

/// 주주 확약 체크 획 CustomPainter (pathLength 0→1)
class _CheckPainter extends CustomPainter {
  const _CheckPainter(this.pathLength);
  final double pathLength;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.withValues(alpha: 0.80)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(size.width * 0.18, size.height * 0.52)
      ..lineTo(size.width * 0.42, size.height * 0.72)
      ..lineTo(size.width * 0.80, size.height * 0.30);

    final pathMetrics = path.computeMetrics().first;
    final extractPath = pathMetrics.extractPath(
      0,
      pathMetrics.length * pathLength,
    );
    canvas.drawPath(extractPath, paint);
  }

  @override
  bool shouldRepaint(_CheckPainter old) => old.pathLength != pathLength;
}
