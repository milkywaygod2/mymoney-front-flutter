import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/Enums.dart';
import '../usecase/AutoClassifyDeductibility.dart';
import 'TaxBloc.dart';
import 'TaxEvent.dart';
import 'TaxState.dart';

/// 세무조정 화면 — 3단계 워크플로우:
///   1단계: 자동 판정 목록
///   2단계: 미판정 항목 수동 수정
///   3단계: 전체 확정
class TaxAdjustmentPage extends StatelessWidget {
  const TaxAdjustmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('세무조정')),
      body: BlocConsumer<TaxBloc, TaxState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
          if (state.isSettlementConfirmed) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('세무조정 확정 완료')),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.listAutoResults.isEmpty) {
            return _buildEmptyView(context);
          }
          return _buildContentView(context, state);
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 빌더
  // ---------------------------------------------------------------------------

  Widget _buildEmptyView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.assignment_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('자동 판정 결과가 없습니다'),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.play_arrow),
            label: const Text('자동 판정 실행'),
            onPressed: () => context.read<TaxBloc>().add(
                  RunAutoClassification(
                    listTransactionIds: const [],
                    asOfDate: DateTime.now(),
                  ),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentView(BuildContext context, TaxState state) {
    return Column(
      children: [
        // 상단 요약 배지
        _buildSummaryBanner(context, state),
        // 결과 목록
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.listAutoResults.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = state.listAutoResults[index];
              return _buildResultTile(context, item);
            },
          ),
        ),
        // 확정 버튼
        _buildConfirmButton(context, state),
      ],
    );
  }

  Widget _buildSummaryBanner(BuildContext context, TaxState state) {
    final countPending = state.listPendingItems.length;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: countPending > 0
          ? colorScheme.errorContainer
          : colorScheme.primaryContainer,
      child: Row(
        children: [
          Icon(
            countPending > 0 ? Icons.warning_amber : Icons.check_circle,
            color: countPending > 0
                ? colorScheme.onErrorContainer
                : colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 8),
          Text(
            countPending > 0
                ? '미판정 $countPending건 남음 — 수동 처리 필요'
                : '모든 항목 판정 완료 (총 ${state.listAutoResults.length}건)',
            style: TextStyle(
              color: countPending > 0
                  ? colorScheme.onErrorContainer
                  : colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultTile(
    BuildContext context,
    DeductibilityClassificationResult item,
  ) {
    final isPending =
        item.suggestedDeductibility == Deductibility.undetermined;

    return ListTile(
      leading: Icon(
        isPending ? Icons.help_outline : Icons.check_circle_outline,
        color: isPending ? Colors.orange : Colors.green,
      ),
      title: Text(item.accountName),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_deductibilityLabel(item.suggestedDeductibility)),
          if (item.reason != null)
            Text(
              item.reason!,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
        ],
      ),
      trailing: isPending
          ? TextButton(
              onPressed: () =>
                  _showOverrideDialog(context, item),
              child: const Text('수정'),
            )
          : null,
    );
  }

  Widget _buildConfirmButton(BuildContext context, TaxState state) {
    final countPending = state.listPendingItems.length;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton.icon(
          onPressed: countPending == 0 && !state.isSettlementConfirmed
              ? () => context.read<TaxBloc>().add(
                    ConfirmSettlement(asOfDate: DateTime.now()),
                  )
              : null,
          icon: const Icon(Icons.done_all),
          label: Text(
            state.isSettlementConfirmed
                ? '확정 완료'
                : countPending > 0
                    ? '미판정 $countPending건 처리 필요'
                    : '세무조정 전체 확정',
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 수동 재정의 다이얼로그
  // ---------------------------------------------------------------------------

  void _showOverrideDialog(
    BuildContext context,
    DeductibilityClassificationResult item,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => _OverrideDialog(
        item: item,
        onConfirm: (deductibility, memo) {
          context.read<TaxBloc>().add(
                OverrideDeductibility(
                  transactionId: item.transactionId,
                  lineId: item.lineId,
                  deductibility: deductibility,
                  memo: memo,
                ),
              );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 헬퍼
  // ---------------------------------------------------------------------------

  String _deductibilityLabel(Deductibility d) {
    return switch (d) {
      Deductibility.undetermined => '미판정',
      Deductibility.deductible => '손금산입',
      Deductibility.deductibleLimited => '손금산입(한도)',
      Deductibility.nonDeductible => '손금불산입',
      Deductibility.incomeInclusion => '익금산입',
      Deductibility.incomeExclusion => '익금불산입',
      Deductibility.bookRespected => '장부존중',
    };
  }
}

// ---------------------------------------------------------------------------
// 수동 재정의 다이얼로그 위젯
// ---------------------------------------------------------------------------

class _OverrideDialog extends StatefulWidget {
  const _OverrideDialog({required this.item, required this.onConfirm});

  final DeductibilityClassificationResult item;
  final void Function(Deductibility deductibility, String? memo) onConfirm;

  @override
  State<_OverrideDialog> createState() => _OverrideDialogState();
}

class _OverrideDialogState extends State<_OverrideDialog> {
  Deductibility _selectedDeductibility = Deductibility.deductible;
  final _controllerMemo = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDeductibility = widget.item.suggestedDeductibility;
  }

  @override
  void dispose() {
    _controllerMemo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.item.accountName} 판정 수정'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<Deductibility>(
            initialValue: _selectedDeductibility,
            decoration: const InputDecoration(labelText: '손금/익금 판정'),
            items: Deductibility.values
                .map(
                  (d) => DropdownMenuItem(
                    value: d,
                    child: Text(_labelOf(d)),
                  ),
                )
                .toList(),
            onChanged: (d) {
              if (d != null) setState(() => _selectedDeductibility = d);
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controllerMemo,
            decoration: const InputDecoration(
              labelText: '비고 (선택)',
              hintText: '판정 근거를 입력하세요',
            ),
            maxLines: 2,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: () {
            widget.onConfirm(
              _selectedDeductibility,
              _controllerMemo.text.isEmpty ? null : _controllerMemo.text,
            );
            Navigator.of(context).pop();
          },
          child: const Text('확정'),
        ),
      ],
    );
  }

  String _labelOf(Deductibility d) => switch (d) {
    Deductibility.undetermined => '미판정',
    Deductibility.deductible => '손금산입',
    Deductibility.deductibleLimited => '손금산입(한도)',
    Deductibility.nonDeductible => '손금불산입',
    Deductibility.incomeInclusion => '익금산입',
    Deductibility.incomeExclusion => '익금불산입',
    Deductibility.bookRespected => '장부존중',
  };
}
