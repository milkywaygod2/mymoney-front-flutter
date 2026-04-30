import 'package:flutter/material.dart';

import 'AppColors.dart';

/// Design Token: 타이포그래피 — colors_and_type.css v2 기준 1:1 변환
class AppTextStyles {
  AppTextStyles._();

  // ─── Display ───
  static const TextStyle displayLarge = TextStyle(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    height: 1.2,
    letterSpacing: -0.25,
  );
  static const TextStyle displayMedium = TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    height: 1.2,
    letterSpacing: 0,
  );
  static const TextStyle displaySmall = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    height: 1.2,
    letterSpacing: 0,
  );

  // ─── Headline ───
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.01 * 32,
  );
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.35,
    letterSpacing: 0,
  );
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.35,
    letterSpacing: 0,
  );

  // ─── Title ───
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.35,
    letterSpacing: 0,
  );
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.35,
    letterSpacing: 0.15,
  );
  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.35,
    letterSpacing: 0.1,
  );

  // ─── Body ───
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.5,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.25,
  );
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.4,
  );

  // ─── Label ───
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.35,
    letterSpacing: 0.01 * 14,
  );
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.35,
    letterSpacing: 0.5,
  );
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.35,
    letterSpacing: 0.5,
  );

  // ─── Amount (JetBrains Mono, tabular-nums) ───
  static const TextStyle amountLg = TextStyle(
    fontFamily: 'JetBrains Mono',
    fontSize: 24, // headline-small
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.01 * 24,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  static const TextStyle amountMd = TextStyle(
    fontFamily: 'JetBrains Mono',
    fontSize: 22, // title-large
    fontWeight: FontWeight.w600,
    height: 1.35,
    letterSpacing: 0,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  static const TextStyle amountSm = TextStyle(
    fontFamily: 'JetBrains Mono',
    fontSize: 14, // body-medium
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  // ─── 다크 테마용 기본 색상 적용 헬퍼 ───
  static TextStyle withDarkColor(TextStyle base) =>
      base.copyWith(color: AppColors.darkFg1);
}
