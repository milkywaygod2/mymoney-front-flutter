import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/theme/AppColors.dart';
import '../../../core/models/CashFlowLineItem.dart';
import '../../../core/constants/Enums.dart';
import 'ReportBloc.dart';

/// 현금흐름 폭포(Waterfall) 차트 — CustomPainter 기반
class CFWaterfall extends StatelessWidget {
  const CFWaterfall({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportBloc, ReportState>(
      builder: (context, state) {
        // TODO: U6 확장 시 ReportBloc에 cashFlowStatement 상태 추가 후 연결
        // 현재는 대시보드 요약에서 가용한 데이터로 표시
        if (state.dashboard == null) return const SizedBox.shrink();

        // stub 데이터: DashboardSummary에서 간이 CF 구성
        final d = state.dashboard!;
        final listItems = <_WaterfallBar>[
          _WaterfallBar(
            label: '기초현금',
            value: 0,
            isBaseline: true,
          ),
          _WaterfallBar(
            label: '영업활동',
            value: d.netIncome,
            isBaseline: false,
          ),
          _WaterfallBar(
            label: '투자활동',
            value: 0,
            isBaseline: false,
          ),
          _WaterfallBar(
            label: '재무활동',
            value: 0,
            isBaseline: false,
          ),
          _WaterfallBar(
            label: '기말현금',
            value: d.netIncome,
            isBaseline: true,
          ),
        ];

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
              SizedBox(
                height: 200,
                child: _WaterfallPainterWidget(bars: listItems),
              ),
              const SizedBox(height: 8),
              const Text(
                '※ CF 보고서 연동 후 세부 항목 표시',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _WaterfallBar {
  const _WaterfallBar({
    required this.label,
    required this.value,
    required this.isBaseline,
  });
  final String label;
  final int value;
  final bool isBaseline;
}

class _WaterfallPainterWidget extends StatelessWidget {
  const _WaterfallPainterWidget({required this.bars});
  final List<_WaterfallBar> bars;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _WaterfallPainter(
        bars: bars,
        positiveColor: AppColors.natureAsset,
        negativeColor: AppColors.natureExpense,
        baselineColor: AppColors.darkFg4,
        labelStyle: Theme.of(context).textTheme.labelSmall ??
            const TextStyle(fontSize: 10),
      ),
      child: const SizedBox.expand(),
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
  });

  final List<_WaterfallBar> bars;
  final Color positiveColor;
  final Color negativeColor;
  final Color baselineColor;
  final TextStyle labelStyle;

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

      paintFill.color = bar.isBaseline
          ? baselineColor
          : (bar.value >= 0 ? positiveColor : negativeColor);

      final rect = Rect.fromLTWH(
        x,
        barH >= 0 ? startY - barH : startY,
        barW,
        barH.abs().clamp(2.0, chartH),
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
      if (bar.value != 0) {
        _drawLabel(
          canvas,
          _fmt(bar.value),
          x + barW / 2,
          barH >= 0 ? startY - barH - 14 : startY - 14,
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
      oldDelegate.bars != bars;
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
      return _WaterfallBar(
        label: item.name.length > 4
            ? '${item.name.substring(0, 4)}..'
            : item.name,
        value: item.amount,
        isBaseline: item.indexType == CfAccountIndex.aggregate &&
            (item.code == 'C6000000' || item.code == 'C7000000'),
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
          SizedBox(
            height: 220,
            child: _WaterfallPainterWidget(bars: bars),
          ),
        ],
      ),
    );
  }
}
