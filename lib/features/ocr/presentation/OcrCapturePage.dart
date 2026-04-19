import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'OcrBloc.dart';

/// 이미지 소스 — image_picker 패키지 설치 전 임시 정의
/// TODO: image_picker 패키지 설치 후 ImageSource enum으로 교체
enum ImageSource { camera, gallery }

/// OCR 캡처 페이지 — 이미지 캡처 + 파싱 결과 프리뷰 + Draft 저장
///
/// 흐름: 카메라/갤러리 → OCR → 파싱 프리뷰 → 수정 → Draft 저장
///
/// TODO: image_picker 패키지 추가 필요
///   pubspec.yaml: image_picker: ^1.1.2
class OcrCapturePage extends StatelessWidget {
  const OcrCapturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('영수증 스캔'),
        centerTitle: false,
      ),
      body: BlocConsumer<OcrBloc, OcrState>(
        listener: (context, state) {
          if (state.phase == OcrPhase.done) {
            // Draft 저장 완료 → 이전 화면으로 복귀
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Draft 거래가 생성되었습니다')),
            );
            Navigator.of(context).pop(state.savedDraft);
          }
          if (state.phase == OcrPhase.error && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return switch (state.phase) {
            OcrPhase.idle => _buildIdleView(context),
            OcrPhase.capturing ||
            OcrPhase.recognizing ||
            OcrPhase.parsing ||
            OcrPhase.classifying ||
            OcrPhase.saving =>
              _buildLoadingView(context, state.phase),
            OcrPhase.reviewing => _buildReviewView(context, state),
            OcrPhase.done => _buildDoneView(context, state),
            OcrPhase.error => _buildErrorView(context, state),
          };
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 대기 화면 — 캡처 버튼
  // ---------------------------------------------------------------------------

  Widget _buildIdleView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.document_scanner_outlined, size: 80),
          const SizedBox(height: 24),
          const Text(
            '영수증을 촬영하거나 갤러리에서 선택하세요',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilledButton.icon(
                onPressed: () => _pickImage(context, ImageSource.camera),
                icon: const Icon(Icons.camera_alt),
                label: const Text('카메라'),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () => _pickImage(context, ImageSource.gallery),
                icon: const Icon(Icons.photo_library),
                label: const Text('갤러리'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 처리 중 화면 — 로딩 인디케이터 + 단계 메시지
  // ---------------------------------------------------------------------------

  Widget _buildLoadingView(BuildContext context, OcrPhase phase) {
    final message = switch (phase) {
      OcrPhase.capturing => '이미지 처리 중...',
      OcrPhase.recognizing => 'OCR 인식 중...',
      OcrPhase.parsing => '데이터 파싱 중...',
      OcrPhase.classifying => '계정과목 분류 중...',
      OcrPhase.saving => 'Draft 저장 중...',
      _ => '처리 중...',
    };

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(message),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 리뷰 화면 — 파싱 결과 확인 + 수정
  // ---------------------------------------------------------------------------

  Widget _buildReviewView(BuildContext context, OcrState state) {
    final parsed = state.parsed;
    if (parsed == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 인식 신뢰도 배지
          _ConfidenceBadge(confidence: state.confidence),
          const SizedBox(height: 16),

          // OCR 원문
          _SectionCard(
            title: 'OCR 원문',
            child: Text(
              parsed.rawText,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                  ),
            ),
          ),
          const SizedBox(height: 12),

          // 파싱 결과 — 수정 가능
          _SectionCard(
            title: '파싱 결과',
            child: Column(
              children: [
                _EditableField(
                  label: '날짜',
                  value: parsed.date?.toString().substring(0, 10) ?? '인식 실패',
                  onEdit: () {/* TODO: DatePicker */},
                ),
                _EditableField(
                  label: '금액',
                  value: parsed.amount != null
                      ? '${_formatAmount(parsed.amount!)}원'
                      : '인식 실패',
                  onEdit: () {/* TODO: 금액 입력 다이얼로그 */},
                ),
                _EditableField(
                  label: '가맹점',
                  value: parsed.merchantName ?? '인식 실패',
                  onEdit: () {/* TODO: 가맹점 검색 */},
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 분류 결과
          _SectionCard(
            title: '자동 분류',
            child: state.classified != null
                ? Text('계정과목 ID: ${state.classified!.accountId.value}'
                    ' (신뢰도 ${(state.classified!.confidence * 100).toStringAsFixed(0)}%)')
                : const Text(
                    '자동 분류 실패 — 계정과목을 직접 선택해 주세요',
                    style: TextStyle(color: Colors.orange),
                  ),
          ),
          const SizedBox(height: 12),

          // "이 패턴 기억하기" 체크박스
          CheckboxListTile(
            title: const Text('이 패턴 기억하기'),
            subtitle: Text(
              parsed.merchantName != null
                  ? '"${parsed.merchantName}" → 같은 계정과목으로 자동 분류'
                  : '가맹점명 인식 후 활성화됩니다',
            ),
            value: state.rememberPattern,
            onChanged: parsed.merchantName != null
                ? (v) => context.read<OcrBloc>().add(
                      OcrEvent.toggleRememberPattern(remember: v ?? false),
                    )
                : null,
          ),
          const SizedBox(height: 24),

          // 저장 버튼
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: state.classified != null || state.overriddenAccountId != null
                  ? () => context.read<OcrBloc>().add(const OcrEvent.saveAsDraft())
                  : null,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Draft로 저장'),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 완료 화면
  // ---------------------------------------------------------------------------

  Widget _buildDoneView(BuildContext context, OcrState state) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
          const SizedBox(height: 16),
          const Text('Draft 거래가 생성되었습니다'),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () => context.read<OcrBloc>().add(const OcrEvent.retryCapture()),
            child: const Text('다른 영수증 스캔'),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 오류 화면
  // ---------------------------------------------------------------------------

  Widget _buildErrorView(BuildContext context, OcrState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline,
                size: 64, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text(
              state.errorMessage ?? '알 수 없는 오류가 발생했습니다',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () =>
                  context.read<OcrBloc>().add(const OcrEvent.retryCapture()),
              icon: const Icon(Icons.refresh),
              label: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 헬퍼
  // ---------------------------------------------------------------------------

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    // TODO: image_picker 패키지 설치 후 실제 구현
    //
    // 구현 예시:
    //   final picker = ImagePicker();
    //   final pickedFile = await picker.pickImage(source: source);
    //   if (pickedFile == null) return;
    //   if (!context.mounted) return;
    //   context.read<OcrBloc>().add(
    //     OcrEvent.captureImage(image: File(pickedFile.path)),
    //   );
    //
    // 현재는 stub — image_picker 미설치
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('TODO: image_picker 패키지 설치 필요')),
    );
  }

  String _formatAmount(int amount) {
    // 3자리마다 쉼표 삽입
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+$)'),
          (m) => '${m.group(1)},',
        );
  }
}

// =============================================================================
// 재사용 위젯
// =============================================================================

/// 신뢰도 배지 — 색상으로 신뢰도 수준 표시
class _ConfidenceBadge extends StatelessWidget {
  const _ConfidenceBadge({required this.confidence});
  final double confidence;

  @override
  Widget build(BuildContext context) {
    final color = confidence >= 0.8
        ? Colors.green
        : confidence >= 0.5
            ? Colors.orange
            : Colors.red;
    final label = confidence >= 0.8
        ? '높음'
        : confidence >= 0.5
            ? '보통'
            : '낮음';

    return Row(
      children: [
        Icon(Icons.verified_outlined, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          '인식 신뢰도: $label (${(confidence * 100).toStringAsFixed(0)}%)',
          style: TextStyle(color: color, fontSize: 13),
        ),
      ],
    );
  }
}

/// 파싱 결과 섹션 카드
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.primary)),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

/// 수정 가능한 필드 행
class _EditableField extends StatelessWidget {
  const _EditableField({
    required this.label,
    required this.value,
    required this.onEdit,
  });
  final String label;
  final String value;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(label,
                style: Theme.of(context).textTheme.labelSmall),
          ),
          Expanded(
            child: Text(value),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 16),
            onPressed: onEdit,
            tooltip: '$label 수정',
          ),
        ],
      ),
    );
  }
}
