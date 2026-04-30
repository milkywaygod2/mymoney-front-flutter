import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/Enums.dart';
import '../../../core/domain/Transaction.dart';
import '../../account/presentation/AccountBloc.dart';
import '../../account/presentation/AccountState.dart';
import 'JournalBloc.dart';
import 'JournalState.dart';
import 'widgets/FlowArrow.dart';
import 'widgets/FlowNode.dart';

Map<int, ({String name, String kind})> _buildAccountMap(AccountState s) {
  return {
    for (final a in s.listAll)
      a.id.value: (name: a.name, kind: a.nature.name),
  };
}

/// V3 — FROM→TO 흐름 카드
class JournalV3 extends StatelessWidget {
  const JournalV3({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, accountState) {
        final accountMap = _buildAccountMap(accountState);
        return BlocBuilder<JournalBloc, JournalState>(
          builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${DateTime.now().month}월 ${DateTime.now().day}일',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.1 * 11, color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                      const Text('돈은 어디로 흘렀나', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    itemCount: state.listTransactions.length,
                    itemBuilder: (context, i) => _FlowCard(tx: state.listTransactions[i], accountMap: accountMap),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _FlowCard extends StatelessWidget {
  const _FlowCard({required this.tx, required this.accountMap});
  final Transaction tx;
  final Map<int, ({String name, String kind})> accountMap;

  @override
  Widget build(BuildContext context) {
    final debits = tx.listLines.where((l) => l.entryType == EntryType.debit).toList();
    final credits = tx.listLines.where((l) => l.entryType == EntryType.credit).toList();

    // FROM = credit 계정들, TO = debit 계정들 (다중 지원)
    final totalAmt = debits.fold<int>(0, (s, l) => s + l.baseAmount);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tx.description, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 2),
                    Text(
                      '${tx.date.hour}:${tx.date.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Text(
                '₩${_fmt(totalAmt)}',
                style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // FROM → TO 흐름 (다중 노드)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: credits.map((l) {
                    final info = accountMap[l.accountId.value];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: FlowNode(
                        accountName: info?.name ?? '?',
                        kind: info?.kind ?? 'asset',
                        icon: '🌳',
                        side: 'from',
                      ),
                    );
                  }).toList(),
                ),
              ),
              const FlowArrow(),
              Expanded(
                child: Column(
                  children: debits.map((l) {
                    final info = accountMap[l.accountId.value];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: FlowNode(
                        accountName: info?.name ?? '?',
                        kind: info?.kind ?? 'expense',
                        icon: '🍎',
                        side: 'to',
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
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
