import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/theme/AppColors.dart';
import '../../../core/models/CashFlowLineItem.dart';
import '../../../core/constants/Enums.dart';
import 'ReportBloc.dart';

/// 현금흐름 폭포(Waterfall) 차트 — ReportBloc cashFlowStatement 실데이터 바인딩
/// cashFlowStatement가 null이면 로딩 중 플레이스홀더 표시
class CFWaterfall extends StatelessWidget {
  const CFWaterfall({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportBloc, ReportState>(
      buildWhen: (prev, curr) =>
          prev.cashFlowStatement != curr.cashFlowStatement ||
          prev.isLoading != curr.isLoading,
      builder: (context, state) {
        final cf = state.cashFlowStatement;

        if (cf != null) {
          return CFWaterfallFull(listItems: cf.listItems);
        }

        // 로딩 중
        if (state.isLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        // 데이터 없음 — 빈 상태
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '현금흐름표',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'CF 보고서 데이터가 없습니다',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}

/// CF 분류 코드 접두어 → 색상 키
enum _CfCategory { operating, investing, financing, netChange, baseline }

class _WaterfallBar {
  const _WaterfallBar({
    required this.label,
    required this.value,
    required this.isBaseline,
    this.category,
  });
  final String label;
  final int value;
  final bool isBaseline;
  final _CfCategory? category;
}

class _WaterfallPainterWidget extends StatefulWidget {
  const _WaterfallPainterWidget({required this.bars});
  final List<_WaterfallBar> bars;

  @override
  State<_WaterfallPainterWidget> createState() => _WaterfallPainterWidgetState();
}

class _WaterfallPainterWidgetState extends State<_WaterfallPainterWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  // 카테고리별 고정 색상
  static const _colorOperating  = Color(0xFF10B981);
  static const _colorInvesting  = Color(0xFF3B82F6);
  static const _colorFinancing  = Color(0xFFF59E0B);
  static const _colorNetChange  = Color(0xFF9CA3AF);
  static const _colorBaseline   = Color(0xFF8B5CF6);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _progress = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _progress,
      builder: (_, __) => CustomPaint(
        painter: _WaterfallPainter(
          bars: widget.bars,
          positiveColor: AppColors.natureAsset,
          negativeColor: AppColors.natureExpense,
          baselineColor: AppColors.darkFg4,
          colorOperating: _colorOperating,
          colorInvesting: _colorInvesting,
          colorFinancing: _colorFinancing,
          colorNetChange: _colorNetChange,
          colorCategoryBaseline: _colorBaseline,
          labelStyle: Theme.of(context).textTheme.labelSmall ??
              const TextStyle(fontSize: 10),
          progress: _progress.value,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _WaterfallPainter extends CustomPainter {
  const _WaterfallPainter({
    required this.bars,
    required this.positiveColor,
    required this.negativeColor,
    required this.baselineColor,
    required this.labelStyle,
    this.colorOperating,
    this.colorInvesting,
    this.colorFinancing,
    this.colorNetChange,
    this.colorCategoryBaseline,
    this.progress = 1.0,
  });

  final List<_WaterfallBar> bars;
  final Color positiveColor;
  final Color negativeColor;
  final Color baselineColor;
  final TextStyle labelStyle;
  final Color? colorOperating;
  final Color? colorInvesting;
  final Color? colorFinancing;
  final Color? colorNetChange;
  final Color? colorCategoryBaseline;
  final double progress;

  Color _colorFor(_WaterfallBar bar) {
    if (bar.isBaseline) return colorCategoryBaseline ?? baselineColor;
    return switch (bar.category) {
      _CfCategory.operating => colorOperating ?? positiveColor,
      _CfCategory.investing =>
        colorInvesting ?? (bar.value >= 0 ? positiveColor : negativeColor),
      _CfCategory.financing =>
        colorFinancing ?? (bar.value >= 0 ? positiveColor : negativeColor),
      _CfCategory.netChange => colorNetChange ?? baselineColor,
      _CfCategory.baseline => colorCategoryBaseline ?? baselineColor,
      null => bar.value >= 0 ? positiveColor : negativeColor,
    };
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (bars.isEmpty) return;

    const double kLabelHeight = 32.0;
    const double kPadding = 8.0;
    final chartH = size.height - kLabelHeight;
    final barW =
        (size.width - kPadding * 2) / bars.length - kPadding;

    // 최대 절댓값으로 스케일 계산
    int maxAbs = 1;
    int runningTotal = 0;
    final List<int> totals = [];
    for (final bar in bars) {
      if (bar.isBaseline) {
        totals.add(runningTotal);
      } else {
        totals.add(runningTotal);
        runningTotal += bar.value;
      }
      if (bar.value.abs() > maxAbs) maxAbs = bar.value.abs();
      if (runningTotal.abs() > maxAbs) maxAbs = runningTotal.abs();
    }

    final double scale = (chartH * 0.8) / maxAbs;
    final double baseline = chartH * 0.9;

    final paintFill = Paint()..style = PaintingStyle.fill;

    for (var i = 0; i < bars.length; i++) {
      final bar = bars[i];
      final x = kPadding + i * (barW + kPadding);
      final startY = baseline - totals[i] * scale;
      final barH = bar.value * scale;

      paintFill.color = _colorFor(bar);

      final animatedBarH = barH * progress;
      final rect = Rect.fromLTWH(
        x,
        animatedBarH >= 0 ? startY - animatedBarH : startY,
        barW,
        animatedBarH.abs().clamp(2.0, chartH),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(3)),
        paintFill,
      );

      // 레이블
      _drawLabel(
        canvas,
        bar.label,
        x + barW / 2,
        size.height - kLabelHeight + 4,
      );

      // 금액 텍스트
      if (bar.value != 0 && progress > 0.5) {
        _drawLabel(
          canvas,
          _fmt(bar.value),
          x + barW / 2,
          animatedBarH >= 0 ? startY - animatedBarH - 14 : startY - 14,
        );
      }
    }

    // 기준선
    final paintLine = Paint()
      ..color = Colors.grey.withValues(alpha: 0.3)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, baseline),
      Offset(size.width, baseline),
      paintLine,
    );
  }

  void _drawLabel(Canvas canvas, String text, double cx, double y) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: labelStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(cx - tp.width / 2, y));
  }

  String _fmt(int v) {
    if (v.abs() >= 100000000) return '${(v / 100000000).toStringAsFixed(1)}억';
    if (v.abs() >= 10000) return '${(v / 10000).toStringAsFixed(0)}만';
    return '₩$v';
  }

  @override
  bool shouldRepaint(_WaterfallPainter oldDelegate) =>
      oldDelegate.bars != bars ||
      oldDelegate.colorOperating != colorOperating ||
      oldDelegate.colorInvesting != colorInvesting ||
      oldDelegate.colorFinancing != colorFinancing ||
      oldDelegate.progress != progress;
}

/// CFWaterfallFull — GenerateCashFlowStatement 결과 직접 수신 버전
/// ReportBloc에 cashFlowStatement 상태가 추가된 후 DashboardPage에서 교체 사용
class CFWaterfallFull extends StatelessWidget {
  const CFWaterfallFull({super.key, required this.listItems});
  final List<CashFlowLineItem> listItems;

  @override
  Widget build(BuildContext context) {
    // level=1 항목(5대 분류)만 폭포 차트에 표시
    final topLevel =
        listItems.where((i) => i.level == 1).toList();

    final bars = topLevel.map((item) {
      final isBaseline = item.indexType == CfAccountIndex.aggregate &&
          (item.code == 'C6000000' || item.code == 'C7000000');
      _CfCategory? cat;
      if (!isBaseline) {
        if (item.code.startsWith('C1')) {
          cat = _CfCategory.operating;
        } else if (item.code.startsWith('C2')) {
          cat = _CfCategory.investing;
        } else if (item.code.startsWith('C3')) {
          cat = _CfCategory.financing;
        } else if (item.code.startsWith('C5')) {
          cat = _CfCategory.netChange;
        }
      }
      return _WaterfallBar(
        label: item.name.length > 4
            ? '${item.name.substring(0, 4)}..'
            : item.name,
        value: item.amount,
        isBaseline: isBaseline,
        category: cat,
      );
    }).toList();

    if (bars.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '현금흐름표',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Wrap(
              spacing: 12,
              runSpacing: 4,
              children: [
                _LegendChip(color: const Color(0xFF10B981), label: '영업'),
                _LegendChip(color: const Color(0xFF3B82F6), label: '투자'),
                _LegendChip(color: const Color(0xFFF59E0B), label: '재무'),
                _LegendChip(color: const Color(0xFF8B5CF6), label: '기말'),
              ],
            ),
          ),
          SizedBox(
            height: 220,
            child: _WaterfallPainterWidget(bars: bars),
          ),
        ],
      ),
    );
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}
