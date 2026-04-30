import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme/AppColors.dart';

/// 물/포도주 게이지 CustomPainter (HomeV2용)
/// [fillRatio]: 0.0 ~ 1.0 채움 비율
class LiquidGauge extends StatelessWidget {
  const LiquidGauge({
    super.key,
    required this.fillRatio,
    this.size = 80,
    this.liquidColor = AppColors.natureAsset,
    this.bgColor = AppColors.darkSurface2,
  });

  final double fillRatio;
  final double size;
  final Color liquidColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _LiquidGaugePainter(
          fillRatio: fillRatio.clamp(0.0, 1.0),
          liquidColor: liquidColor,
          bgColor: bgColor,
        ),
      ),
    );
  }
}

class _LiquidGaugePainter extends CustomPainter {
  _LiquidGaugePainter({
    required this.fillRatio,
    required this.liquidColor,
    required this.bgColor,
  });

  final double fillRatio;
  final Color liquidColor;
  final Color bgColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 배경 원
    canvas.drawCircle(center, radius, Paint()..color = bgColor);

    // 물결 클리핑
    final fillY = size.height * (1 - fillRatio);
    final clipPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
    canvas.save();
    canvas.clipPath(clipPath);

    // 물결 웨이브
    final wavePaint = Paint()..color = liquidColor.withValues(alpha: 0.85);
    final wavePath = Path();
    wavePath.moveTo(0, fillY);
    for (double x = 0; x <= size.width; x += 1) {
      final y = fillY + math.sin((x / size.width) * 2 * math.pi) * 4;
      wavePath.lineTo(x, y);
    }
    wavePath.lineTo(size.width, size.height);
    wavePath.lineTo(0, size.height);
    wavePath.close();
    canvas.drawPath(wavePath, wavePaint);
    canvas.restore();

    // 테두리
    canvas.drawCircle(
      center,
      radius - 1,
      Paint()
        ..color = liquidColor.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(_LiquidGaugePainter old) =>
      old.fillRatio != fillRatio || old.liquidColor != liquidColor;
}
