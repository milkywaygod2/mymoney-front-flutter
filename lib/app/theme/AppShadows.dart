import 'package:flutter/material.dart';

/// Design Token: 그림자 — colors_and_type.css v2 기준 1:1 변환
class AppShadows {
  AppShadows._();

  static const List<BoxShadow> shadow1 = [
    BoxShadow(
      color: Color(0x40000000), // rgba(0,0,0,0.25)
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
    BoxShadow(
      color: Color(0x26000000), // rgba(0,0,0,0.15)
      blurRadius: 3,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> shadow2 = [
    BoxShadow(
      color: Color(0x47000000), // rgba(0,0,0,0.28)
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> shadow3 = [
    BoxShadow(
      color: Color(0x5C000000), // rgba(0,0,0,0.36)
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  // glow-leaf: rgba(16,185,129,0.28) ring + rgba(16,185,129,0.22) blur
  static const List<BoxShadow> glowLeaf = [
    BoxShadow(
      color: Color(0x4710B981), // 0.28
      blurRadius: 0,
      spreadRadius: 1,
    ),
    BoxShadow(
      color: Color(0x3810B981), // 0.22
      blurRadius: 28,
      offset: Offset(0, 8),
    ),
  ];

  // glow-well: rgba(107,63,139,0.30) ring + rgba(107,63,139,0.22) blur
  static const List<BoxShadow> glowWell = [
    BoxShadow(
      color: Color(0x4D6B3F8B), // 0.30
      blurRadius: 0,
      spreadRadius: 1,
    ),
    BoxShadow(
      color: Color(0x386B3F8B), // 0.22
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  // glow-amber: rgba(245,158,11,0.28) ring + rgba(245,158,11,0.18) blur
  static const List<BoxShadow> glowAmber = [
    BoxShadow(
      color: Color(0x47F59E0B), // 0.28
      blurRadius: 0,
      spreadRadius: 1,
    ),
    BoxShadow(
      color: Color(0x2EF59E0B), // 0.18
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];
}
