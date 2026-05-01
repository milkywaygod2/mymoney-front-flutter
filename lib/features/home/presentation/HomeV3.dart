import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/AppColors.dart';
import 'HomeBloc.dart';
import 'widgets/FiveAccountBox.dart';
import 'widgets/PendingBox.dart';
import 'widgets/ProportionalScale.dart';

/// HomeV3 — 저울 (ProportionalScale + FiveAccountBox)
class HomeV3 extends StatelessWidget {
  const HomeV3({super.key, required this.vm});

  final HomeViewModel vm;

  @override
  Widget build(BuildContext context) {
    if (vm.assets == 0 && vm.netWorth == 0) {
      return const Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.balance, size: 72, color: Colors.grey),
          SizedBox(height: 16),
          Text('아직 데이터가 없습니다', style: TextStyle(fontSize: 16, color: Colors.grey)),
          SizedBox(height: 8),
          Text('거래를 입력하면 저울이 나타납니다', style: TextStyle(fontSize: 13, color: Colors.grey)),
        ]),
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _eyelet(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.1 * 10,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '이번 달 현금·카드 흐름',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, height: 1.2),
                ),
                const SizedBox(height: 3),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 10.5, color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.4),
                    children: [
                      const TextSpan(text: '5대 계정 어느 거래든 '),
                      TextSpan(
                        text: '현금·카드의 증감을 유발하는 모든 금액',
                        style: TextStyle(fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurface),
                      ),
                      const TextSpan(text: '이 누적돼\n이 저울에 반영돼요. 수익 > 비용이면 수익 쪽으로 기울어요.'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // 저울 — 중앙 정렬
          InkWell(
            onTap: () => context.go('/report'),
            borderRadius: BorderRadius.circular(16),
            child: Center(
              child: ProportionalScale(
                revenue: vm.revenue,
                expense: vm.expense,
                listPendingExpenses: vm.listPendingExpenses,
                listPendingAssets: vm.listPendingAssets,
                listPendingRevenues: vm.listPendingRevenues,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 순증가 요약
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '순증가 · 자본에 쌓이는 양',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          letterSpacing: 0.05 * 11,
                        ),
                      ),
                      _NetIncomeChip(revenue: vm.revenue, expense: vm.expense),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // 예약 거래
                PendingBox(
                  title: '비용 예정',
                  items: vm.listPendingExpenses,
                  accentColor: AppColors.natureExpense,
                ),
                if (vm.listPendingExpenses.isNotEmpty) const SizedBox(height: 8),
                PendingBox(
                  title: '수익 예정',
                  items: vm.listPendingRevenues,
                  accentColor: AppColors.equitySoft,
                ),
                if (vm.listPendingRevenues.isNotEmpty) const SizedBox(height: 8),
                PendingBox(
                  title: '자산 예정',
                  items: vm.listPendingAssets,
                  accentColor: AppColors.natureAsset,
                ),
                const SizedBox(height: 16),
                // 복식부기 항등식
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 10),
                  child: Text(
                    '복식부기 항등식',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.08 * 11,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => context.go('/report'),
                  borderRadius: BorderRadius.circular(16),
                  child: FiveAccountBox(
                    assets: vm.assets,
                    expense: vm.expense,
                    liabilities: vm.liabilities,
                    equity: vm.equity,
                    revenue: vm.revenue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

String _eyelet() {
  final now = DateTime.now();
  const weekdays = ['일', '월', '화', '수', '목', '금', '토'];
  return '${now.month}월 · ${weekdays[now.weekday % 7]}요일';
}

class _NetIncomeChip extends StatelessWidget {
  const _NetIncomeChip({required this.revenue, required this.expense});
  final int revenue;
  final int expense;

  @override
  Widget build(BuildContext context) {
    final net = revenue - expense;
    final isProfit = net >= 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: (isProfit ? AppColors.stateSuccess : AppColors.stateError).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: (isProfit ? AppColors.stateSuccess : AppColors.stateError).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isProfit ? Icons.trending_up : Icons.trending_down,
            size: 14,
            color: isProfit ? AppColors.stateSuccess : AppColors.stateError,
          ),
          const SizedBox(width: 4),
          Text(
            '${isProfit ? "+" : ""}₩${_fmtCompact(net.abs())} ${isProfit ? "흑자" : "적자"}',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isProfit ? AppColors.stateSuccess : AppColors.stateError,
            ),
          ),
        ],
      ),
    );
  }

  String _fmtCompact(int v) {
    if (v >= 100000000) return '${(v / 100000000).toStringAsFixed(1)}억';
    if (v >= 10000) return '${(v / 10000).toStringAsFixed(0)}만';
    return '₩$v';
  }
}
