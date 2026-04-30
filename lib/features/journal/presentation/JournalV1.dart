import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/Enums.dart';
import '../../../core/domain/Transaction.dart';
import '../../account/presentation/AccountBloc.dart';
import '../../account/presentation/AccountState.dart';
import 'JournalBloc.dart';
import 'JournalState.dart';
import 'widgets/DayGroupHeader.dart';
import 'widgets/LedgerPosting.dart';
import 'widgets/MiniPosting.dart';

Map<int, ({String name, String kind})> _buildAccountMap(AccountState s) {
  return {
    for (final a in s.listAll)
      a.id.value: (name: a.name, kind: a.nature.name),
  };
}

/// V1 — 단식/복식 토글, 펼침형
class JournalV1 extends StatefulWidget {
  const JournalV1({super.key});

  @override
  State<JournalV1> createState() => _JournalV1State();
}

class _JournalV1State extends State<JournalV1> {
  bool _isDoublEntry = true;
  String _filter = '전체';
  int? _openId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, accountState) {
        final accountMap = _buildAccountMap(accountState);
        return BlocBuilder<JournalBloc, JournalState>(
          builder: (context, state) {
            final grouped = _groupByDate(state.listTransactions, _filter, _isDoublEntry);

            return Column(
          children: [
            // 헤더
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${DateTime.now().month}월',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.1 * 11, color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                        const Text('거래내역', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.tune)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
                ],
              ),
            ),
            // 단식/복식 토글
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: _BookToggle(
                isDouble: _isDoublEntry,
                onChanged: (v) => setState(() { _isDoublEntry = v; _openId = null; }),
              ),
            ),
            // 단식 모드: 필터 칩
            if (!_isDoublEntry) ...[
              _MonthSummary(transactions: state.listTransactions),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 4),
                child: _FilterChips(selected: _filter, onChanged: (v) => setState(() => _filter = v)),
              ),
            ],
            // 거래 목록
            Expanded(
              child: ListView.builder(
                itemCount: grouped.length,
                itemBuilder: (context, gi) {
                  final g = grouped[gi];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      DayGroupHeader(date: g.date, dayNet: g.dayNet),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _isDoublEntry
                            ? Column(
                                children: g.items
                                    .map((tx) => _DoubleEntryCard(tx: tx, accountMap: accountMap))
                                    .toList(),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: Column(
                                  children: List.generate(g.items.length, (i) {
                                    final tx = g.items[i];
                                    final isOpen = _openId == tx.id.value;
                                    return _SingleEntryRow(
                                      tx: tx,
                                      isLast: i == g.items.length - 1,
                                      isOpen: isOpen,
                                      onTap: () => setState(() => _openId = isOpen ? null : tx.id.value),
                                      accountMap: accountMap,
                                    );
                                  }),
                                ),
                              ),
                      ),
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

List<_DayGroup> _groupByDate(List<Transaction> txns, String filter, bool isDouble) {
  final filtered = isDouble
      ? txns
      : txns.where((t) {
          if (filter == '전체') return true;
          // flow 판단: 대변 수익 > 0 이면 in, 대변 비용 > 0 이면 out 등 단순 처리
          final hasRevenue = t.listLines.any((l) => l.entryType == EntryType.credit);
          if (filter == '수익') return hasRevenue;
          if (filter == '비용') return !hasRevenue;
          return true;
        }).toList();

  final map = <String, List<Transaction>>{};
  for (final t in filtered) {
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

class _BookToggle extends StatelessWidget {
  const _BookToggle({required this.isDouble, required this.onChanged});
  final bool isDouble;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (true, '복식부기', '수익·비용·자산·부채·자본'),
      (false, '단식부기', '수익·비용'),
    ];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Row(
        children: tabs.map((t) {
          final active = isDouble == t.$1;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(t.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                decoration: BoxDecoration(
                  color: active ? Theme.of(context).colorScheme.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                  border: active
                      ? Border.all(color: Theme.of(context).colorScheme.outlineVariant)
                      : Border.all(color: Colors.transparent),
                ),
                child: Column(
                  children: [
                    Text(t.$2, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: active ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurfaceVariant)),
                    const SizedBox(height: 1),
                    Text(t.$3, style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: FontWeight.w600, letterSpacing: 0.03 * 10)),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.selected, required this.onChanged});
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ['전체', '수익', '비용', '이체'].map((c) {
          final active = selected == c;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onChanged(c),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: active ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  c,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: active ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _MonthSummary extends StatelessWidget {
  const _MonthSummary({required this.transactions});
  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    final rev = transactions.fold<int>(0, (s, t) =>
      s + t.listLines.where((l) => l.entryType == EntryType.credit).fold<int>(0, (a, l) => a + l.baseAmount));
    final exp = transactions.fold<int>(0, (s, t) =>
      s + t.listLines.where((l) => l.entryType == EntryType.debit).fold<int>(0, (a, l) => a + l.baseAmount));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            _SumCol(label: '수익', value: rev, color: const Color(0xFF7DD3FC)),
            _SumCol(label: '비용', value: exp, color: const Color(0xFFEF4444)),
            _SumCol(label: '순증가', value: rev - exp, color: const Color(0xFF10B981), strong: true),
          ],
        ),
      ),
    );
  }
}

class _SumCol extends StatelessWidget {
  const _SumCol({required this.label, required this.value, required this.color, this.strong = false});
  final String label;
  final int value;
  final Color color;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.06 * 10, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const SizedBox(height: 4),
          Text(
            '${value >= 0 ? '+' : '−'}₩${_fmtCompact(value.abs())}',
            style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w700, fontSize: strong ? 15 : 13, color: color),
          ),
        ],
      ),
    );
  }

  String _fmtCompact(int v) {
    if (v >= 10000) return '${(v / 10000).toStringAsFixed(0)}만';
    return v.toString();
  }
}

