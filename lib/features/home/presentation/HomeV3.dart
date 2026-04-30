import 'package:flutter/material.dart';

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
                  '이번 달 현금·카드 흐름',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, height: 1.2),
                ),
                const SizedBox(height: 3),
                Text(
                  '수익 > 비용이면 수익 쪽으로 기울어요.',
                  style: TextStyle(fontSize: 10.5, color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // 저울 — 중앙 정렬
          Center(
            child: ProportionalScale(
              revenue: vm.revenue,
              expense: vm.expense,
              listPendingExpenses: vm.listPendingExpenses,
              listPendingAssets: vm.listPendingAssets,
              listPendingRevenues: vm.listPendingRevenues,
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
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
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
                      Text(
                        '${vm.revenue >= vm.expense ? '+' : '−'}₩${_fmtCompact((vm.revenue - vm.expense).abs())}',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          // TODO: U1 머지 후 AppColors.natureAsset으로 교체
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // 예약 거래
                PendingBox(
                  title: '비용 예정',
                  items: vm.listPendingExpenses,
                  accentColor: const Color(0xFFEF4444),
                ),
                if (vm.listPendingExpenses.isNotEmpty) const SizedBox(height: 8),
                PendingBox(
                  title: '수익 예정',
                  items: vm.listPendingRevenues,
                  accentColor: const Color(0xFF7DD3FC),
                ),
                if (vm.listPendingRevenues.isNotEmpty) const SizedBox(height: 8),
                PendingBox(
                  title: '자산 예정',
                  items: vm.listPendingAssets,
                  accentColor: const Color(0xFF10B981),
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
                FiveAccountBox(
                  assets: vm.assets,
                  expense: vm.expense,
                  liabilities: vm.liabilities,
                  equity: vm.equity,
                  revenue: vm.revenue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _fmtCompact(int v) {
    if (v >= 100000000) return '${(v / 100000000).toStringAsFixed(1)}억';
    if (v >= 10000) return '${(v / 10000).toStringAsFixed(0)}만';
    return v.toString();
  }
}
