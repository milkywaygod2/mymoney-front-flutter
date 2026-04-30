import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../account/presentation/AccountBloc.dart';
import '../../account/presentation/AccountState.dart';
import 'EntryBloc.dart';
import 'widgets/AmountHero.dart';
import 'widgets/FromToFlow.dart';

/// V1 — 자연어 입력 + AI 자동분개 결과
class EntryV1 extends StatelessWidget {
  const EntryV1({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, accountState) {
        return BlocBuilder<EntryBloc, EntryState>(
          builder: (context, state) {
            final creditName = accountState.listAll
                .where((a) => a.id.value == state.creditAccountId?.value)
                .firstOrNull?.name ?? '계정 선택';
            final debitName = accountState.listAll
                .where((a) => a.id.value == state.debitAccountId?.value)
                .firstOrNull?.name ?? '계정 선택';
            return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AmountHero(
                display: state.amountDisplay,
                description: state.parsedDescription,
              ),
              const SizedBox(height: 16),
              if (state.debitAccountId != null || state.creditAccountId != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: FromToFlow(
                    fromLabel: state.creditAccountId != null
                        ? creditName
                        : '출처 선택',
                    toLabel: state.debitAccountId != null
                        ? debitName
                        : '도착 선택',
                  ),
                ),
              // 자연어 입력 필드
              TextField(
                autofocus: true,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: '예) 편의점에서 커피 3500원 샀어\n점심 식사비 12000원',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                onChanged: (text) {
                  context.read<EntryBloc>().add(EntryNaturalTextChanged(text));
                },
                onSubmitted: (_) {
                  context.read<EntryBloc>().add(const EntryParseNaturalText());
                },
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: state.naturalText.isEmpty
                      ? null
                      : () => context
                          .read<EntryBloc>()
                          .add(const EntryParseNaturalText()),
                  icon: const Icon(Icons.auto_fix_high, size: 16),
                  label: const Text('자동 분석'),
                ),
              ),
              if (state.parsedAmount != null) ...[
                const Divider(),
                _ParsedResultRow(label: '인식 금액', value: '₩${state.amountDisplay}'),
                if (state.parsedDescription != null)
                  _ParsedResultRow(
                    label: '설명',
                    value: state.parsedDescription!,
                  ),
                const SizedBox(height: 4),
                const Text(
                  '※ 계정과목은 V2 탭에서 선택 가능합니다',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ],
          ),
        );
          },
        );
      },
    );
  }
}

class _ParsedResultRow extends StatelessWidget {
  const _ParsedResultRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          Text(value, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