class _DoubleEntryCard extends StatelessWidget {
  const _DoubleEntryCard({required this.tx, required this.accountMap});
  final Transaction tx;
  final Map<int, ({String name, String kind})> accountMap;

  @override
  Widget build(BuildContext context) {
    final debits = tx.listLines.where((l) => l.entryType == EntryType.debit).toList();
    final credits = tx.listLines.where((l) => l.entryType == EntryType.credit).toList();

    final layout = MiniPostingLayout.computeHeights(
      debits.map((l) => l.baseAmount).toList(),
      credits.map((l) => l.baseAmount).toList(),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(11, 11, 11, 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 4, offset: const Offset(0, 1))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tx.description,
                style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${tx.date.hour.toString().padLeft(2, '0')}:${tx.date.minute.toString().padLeft(2, '0')}',
                style: TextStyle(fontFamily: 'monospace', fontSize: 10.5, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 2-col 분개
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: List.generate(debits.length, (i) {
                    final info = accountMap[debits[i].accountId.value];
                    return Padding(
                      padding: EdgeInsets.only(bottom: i < debits.length - 1 ? 6 : 0),
                      child: SizedBox(
                        height: layout.debitHs[i],
                        child: MiniPosting(
                          accountName: info?.name ?? '#${debits[i].accountId.value}',
                          kind: info?.kind ?? 'expense',
                          icon: '🍎',
                          amount: debits[i].baseAmount,
                          isDebit: true,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: List.generate(credits.length, (i) {
                    final info = accountMap[credits[i].accountId.value];
                    return Padding(
                      padding: EdgeInsets.only(bottom: i < credits.length - 1 ? 6 : 0),
                      child: SizedBox(
                        height: layout.creditHs[i],
                        child: MiniPosting(
                          accountName: info?.name ?? '#${credits[i].accountId.value}',
                          kind: info?.kind ?? 'asset',
                          icon: '🌳',
                          amount: credits[i].baseAmount,
                          isDebit: false,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SingleEntryRow extends StatelessWidget {
  const _SingleEntryRow({required this.tx, required this.isLast, required this.isOpen, required this.onTap, required this.accountMap});
  final Transaction tx;
  final bool isLast;
  final bool isOpen;
  final VoidCallback onTap;
  final Map<int, ({String name, String kind})> accountMap;

  @override
  Widget build(BuildContext context) {
    final totalDebit = tx.listLines
        .where((l) => l.entryType == EntryType.debit)
        .fold<int>(0, (s, l) => s + l.baseAmount);

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(child: Text('↔', style: TextStyle(fontSize: 18))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tx.description, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14), overflow: TextOverflow.ellipsis),
                      Text(
                        '${tx.date.hour}:${tx.date.minute.toString().padLeft(2, '0')} · ${tx.listLines.length}건',
                        style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '₩${_fmt(totalDebit)}',
                  style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w700, fontSize: 14),
                ),
                const SizedBox(width: 4),
                Icon(isOpen ? Icons.expand_less : Icons.chevron_right, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
              ],
            ),
          ),
        ),
        if (isOpen) _ExpandedPosting(tx: tx, accountMap: accountMap),
        if (!isLast || isOpen) const Divider(height: 1),
      ],
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

class _ExpandedPosting extends StatelessWidget {
  const _ExpandedPosting({required this.tx, required this.accountMap});
  final Transaction tx;
  final Map<int, ({String name, String kind})> accountMap;

  @override
  Widget build(BuildContext context) {
    final debits = tx.listLines.where((l) => l.entryType == EntryType.debit).toList();
    final credits = tx.listLines.where((l) => l.entryType == EntryType.credit).toList();

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '분개 · Double Entry',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.08 * 10, color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: debits.map((l) {
                    final info = accountMap[l.accountId.value];
                    return LedgerPosting(
                      side: '차',
                      accountName: info?.name ?? '#${l.accountId.value}',
                      kind: info?.kind ?? 'expense',
                      icon: '🍎',
                      amount: l.baseAmount,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  children: credits.map((l) {
                    final info = accountMap[l.accountId.value];
                    return LedgerPosting(
                      side: '대',
                      accountName: info?.name ?? '#${l.accountId.value}',
                      kind: info?.kind ?? 'asset',
                      icon: '🌳',
                      amount: l.baseAmount,
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
}
