import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'EntryBloc.dart';
import 'widgets/AmountHero.dart';
import 'widgets/FromToFlow.dart';
import 'widgets/NumPad.dart';
import 'widgets/AccountPicker.dart';

/// V2 — 숫자패드 + 계정 2개 선택
class EntryV2 extends StatelessWidget {
  const EntryV2({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EntryBloc, EntryState>(
      builder: (context, state) {
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
                    ? '계정 #${state.creditAccountId}'
                    : '대변 계정 선택',
                toLabel: state.debitAccountId != null
                    ? '계정 #${state.debitAccountId}'
                    : '차변 계정 선택',
                onFromTap: () => _pickCredit(context, state),
                onToTap: () => _pickDebit(context, state),
              ),
              const SizedBox(height: 12),
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
