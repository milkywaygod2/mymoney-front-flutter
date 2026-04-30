import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'EntryBloc.dart';
import 'EntryV1.dart';
import 'EntryV2.dart';
import 'EntryV3.dart';
import 'widgets/EntryAutoPlay.dart';

/// Entry 거래 입력 BottomSheet 컨테이너
/// V1(자연어) / V2(숫자패드) / V3(OCR) 세그먼트 토글
class EntryPage extends StatefulWidget {
  const EntryPage({super.key});

  /// BottomSheet로 표시 — 320ms emphasized 모션
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 320),
      ),
      builder: (_) => BlocProvider(
        create: (_) => EntryBloc(),
        child: const EntryPage(),
      ),
    );
  }

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EntryBloc, EntryState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == EntryStatus.error && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      builder: (context, state) {
        // 저장 완료 → 애니메이션
        if (state.status == EntryStatus.done) {
          return _AnimationSheet(
            description: state.savedTransactionDescription ?? '거래 입력',
            onFinished: () {
              context.read<EntryBloc>().add(const EntryAnimationFinished());
              Navigator.of(context).pop();
            },
          );
        }

        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, scrollController) => Column(
            children: [
              // 드래그 핸들
              const _DragHandle(),

              // 헤더 (모드 세그먼트 + 저장 버튼)
              _EntryHeader(),

              // 컨텐츠 영역
              Expanded(
                child: _ModeContent(scrollController: scrollController),
              ),

              // 저장 버튼
              _SaveButton(),

              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 4),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _EntryHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EntryBloc, EntryState>(
      buildWhen: (prev, curr) => prev.mode != curr.mode,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Text(
                '거래 입력',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              // V1/V2/V3 토글
              _ModeSegment(
                selected: state.mode,
                onChanged: (mode) {
                  context.read<EntryBloc>().add(EntryModeChanged(mode));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ModeSegment extends StatelessWidget {
  const _ModeSegment({
    required this.selected,
    required this.onChanged,
  });

  final EntryMode selected;
  final ValueChanged<EntryMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<EntryMode>(
      segments: const [
        ButtonSegment(
          value: EntryMode.v1Natural,
          label: Text('자연어', style: TextStyle(fontSize: 11)),
          icon: Icon(Icons.auto_fix_high, size: 14),
        ),
        ButtonSegment(
          value: EntryMode.v2NumPad,
          label: Text('숫자', style: TextStyle(fontSize: 11)),
          icon: Icon(Icons.dialpad, size: 14),
        ),
        ButtonSegment(
          value: EntryMode.v3Ocr,
          label: Text('OCR', style: TextStyle(fontSize: 11)),
          icon: Icon(Icons.document_scanner, size: 14),
        ),
      ],
      selected: {selected},
      onSelectionChanged: (s) => onChanged(s.first),
      style: ButtonStyle(
        visualDensity: VisualDensity.compact,
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 4),
        ),
      ),
    );
  }
}

class _ModeContent extends StatelessWidget {
  const _ModeContent({required this.scrollController});
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EntryBloc, EntryState>(
      buildWhen: (prev, curr) => prev.mode != curr.mode,
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: switch (state.mode) {
            EntryMode.v1Natural =>
              const SingleChildScrollView(child: EntryV1()),
            EntryMode.v2NumPad => const EntryV2(),
            EntryMode.v3Ocr => const EntryV3(),
          },
        );
      },
    );
  }
}

class _SaveButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EntryBloc, EntryState>(
      buildWhen: (prev, curr) =>
          prev.canSave != curr.canSave || prev.status != curr.status,
      builder: (context, state) {
        final isSaving = state.status == EntryStatus.saving;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: (state.canSave && !isSaving)
                  ? () => context.read<EntryBloc>().add(const EntrySave())
                  : null,
              child: isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('저장'),
            ),
          ),
        );
      },
    );
  }
}

class _AnimationSheet extends StatelessWidget {
  const _AnimationSheet({
    required this.description,
    required this.onFinished,
  });

  final String description;
  final VoidCallback onFinished;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: EntryAutoPlay(
        description: description,
        onFinished: onFinished,
      ),
    );
  }
}
