import 'package:freezed_annotation/freezed_annotation.dart';

import '../usecase/AutoClassifyDeductibility.dart';

part 'TaxState.freezed.dart';

/// 세무조정 BLoC 상태 (freezed v3 — abstract class 필수)
@freezed
abstract class TaxState with _$TaxState {
  const factory TaxState({
    /// 자동 판정 결과 목록
    @Default([])
    List<DeductibilityClassificationResult> listAutoResults,

    /// 미판정 항목 (undetermined) 목록 — 수동 검토 대상
    @Default([])
    List<DeductibilityClassificationResult> listPendingItems,

    /// 세무조정 확정 여부
    @Default(false) bool isSettlementConfirmed,

    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _TaxState;
}
