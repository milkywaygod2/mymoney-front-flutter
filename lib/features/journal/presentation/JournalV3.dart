import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/Enums.dart';
import '../../../core/domain/Transaction.dart';
import '../../account/presentation/AccountBloc.dart';
import '../../account/presentation/AccountState.dart';
import 'JournalBloc.dart';
import 'JournalState.dart';
import 'widgets/DayGroupHeader.dart';
import 'widgets/FlowArrow.dart';
import 'widgets/FlowNode.dart';

Map<int, ({String name, String kind})> _buildAccountMap(AccountState s) {
  return {
    for (final a in s.listAll)
      a.id.value: (name: a.name, kind: a.nature.name),
  };
}

/// V3 — FROM→TO 흐름 카드 (날짜 그루핑 + 검색)
class JournalV3 extends StatefulWidget {
  const JournalV3({super.key});

  @override
  State<JournalV3> createState() => _JournalV3State();
}

class _JournalV3State extends State<JournalV3> {
  String _query = '';

  void _showSearchDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        String draft = _query;
        return AlertDialog(
          title: const Text('거래 검색'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: '거래 설명 검색...'),
            controller: TextEditingController(text: _query),
            onChanged: (v) => draft = v,
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() => _query = '');
                Navigator.of(ctx).pop();
              },
              child: const Text('초기화'),
            ),
            FilledButton(
              onPressed: () {
                setState(() => _query = draft);
                Navigator.of(ctx).pop();
              },
              child: const Text('검색'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, accountState) {
        final accountMap = _buildAccountMap(accountState);
        return BlocBuilder<JournalBloc, JournalState>(
          builder: (context, state) {
            final filtered = _query.isEmpty
                ? state.listTransactions
                : state.listTransactions
                    .where((t) => t.description.contains(_query))
                    .toList();

            final groups = _groupByDate(filtered);

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
                  child: Row(
                    children: [
                      Expanded(
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
                      if (_query.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Chip(
                            label: Text(_query, style: const TextStyle(fontSize: 11)),
                            deleteIcon: const Icon(Icons.close, size: 14),
                            onDeleted: () => setState(() => _query = ''),
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      IconButton(
                        onPressed: _showSearchDialog,
                        icon: Icon(
                          Icons.search,
                          color: _query.isNotEmpty
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: groups.isEmpty
                      ? Center(
                          child: Text(
                            _query.isEmpty ? '거래 내역이 없습니다' : '"$_query" 검색 결과 없음',
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                          itemCount: groups.length,
                          itemBuilder: (context, gi) {
                            final g = groups[gi];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DayGroupHeader(date: g.date, dayNet: g.dayNet),
                                ...g.items.map((tx) => _FlowCard(tx: tx, accountMap: accountMap)),
                                const SizedBox(height: 6),
                              ],
                            );
                          },
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

// ─── 그루핑 헬퍼 ────────────────────────────────────────────────

class _DayGroup {
  const _DayGroup({required this.date, required this.items, required this.dayNet});
  final DateTime date;
  final List<Transaction> items;
  final int dayNet;
}

List<_DayGroup> _groupByDate(List<Transaction> txns) {
  final map = <String, List<Transaction>>{};
  for (final t in txns) {
    final key = '${t.date.year}-${t.date.month}-${t.date.day}';
    (map[key] ??= []).add(t);
  }

  return map.entries.map((e) {
    final date = e.value.first.date;
    final dayNet = e.value.fold<int>(0, (s, t) {
      final rev = t.listLines.where((l) => l.entryType == EntryType.credit).fold<int>(0, (a, l) => a + l.baseAmount);
      final exp = t.listLines.where((l) => l.entryType == EntryType.debit).fold<int>(0, (a, l) => a + l.baseAmount);
      return s + rev - exp;
    });
    return _DayGroup(date: date, items: e.value, dayNet: dayNet);
  }).toList()
    ..sort((a, b) => b.date.compareTo(a.date));
}

// ─── 서브 위젯 ──────────────────────────────────────────────────

class _FlowCard extends StatelessWidget {
  const _FlowCard({required this.tx, required this.accountMap});
  final Transaction tx;
  final Map<int, ({String name, String kind})> accountMap;

  @override
  Widget build(BuildContext context) {
    final debits = tx.listLines.where((l) => l.entryType == EntryType.debit).toList();
    final credits = tx.listLines.where((l) => l.entryType == EntryType.credit).toList();

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
