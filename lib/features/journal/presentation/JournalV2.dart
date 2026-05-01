import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/theme/AppColors.dart';
import '../../../core/constants/Enums.dart';
import '../../../core/domain/Transaction.dart';
import '../../../core/models/TypedId.dart';
import '../../account/presentation/AccountBloc.dart';
import '../../account/presentation/AccountState.dart';
import '../../report/presentation/ReportBloc.dart';
import 'JournalBloc.dart';
import 'JournalEvent.dart';
import 'JournalState.dart';
import 'widgets/DayGroupHeader.dart';
import 'widgets/PostingCell.dart';

Map<int, ({String name, String kind})> _buildAccountMap(AccountState s) {
  return {
    for (final a in s.listAll)
      a.id.value: (name: a.name, kind: a.nature.name),
  };
}

/// V2 — 분개장 그리드 (날짜|차변|대변 3col) + 검색 + 월 네비게이션
class JournalV2 extends StatefulWidget {
  const JournalV2({super.key});

  @override
  State<JournalV2> createState() => _JournalV2State();
}

class _JournalV2State extends State<JournalV2> {
  String _searchQuery = '';
  String _filter = '전체';
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month);
  }

  void _prevMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    });
  }

  void _showSearchDialog(BuildContext context) {
    final ctrl = TextEditingController(text: _searchQuery);
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('거래 검색'),
        content: TextField(
          autofocus: true,
          controller: ctrl,
          decoration: const InputDecoration(hintText: '거래 설명 입력...'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _searchQuery = '');
              Navigator.pop(context);
            },
            child: const Text('초기화'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _searchQuery = ctrl.text.trim());
              Navigator.pop(context);
            },
            child: const Text('검색'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, accountState) {
        final accountMap = _buildAccountMap(accountState);
        return BlocBuilder<JournalBloc, JournalState>(
          builder: (context, state) {
            final grouped = _groupByDate(state.listTransactions, _selectedMonth, _searchQuery, _filter, accountMap);

        return Column(
          children: [
            // 헤더
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 12, 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_selectedMonth.year}년 ${_selectedMonth.month}월 · 분개장',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.1 * 11, color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                        const Text('General Journal', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  // 월 네비게이션
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    tooltip: '이전 달',
                    onPressed: _prevMonth,
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    tooltip: '다음 달',
                    onPressed: _nextMonth,
                  ),
                  // 검색
                  if (_searchQuery.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.search_off),
                      tooltip: '검색 초기화',
                      onPressed: () => setState(() => _searchQuery = ''),
                    ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    tooltip: '검색',
                    onPressed: () => _showSearchDialog(context),
                  ),
                ],
              ),
            ),
            // 검색 활성 배너
            if (_searchQuery.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 6),
                child: Row(
                  children: [
                    const Icon(Icons.search, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('"$_searchQuery" 검색 중', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              ),
            // 필터 칩
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: ['전체', '수익', '비용', '이체'].map((c) {
                  final active = _filter == c;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _filter = c),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: active ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(c, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: active ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.onSurface)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
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
            // 거래 없음
            if (grouped.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _searchQuery.isNotEmpty ? Icons.search_off : Icons.receipt_long_outlined,
                        size: 48,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _searchQuery.isNotEmpty
                            ? '"$_searchQuery" 검색 결과 없음'
                            : _filter != '전체'
                                ? '${_selectedMonth.year}년 ${_selectedMonth.month}월 $_filter 거래 없음'
                                : '${_selectedMonth.year}년 ${_selectedMonth.month}월 거래 없음',
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
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
                              color: Theme.of(context).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Column(
                              children: [
                                ...List.generate(g.items.length, (i) {
                                  final tx = g.items[i];
                                  return _JournalRow(tx: tx, isLast: i == g.items.length - 1, accountMap: accountMap);
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

bool _matchesFilter(Transaction t, String filter, Map<int, ({String name, String kind})> accountMap) {
  if (filter == '전체') return true;
  final debits = t.listLines.where((l) => l.entryType == EntryType.debit).toList();
  final credits = t.listLines.where((l) => l.entryType == EntryType.credit).toList();
  if (filter == '수익') {
    return credits.isNotEmpty && (accountMap[credits.first.accountId.value]?.kind == 'revenue');
  }
  if (filter == '비용') {
    return debits.isNotEmpty && (accountMap[debits.first.accountId.value]?.kind == 'expense');
  }
  if (filter == '이체') {
    return debits.isNotEmpty && credits.isNotEmpty &&
        (accountMap[debits.first.accountId.value]?.kind == 'asset') &&
        (accountMap[credits.first.accountId.value]?.kind == 'asset');
  }
  return true;
}

List<_DayGroup> _groupByDate(
  List<Transaction> txns,
  DateTime selectedMonth,
  String searchQuery,
  String filter,
  Map<int, ({String name, String kind})> accountMap,
) {
  final q = searchQuery.toLowerCase();
  final filtered = txns.where((t) {
    if (t.date.year != selectedMonth.year || t.date.month != selectedMonth.month) return false;
    if (q.isNotEmpty && !t.description.toLowerCase().contains(q)) return false;
    if (!_matchesFilter(t, filter, accountMap)) return false;
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
  }).toList()..sort((a, b) => b.date.compareTo(a.date));
}

class _JournalRow extends StatelessWidget {
  const _JournalRow({required this.tx, required this.isLast, required this.accountMap});
  final Transaction tx;
  final bool isLast;
  final Map<int, ({String name, String kind})> accountMap;

  void _showDetail(BuildContext context) {
    final journalBloc = context.read<JournalBloc>();
    final periodId = context.read<ReportBloc>().state.activePeriodId;
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tx.description, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('날짜: ${tx.date.year}.${tx.date.month}.${tx.date.day}'),
            const SizedBox(height: 4),
            Text('금액: ₩${_fmt(tx.listLines.where((l) => l.entryType == EntryType.debit).fold(0, (s, l) => s + l.baseAmount))}'),
            const SizedBox(height: 4),
            Text(
              '상태: ${tx.status.name}',
              style: TextStyle(color: tx.status == TransactionStatus.posted ? Colors.green : Colors.orange),
            ),
            const SizedBox(height: 16),
            ...tx.listLines.map((l) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Text(l.entryType == EntryType.debit ? '차변' : '대변', style: const TextStyle(fontSize: 12)),
                  const SizedBox(width: 8),
                  Expanded(child: Text(l.accountId.value.toString())),
                  Text('₩${_fmt(l.baseAmount)}'),
                ],
              ),
            )),
            if (tx.status == TransactionStatus.draft) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: periodId == null ? null : () {
                    Navigator.of(context).pop();
                    journalBloc.add(
                          PostTransactionEvent(
                            id: tx.id,
                            periodId: PeriodId(periodId),
                          ),
                        );
                  },
                  child: const Text('전기 처리'),
                ),
              ),
            ],
          ],
        ),
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

  @override
  Widget build(BuildContext context) {
    final debits = tx.listLines.where((l) => l.entryType == EntryType.debit).toList();
    final credits = tx.listLines.where((l) => l.entryType == EntryType.credit).toList();
    final rowCount = debits.length > credits.length ? debits.length : credits.length;

    return Dismissible(
      key: ValueKey(tx.id.value),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red.shade700,
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('거래 삭제'),
            content: const Text('이 거래를 삭제할까요?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('취소')),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('삭제', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ) ?? false;
      },
      onDismissed: (_) {
        context.read<JournalBloc>().add(DeleteTransactionEvent(id: tx.id));
      },
      child: InkWell(
        onTap: () => _showDetail(context),
        child: Container(
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
          // 날짜|차변|대변 3col — 다중 분개 지원
          ...List.generate(rowCount, (i) {
            final debit = i < debits.length ? debits[i] : null;
            final credit = i < credits.length ? credits[i] : null;
            final debitInfo = debit != null ? accountMap[debit.accountId.value] : null;
            final creditInfo = credit != null ? accountMap[credit.accountId.value] : null;
            return Padding(
              padding: EdgeInsets.only(top: i > 0 ? 6 : 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 70,
                    child: i == 0
                        ? Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              '${tx.date.month.toString().padLeft(2, '0')}/${tx.date.day.toString().padLeft(2, '0')}',
                              style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant, fontFamily: 'monospace'),
                            ),
                          )
                        : const SizedBox(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: debit != null
                        ? PostingCell(
                            accountName: debitInfo?.name ?? '계정 ${debit.accountId.value}',
                            kind: debitInfo?.kind ?? 'expense',
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
                            accountName: creditInfo?.name ?? '계정 ${credit.accountId.value}',
                            kind: creditInfo?.kind ?? 'asset',
                            icon: '🌳',
                            amount: credit.baseAmount,
                            side: '대',
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
        ),
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
