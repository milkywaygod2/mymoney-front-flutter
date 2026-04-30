import 'package:flutter/material.dart';

/// Design Token: 애니메이션 — colors_and_type.css v2 기준 1:1 변환
class AppMotion {
  AppMotion._();

  // ─── Durations ───
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration mid = Duration(milliseconds: 220);
  static const Duration slow = Duration(milliseconds: 320);
  static const Duration kick = Duration(milliseconds: 420);

  // ─── Curves ───
  // standard: cubic-bezier(0.2, 0, 0, 1)
  static const Cubic standard = Cubic(0.2, 0.0, 0.0, 1.0);
  // emphasized: cubic-bezier(0.2, 0, 0, 1) — Material 3 emphasized
  static const Cubic emphasized = Cubic(0.2, 0.0, 0.0, 1.0);
  // out: cubic-bezier(0, 0, 0.2, 1)
  static const Cubic easeOut = Cubic(0.0, 0.0, 0.2, 1.0);
  // kick: cubic-bezier(0.34, 1.56, 0.64, 1) — 제한적 스프링
  static const Cubic kickCurve = Cubic(0.34, 1.56, 0.64, 1.0);
}
