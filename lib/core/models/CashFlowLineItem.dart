import 'package:freezed_annotation/freezed_annotation.dart';

import '../constants/Enums.dart';

part 'CashFlowLineItem.freezed.dart';

/// CF 보고서 개별 항목 — CashFlowCodes 코드 + 금액
/// aggregate: 하위 합산, actual: JEL 집계, automatic: PL 연동
@freezed
abstract class CashFlowLineItem with _$CashFlowLineItem {
  const CashFlowLineItem._();

  const factory CashFlowLineItem({
    /// CashFlowCodes.code (예: "C100000")
    required String code,
    /// 항목명 (예: "Cash flows from operating activities")
    required String name,
    /// 금액 (최소 단위 int)
    required int amount,
    /// 계층 깊이 (1~4)
    required int level,
    /// 계정 인덱스 유형
    required CfAccountIndex indexType,
  }) = _CashFlowLineItem;
}
