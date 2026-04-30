import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/Enums.dart';
import '../../../core/domain/Transaction.dart';
import '../../perspective/presentation/LensSwitcher.dart';
import '../../perspective/presentation/PerspectiveBloc.dart';
import '../../perspective/presentation/PerspectiveEvent.dart';
import '../../perspective/presentation/PerspectiveState.dart';
import 'FlowCard.dart';
import 'JournalBloc.dart';
import 'JournalEvent.dart';
import 'JournalState.dart';
import 'TransactionForm.dart';

/// 거래 페이지 — Split View (상단 FlowCard + 하단 리스트)
/// 데스크톱: 좌우 Master-Detail, 모바일: 상하 Split
class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  @override
  void initState() {
    super.initState();
    context.read<PerspectiveBloc>().add(const LoadPresets());
    final perspective =
        context.read<PerspectiveBloc>().state.effectivePerspective;
    context.read<JournalBloc>().add(LoadTransactions(perspective: perspective));
  }

  void _showLensSwitcher(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => BlocProvider.value(
        value: context.read<PerspectiveBloc>(),
        child: const LensSwitcher(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('거래'),
        actions: [
          BlocBuilder<PerspectiveBloc, PerspectiveState>(
            buildWhen: (prev, curr) =>
                prev.effectivePerspective != curr.effectivePerspective,
            builder: (context, state) {
              final name = state.effectivePerspective?.name ?? '전체';
              return ActionChip(
                avatar: const Icon(Icons.lens, size: 14),
                label: Text(name, style: const TextStyle(fontSize: 11)),
                onPressed: () => _showLensSwitcher(context),
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 4),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<JournalBloc, JournalState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.errorMessage != null) {
            return Center(
              child: Text(state.errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error)),
            );
          }
          if (state.listTransactions.isEmpty) {
            return const Center(child: Text('거래가 없습니다'));
          }

          // 플랫폼별 적응 레이아웃
          if (isWide) {
            return _buildDesktopLayout(context, state);
          }
          return _buildMobileLayout(context, state);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => TransactionForm.show(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  /// 데스크톱: 좌 리스트 + 우 FlowCard
  Widget _buildDesktopLayout(BuildContext context, JournalState state) {
    return Row(
      children: [
        // 좌: 거래 리스트
        SizedBox(
          width: 360,
          child: _buildTransactionList(context, state),
        ),
        const VerticalDivider(width: 1),
        // 우: 선택된 거래의 FlowCard
        Expanded(
          child: state.selectedTransaction != null
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: FlowCard(transaction: state.selectedTransaction!),
                )
              : const Center(child: Text('거래를 선택하세요')),
        ),
      ],
    );
  }

  /// 모바일: 상 FlowCard + 하 리스트
  Widget _buildMobileLayout(BuildContext context, JournalState state) {
    return Column(
      children: [
        // 상: FlowCard (선택된 거래 또는 첫 번째)
        if (state.selectedTransaction != null || state.listTransactions.isNotEmpty)
          SizedBox(
            height: 220,
            child: SingleChildScrollView(
              child: FlowCard(
                transaction: state.selectedTransaction ?? state.listTransactions.first,
              ),
            ),
          ),
        const Divider(height: 1),
        // 하: 거래 리스트
        Expanded(child: _buildTransactionList(context, state)),
      ],
    );
  }

  Widget _buildTransactionList(BuildContext context, JournalState state) {
    return ListView.builder(
      itemCount: state.listTransactions.length,
      itemBuilder: (context, index) {
        final tx = state.listTransactions[index];
        final isSelected = state.selectedTransaction?.id == tx.id;
        return _TransactionTile(
          transaction: tx,
          isSelected: isSelected,
          onTap: () => context.read<JournalBloc>().add(
                SelectTransaction(id: tx.id),
              ),
        );
      },
    );
  }
}

/// 거래 리스트 타일
class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.transaction, this.isSelected = false, this.onTap});

  final Transaction transaction;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // status 뱃지 색상
    final (statusColor, statusLabel) = switch (transaction.status) {
      TransactionStatus.draft => (Colors.orange, 'Draft'),
      TransactionStatus.posted => (Colors.green, 'Posted'),
      TransactionStatus.voided => (Colors.red, 'Voided'),
    };

    // 총 차변 금액 계산
    final totalDebit = transaction.listLines
        .where((l) => l.entryType == EntryType.debit)
        .fold<int>(0, (sum, l) => sum + l.baseAmount);

    return ListTile(
      selected: isSelected,
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: statusColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          statusLabel,
          style: TextStyle(color: statusColor, fontSize: 12),
        ),
      ),
      title: Text(transaction.description),
      subtitle: Text(
        '${transaction.date.year}-'
        '${transaction.date.month.toString().padLeft(2, '0')}-'
        '${transaction.date.day.toString().padLeft(2, '0')}'
        '  |  ${transaction.listLines.length}건',
      ),
      trailing: Text(
        '₩${_formatAmount(totalDebit)}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
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
