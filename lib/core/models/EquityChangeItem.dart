import 'package:freezed_annotation/freezed_annotation.dart';

import '../constants/Enums.dart';

part 'EquityChangeItem.freezed.dart';

/// CE(자본변동표) 행 항목 — 5구성요소 x 변동유형
/// changeType=ociChange일 때 ociCategory로 OCI 5항목 구분
@freezed
abstract class EquityChangeItem with _$EquityChangeItem {
  const EquityChangeItem._();

  const factory EquityChangeItem({
    /// 변동 유형 (기초/순이익/OCI/배당/자사주/기타/기말)
    required EquityChangeType changeType,
    /// OCI 세부 항목 (changeType == ociChange일 때만 유효)
    OciCategory? ociCategory,
    /// 자본금
    required int capitalStock,
    /// 자본잉여금
    required int capitalSurplus,
    /// 기타자본
    required int otherCapital,
    /// 기타포괄손익누계액 (AOCI)
    required int aoci,
    /// 이익잉여금
    required int retainedEarnings,
  }) = _EquityChangeItem;

  /// 행 합계 (자본 총액)
  int get total => capitalStock + capitalSurplus + otherCapital + aoci + retainedEarnings;
}
