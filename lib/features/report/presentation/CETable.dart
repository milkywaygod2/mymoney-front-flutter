import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/Enums.dart';
import '../../../core/models/EquityChangeItem.dart';
import 'ReportBloc.dart';

/// 자본변동표 — 5구성요소 롤포워드 테이블
class CETable extends StatelessWidget {
  const CETable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportBloc, ReportState>(
      builder: (context, state) {
        // TODO: ReportBloc에 equityChangeStatement 상태 추가 후 연결
        // 현재는 comprehensiveIncome 데이터로 간이 표시
        final ci = state.comprehensiveIncome;
        if (ci == null) return const SizedBox.shrink();

        // stub 행 목록 — 순이익 행만 실데이터, 나머지는 0
        final listItems = <EquityChangeItem>[
          const EquityChangeItem(
            changeType: EquityChangeType.beginningBalance,
            capitalStock: 0,
            capitalSurplus: 0,
            otherCapital: 0,
            aoci: 0,
            retainedEarnings: 0,
          ),
          EquityChangeItem(
            changeType: EquityChangeType.netIncome,
            capitalStock: 0,
            capitalSurplus: 0,
            otherCapital: 0,
            aoci: 0,
            retainedEarnings: ci.netIncome,
          ),
          EquityChangeItem(
            changeType: EquityChangeType.ociChange,
            capitalStock: 0,
            capitalSurplus: 0,
            otherCapital: 0,
            aoci: ci.totalOci,
            retainedEarnings: 0,
          ),
          const EquityChangeItem(
            changeType: EquityChangeType.dividends,
            capitalStock: 0,
            capitalSurplus: 0,
            otherCapital: 0,
            aoci: 0,
            retainedEarnings: 0,
          ),
          EquityChangeItem(
            changeType: EquityChangeType.endingBalance,
            capitalStock: 0,
            capitalSurplus: 0,
            otherCapital: 0,
            aoci: ci.totalOci,
            retainedEarnings: ci.netIncome,
          ),
        ];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '자본변동표',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _CETableContent(listItems: listItems),
              ),
              const SizedBox(height: 8),
              const Text(
                '※ 결산 완료 후 전체 항목 표시',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CETableContent extends StatelessWidget {
  const _CETableContent({required this.listItems});
  final List<EquityChangeItem> listItems;

  static const _kHeaders = ['구분', '자본금', '자본잉여금', '기타자본', 'AOCI', '이익잉여금', '합계'];

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(
        color: Colors.grey.withValues(alpha: 0.3),
        width: 0.5,
      ),
      defaultColumnWidth: const FixedColumnWidth(80),
      columnWidths: const {
        0: FixedColumnWidth(100),
      },
      children: [
        // 헤더 행
        TableRow(
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest,
          ),
          children: _kHeaders
              .map(
                (h) => _Cell(
                  text: h,
                  isBold: true,
                  isHeader: true,
                ),
              )
              .toList(),
        ),
        // 데이터 행
        ...listItems.map((item) => _buildRow(item)),
      ],
    );
  }

  TableRow _buildRow(EquityChangeItem item) {
    final isTotal = item.changeType == EquityChangeType.beginningBalance ||
        item.changeType == EquityChangeType.endingBalance;

    return TableRow(
      decoration: isTotal
          ? const BoxDecoration(color: Color(0xFFF5F5F5))
          : null,
      children: [
        _Cell(text: _rowLabel(item), isBold: isTotal),
        _Cell(text: _fmt(item.capitalStock)),
        _Cell(text: _fmt(item.capitalSurplus)),
        _Cell(text: _fmt(item.otherCapital)),
        _Cell(text: _fmt(item.aoci)),
        _Cell(text: _fmt(item.retainedEarnings)),
        _Cell(text: _fmt(item.total), isBold: isTotal),
      ],
    );
  }

  String _rowLabel(EquityChangeItem item) {
    return switch (item.changeType) {
      EquityChangeType.beginningBalance => '기초잔액',
      EquityChangeType.netIncome => '당기순이익',
      EquityChangeType.ociChange => 'OCI 변동',
      EquityChangeType.dividends => '배당',
      EquityChangeType.treasuryStock => '자사주',
      EquityChangeType.other => '기타',
      EquityChangeType.endingBalance => '기말잔액',
    };
  }

  String _fmt(int v) {
    if (v == 0) return '-';
    if (v.abs() >= 100000000) return '${(v / 100000000).toStringAsFixed(1)}억';
    if (v.abs() >= 10000) return '${(v / 10000).toStringAsFixed(0)}만';
    final s = v.abs().toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return v < 0 ? '-${buf.toString()}' : buf.toString();
  }
}

class _Cell extends StatelessWidget {
  const _Cell({
    required this.text,
    this.isBold = false,
    this.isHeader = false,
  });

  final String text;
  final bool isBold;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: Text(
        text,
        textAlign: isHeader ? TextAlign.center : TextAlign.right,
        style: TextStyle(
          fontSize: isHeader ? 11 : 11,
          fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}
