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
              if (state.debitAccountId != null || state.creditAccountId != null || state.accountHint != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: FromToFlow(
                          fromLabel: state.creditAccountId != null
                              ? creditName
                              : '출처 선택',
                          toLabel: state.debitAccountId != null
                              ? debitName
                              : '도착 선택',
                        ),
                      ),
                      if (state.accountHint != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '💡 ${state.accountHint} 추천',
                            style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ],
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
                child: state.status == EntryStatus.parsing
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)),
                            SizedBox(width: 8),
                            Text('AI 분석 중...', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      )
                    : TextButton.icon(
                        onPressed: state.naturalText.isEmpty
                            ? null
                            : () => context
                                .read<EntryBloc>()
                                .add(const EntryParseNaturalText()),
                        icon: const Icon(Icons.auto_fix_high, size: 16),
                        label: const Text('자동 분석'),
                      ),
              ),
              AnimatedOpacity(
                opacity: state.parsedAmount != null ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    _ParsedResultRow(label: '인식 금액', value: '₩${state.amountDisplay}'),
                    if (state.parsedDescription != null)
                      _ParsedResultRow(
                        label: '설명',
                        value: state.parsedDescription!,
                      ),
                    if (state.parsedDate != null)
                      _ParsedResultRow(
                        label: '날짜',
                        value: '${state.parsedDate!.month}/${state.parsedDate!.day}',
                      ),
                    const SizedBox(height: 4),
                    const Text(
                      '※ 계정과목은 V2 탭에서 선택 가능합니다',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
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
