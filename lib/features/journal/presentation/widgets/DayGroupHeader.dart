import 'package:flutter/material.dart';

/// 날짜 그룹 헤더 + 일 손익
class DayGroupHeader extends StatelessWidget {
  const DayGroupHeader({
    super.key,
    required this.date,
    required this.dayNet,
    this.weekday,
  });

  final DateTime date;
  final int dayNet;
  final String? weekday;

  @override
  Widget build(BuildContext context) {
    final weekdays = ['일', '월', '화', '수', '목', '금', '토'];
    final dayStr = weekday ?? weekdays[date.weekday % 7];
    final dateStr = '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            '$dateStr · $dayStr',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.05 * 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            '${dayNet >= 0 ? '+' : '−'}₩${_fmt(dayNet.abs())}',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
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
