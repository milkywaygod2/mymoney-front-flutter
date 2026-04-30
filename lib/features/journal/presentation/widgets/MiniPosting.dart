import 'dart:math';
import 'package:flutter/material.dart';

import '../../../../../app/theme/AppColors.dart';

Color _kindColor(String kind) => switch (kind) {
      'asset' => AppColors.natureAsset,
      'liability' => AppColors.natureLiability,
      'equity' => AppColors.natureEquity,
      'revenue' => AppColors.natureRevenue,
      'expense' => AppColors.natureExpense,
      _ => const Color(0xFF9CA3AF),
    };

Color _kindHex(String kind) => _kindColor(kind);

/// MiniPosting — 복식 모드 셀
/// 셀 높이 = log10(amount/1000) × scale, MIN 52 / MAX 160
/// 차변합 = 대변합 → 짧은 쪽 자동 신장
class MiniPosting extends StatelessWidget {
  const MiniPosting({
    super.key,
    required this.accountName,
    required this.kind,
    required this.icon,
    required this.amount,
    required this.isDebit,
  });

  final String accountName;
  final String kind;
  final String icon;
  final int amount;
  final bool isDebit;

  static const double _minH = 52.0;
  static const double _maxH = 160.0;

  static double baseHeight(int amount) {
    final t = max(0.0, min(1.0, log(max(amount, 1000) / 1000) / log(10) / 3));
    return _minH + (_maxH - _minH) * t;
  }

  @override
  Widget build(BuildContext context) {
    final h = _kindHex(kind);
    final debitIncreases = kind == 'asset' || kind == 'expense';
    final increases = isDebit ? debitIncreases : !debitIncreases;

    return Container(
      decoration: BoxDecoration(
        color: h.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: h.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // 배경 화살표 (CustomPainter)
          Positioned.fill(
            child: CustomPaint(
              painter: _ArrowBgPainter(color: h, increases: increases),
            ),
          ),
          // 콘텐츠
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 계정명
              Padding(
                padding: const EdgeInsets.only(right: 18),
                child: Row(
                  children: [
                    Text(icon, style: const TextStyle(fontSize: 13)),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        accountName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
              // 금액
              Padding(
                padding: const EdgeInsets.only(right: 18),
                child: Text(
                  '₩${amount.toLocaleString()}',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

extension _IntFormat on int {
  String toLocaleString() {
    final str = toString();
    final buf = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buf.write(',');
      buf.write(str[i]);
    }
    return buf.toString();
  }
}

class _ArrowBgPainter extends CustomPainter {
  _ArrowBgPainter({required this.color, required this.increases});
  final Color color;
  final bool increases;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final cx = size.width * 0.78;
    if (increases) {
      // ↑ 화살표
      canvas.drawLine(Offset(cx, size.height * 0.875), Offset(cx, size.height * 0.25), paint);
      canvas.drawLine(Offset(cx - 8, size.height * 0.375), Offset(cx, size.height * 0.25), paint);
      canvas.drawLine(Offset(cx + 8, size.height * 0.375), Offset(cx, size.height * 0.25), paint);
    } else {
      // ↓ 화살표
      canvas.drawLine(Offset(cx, size.height * 0.125), Offset(cx, size.height * 0.75), paint);
      canvas.drawLine(Offset(cx - 8, size.height * 0.625), Offset(cx, size.height * 0.75), paint);
      canvas.drawLine(Offset(cx + 8, size.height * 0.625), Offset(cx, size.height * 0.75), paint);
    }
  }

  @override
  bool shouldRepaint(_ArrowBgPainter old) => old.color != color || old.increases != increases;
}

/// MiniPosting 높이 계산 + 양쪽 신장 처리 헬퍼
class MiniPostingLayout {
  const MiniPostingLayout._();

  /// [debitAmounts], [creditAmounts] 리스트를 받아 각각의 최종 높이 반환
  /// (짧은 쪽 비례 신장)
  static ({List<double> debitHs, List<double> creditHs}) computeHeights(
    List<int> debitAmounts,
    List<int> creditAmounts,
  ) {
    const gap = 6.0;
    final dBases = debitAmounts.map(MiniPosting.baseHeight).toList();
    final cBases = creditAmounts.map(MiniPosting.baseHeight).toList();

    double sideTotal(List<double> arr) =>
        arr.fold(0.0, (a, b) => a + b) + max(0, arr.length - 1) * gap;

    final target = max(sideTotal(dBases), sideTotal(cBases));

    List<double> scale(List<double> arr) {
      final s = sideTotal(arr);
      if (s >= target) return arr;
      final extra = target - s;
      final sumH = arr.fold(0.0, (a, b) => a + b);
      return arr.map((h) => h + extra * (h / sumH)).toList();
    }

    return (debitHs: scale(dBases), creditHs: scale(cBases));
  }
}
