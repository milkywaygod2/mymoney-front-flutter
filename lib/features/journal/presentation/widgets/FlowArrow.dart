import 'package:flutter/material.dart';

/// V3 그래디언트 화살표
class FlowArrow extends StatelessWidget {
  const FlowArrow({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 24,
      child: CustomPaint(painter: _FlowArrowPainter()),
    );
  }
}

class _FlowArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 점선 화살대
    final dashPaint = Paint()
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..shader = const LinearGradient(
        colors: [Color(0x66BAE6FD), Color(0xF27DD3FC)],
      ).createShader(Rect.fromLTWH(0, 0, size.width * 0.7, size.height));

    const dashLen = 3.0;
    const gapLen = 3.0;
    final total = size.width * 0.65;
    var x = 2.0;
    while (x < total) {
      final end = (x + dashLen).clamp(0.0, total);
      canvas.drawLine(
        Offset(x, size.height / 2),
        Offset(end, size.height / 2),
        dashPaint,
      );
      x += dashLen + gapLen;
    }

    // 화살머리
    final arrowPaint = Paint()
      ..color = const Color(0xFF7DD3FC)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(size.width * 0.75, size.height * 0.25)
      ..lineTo(size.width * 0.95, size.height / 2)
      ..lineTo(size.width * 0.75, size.height * 0.75);
    canvas.drawPath(path, arrowPaint);
  }

  @override
  bool shouldRepaint(_FlowArrowPainter old) => false;
}
