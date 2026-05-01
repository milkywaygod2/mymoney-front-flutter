import 'package:flutter/material.dart';
import 'scene_common.dart';

/// Scene4 — 대출 받음: (차)보통예금 / (대)장기차입금
class Scene4 extends StatelessWidget {
  const Scene4({super.key, required this.progress});

  /// 전체 진행률 0.0~1.0
  final double progress;

  // 구간 헬퍼
  double _interval(double t, double start, double end) {
    if (t <= start) return 0.0;
    if (t >= end) return 1.0;
    return (t - start) / (end - start);
  }

  @override
  Widget build(BuildContext context) {
    // 0.00~0.20 enter
    final enterT = _interval(progress, 0.0, 0.20);
    // 0.20~0.40 door open: MetaBank scale 0.8→1.1→1.0
    final doorT = _interval(progress, 0.20, 0.40);
    final bankScale = progress < 0.20
        ? 0.8
        : progress < 0.30
            ? 0.8 + doorT * 2 * 0.3  // 0.8→1.1
            : 1.1 - (doorT * 2 - 1).clamp(0.0, 1.0) * 0.1; // 1.1→1.0
    // 0.25~0.95 bill shower — 4장
    const billCount = 4;
    const billStagger = [0.0, 0.08, 0.16, 0.24];
    const crOffset = Offset(20, 60);
    const drOffset = Offset(220, 60);

    // 0.70~1.00 DR scale bounce 1→1.2→1.1
    final arriveT = _interval(progress, 0.70, 1.0);
    final drScale = 1.0 + (arriveT < 0.5 ? arriveT * 2 * 0.2 : (1 - (arriveT - 0.5) * 2) * 0.2 + 0.1);

    return SceneFrame(
      animArea: Stack(
        children: [
          // CR: MetaBank (은행)
          Positioned(
            left: 0,
            top: 20,
            child: Opacity(
              opacity: enterT.clamp(0.0, 1.0),
              child: Anchor(emoji: metaBank, label: '은행', scale: bankScale),
            ),
          ),
          // DR: MetaDollar (지갑)
          Positioned(
            right: 0,
            top: 20,
            child: Opacity(
              opacity: enterT.clamp(0.0, 1.0),
              child: Anchor(emoji: metaDollar, label: '보통예금', scale: drScale),
            ),
          ),
          // Bill shower — 4장
          for (var i = 0; i < billCount; i++) ...[
            Builder(builder: (ctx) {
              final billStart = 0.25 + billStagger[i];
              final billT = _interval(progress, billStart, 0.95);
              return FlyingPiece(
                emoji: metaDollar,
                progress: billT,
                startOffset: crOffset,
                endOffset: drOffset,
                archHeight: -50,
                archOffsetX: (i - 1.5) * 8,
                visible: progress >= billStart,
              );
            }),
          ],
        ],
      ),
      sideLabel: const SideLabel(
        drTitle: '차변 · 자산↑',
        drSub: '보통예금',
        crTitle: '대변 · 부채↑',
        crSub: '장기차입금',
      ),
    );
  }
}
