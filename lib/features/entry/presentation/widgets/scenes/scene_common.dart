import 'package:flutter/material.dart';

import '../../../../../../app/theme/AppColors.dart';

// ─── 공통 이모지 상수 ─────────────────────────────────────────────────────────
const String metaBank = '🏦';
const String metaDollar = '💵';
const String metaPayroll = '🧾';
const String assetBow = '🏹';

// ─── arch() ───────────────────────────────────────────────────────────────────
/// t(0~1)에서 CR→DR 포물선 궤적 Offset 반환
/// [start], [end]: 글로벌 좌표 기준 시작/끝
/// [archHeight]: 호의 최대 높이 (음수=위쪽)
Offset arch(Offset start, Offset end, double t, {double archHeight = -60}) {
  final linear = Offset.lerp(start, end, t)!;
  final height = archHeight * 4 * t * (1 - t);
  return linear + Offset(0, height);
}

// ─── Anchor ───────────────────────────────────────────────────────────────────
/// DR/CR 고정 위젯 (이모지 + 라벨)
class Anchor extends StatelessWidget {
  const Anchor({
    super.key,
    required this.emoji,
    required this.label,
    this.scale = 1.0,
    this.translateX = 0.0,
  });

  final String emoji;
  final String label;
  final double scale;
  final double translateX;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(translateX, 0),
      child: Transform.scale(
        scale: scale,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── FlyingPiece ──────────────────────────────────────────────────────────────
/// 포물선 궤적으로 날아가는 이모지 조각
class FlyingPiece extends StatelessWidget {
  const FlyingPiece({
    super.key,
    required this.emoji,
    required this.progress,
    required this.startOffset,
    required this.endOffset,
    this.archHeight = -60,
    this.archOffsetX = 0,
    this.visible = true,
  });

  final String emoji;
  final double progress; // 0~1
  final Offset startOffset;
  final Offset endOffset;
  final double archHeight;
  final double archOffsetX;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();
    final pos = arch(
      startOffset + Offset(archOffsetX, 0),
      endOffset + Offset(archOffsetX, 0),
      progress,
      archHeight: archHeight,
    );
    return Positioned(
      left: pos.dx,
      top: pos.dy,
      child: Text(emoji, style: const TextStyle(fontSize: 24)),
    );
  }
}

// ─── SideLabel ────────────────────────────────────────────────────────────────
/// 차변/대변 설명 라벨 (하단)
class SideLabel extends StatelessWidget {
  const SideLabel({
    super.key,
    required this.drTitle,
    required this.drSub,
    required this.crTitle,
    required this.crSub,
  });

  final String drTitle;
  final String drSub;
  final String crTitle;
  final String crSub;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _LabelBox(title: drTitle, sub: drSub, color: AppColors.natureAsset)),
        const SizedBox(width: 8),
        Expanded(child: _LabelBox(title: crTitle, sub: crSub, color: AppColors.natureLiability)),
      ],
    );
  }
}

class _LabelBox extends StatelessWidget {
  const _LabelBox({required this.title, required this.sub, required this.color});
  final String title;
  final String sub;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(height: 2),
          Text(sub, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ─── 공유 씬 레이아웃 래퍼 ──────────────────────────────────────────────────
/// 씬 공통 컨테이너 — 애니메이션 영역 + 하단 SideLabel
class SceneFrame extends StatelessWidget {
  const SceneFrame({
    super.key,
    required this.animArea,
    required this.sideLabel,
  });

  final Widget animArea;
  final SideLabel sideLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 160, child: animArea),
        const SizedBox(height: 12),
        sideLabel,
      ],
    );
  }
}
