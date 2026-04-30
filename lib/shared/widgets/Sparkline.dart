import 'dart:math';

import 'package:flutter/material.dart';

import '../../app/theme/AppColors.dart';

/// 7일 추이용 미니 선 그래프 CustomPainter
class Sparkline extends StatefulWidget {
  const Sparkline({
    super.key,
    required this.values,
    this.color = AppColors.natureAsset,
    this.width = 80,
    this.height = 32,
    this.strokeWidth = 1.5,
  });

  final List<double> values;
  final Color color;
  final double width;
  final double height;
  final double strokeWidth;

  @override
  State<Sparkline> createState() => _SparklineState();
}

class _SparklineState extends State<Sparkline> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _progress = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _progress,
        builder: (_, __) => CustomPaint(
          painter: _SparklinePainter(
            values: widget.values,
            color: widget.color,
            strokeWidth: widget.strokeWidth,
            progress: _progress.value,
          ),
        ),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter({
    required this.values,
    required this.color,
    required this.strokeWidth,
    required this.progress,
  });

  final List<double> values;
  final Color color;
  final double strokeWidth;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;

    final visibleCount = max(2, (values.length * progress).round());
    final visibleValues = values.sublist(0, visibleCount);

    final minV = visibleValues.reduce((a, b) => a < b ? a : b);
    final maxV = visibleValues.reduce((a, b) => a > b ? a : b);
    final range = maxV - minV;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    for (int i = 0; i < visibleValues.length; i++) {
      final x = i / (values.length - 1) * size.width;
      final normalised = range == 0 ? 0.5 : (visibleValues[i] - minV) / range;
      final y = size.height - normalised * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_SparklinePainter old) =>
      old.values != values || old.color != color || old.progress != progress;
}
