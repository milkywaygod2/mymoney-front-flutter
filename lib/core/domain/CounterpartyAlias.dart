import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/TypedId.dart';

part 'CounterpartyAlias.freezed.dart';

/// CounterpartyAlias — OCR/CSV 텍스트에서 거래처를 매칭하기 위한 별칭 VO.
/// 하나의 Counterparty에 여러 표기 변형이 매핑됨.
@freezed
class CounterpartyAlias with _$CounterpartyAlias {
  const factory CounterpartyAlias({
    required int id,
    required CounterpartyId counterpartyId,

    /// 별칭 텍스트 (예: "스타벅스", "STARBUCKS", "스타벅스강남점")
    required String alias,
  }) = _CounterpartyAlias;
}
