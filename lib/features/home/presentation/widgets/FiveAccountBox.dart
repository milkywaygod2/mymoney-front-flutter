import 'dart:math';
import 'package:flutter/material.dart';

import '../../../../../app/theme/AppColors.dart';

/// 5대 계정 2-tier 비례 박스 (HomeV3용)
/// 복식부기 항등식: 자산 + 비용 = 부채 + 자본 + 수익
class FiveAccountBox extends StatelessWidget {
  const FiveAccountBox({
    super.key,
    required this.assets,
    required this.expense,
    required this.liabilities,
    required this.equity,
    required this.revenue,
  });

  final int assets;
  final int expense;
  final int liabilities;
  final int equity;
  final int revenue;

  static const double _barH = 180.0;
  static const double _minPx = 32.0;
  static const double _flowRefPx = 60.0;

  @override
  Widget build(BuildContext context) {
    final flowMax = max(max(revenue, expense), 1);

    final leftSegs = [
      _Seg(kind: 'stock', icon: '🌳', label: '자산', value: assets, gradient: LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [AppColors.natureAsset.withValues(alpha: 0.75), AppColors.natureAsset.withValues(alpha: 0.35)],
      )),
      _Seg(kind: 'flow', icon: '🍎', label: '비용', value: expense, gradient: LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [AppColors.natureExpense.withValues(alpha: 0.75), AppColors.natureExpense.withValues(alpha: 0.35)],
      )),
    ];
    final rightSegs = [
      _Seg(kind: 'stock', icon: '🫙', label: '부채', value: liabilities, gradient: LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [AppColors.liabilitySoft.withValues(alpha: 0.75), AppColors.natureLiability.withValues(alpha: 0.35)],
      )),
      _Seg(kind: 'stock', icon: '🪣', label: '자본', value: equity, gradient: LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [AppColors.equityDeep.withValues(alpha: 0.85), AppColors.natureEquity.withValues(alpha: 0.55)],
      )),
      _Seg(kind: 'flow', icon: '💧', label: '수익', value: revenue, gradient: LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [AppColors.revenueSoft.withValues(alpha: 0.85), AppColors.revenueSoft.withValues(alpha: 0.45)],
      )),
    ];

    final leftPx = _allocPx(leftSegs, _barH, flowMax);
    final rightPx = _allocPx(rightSegs, _barH, flowMax);
    final leftTotal = assets + expense;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          // 서브타이틀
          Row(
            children: [
              const Expanded(child: _SubTitle(text: '자산 + 비용')),
              const SizedBox(width: 18),
              const Expanded(child: _SubTitle(text: '부채 + 자본 + 수익')),
            ],
          ),
          const SizedBox(height: 6),
          // 바 + 등호
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: _Bar(segs: leftSegs, pxs: leftPx, barH: _barH)),
              const SizedBox(
                width: 18,
                child: Center(
                  child: Text(
                    '=',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Expanded(child: _Bar(segs: rightSegs, pxs: rightPx, barH: _barH)),
            ],
          ),
          const SizedBox(height: 8),
          // 경제규모
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const Text(
                '경제규모',
                style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, letterSpacing: 0.12 * 9.5),
              ),
              const SizedBox(width: 8),
              Text(
                _fmtCompact(leftTotal),
                style: const TextStyle(fontFamily: 'monospace', fontSize: 13, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<double> _allocPx(List<_Seg> segs, double barHeight, int flowMax) {
    // flow 세그먼트 먼저 처리
    final flowPx = segs.map((s) {
      if (s.kind != 'flow') return null;
      final raw = (s.value / flowMax) * _flowRefPx;
      return max(_minPx, raw);
    }).toList();

    final flowSum = flowPx.fold<double>(0, (a, b) => a + (b ?? 0));
    final stockSegs = segs.where((s) => s.kind != 'flow').toList();
    final stockTotal = stockSegs.fold<int>(0, (a, s) => a + s.value);
    final stockFreeRaw = barHeight - flowSum - stockSegs.length * _minPx;
    final stockFree = max(0.0, stockFreeRaw);

    final stockPx = <String, double>{};
    for (final s in stockSegs) {
      final share = stockTotal > 0 ? s.value / stockTotal : 1.0 / stockSegs.length;
      stockPx[s.label] = _minPx + share * stockFree;
    }

    return List.generate(segs.length, (i) {
      final s = segs[i];
      return s.kind == 'flow' ? (flowPx[i] ?? _minPx) : (stockPx[s.label] ?? _minPx);
    });
  }

  String _fmtCompact(int v) {
    if (v >= 100000000) return '${(v / 100000000).toStringAsFixed(1)}억';
    if (v >= 10000) return '${(v / 10000).toStringAsFixed(0)}만';
    return v.toString();
  }
}

class _Seg {
  const _Seg({required this.kind, required this.icon, required this.label, required this.value, required this.gradient});
  final String kind;
  final String icon;
  final String label;
  final int value;
  final LinearGradient gradient;
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        letterSpacing: 0.08 * 10,
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.segs, required this.pxs, required this.barH});
  final List<_Seg> segs;
  final List<double> pxs;
  final double barH;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: barH,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        child: Column(
          children: List.generate(segs.length, (i) {
            final seg = segs[i];
            final isLast = i == segs.length - 1;
            return _Segment(seg: seg, px: pxs[i], isLast: isLast);
          }),
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({required this.seg, required this.px, required this.isLast});
  final _Seg seg;
  final double px;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: px),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (_, h, __) => Container(
        height: h,
        decoration: BoxDecoration(
          gradient: seg.gradient,
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(
                    color: seg.kind == 'flow'
                        ? Colors.white.withValues(alpha: 0.35)
                        : Colors.white.withValues(alpha: 0.25),
                    width: 1,
                    style: seg.kind == 'flow' ? BorderStyle.none : BorderStyle.solid,
                  ),
                ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(seg.icon, style: const TextStyle(fontSize: 15)),
                const SizedBox(width: 6),
                Text(
                  seg.label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.06 * 11,
                    shadows: [Shadow(color: Colors.black45, offset: Offset(0, 1), blurRadius: 2)],
                  ),
                ),
              ],
            ),
            Text(
              _fmtCompact(seg.value),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                shadows: [Shadow(color: Colors.black45, offset: Offset(0, 1), blurRadius: 2)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _fmtCompact(int v) {
    if (v >= 100000000) return '${(v / 100000000).toStringAsFixed(1)}억';
    if (v >= 10000) return '${(v / 10000).toStringAsFixed(0)}만';
    return v.toString();
  }
}
