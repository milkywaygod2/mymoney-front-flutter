import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/ocr/presentation/OcrBloc.dart';
import 'EntryBloc.dart';
import 'widgets/OcrCaptureView.dart';
import 'widgets/OcrResultPanel.dart';

/// V3 — OCR 영수증 (카메라 + 결과)
class EntryV3 extends StatelessWidget {
  const EntryV3({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OcrBloc, OcrState>(
      builder: (ocrContext, ocrState) {
        // OCR 완료 → 결과 패널
        if (ocrState.phase == OcrPhase.reviewing &&
            ocrState.parsed != null) {
          return OcrResultPanel(
            parsed: ocrState.parsed!,
            onConfirm: () {
              // EntryBloc에 OCR 결과 전달
              context.read<EntryBloc>().add(
                    EntryOcrResultReceived(
                      parsed: ocrState.parsed!,
                      suggestedDebitId: ocrState.classified?.accountId,
                    ),
                  );
              // V1으로 이동하여 결과 확인
              context.read<EntryBloc>().add(
                    const EntryModeChanged(EntryMode.v1Natural),
                  );
            },
            onRetry: () {
              context.read<OcrBloc>().add(const OcrEvent.retryCapture());
            },
          );
        }

        // 인식 중 / 분류 중
        if (ocrState.phase == OcrPhase.recognizing ||
            ocrState.phase == OcrPhase.classifying ||
            ocrState.phase == OcrPhase.parsing) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 12),
                Text(
                  _phaseLabel(ocrState.phase),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // 기본: 카메라 캡처 뷰
        return OcrCaptureView(
          onCapture: () {
            // TODO: image_picker 연동 후 CaptureImage 이벤트 발행
            // 현재는 stub: 테스트용 더미 텍스트로 ProcessOcr 직접 호출
            context.read<OcrBloc>().add(
                  const OcrEvent.processOcr(
                    rawText: '스타벅스 아메리카노 4500원 2024-01-15',
                  ),
                );
          },
        );
      },
    );
  }

  String _phaseLabel(OcrPhase phase) {
    return switch (phase) {
      OcrPhase.recognizing => '텍스트 인식 중...',
      OcrPhase.parsing => '내용 분석 중...',
      OcrPhase.classifying => '계정 분류 중...',
      _ => '처리 중...',
    };
  }
}
