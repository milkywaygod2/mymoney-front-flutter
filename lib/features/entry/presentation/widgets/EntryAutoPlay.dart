import 'package:flutter/material.dart';

import '../../../../../app/theme/AppColors.dart';
import 'scenes/scene_registry.dart';

/// 거래 저장 후 2초 애니메이션 위젯
/// sceneIndex 0~8: 씬별 애니메이션 / sceneIndex -1: 범용 3페이즈 fallback
class EntryAutoPlay extends StatefulWidget {
  const EntryAutoPlay({
    super.key,
    required this.description,
    required this.onFinished,
    this.sceneIndex = -1,
  });

  final String description;
  final VoidCallback onFinished;
  /// 0~8: 씬 애니메이션, -1: 범용 fallback
  final int sceneIndex;

  @override
  State<EntryAutoPlay> createState() => _EntryAutoPlayState();
}

class _EntryAutoPlayState extends State<EntryAutoPlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const double kEnterEnd  = 0.22;
  static const double kFlyEnd    = 0.72;
  static const double kArriveEnd = 0.94;

  late final Animation<double> _enterAnim;
  late final Animation<double> _flyAnim;
  late final Animation<double> _arriveAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _enterAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, kEnterEnd, curve: Curves.easeOut),
      ),
    );
    _flyAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(kEnterEnd, kFlyEnd, curve: Curves.easeInOut),
      ),
    );
    _arriveAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(kFlyEnd, kArriveEnd, curve: Curves.elasticOut),
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onFinished();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final idx = widget.sceneIndex;
    if (idx >= 0 && idx < scenes.length) {
      return _SceneShell(
        description: widget.description,
        controller: _controller,
        sceneIndex: idx,
      );
    }
    return _FallbackAnimation(
      enterAnim: _enterAnim,
      flyAnim: _flyAnim,
      arriveAnim: _arriveAnim,
      description: widget.description,
    );
  }
}

/// 씬 렌더링 쉘 — 360×260 스테이지 + 헤더
class _SceneShell extends StatelessWidget {
  const _SceneShell({
    required this.description,
    required this.controller,
    required this.sceneIndex,
  });
  final String description;
  final AnimationController controller;
  final int sceneIndex;

  @override
  Widget build(BuildContext context) {
    final meta = scenes[sceneIndex];
    return Container(
      color: Colors.black.withValues(alpha: 0.85),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                Text(
                  meta.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  meta.sub,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 360,
            height: 260,
            child: meta.build(controller),
          ),
        ],
      ),
    );
  }
}

/// 범용 fallback — 기존 3페이즈 (체크아이콘 + 설명 + 저장됨 배지)
class _FallbackAnimation extends StatelessWidget {
  const _FallbackAnimation({
    required this.enterAnim,
    required this.flyAnim,
    required this.arriveAnim,
    required this.description,
  });
  final Animation<double> enterAnim;
  final Animation<double> flyAnim;
  final Animation<double> arriveAnim;
  final String description;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: enterAnim,
      builder: (context, _) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Opacity(
                  opacity: enterAnim.value,
                  child: const Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: AppColors.stateSuccess,
                  ),
                ),
                const SizedBox(height: 16),
                Transform.translate(
                  offset: Offset(0, (1 - flyAnim.value) * 20),
                  child: Opacity(
                    opacity: flyAnim.value,
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Transform.scale(
                  scale: 0.8 + arriveAnim.value * 0.2,
                  child: Opacity(
                    opacity: arriveAnim.value,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.stateSuccess.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '저장됨',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.stateSuccess,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
