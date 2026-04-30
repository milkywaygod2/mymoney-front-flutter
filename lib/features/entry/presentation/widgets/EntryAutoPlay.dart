import 'package:flutter/material.dart';

import '../../../../../app/theme/AppColors.dart';

/// 거래 저장 후 2초 애니메이션 위젯
/// 3페이즈: enter(0~22%), fly(22~72%), arrive(72~94%)
class EntryAutoPlay extends StatefulWidget {
  const EntryAutoPlay({
    super.key,
    required this.description,
    required this.onFinished,
  });

  final String description;
  final VoidCallback onFinished;

  @override
  State<EntryAutoPlay> createState() => _EntryAutoPlayState();
}

class _EntryAutoPlayState extends State<EntryAutoPlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // 페이즈 구간 (비율)
  static const double kEnterEnd = 0.22;
  static const double kFlyEnd = 0.72;
  static const double kArriveEnd = 0.94;

  late final Animation<double> _enterAnim;   // 0.0 → 1.0 (enter phase)
  late final Animation<double> _flyAnim;     // 0.0 → 1.0 (fly phase)
  late final Animation<double> _arriveAnim;  // 0.0 → 1.0 (arrive phase)

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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Enter 페이즈: 아이콘 페이드인
                Opacity(
                  opacity: _enterAnim.value,
                  child: const Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: AppColors.stateSuccess,
                  ),
                ),
                const SizedBox(height: 16),

                // Fly 페이즈: 거래 설명 슬라이드업
                Transform.translate(
                  offset: Offset(0, (1 - _flyAnim.value) * 20),
                  child: Opacity(
                    opacity: _flyAnim.value,
                    child: Text(
                      widget.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Arrive 페이즈: "저장됨" 확인 텍스트 + 스케일
                Transform.scale(
                  scale: 0.8 + _arriveAnim.value * 0.2,
                  child: Opacity(
                    opacity: _arriveAnim.value,
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
