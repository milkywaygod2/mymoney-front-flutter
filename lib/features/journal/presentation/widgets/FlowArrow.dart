import 'package:flutter/material.dart';

import '../../../../../app/theme/AppColors.dart';

/// V3 그래디언트 화살표 — 베지어 곡선 + 차변→대변 그라디언트
class FlowArrow extends StatelessWidget {
  const FlowArrow({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 32,
      child: CustomPaint(painter: _FlowArrowPainter()),
    );
  }
}

class _FlowArrowPainter extends CustomPainter {
  static const _colorFrom = AppColors.natureAsset;
  static const _colorTo = AppColors.equitySoft;

  @override
  void paint(Canvas canvas, Size size) {
    final cy = size.height / 2;
    final startX = 4.0;
    final endX = size.width - 8.0;

    // 베지어 곡선 경로 (완만한 S자 흐름)
    final curvePath = Path()
      ..moveTo(startX, cy)
      ..cubicTo(startX + (endX - startX) * 0.35, cy - 6, startX + (endX - startX) * 0.65, cy + 6, endX, cy);

    // 그라디언트 stroke
    final rect = Rect.fromLTWH(startX, 0, endX - startX, size.height);
    final curvePaint = Paint()
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..shader = const LinearGradient(
        colors: [_colorFrom, _colorTo],
      ).createShader(rect);

    canvas.drawPath(curvePath, curvePaint);

    // 화살머리
    final arrowPaint = Paint()
      ..color = _colorTo
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final arrowPath = Path()
      ..moveTo(endX - 6, cy - 5)
      ..lineTo(endX, cy)
      ..lineTo(endX - 6, cy + 5);
    canvas.drawPath(arrowPath, arrowPaint);
  }

  @override
  bool shouldRepaint(_FlowArrowPainter old) => false;
}
