import 'package:freezed_annotation/freezed_annotation.dart';

part 'PeriodComparison.freezed.dart';

/// 기간 비교 값 객체 — MoM/QoQ/YoY/YoY_Annual 증감 결과
/// changeRatio: 배율 10000 (5.25% → 525)
@freezed
abstract class PeriodComparison with _$PeriodComparison {
  const factory PeriodComparison({
    required int currentValue,
    required int previousValue,
    /// 증감액 (current - previous)
    required int changeAmount,
    /// 증감률 (배율 10000)
    required int changeRatio,
    /// 비교 유형
    required String comparisonType,
  }) = _PeriodComparison;
}
