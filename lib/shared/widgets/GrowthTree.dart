import 'package:flutter/material.dart';

import '../../app/theme/AppColors.dart';

/// 나무 성장 CustomPainter (HomeV2용)
/// [growthRatio]: 0.0 ~ 1.0 성장 비율 (0 = 씨앗, 1 = 완성된 나무)
class GrowthTree extends StatelessWidget {
  const GrowthTree({
    super.key,
    required this.growthRatio,
    this.size = 80,
    this.trunkColor = AppColors.assetDeep,
    this.leafColor = AppColors.natureAsset,
  });

  final double growthRatio;
  final double size;
  final Color trunkColor;
  final Color leafColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GrowthTreePainter(
          growthRatio: growthRatio.clamp(0.0, 1.0),
          trunkColor: trunkColor,
          leafColor: leafColor,
        ),
      ),
    );
  }
}

class _GrowthTreePainter extends CustomPainter {
  _GrowthTreePainter({
    required this.growthRatio,
    required this.trunkColor,
    required this.leafColor,
  });

  final double growthRatio;
  final Color trunkColor;
  final Color leafColor;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final trunkH = h * 0.35 * growthRatio;
    final trunkW = w * 0.08;

    // 줄기
    final trunkPaint = Paint()
      ..color = trunkColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w / 2 - trunkW / 2, h - trunkH, trunkW, trunkH),
        const Radius.circular(4),
      ),
      trunkPaint,
    );

    if (growthRatio < 0.2) return;

    // 수관 (원형 레이어 3개)
    final leafPaint = Paint()..style = PaintingStyle.fill;
    final layers = 3;
    for (int i = 0; i < layers; i++) {
      final t = (i / (layers - 1));
      final layerGrowth = ((growthRatio - 0.2) / 0.8).clamp(0.0, 1.0);
      final r = (w * 0.28 - w * 0.06 * t) * layerGrowth;
      final cx = w / 2;
      final cy = h - trunkH - r * 0.6 - i * r * 0.55;
      leafPaint.color = Color.lerp(leafColor, AppColors.assetSoft, t * 0.4)!
          .withValues(alpha: 0.85 - t * 0.2);
      canvas.drawCircle(Offset(cx, cy), r, leafPaint);
    }

    // 반짝이 하이라이트
    if (growthRatio > 0.7) {
      final highlightPaint = Paint()
        ..color = AppColors.primary90.withValues(alpha: 0.25)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(w * 0.42, h - trunkH - w * 0.22),
        w * 0.07,
        highlightPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_GrowthTreePainter old) =>
      old.growthRatio != growthRatio || old.leafColor != leafColor;
}
