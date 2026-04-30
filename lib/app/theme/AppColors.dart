import 'package:flutter/material.dart';

/// Design Token: 색상 — colors_and_type.css v2 기준 1:1 변환
class AppColors {
  AppColors._();

  // ─── Nature 5색 ───
  static const Color natureAsset = Color(0xFF10B981);     // 자산 · Leaf Green
  static const Color natureExpense = Color(0xFFEF4444);   // 비용 · Apple Red
  static const Color natureRevenue = Color(0xFFBAE6FD);   // 수익 · Sky 200
  static const Color natureLiability = Color(0xFF4A1A7F); // 부채 · Deep Purple
  static const Color natureEquity = Color(0xFF0C2E57);    // 자본 · Deep Navy

  // 보조 톤
  static const Color assetDeep = Color(0xFF047857);
  static const Color assetSoft = Color(0xFF6EE7B7);
  static const Color expenseDeep = Color(0xFFB91C1C);
  static const Color expenseSoft = Color(0xFFFCA5A5);
  static const Color revenueDeep = Color(0xFF0284C7);
  static const Color revenueSoft = Color(0xFFBAE6FD);
  static const Color liabilityDeep = Color(0xFF2E0E55);
  static const Color liabilitySoft = Color(0xFFB48BD6);
  static const Color equityDeep = Color(0xFF0C4A6E);
  static const Color equitySoft = Color(0xFF7DD3FC);

  // ─── Primary tonal (Leaf-Green seed) ───
  static const Color primary10 = Color(0xFF002114);
  static const Color primary20 = Color(0xFF003822);
  static const Color primary30 = Color(0xFF045A33);
  static const Color primary40 = Color(0xFF047857);
  static const Color primary50 = Color(0xFF059669);
  static const Color primary60 = Color(0xFF10B981);
  static const Color primary70 = Color(0xFF34D399);
  static const Color primary80 = Color(0xFF6EE7B7);
  static const Color primary90 = Color(0xFFA7F3D0);
  static const Color primary95 = Color(0xFFD1FAE5);
  static const Color primary99 = Color(0xFFECFDF5);

  // ─── Semantic state ───
  static const Color stateDraft = Color(0xFFF59E0B);
  static const Color statePosted = natureAsset;
  static const Color stateVoided = natureExpense;
  static const Color stateSuccess = Color(0xFF10B981);
  static const Color stateWarning = Color(0xFFF59E0B);
  static const Color stateError = Color(0xFFEF4444);
  static const Color stateInfo = natureRevenue;

  // ─── Confidence levels ───
  static const Color confidenceVerified = stateSuccess;
  static const Color confidenceHigh = natureRevenue;
  static const Color confidenceMedium = Color(0xFFF59E0B);
  static const Color confidenceLow = natureExpense;
  static const Color confidenceUnknown = Color(0xFF94A3B8);

  // ─── Dark theme ───
  static const Color darkBg = Color(0xFF0B0E14);
  static const Color darkBg2 = Color(0xFF0F1320);
  static const Color darkSurface = Color(0xFF141826);
  static const Color darkSurface1 = Color(0xFF1B2030);
  static const Color darkSurface2 = Color(0xFF242A3D);
  static const Color darkSurface3 = Color(0xFF2E3449);
  static const Color darkSurfaceHover = Color(0xFF282E43);

  static const Color darkFg1 = Color(0xFFEEF2FA);
  static const Color darkFg2 = Color(0xFFB8C0D4);
  static const Color darkFg3 = Color(0xFF8A94AC);
  static const Color darkFg4 = Color(0xFF5A6177);

  static const Color darkOutline = Color(0x14FFFFFF);        // rgba(255,255,255,0.08)
  static const Color darkOutlineVariant = Color(0x0AFFFFFF); // rgba(255,255,255,0.04)
  static const Color darkOutlineStrong = Color(0x2EFFFFFF);  // rgba(255,255,255,0.18)
  static const Color darkDivider = Color(0x0FFFFFFF);        // rgba(255,255,255,0.06)

  static const Color darkPrimary = Color(0xFF10B981);
  static const Color darkOnPrimary = Color(0xFF002114);
  static const Color darkPrimaryContainer = Color(0xFF003822);
  static const Color darkOnPrimaryContainer = Color(0xFFA7F3D0);

  // Nature-tinted surfaces (dark)
  static const Color darkAssetSurface = Color(0x2E10B981);     // 18%
  static const Color darkExpenseSurface = Color(0x2EEF4444);   // 18%
  static const Color darkRevenueSurface = Color(0x3338BDF8);   // 20%
  static const Color darkLiabilitySurface = Color(0x477F1D3A); // 28%
  static const Color darkEquitySurface = Color(0x386B3F8B);    // 22%

  // ─── Light theme ───
  static const Color lightBg = Color(0xFFF7F8FC);
  static const Color lightBg2 = Color(0xFFEEF0F8);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurface1 = Color(0xFFF4F6FB);
  static const Color lightSurface2 = Color(0xFFEAEEF6);
  static const Color lightSurface3 = Color(0xFFDFE4EE);
  static const Color lightSurfaceHover = Color(0xFFEDF0F7);

  static const Color lightFg1 = Color(0xFF0B1020);
  static const Color lightFg2 = Color(0xFF3E475B);
  static const Color lightFg3 = Color(0xFF6B7489);
  static const Color lightFg4 = Color(0xFF9BA3B5);

  static const Color lightOutline = Color(0x1A0B1020);        // rgba(11,16,32,0.10)
  static const Color lightOutlineVariant = Color(0x0F0B1020); // rgba(11,16,32,0.06)
  static const Color lightOutlineStrong = Color(0x380B1020);  // rgba(11,16,32,0.22)
  static const Color lightDivider = Color(0x140B1020);        // rgba(11,16,32,0.08)

  static const Color lightPrimary = Color(0xFF047857);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightPrimaryContainer = Color(0xFFA7F3D0);
  static const Color lightOnPrimaryContainer = Color(0xFF002114);

  static const Color lightAssetSurface = Color(0x1A10B981);     // 10%
  static const Color lightExpenseSurface = Color(0x1AEF4444);   // 10%
  static const Color lightRevenueSurface = Color(0x1E38BDF8);   // 12%
  static const Color lightLiabilitySurface = Color(0x247F1D3A); // 14%
  static const Color lightEquitySurface = Color(0x1E6B3F8B);    // 12%

  // ─── 에러 컨테이너 ───
  static const Color darkErrorContainer = Color(0xFF7F1D1D);

  // ─── 그래디언트용 원색 (불투명) ───
  static const Color gradKickerStart = Color(0xFF10B981);
  static const Color gradKickerMid1 = Color(0xFF38BDF8);
  static const Color gradKickerMid2 = Color(0xFF6B3F8B);
  static const Color gradKickerEnd = Color(0xFF7F1D3A);
}
