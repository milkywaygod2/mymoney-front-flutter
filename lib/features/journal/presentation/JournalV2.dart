import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/theme/AppColors.dart';
import '../../../core/constants/Enums.dart';
import '../../../core/domain/Transaction.dart';
import 'JournalBloc.dart';
import 'JournalState.dart';
import 'widgets/DayGroupHeader.dart';
import 'widgets/PostingCell.dart';

/// V2 — 분개장 그리드 (날짜|차변|대변 3col)
class JournalV2 extends StatelessWidget {
  const JournalV2({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JournalBloc, JournalState>(
      builder: (context, state) {
        final grouped = _groupByDate(state.listTransactions);

        return Column(
          children: [
            // 헤더
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${DateTime.now().month}월 · 분개장',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.1 * 11, color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                      const Text('General Journal', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      // TODO: U1 머지 후 AppColors로 교체
                      color: AppColors.natureAsset.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      '부기 ON',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.08 * 10, color: AppColors.natureAsset),
                    ),
                  ),
                ],
              ),
            ),
            // 컬럼 헤더
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                children: [
                  const SizedBox(width: 70, child: Text('날짜', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.08 * 10))),
                  const SizedBox(width: 8),
                  const Expanded(child: Text('차변 (Debit)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.natureAsset))),
                  const SizedBox(width: 8),
                  const Expanded(child: Text('대변 (Credit)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.equitySoft))),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: grouped.length,
                itemBuilder: (context, gi) {
                  final g = grouped[gi];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DayGroupHeader(date: g.date, dayNet: g.dayNet),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: Column(
                            children: [
                              ...List.generate(g.items.length, (i) {
                                final tx = g.items[i];
                                return _JournalRow(tx: tx, isLast: i == g.items.length - 1);
                              }),
                              _DayTotalsRow(txns: g.items),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

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
  }).toList()..sort((a, b) => b.date.compareTo(a.date));
}

class _JournalRow extends StatelessWidget {
  const _JournalRow({required this.tx, required this.isLast});
  final Transaction tx;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final debits = tx.listLines.where((l) => l.entryType == EntryType.debit).toList();
    final credits = tx.listLines.where((l) => l.entryType == EntryType.credit).toList();
    final debit = debits.isNotEmpty ? debits.first : null;
    final credit = credits.isNotEmpty ? credits.first : null;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: Theme.of(context).colorScheme.outlineVariant, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 설명 + 시각
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(tx.description, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              ),
              Text(
                '${tx.date.hour.toString().padLeft(2, '0')}:${tx.date.minute.toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant, fontFamily: 'monospace'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 날짜|차변|대변 3col
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 70,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '${tx.date.month.toString().padLeft(2, '0')}/${tx.date.day.toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant, fontFamily: 'monospace'),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: debit != null
                    ? PostingCell(
                        accountName: '계정 ${debit.accountId.value}',
                        kind: 'expense',
                        icon: '🍎',
                        amount: debit.baseAmount,
                        side: '차',
                      )
                    : const SizedBox(),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: credit != null
                    ? PostingCell(
                        accountName: '계정 ${credit.accountId.value}',
                        kind: 'asset',
                        icon: '🌳',
                        amount: credit.baseAmount,
                        side: '대',
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DayTotalsRow extends StatelessWidget {
  const _DayTotalsRow({required this.txns});
  final List<Transaction> txns;

  @override
  Widget build(BuildContext context) {
    final dayRev = txns.fold<int>(0, (s, t) =>
      s + t.listLines.where((l) => l.entryType == EntryType.credit).fold<int>(0, (a, l) => a + l.baseAmount));
    final dayExp = txns.fold<int>(0, (s, t) =>
      s + t.listLines.where((l) => l.entryType == EntryType.debit).fold<int>(0, (a, l) => a + l.baseAmount));

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outline, width: 2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '하루 손익',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.05 * 10, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
          Text(
            '${dayRev >= 0 ? '+' : '−'}₩${_fmt(dayRev.abs())}',
            style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.equitySoft),
          ),
          const SizedBox(width: 8),
          Text(
            '−₩${_fmt(dayExp)}',
            style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.natureExpense),
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
