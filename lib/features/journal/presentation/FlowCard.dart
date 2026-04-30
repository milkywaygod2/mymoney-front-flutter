import 'package:flutter/material.dart';

import '../../../app/theme/AppColors.dart';
import '../../../core/constants/Enums.dart';
import '../../../core/domain/Transaction.dart';
import '../../../core/domain/JournalEntryLine.dart';

/// Balance Flow Card — 복식부기 노드-엣지 시각화
/// 차변(왼쪽) → 대변(오른쪽) 흐름을 시각적으로 표현
class FlowCard extends StatelessWidget {
  const FlowCard({super.key, required this.transaction});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final listDebitLines = transaction.listLines
        .where((l) => l.entryType == EntryType.debit)
        .toList();
    final listCreditLines = transaction.listLines
        .where((l) => l.entryType == EntryType.credit)
        .toList();

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더: 날짜 + 설명 + status 뱃지
            _buildHeader(context),
            const SizedBox(height: 12),
            // 차변/대변 노드-엣지 영역
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 차변 노드들 (왼쪽)
                Expanded(child: _buildNodeColumn(context, listDebitLines, '차변', AppColors.revenueDeep)),
                // 중앙 엣지 (화살표)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Icon(Icons.arrow_forward, color: colorScheme.outline),
                ),
                // 대변 노드들 (오른쪽)
                Expanded(child: _buildNodeColumn(context, listCreditLines, '대변', AppColors.stateError)),
              ],
            ),
            const SizedBox(height: 8),
            // 균형 체크
            _buildBalanceCheck(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final (statusColor, statusLabel) = switch (transaction.status) {
      TransactionStatus.draft => (AppColors.stateDraft, 'Draft'),
      TransactionStatus.posted => (AppColors.stateSuccess, 'Posted'),
      TransactionStatus.voided => (AppColors.stateError, 'Voided'),
    };

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction.description,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                '${transaction.date.year}-'
                '${transaction.date.month.toString().padLeft(2, '0')}-'
                '${transaction.date.day.toString().padLeft(2, '0')}'
                '${transaction.counterpartyName != null ? '  |  ${transaction.counterpartyName}' : ''}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(statusLabel, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
        if (transaction.source != TransactionSource.manual) ...[
          const SizedBox(width: 4),
          _buildSourceIcon(),
        ],
      ],
    );
  }

  Widget _buildSourceIcon() {
    final (icon, tooltip) = switch (transaction.source) {
      TransactionSource.ocr => (Icons.document_scanner, 'OCR'),
      TransactionSource.csvImport => (Icons.upload_file, 'CSV'),
      TransactionSource.systemSettlement => (Icons.auto_fix_high, '자동전표'),
      _ => (Icons.edit, '수동'),
    };
    return Tooltip(message: tooltip, child: Icon(icon, size: 16));
  }

  /// 차변/대변 노드 열
  Widget _buildNodeColumn(BuildContext context, List<JournalEntryLine> listLines, String label, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
            textAlign: TextAlign.center),
        const SizedBox(height: 4),
        ...listLines.map((line) => _FlowNode(line: line, color: color)),
      ],
    );
  }

  /// 차대변 균형 체크 표시
  Widget _buildBalanceCheck(BuildContext context) {
    final debitSum = transaction.listLines
        .where((l) => l.entryType == EntryType.debit)
        .fold<int>(0, (s, l) => s + l.baseAmount);
    final creditSum = transaction.listLines
        .where((l) => l.entryType == EntryType.credit)
        .fold<int>(0, (s, l) => s + l.baseAmount);
    final isBalanced = debitSum == creditSum;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(isBalanced ? Icons.check_circle : Icons.warning,
            color: isBalanced ? AppColors.stateSuccess : AppColors.stateDraft, size: 16),
        const SizedBox(width: 4),
        Text(
          isBalanced ? '균형' : '불균형 (차:${_fmt(debitSum)} / 대:${_fmt(creditSum)})',
          style: TextStyle(
            color: isBalanced ? AppColors.stateSuccess : AppColors.stateDraft,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  static String _fmt(int amount) {
    final str = amount.toString();
    final buf = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buf.write(',');
      buf.write(str[i]);
    }
    return buf.toString();
  }
}

/// 개별 전표 라인 노드
class _FlowNode extends StatelessWidget {
  const _FlowNode({required this.line, required this.color});

  final JournalEntryLine line;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: color.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(8),
        color: color.withValues(alpha: 0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 계정 ID (향후 계정명으로 교체)
          Text('계정 #${line.accountId}',
              style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.outline)),
          const SizedBox(height: 2),
          Text(FlowCard._fmt(line.baseAmount),
              style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
