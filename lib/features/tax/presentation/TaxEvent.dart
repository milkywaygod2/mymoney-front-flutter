import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/constants/Enums.dart';
import '../../../core/models/TypedId.dart';

part 'TaxEvent.freezed.dart';

/// 세무조정 이벤트 (freezed v3 — abstract class 필수)
@freezed
abstract class TaxEvent with _$TaxEvent {
  /// 자동 판정 실행 — Posted 거래 목록에 대해 TaxRuleEngine 적용
  const factory TaxEvent.runAutoClassification({
    required List<TransactionId> listTransactionIds,
    required DateTime asOfDate,
  }) = RunAutoClassification;

  /// 미판정 항목 목록 로드
  const factory TaxEvent.loadPendingItems() = LoadPendingItems;

  /// 수동 deductibility 재정의 — 사용자 검토 후 확정
  const factory TaxEvent.overrideDeductibility({
    required TransactionId transactionId,
    required JournalEntryLineId lineId,
    required Deductibility deductibility,
    String? memo,
  }) = OverrideDeductibility;

  /// 세무조정 전체 확정 — 미판정 0건 검증 후 확정
  const factory TaxEvent.confirmSettlement({
    required DateTime asOfDate,
  }) = ConfirmSettlement;
}
