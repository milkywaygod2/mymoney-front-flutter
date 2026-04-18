import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/TypedId.dart';
import '../constants/Enums.dart';
import '../models/CurrencyCode.dart';

part 'JournalEntryLine.freezed.dart';

/// 전표 라인 — Transaction(거래)의 복식부기 개별 행.
/// AR 간 ID 참조만 허용 (Account 직접 참조 금지).
@freezed
class JournalEntryLine with _$JournalEntryLine {
  const JournalEntryLine._();

  const factory JournalEntryLine({
    required JournalEntryLineId id,
    required AccountId accountId,
    required EntryType entryType,

    /// 거래원화 금액 (최소 단위 int, 항상 양수)
    required int originalAmount,

    /// 거래원화 — 실제 거래에 사용된 화폐 (ISO 4217)
    required CurrencyCode originalCurrency,

    /// 거래시점 기준통화 환율 (배율 1,000,000, 불변)
    required int exchangeRateAtTrade,

    /// 기준통화 — 환율 정산의 기축통화
    required CurrencyCode baseCurrency,

    /// 기준통화 환산액 (파생값, 거래시점 기준)
    required int baseAmount,

    /// T2 활동구분 재정의 (null = Account 기본값 사용)
    DimensionValueId? activityTypeOverride,

    /// T2 소유자 재정의 (null = Account 기본 소유자 사용)
    OwnerId? ownerIdOverride,

    /// T2 소득유형 재정의 (null = Account 기본값 사용)
    DimensionValueId? incomeTypeOverride,

    /// T2 손익금구분 (기본: 미판정)
    @Default(Deductibility.undetermined) Deductibility deductibility,

    /// 실질 수혜자 (세무 실질과세 원칙 + 통계)
    OwnerId? beneficiaryId,

    /// 세무 분류 (확장용)
    String? taxClassification,

    /// 적요 메모
    String? memo,
  }) = _JournalEntryLine;

  /// INV-T4: 거래원화 금액은 항상 양수
  bool get isValidAmount => originalAmount > 0;
}
