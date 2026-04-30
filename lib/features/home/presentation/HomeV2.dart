import 'package:flutter/material.dart';

import 'HomeBloc.dart';

/// HomeV2 — 나무·물 은유 (GrowthTree + LiquidGauge × 3)
class HomeV2 extends StatelessWidget {
  const HomeV2({super.key, required this.vm});

  final HomeViewModel vm;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TreeHero(netWorth: vm.netWorth),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionLabel(text: '액체 축 · 이번 달'),
                const SizedBox(height: 14),
                _LiquidAxisPanel(
                  revenue: vm.revenue,
                  equity: vm.equity,
                  liabilities: vm.liabilities,
                ),
                const SizedBox(height: 10),
                _EquationHint(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TreeHero extends StatelessWidget {
  const _TreeHero({required this.netWorth});
  final int netWorth;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
      decoration: const BoxDecoration(
        // TODO: U1 머지 후 AppColors로 교체
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x240C2E57), Color(0x00000000)],
        ),
      ),
      child: Row(
        children: [
          _GrowthTreeWidget(fill: 0.85),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '순자산',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    letterSpacing: 0.05 * 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '₩${_fmt(netWorth)}',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.02 * 28,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    // TODO: U1 머지 후 AppColors.natureAsset으로 교체
                    color: const Color(0x2E10B981),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.trending_up, size: 13, color: Color(0xFF10B981)),
                      SizedBox(width: 5),
                      Text(
                        '+5.1% 자라는 중',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(int v) {
    final str = v.toString();
    final buf = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buf.write(',');
      buf.write(str[i]);
    }
    return buf.toString();
  }
}

/// 나무 성장 아이콘 (CustomPainter 간소화)
class _GrowthTreeWidget extends StatelessWidget {
  const _GrowthTreeWidget({required this.fill});
  final double fill;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: CustomPaint(painter: _TreePainter(fill: fill)),
    );
  }
}

class _TreePainter extends CustomPainter {
  _TreePainter({required this.fill});
  final double fill;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    // 줄기
    final trunkPaint = Paint()..color = const Color(0xFF8B5A2B);
    canvas.drawRect(Rect.fromLTWH(cx - 5, size.height * 0.6, 10, size.height * 0.4), trunkPaint);
    // 나무 캐노피
    final leafPaint = Paint()
      ..color = Color.lerp(const Color(0xFF047857), const Color(0xFF10B981), fill)!;
    canvas.drawCircle(Offset(cx, size.height * 0.42), size.width * 0.38, leafPaint);
    canvas.drawCircle(Offset(cx - 14, size.height * 0.54), size.width * 0.26, leafPaint);
    canvas.drawCircle(Offset(cx + 14, size.height * 0.54), size.width * 0.26, leafPaint);
  }

  @override
  bool shouldRepaint(_TreePainter old) => old.fill != fill;
}

class _LiquidAxisPanel extends StatelessWidget {
  const _LiquidAxisPanel({
    required this.revenue,
    required this.equity,
    required this.liabilities,
  });
  final int revenue;
  final int equity;
  final int liabilities;

  @override
  Widget build(BuildContext context) {
    final maxVal = [revenue, equity, liabilities].reduce((a, b) => a > b ? a : b);
    final items = [
      _LiquidItem(label: '수익 · 물 한 컵', value: revenue, fill: maxVal > 0 ? revenue / maxVal * 0.6 : 0.1, color: const Color(0xFF7DD3FC)),
      _LiquidItem(label: '자본 · 물 한 통', value: equity, fill: maxVal > 0 ? equity / maxVal * 0.9 : 0.5, color: const Color(0xFF1D4E8C)),
      _LiquidItem(label: '부채 · 포도주', value: liabilities, fill: maxVal > 0 ? liabilities / maxVal * 0.5 : 0.2, color: const Color(0xFF6B2E9E)),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: items
            .map((item) => Expanded(
                  child: _LiquidColumn(item: item),
                ))
            .toList(),
      ),
    );
  }
}

class _LiquidItem {
  const _LiquidItem({required this.label, required this.value, required this.fill, required this.color});
  final String label;
  final int value;
  final double fill;
  final Color color;
}

class _LiquidColumn extends StatelessWidget {
  const _LiquidColumn({required this.item});
  final _LiquidItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _LiquidGauge(fill: item.fill, color: item.color, height: 110, width: 50),
        const SizedBox(height: 10),
        Text(
          item.label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10, color: item.color, fontWeight: FontWeight.w700, letterSpacing: 0.03 * 10),
        ),
        const SizedBox(height: 3),
        Text(
          _fmtCompact(item.value),
          style: const TextStyle(fontFamily: 'monospace', fontSize: 13, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  String _fmtCompact(int v) {
    if (v >= 100000000) return '${(v / 100000000).toStringAsFixed(1)}억';
    if (v >= 10000) return '${(v / 10000).toStringAsFixed(0)}만';
    return v.toString();
  }
}

class _LiquidGauge extends StatelessWidget {
  const _LiquidGauge({required this.fill, required this.color, required this.height, required this.width});
  final double fill;
  final Color color;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: CustomPaint(painter: _LiquidPainter(fill: fill.clamp(0.0, 1.0), color: color)),
    );
  }
}

class _LiquidPainter extends CustomPainter {
  _LiquidPainter({required this.fill, required this.color});
  final double fill;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    // 유리 컵 외곽
    final borderPaint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(8)),
      borderPaint,
    );

    // 액체
    final liquidH = size.height * fill;
    final liquidRect = Rect.fromLTWH(2, size.height - liquidH, size.width - 4, liquidH);
    final liquidPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: 0.5), color.withValues(alpha: 0.85)],
      ).createShader(liquidRect);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        liquidRect,
        bottomLeft: const Radius.circular(6),
        bottomRight: const Radius.circular(6),
      ),
      liquidPaint,
    );
  }

  @override
  bool shouldRepaint(_LiquidPainter old) => old.fill != fill || old.color != old.color;
}

class _EquationHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      decoration: BoxDecoration(
        // TODO: U1 머지 후 AppColors로 교체
        color: const Color(0x140284C7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0x400284C7)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 16, color: Color(0xFF1D4E8C)),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 12, color: Color(0xFF374151)),
                children: [
                  TextSpan(text: '수익 한 컵', style: TextStyle(color: Color(0xFF7DD3FC), fontWeight: FontWeight.w700)),
                  TextSpan(text: '이 '),
                  TextSpan(text: '자본 통', style: TextStyle(color: Color(0xFF1D4E8C), fontWeight: FontWeight.w700)),
                  TextSpan(text: '에 들어가고, '),
                  TextSpan(text: '부채 한 병', style: TextStyle(color: Color(0xFF6B2E9E), fontWeight: FontWeight.w700)),
                  TextSpan(text: '은 옆에 따로 서 있어요.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 20),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.08 * 11,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
