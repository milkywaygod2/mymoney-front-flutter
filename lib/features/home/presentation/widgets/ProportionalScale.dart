import 'dart:math';
import 'package:flutter/material.dart';

import '../../../../../app/theme/AppColors.dart';
import '../HomeBloc.dart';

/// 시소 저울 CustomPainter (HomeV3용)
/// tilt = log2(revenue/expense) × 18°, ±18° clamp
class ProportionalScale extends StatelessWidget {
  const ProportionalScale({
    super.key,
    required this.revenue,
    required this.expense,
    required this.listPendingExpenses,
    required this.listPendingAssets,
    required this.listPendingRevenues,
  });

  final int revenue;
  final int expense;
  final List<PendingItem> listPendingExpenses;
  final List<PendingItem> listPendingAssets;
  final List<PendingItem> listPendingRevenues;

  @override
  Widget build(BuildContext context) {
    final tilt = _computeTilt(revenue, expense);

    return SizedBox(
      width: 340,
      height: 220,
      child: CustomPaint(
        painter: _ScalePainter(
          tilt: tilt,
          revenue: revenue,
          expense: expense,
          listPendingExpenses: listPendingExpenses,
          listPendingRevenues: listPendingRevenues,
        ),
      ),
    );
  }

  /// tilt: 수익 > 비용이면 오른쪽으로 기울어짐 (양수), ±18° clamp
  static double _computeTilt(int revenue, int expense) {
    final total = revenue + expense;
    if (total <= 0) return 0.0;
    final norm = ((revenue - expense) / total).clamp(-1.0, 1.0);
    return norm * 18.0;
  }
}

class _ScalePainter extends CustomPainter {
  _ScalePainter({
    required this.tilt,
    required this.revenue,
    required this.expense,
    required this.listPendingExpenses,
    required this.listPendingRevenues,
  });

  final double tilt;
  final int revenue;
  final int expense;
  final List<PendingItem> listPendingExpenses;
  final List<PendingItem> listPendingRevenues;

  static const double _panH = 80.0;
  static const double _panW = 100.0;
  static const double _beamH = 10.0;
  static const double _panPostH = 20.0;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;

    // 받침대 중심 y
    final double fulcrumApexY = size.height - 50;
    final double fulcrumBaseY = fulcrumApexY + 36;
    final double beamBottomY = fulcrumApexY;
    final double beamTopY = beamBottomY - _beamH;
    final double pivotY = beamBottomY;
    final double panLcx = w * 0.22;
    final double panRcx = w * 0.78;

    // y 틸트 계산 (pivot 기준 회전)
    final rad = tilt * pi / 180;
    final leftYShift = (panLcx - w / 2) * sin(rad);
    final rightYShift = (panRcx - w / 2) * sin(rad);

