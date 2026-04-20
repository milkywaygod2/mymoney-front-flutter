import 'package:freezed_annotation/freezed_annotation.dart';

part 'FinancialRatio.freezed.dart';

/// 재무비율 값 객체 — 결산/대시보드에서 사용
/// ratioValue: 배율 10000 (33.33% → 3333)
@freezed
abstract class FinancialRatio with _$FinancialRatio {
  const factory FinancialRatio({
    required String ratioCode,
    required String category,
    required int periodId,
    required int numerator,
    required int denominator,
    required int ratioValue,
    DateTime? calculatedAt,
  }) = _FinancialRatio;
}
