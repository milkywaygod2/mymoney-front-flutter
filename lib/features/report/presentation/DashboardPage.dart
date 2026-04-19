import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ReportBloc.dart';

/// 대시보드 페이지 — 순자산, 수입/지출 요약, 미확인 Draft 알림
/// [CW_ARCHITECTURE.md 섹션 10.1] 홈 탭 화면
/// 상세 UI는 후속 Wave에서 구현
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('대시보드')),
      body: BlocBuilder<ReportBloc, ReportState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.errorMessage != null) {
            return Center(
              child: Text(
                state.errorMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            );
          }
          if (state.dashboard == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('데이터를 불러오는 중...'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () =>
                        context.read<ReportBloc>().add(const LoadDashboard()),
                    child: const Text('새로고침'),
                  ),
                ],
              ),
            );
          }

          final d = state.dashboard!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 순자산 카드
              _SummaryCard(
                label: '순자산',
                amount: d.netAssets,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              // 수입/지출 행
              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      label: '수입',
                      amount: d.totalRevenue,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryCard(
                      label: '지출',
                      amount: d.totalExpense,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // 당기순이익
              _SummaryCard(
                label: d.netIncome >= 0 ? '당기순이익' : '당기순손실',
                amount: d.netIncome.abs(),
                color: d.netIncome >= 0 ? Colors.teal : Colors.orange,
              ),
              const SizedBox(height: 8),
              Text(
                '기준일: ${_formatDate(d.snapshotDate)}',
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              // TODO: 미확인 Draft 알림 배너 (JournalBloc 연동 후 구현)
            ],
          );
        },
      ),
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.color,
  });

  final String label;
  final int amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(color: color, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(
              '₩${_formatAmount(amount)}',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  String _formatAmount(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write(',');
      buffer.write(str[i]);
    }
    return buffer.toString();
  }
}
