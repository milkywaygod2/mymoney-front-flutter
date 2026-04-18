import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/Enums.dart';
import '../../../core/domain/Transaction.dart';
import 'JournalBloc.dart';
import 'JournalState.dart';

/// 거래 리스트 페이지 — 기본 리스트 (Flow Card는 Wave 5)
class JournalPage extends StatelessWidget {
  const JournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JournalBloc, JournalState>(
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

        if (state.listTransactions.isEmpty) {
          return const Center(child: Text('거래가 없습니다'));
        }

        return ListView.builder(
          itemCount: state.listTransactions.length,
          itemBuilder: (context, index) {
            final tx = state.listTransactions[index];
            return _TransactionTile(transaction: tx);
          },
        );
      },
    );
  }
}

/// 거래 리스트 타일
class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.transaction});

  final Transaction transaction;

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
