import 'package:freezed_annotation/freezed_annotation.dart';

import 'TypedId.dart';

part 'Period.freezed.dart';

/// 결산 기간 (손익귀속기간)
/// 거래의 발생일과 귀속기간은 다를 수 있음 (발생주의)
@freezed
class Period with _$Period {
  const factory Period({
    required PeriodId id,
    required String name,
    required DateTime startDate,
    required DateTime endDate,
  }) = _Period;
}