    _drawShadow(canvas, w, fulcrumBaseY);
    _drawFulcrum(canvas, w, fulcrumApexY, fulcrumBaseY);
    _drawBeam(canvas, w, beamTopY, pivotY, tilt, panLcx, panRcx);
    _drawPan(canvas, panLcx, beamTopY, leftYShift, _panW, _panH);
    _drawPan(canvas, panRcx, beamTopY, rightYShift, _panW, _panH);
    _drawPanContents(canvas, panLcx, beamTopY, leftYShift, expense, '비용', AppColors.natureExpense, AppColors.expenseDeep);
    _drawPanContents(canvas, panRcx, beamTopY, rightYShift, revenue, '수익', AppColors.revenueSoft, AppColors.equitySoft);
  }

  void _drawShadow(Canvas canvas, double w, double baseY) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w / 2, baseY + 4), width: 180, height: 8),
      paint,
    );
  }

  void _drawFulcrum(Canvas canvas, double w, double apexY, double baseY) {
    const wood1 = Color(0xFF8B5A2B);
    const wood2 = Color(0xFF5E3A1A);
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: const [wood1, wood2],
      ).createShader(Rect.fromLTWH(w / 2 - 38, apexY, 76, baseY - apexY));

    final path = Path()
      ..moveTo(w / 2, apexY)
      ..lineTo(w / 2 - 38, baseY)
      ..lineTo(w / 2 + 38, baseY)
      ..close();
    canvas.drawPath(path, paint);

    final strokePaint = Paint()
      ..color = const Color(0xFF3A2410)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawPath(path, strokePaint);
  }

  void _drawBeam(Canvas canvas, double w, double beamTopY, double pivotY, double tiltDeg, double lcx, double rcx) {
    canvas.save();
    canvas.translate(w / 2, pivotY);
    canvas.rotate(tiltDeg * pi / 180);
    canvas.translate(-w / 2, -pivotY);

    const wood1 = Color(0xFF8B5A2B);
    const wood2 = Color(0xFF5E3A1A);
    final beamPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: const [wood1, wood2],
      ).createShader(Rect.fromLTWH(30, beamTopY, w - 60, _beamH));

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(30, beamTopY, w - 60, _beamH),
        const Radius.circular(4),
      ),
      beamPaint,
    );

    final strokePaint = Paint()
      ..color = const Color(0xFF3A2410)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(30, beamTopY, w - 60, _beamH),
        const Radius.circular(4),
      ),
      strokePaint,
    );

    // 피봇 핀
    canvas.drawCircle(
      Offset(w / 2, pivotY),
      3.5,
      Paint()..color = const Color(0xFF3A2410),
    );

    // 기둥 포스트
    final postPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: const [wood1, wood2],
      ).createShader(Rect.fromLTWH(lcx - 3, beamTopY - _panPostH, 6, _panPostH + 2));

    canvas.drawRect(Rect.fromLTWH(lcx - 3, beamTopY - _panPostH, 6, _panPostH + 2), postPaint);
    canvas.drawRect(Rect.fromLTWH(rcx - 3, beamTopY - _panPostH, 6, _panPostH + 2), postPaint);

    canvas.restore();
  }

  void _drawPan(Canvas canvas, double cx, double beamTopY, double yShift, double panW, double panH) {
    final panBaseY = beamTopY - _panPostH + yShift;
    final lipRect = Rect.fromLTWH(cx - panW / 2 - 4, panBaseY, panW + 8, 5);
    const wood1 = Color(0xFF8B5A2B);
    const wood2 = Color(0xFF5E3A1A);
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: const [wood1, wood2],
      ).createShader(lipRect);
    canvas.drawRRect(RRect.fromRectAndRadius(lipRect, const Radius.circular(2)), paint);
  }

  void _drawPanContents(
    Canvas canvas,
    double cx,
    double beamTopY,
    double yShift,
    int amount,
    String label,
    Color colorLight,
    Color colorDark,
  ) {
    const double maxPanH = _panH - 10;
    const double minH = 20.0;
    final double barH = amount > 0
        ? max(minH, min(maxPanH, log10(max(amount / 1000.0, 1)) / 3 * maxPanH))
        : minH;

    final panBaseY = beamTopY - _panPostH + yShift;
    final barTop = panBaseY - barH;
    final barRect = Rect.fromLTWH(cx - _panW / 2 + 6, barTop, _panW - 12, barH);

    final barPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [colorLight, colorDark],
      ).createShader(barRect);
    canvas.drawRRect(RRect.fromRectAndRadius(barRect, const Radius.circular(3)), barPaint);

    // 라벨
    if (barH >= 20) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(barRect.left + 6, barRect.top + 6));

      final amtPainter = TextPainter(
        text: TextSpan(
          text: _fmtCompact(amount),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            fontFamily: 'monospace',
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      amtPainter.paint(
        canvas,
        Offset(barRect.right - amtPainter.width - 6, barRect.top + 6),
      );
    }
  }

  String _fmtCompact(int v) {
    if (v >= 100000000) return '${(v / 100000000).toStringAsFixed(1)}억';
    if (v >= 10000) return '${(v / 10000).toStringAsFixed(0)}만';
    return v.toString();
  }

  double log10(double x) => log(x) / ln10;

  @override
  bool shouldRepaint(_ScalePainter old) =>
      old.tilt != tilt || old.revenue != revenue || old.expense != expense;
}
