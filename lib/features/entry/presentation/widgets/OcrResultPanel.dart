import 'package:flutter/material.dart';

import '../../../../features/ocr/presentation/OcrBloc.dart';

/// V3 OCR 자동분개 결과 패널
class OcrResultPanel extends StatelessWidget {
  const OcrResultPanel({
    super.key,
    required this.parsed,
    required this.onConfirm,
    required this.onRetry,
  });

  final ParsedOcrData parsed;
  final VoidCallback onConfirm;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.document_scanner, size: 20),
              const SizedBox(width: 8),
              const Text(
                'OCR 인식 결과',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('재촬영'),
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ResultRow(label: '날짜', value: parsed.date != null
              ? '${parsed.date!.year}-${parsed.date!.month.toString().padLeft(2,'0')}-${parsed.date!.day.toString().padLeft(2,'0')}'
              : '인식 실패'),
          _ResultRow(
            label: '금액',
            value: parsed.amount != null
                ? '₩${_fmtAmount(parsed.amount!)}'
                : '인식 실패',
            highlight: parsed.amount != null,
          ),
          _ResultRow(label: '가맹점', value: parsed.merchantName ?? '인식 실패'),
          _ResultRow(label: '원문', value: parsed.rawText, maxLines: 3),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onConfirm,
              child: const Text('이 내용으로 입력하기'),
            ),
          ),
        ],
      ),
    );
  }

  String _fmtAmount(int v) {
    final s = v.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.label,
    required this.value,
    this.highlight = false,
    this.maxLines = 1,
  });

  final String label;
  final String value;
  final bool highlight;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 52,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                fontWeight:
                    highlight ? FontWeight.bold : FontWeight.normal,
                color: highlight
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
