import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/AppColors.dart';
import '../../account/presentation/AccountBloc.dart';
import '../../account/presentation/AccountState.dart';
import 'EntryBloc.dart';
import 'widgets/AmountHero.dart';
import 'widgets/FromToFlow.dart';

/// V1 — 자연어 입력 + AI 자동분개 결과
class EntryV1 extends StatefulWidget {
  const EntryV1({super.key});

  @override
  State<EntryV1> createState() => _EntryV1State();
}

class _EntryV1State extends State<EntryV1> {
  final _merchantController = TextEditingController();
  final _memoController = TextEditingController();

  @override
  void dispose() {
    _merchantController.dispose();
    _memoController.dispose();
    super.dispose();
  }

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
              // 비슷한 거래 추천 칩
              if (state.accountHint != null)
                _SuggestedChips(
                  hint: state.accountHint!,
                  onSelected: (label) {
                    context.read<EntryBloc>().add(EntryNaturalTextChanged(label));
                  },
                ),
              // 상대처 / 메모 행
              const SizedBox(height: 8),
              _EntryInfoRow(
                icon: Icons.storefront_outlined,
                label: '상대처',
                controller: _merchantController,
                hint: '예) 스타벅스 코엑스',
              ),
              const SizedBox(height: 6),
              _EntryInfoRow(
                icon: Icons.notes_outlined,
                label: '메모',
                controller: _memoController,
                hint: '선택 사항',
              ),
              AnimatedOpacity(
                opacity: state.parsedAmount != null ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    if (state.confidence != null)
                      _ConfidenceBanner(confidence: state.confidence!),
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

class _SuggestedChips extends StatelessWidget {
  const _SuggestedChips({required this.hint, required this.onSelected});
  final String hint;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Wrap(
        spacing: 6,
        children: [
          ActionChip(
            label: Text(hint, style: const TextStyle(fontSize: 12)),
            onPressed: () => onSelected(hint),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

class _ConfidenceBanner extends StatelessWidget {
  const _ConfidenceBanner({required this.confidence});
  final double confidence;

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final String label;
    if (confidence >= 0.9) {
      bg = AppColors.stateSuccess;
      label = '✓ 자동 확정';
    } else if (confidence >= 0.7) {
      bg = AppColors.stateWarning;
      label = '⚠ 확인 필요';
    } else {
      bg = AppColors.stateError;
      label = '✗ 직접 수정';
    }
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: bg.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: bg),
      ),
    );
  }
}

class _EntryInfoRow extends StatelessWidget {
  const _EntryInfoRow({
    required this.icon,
    required this.label,
    required this.controller,
    required this.hint,
  });
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        SizedBox(
          width: 44,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }
}
