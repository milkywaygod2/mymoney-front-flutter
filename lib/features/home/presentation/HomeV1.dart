import 'package:flutter/material.dart';

import '../../../../app/theme/AppColors.dart';
import 'HomeBloc.dart';
import 'widgets/MonthFlowBar.dart';
import 'widgets/NetWorthCard.dart';
import 'widgets/PendingBox.dart';
import 'widgets/ThreeUpStats.dart';

/// HomeV1 — Toss형 (순자산 카드 + 3-up + 흐름)
class HomeV1 extends StatelessWidget {
  const HomeV1({super.key, required this.vm});

  final HomeViewModel vm;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 인사
          _GreetingRow(),
          const SizedBox(height: 16),
          // 순자산 카드
          NetWorthCard(netWorth: vm.netWorth, spark7d: vm.spark7d, periodLabel: vm.periodLabel),
          const SizedBox(height: 12),
          // 3분할
          ThreeUpStats(
            assets: vm.assets,
            liabilities: vm.liabilities,
            equity: vm.equity,
          ),
          const SizedBox(height: 24),
          // 섹션 라벨
          _SectionLabel(text: '이번 달 흐름'),
          const SizedBox(height: 10),
          MonthFlowBar(revenue: vm.revenue, expense: vm.expense),
          const SizedBox(height: 24),
          // 예약 거래
          PendingBox(
            title: '비용 예정',
            items: vm.listPendingExpenses,
            accentColor: AppColors.natureExpense,
          ),
          if (vm.listPendingExpenses.isNotEmpty) const SizedBox(height: 10),
          PendingBox(
            title: '수익 예정',
            items: vm.listPendingRevenues,
            accentColor: AppColors.equitySoft,
          ),
        ],
      ),
    );
  }
}

class _GreetingRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weekdays = ['일', '월', '화', '수', '목', '금', '토'];
    final dayLabel = '${now.month}월 · ${weekdays[now.weekday % 7]}요일';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dayLabel,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              '안녕하세요',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.assetDeep, AppColors.natureAsset],
            ),
          ),
          child: const Center(
            child: Text(
              '나',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
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
