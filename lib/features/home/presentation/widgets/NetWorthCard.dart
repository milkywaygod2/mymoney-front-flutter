import 'package:flutter/material.dart';

/// 순자산 카드 (HomeV1용)
class NetWorthCard extends StatelessWidget {
  const NetWorthCard({
    super.key,
    required this.netWorth,
    required this.spark7d,
  });

  final int netWorth;
  final List<int> spark7d;

  @override
  Widget build(BuildContext context) {
    // TODO: U1 머지 후 AppColors로 교체
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.surfaceContainerHigh,
            Theme.of(context).colorScheme.surface,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '내 순자산',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              letterSpacing: 0.06 * 12,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '₩ ${_formatAmount(netWorth)}',
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 34,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.02 * 34,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(
              // TODO: U1 머지 후 AppColors.natureAsset으로 교체
              color: const Color(0x2610B981),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              '+5.1%',
              style: TextStyle(
                color: Color(0xFF10B981),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SparklineWidget(data: spark7d),
        ],
      ),
    );
  }

  String _formatAmount(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write(',');
      buffer.write(str[i]);
    }
    return buffer.toString();
  }
}

/// 7일 추이 스파크라인
class SparklineWidget extends StatelessWidget {
  const SparklineWidget({super.key, required this.data});

  final List<int> data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: CustomPaint(
        painter: _SparklinePainter(data: data),
        size: const Size(double.infinity, 44),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter({required this.data});

  final List<int> data;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    final minV = data.reduce((a, b) => a < b ? a : b).toDouble();
    final maxV = data.reduce((a, b) => a > b ? a : b).toDouble();
    final range = (maxV - minV).abs();
    final effectiveRange = range == 0 ? 1.0 : range;

    final paint = Paint()
      // TODO: U1 머지 후 AppColors.natureAsset으로 교체
      ..color = const Color(0xFF10B981)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    for (var i = 0; i < data.length; i++) {
      final x = i / (data.length - 1) * size.width;
      final normalized = (data[i] - minV) / effectiveRange;
      final y = size.height - normalized * size.height * 0.8 - size.height * 0.1;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_SparklinePainter oldDelegate) => oldDelegate.data != data;
}
