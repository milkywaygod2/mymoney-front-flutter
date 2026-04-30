import 'package:flutter/material.dart';

import '../../../../../app/theme/AppColors.dart';

/// 수익/비용 가로 바 (HomeV1 이번달 흐름)
class MonthFlowBar extends StatelessWidget {
  const MonthFlowBar({
    super.key,
    required this.revenue,
    required this.expense,
  });

  final int revenue;
  final int expense;

  @override
  Widget build(BuildContext context) {
    if (revenue == 0 && expense == 0) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        child: Center(
          child: Text(
            '이번 달 거래 없음',
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }
    final net = revenue - expense;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '수익 · 물 한 컵',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.equitySoft,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.05 * 11,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '+₩ ${_fmt(revenue)}',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '비용 · 떨어진 사과',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.natureExpense,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.05 * 11,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '−₩ ${_fmt(expense)}',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 8,
              child: Row(
                children: [
                  Flexible(
                    flex: revenue > 0 ? revenue : 1,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.revenueSoft, AppColors.equitySoft],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    flex: expense > 0 ? expense : 1,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.natureExpense, AppColors.expenseDeep],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '순 증가',
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '${net >= 0 ? '+' : '−'}₩ ${_fmt(net.abs())}',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppColors.natureAsset,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _fmt(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write(',');
      buffer.write(str[i]);
    }
    return buffer.toString();
  }
}
