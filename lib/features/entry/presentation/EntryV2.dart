import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../account/presentation/AccountBloc.dart';
import '../../account/presentation/AccountState.dart';
import 'EntryBloc.dart';
import 'widgets/AccountPicker.dart';
import 'widgets/AmountHero.dart';
import 'widgets/FromToFlow.dart';
import 'widgets/NumPad.dart';

/// V2 — 숫자패드 + 계정 2개 선택
class EntryV2 extends StatelessWidget {
  const EntryV2({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, accountState) {
        return BlocBuilder<EntryBloc, EntryState>(
          builder: (context, state) {
            final creditName = accountState.listAll
                .where((a) => a.id.value == state.creditAccountId?.value)
                .firstOrNull?.name ?? '대변 계정 선택';
            final debitName = accountState.listAll
                .where((a) => a.id.value == state.debitAccountId?.value)
                .firstOrNull?.name ?? '차변 계정 선택';
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  AmountHero(display: state.amountDisplay),
                  const SizedBox(height: 12),
                  // 계정 선택 칩
                  FromToFlow(
                    fromLabel: state.creditAccountId != null
                        ? creditName
                        : '대변 계정 선택',
                    toLabel: state.debitAccountId != null
                        ? debitName
                        : '차변 계정 선택',
                    onFromTap: () => _pickCredit(context, state),
                    onToTap: () => _pickDebit(context, state),
                  ),
                  const SizedBox(height: 8),
                  // 날짜 / 메모 row
                  _DateRow(date: state.parsedDate),
                  const SizedBox(height: 4),
                  _MemoRow(memo: state.memo),
                  const SizedBox(height: 8),
                  // 숫자패드
                  Expanded(
                    child: NumPad(
                      onPressed: (digit) {
                        context.read<EntryBloc>().add(EntryNumPadPressed(digit));
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static Future<void> _pickDate(BuildContext context, DateTime? current) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
    );
    if (picked != null && context.mounted) {
      context.read<EntryBloc>().add(EntryDateChanged(picked));
    }
  }

  Future<void> _pickDebit(BuildContext context, EntryState state) async {
    final id = await AccountPicker.show(
      context,
      title: '차변 계정 선택 (돈이 들어오는 곳)',
      selectedId: state.debitAccountId,
    );
    if (id != null && context.mounted) {
      context.read<EntryBloc>().add(EntryDebitAccountSelected(id));
    }
  }

  Future<void> _pickCredit(BuildContext context, EntryState state) async {
    final id = await AccountPicker.show(
      context,
      title: '대변 계정 선택 (돈이 나가는 곳)',
      selectedId: state.creditAccountId,
    );
    if (id != null && context.mounted) {
      context.read<EntryBloc>().add(EntryCreditAccountSelected(id));
    }
  }
}

class _DateRow extends StatelessWidget {
  const _DateRow({required this.date});
  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    final label = date == null
        ? '오늘'
        : '${date!.year}.${date!.month.toString().padLeft(2, '0')}.${date!.day.toString().padLeft(2, '0')}';
    return Row(
      children: [
        const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        const SizedBox(
          width: 44,
          child: Text('날짜', style: TextStyle(fontSize: 12, color: Colors.grey)),
        ),
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () => EntryV2._pickDate(context, date),
          child: Text(label, style: const TextStyle(fontSize: 13)),
        ),
      ],
    );
  }
}

class _MemoRow extends StatelessWidget {
  const _MemoRow({required this.memo});
  final String? memo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.notes_outlined, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        const SizedBox(
          width: 44,
          child: Text('메모', style: TextStyle(fontSize: 12, color: Colors.grey)),
        ),
        Expanded(
          child: TextField(
            controller: TextEditingController(text: memo),
            style: const TextStyle(fontSize: 13),
            decoration: const InputDecoration(
              hintText: '선택 사항',
              hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (v) =>
                context.read<EntryBloc>().add(EntryMemoChanged(v)),
          ),
        ),
      ],
    );
  }
}
