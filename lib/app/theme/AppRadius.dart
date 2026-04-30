import 'package:flutter/material.dart';

/// Design Token: 모서리 반경 — colors_and_type.css v2 기준 1:1 변환
class AppRadius {
  AppRadius._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double full = 9999;

  static const BorderRadius bXs = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius bSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius bMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius bLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius bXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius bFull = BorderRadius.all(Radius.circular(full));
}
