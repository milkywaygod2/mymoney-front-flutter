import 'package:flutter/material.dart';

// ─── 스테이지 상수 ───
const double stageW = 360.0;
const double stageH = 260.0;
const double crX    = 90.0;
const double drX    = 270.0;
const double rowY   = 130.0;

// ─── 이징 함수 ───

double easeInOutCubic(double t) {
  return t < 0.5 ? 4 * t * t * t : 1 - _pow(-2 * t + 2, 3) / 2;
}

double easeInQuad(double t) => t * t;

double _pow(double base, int exp) {
  double result = 1;
  for (int i = 0; i < exp; i++) {
    result *= base;
  }
  return result;
}

/// 포물선 궤적: from → to, peak height h
Offset arch({
  required Offset from,
  required Offset to,
  required double t,
  double h = 30,
}) {
  final ease = easeInOutCubic(t);
  final x = from.dx + (to.dx - from.dx) * ease;
  final y = from.dy + (to.dy - from.dy) * ease - (Math.sin(ease * 3.14159265) * h);
  return Offset(x, y);
}

// dart:math 미사용 — 자체 sin 근사
class Math {
  static double sin(double x) => _sinApprox(x);
  static double _sinApprox(double x) {
    // Bhaskara I 근사 (0~π 범위)
    final xi = x % (2 * 3.14159265);
    final xn = xi < 0 ? xi + 2 * 3.14159265 : xi;
    if (xn <= 3.14159265) {
      return 16 * xn * (3.14159265 - xn) / (5 * 3.14159265 * 3.14159265 - 4 * xn * (3.14159265 - xn));
    } else {
      final xr = xn - 3.14159265;
      return -(16 * xr * (3.14159265 - xr) / (5 * 3.14159265 * 3.14159265 - 4 * xr * (3.14159265 - xr)));
    }
  }
}

// ─── 공통 배치 위젯 ───

/// 스테이지 내 고정 위치 위젯
class Anchor extends StatelessWidget {
  const Anchor({
    super.key,
    required this.x,
    required this.child,
    this.opacity = 1.0,
    this.scale = 1.0,
  });

  final double x;
  final Widget child;
  final double opacity;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x - 48,
      top: rowY - 48,
      child: Opacity(
        opacity: opacity.clamp(0.0, 1.0),
        child: Transform.scale(
          scale: scale,
          child: SizedBox(width: 96, height: 96, child: child),
        ),
      ),
    );
  }
}

/// 애니메이션 중 이동하는 조각
class FlyingPiece extends StatelessWidget {
  const FlyingPiece({
    super.key,
    required this.x,
    required this.y,
    required this.child,
    this.rotate = 0.0,
    this.scale = 1.0,
    this.opacity = 1.0,
  });

  final double x;
  final double y;
  final Widget child;
  final double rotate;
  final double scale;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x - 17,
      top: y - 17,
      child: Opacity(
        opacity: opacity.clamp(0.0, 1.0),
        child: Transform.scale(
          scale: scale,
          child: Transform.rotate(
            angle: rotate * 3.14159265 / 180,
            child: SizedBox(width: 34, height: 34, child: child),
          ),
        ),
      ),
    );
  }
}

/// 좌우 라벨 (side 설명 + 계정명)
class SideLabel extends StatelessWidget {
  const SideLabel({
    super.key,
    required this.x,
    required this.side,
    required this.label,
  });

  final double x;
  final String side;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x - 60,
      top: rowY + 52,
      child: SizedBox(
        width: 120,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              side,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.06 * 10,
                color: Colors.white70,
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Metaphor 위젯 (이모지 기반 flat) ───

class MetaDollar extends StatelessWidget {
  const MetaDollar({super.key, this.size = 64});
  final double size;
  @override
  Widget build(BuildContext context) => _EmojiMeta(emoji: '💵', size: size);
}

class MetaBag extends StatelessWidget {
  const MetaBag({super.key, this.size = 64});
  final double size;
  @override
  Widget build(BuildContext context) => _EmojiMeta(emoji: '🛍️', size: size);
}

class MetaHome extends StatelessWidget {
  const MetaHome({super.key, this.size = 64});
  final double size;
  @override
  Widget build(BuildContext context) => _EmojiMeta(emoji: '🏠', size: size);
}

class MetaCard extends StatelessWidget {
  const MetaCard({super.key, this.size = 64});
  final double size;
  @override
  Widget build(BuildContext context) => _EmojiMeta(emoji: '💳', size: size);
}

class MetaPayroll extends StatelessWidget {
  const MetaPayroll({super.key, this.size = 64});
  final double size;
  @override
  Widget build(BuildContext context) => _EmojiMeta(emoji: '💼', size: size);
}

class MetaBank extends StatelessWidget {
  const MetaBank({super.key, this.size = 64});
  final double size;
  @override
  Widget build(BuildContext context) => _EmojiMeta(emoji: '🏦', size: size);
}

class AssetCoffee extends StatelessWidget {
  const AssetCoffee({super.key, this.size = 64});
  final double size;
  @override
  Widget build(BuildContext context) => _EmojiMeta(emoji: '☕', size: size);
}

class AssetBow extends StatelessWidget {
  const AssetBow({super.key, this.size = 64});
  final double size;
  @override
  Widget build(BuildContext context) => _EmojiMeta(emoji: '🏹', size: size);
}

class AssetCheck extends StatelessWidget {
  const AssetCheck({super.key, this.size = 64});
  final double size;
  @override
  Widget build(BuildContext context) => _EmojiMeta(emoji: '🧾', size: size);
}

class AssetBuildingSmall extends StatelessWidget {
  const AssetBuildingSmall({super.key, this.size = 64});
  final double size;
  @override
  Widget build(BuildContext context) => _EmojiMeta(emoji: '🏢', size: size);
}

class AssetContract extends StatelessWidget {
  const AssetContract({super.key, this.size = 64});
  final double size;
  @override
  Widget build(BuildContext context) => _EmojiMeta(emoji: '📄', size: size);
}

class _EmojiMeta extends StatelessWidget {
  const _EmojiMeta({required this.emoji, required this.size});
  final String emoji;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(emoji, style: TextStyle(fontSize: size * 0.6)),
    );
  }
}
