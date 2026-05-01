import 'package:flutter/material.dart';
import 'scene_common.dart';

/// Scene8 — 부동산 매입: (차)건물 / (대)보통예금
class Scene8 extends StatelessWidget {
  const Scene8({super.key, required this.progress});

  final double progress;

  double _interval(double t, double start, double end) {
    if (t <= start) return 0.0;
    if (t >= end) return 1.0;
    return (t - start) / (end - start);
  }

  @override
  Widget build(BuildContext context) {
    // 0.00~0.20 enter
    final enterT = _interval(progress, 0.0, 0.20);

    // 0.20~0.70 money burn: MetaDollar opacity 1→0
    final burnT = _interval(progress, 0.20, 0.70);
    final dollarOpacity = (1.0 - burnT).clamp(0.0, 1.0);

    // 0.50~1.00 building rise: translateY 80→0, scale 0.3→1
    final riseT = _interval(progress, 0.50, 1.0);
    final buildingTranslateY = (1 - riseT) * 80.0;
    final buildingScale = 0.3 + riseT * 0.7;

    // 0.90~1.00 DR pulse
    final pulseT = _interval(progress, 0.90, 1.0);
    final pulseScale = buildingScale * (1.0 + (pulseT < 0.5 ? pulseT * 2 * 0.18 : (1 - (pulseT - 0.5) * 2) * 0.18 + 0.03));

    final finalScale = progress >= 0.90 ? pulseScale : buildingScale;

    return SceneFrame(
      animArea: Stack(
        children: [
          // CR: 💵 보통예금 (지갑 — 돈이 사라짐)
          Positioned(
            right: 0,
            top: 20,
            child: Opacity(
              opacity: enterT.clamp(0.0, 1.0) * dollarOpacity,
              child: const Anchor(emoji: metaDollar, label: '보통예금'),
            ),
          ),
          // DR: 🏠 건물 (아래서 솟아오름)
          Positioned(
            left: 0,
            top: 20,
            child: Opacity(
              opacity: riseT.clamp(0.0, 1.0),
              child: Transform.translate(
                offset: Offset(0, buildingTranslateY),
                child: Transform.scale(
                  scale: finalScale,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🏠', style: TextStyle(fontSize: 40)),
                      const SizedBox(height: 4),
                      Text(
                        '건물',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      sideLabel: const SideLabel(
        drTitle: '차변 · 자산↑',
        drSub: '건물',
        crTitle: '대변 · 자산↓',
        crSub: '보통예금',
      ),
    );
  }
}
