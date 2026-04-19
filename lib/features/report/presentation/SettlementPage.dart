import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ReportBloc.dart';

/// 결산 페이지 — 결산 5단계 프로세스 진입점
/// [CW_ARCHITECTURE.md 섹션 10.1] "더보기 > 결산" 화면
/// 상세 UI는 후속 Wave에서 구현
class SettlementPage extends StatelessWidget {
  const SettlementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('결산')),
      body: BlocBuilder<ReportBloc, ReportState>(
        builder: (context, state) {
          // 결산 진행 중
          if (state.isLoading && state.settlementStep != null) {
            return _SettlementProgressView(currentStep: state.settlementStep!);
          }

          // 결산 완료
          if (state.settlementResult != null) {
            return _SettlementResultView(result: state.settlementResult!);
          }

          // 결산 시작 화면
          return _SettlementStartView(
            activePeriodId: state.activePeriodId,
            errorMessage: state.errorMessage,
          );
        },
      ),
    );
  }
}

/// 결산 시작 화면
class _SettlementStartView extends StatelessWidget {
  const _SettlementStartView({
    this.activePeriodId,
    this.errorMessage,
  });

  final int? activePeriodId;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('결산 5단계', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          // 단계 안내 카드
          ..._buildStepCards(context),
          const Spacer(),
          if (errorMessage != null) ...[
            Text(
              errorMessage!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: 8),
          ],
          // 결산 실행 버튼 (활성 기간 없으면 비활성)
          FilledButton.icon(
            onPressed: activePeriodId == null
                ? null
                : () => _confirmAndRun(context),
            icon: const Icon(Icons.calculate),
            label: activePeriodId == null
                ? const Text('기간을 먼저 선택하세요')
                : const Text('결산 실행'),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStepCards(BuildContext context) {
    const listSteps = [
      (Icons.checklist, '1단계', 'Draft 잔존 검증 + 시산표 균형 확인'),
      (Icons.currency_exchange, '2단계', '외환 평가 자동전표 생성'),
      (Icons.receipt_long, '3단계', '세무조정 검토'),
      (Icons.trending_up, '4단계', '손익 마감 (이익잉여금 대체)'),
      (Icons.save_alt, '5단계', '결산 스냅샷 저장'),
    ];
    return listSteps
        .map(
          (step) => ListTile(
            leading: Icon(step.$1,
                color: Theme.of(context).colorScheme.primary),
            title: Text(step.$2,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(step.$3),
            dense: true,
          ),
        )
        .toList();
  }

  void _confirmAndRun(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('결산을 실행하시겠습니까?'),
        content: const Text(
          '결산은 되돌리기 어렵습니다.\n'
          'Draft 거래가 없는지 확인 후 진행하세요.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: retainedEarningsAccountId를 설정에서 조회 (MVP: 하드코딩 0 → 추후 교체)
              context.read<ReportBloc>().add(
                    RunSettlementEvent(
                      periodId: activePeriodId!,
                      snapshotDate: DateTime.now(),
                      retainedEarningsAccountId: 0, // TODO: 이익잉여금 계정 ID 설정 필요
                    ),
                  );
            },
            child: const Text('결산 실행'),
          ),
        ],
      ),
    );
  }
}

/// 결산 진행 중 뷰
class _SettlementProgressView extends StatelessWidget {
  const _SettlementProgressView({required this.currentStep});
  final SettlementStep currentStep;

  @override
  Widget build(BuildContext context) {
    final strStep = switch (currentStep) {
      SettlementStep.preparingClose => '1단계: 마감 준비 중...',
      SettlementStep.fxRevaluation => '2단계: 외환 평가 중...',
      SettlementStep.taxAdjustment => '3단계: 세무조정 중...',
      SettlementStep.closingIncome => '4단계: 손익 마감 중...',
      SettlementStep.savingSnapshot => '5단계: 스냅샷 저장 중...',
      SettlementStep.completed => '결산 완료',
    };
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(strStep, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}

/// 결산 결과 뷰
class _SettlementResultView extends StatelessWidget {
  const _SettlementResultView({required this.result});
  final SettlementResult result;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 결과 헤더
        Row(
          children: [
            Icon(
              result.isCompleted ? Icons.check_circle : Icons.error,
              color: result.isCompleted ? Colors.green : Colors.red,
              size: 32,
            ),
            const SizedBox(width: 12),
            Text(
              result.isCompleted ? '결산 완료' : '결산 중 오류 발생',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '당기순이익: ₩${result.netIncome}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: result.netIncome >= 0 ? Colors.teal : Colors.orange,
          ),
        ),
        const Divider(height: 24),
        // 단계별 결과
        ...result.listStepResults.map((stepResult) => ListTile(
              leading: Icon(
                stepResult.isSuccess ? Icons.check : Icons.close,
                color: stepResult.isSuccess ? Colors.green : Colors.red,
              ),
              title: Text(_stepLabel(stepResult.step)),
              subtitle: stepResult.message != null
                  ? Text(stepResult.message!)
                  : null,
              dense: true,
            )),
      ],
    );
  }

  String _stepLabel(SettlementStep step) => switch (step) {
        SettlementStep.preparingClose => '1단계: 마감 준비',
        SettlementStep.fxRevaluation => '2단계: 외환 평가',
        SettlementStep.taxAdjustment => '3단계: 세무조정',
        SettlementStep.closingIncome => '4단계: 손익 마감',
        SettlementStep.savingSnapshot => '5단계: 스냅샷 저장',
        SettlementStep.completed => '완료',
      };
}
