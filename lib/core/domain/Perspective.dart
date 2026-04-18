import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/TypedId.dart';
import '../models/CurrencyCode.dart';
import '../constants/Enums.dart';
import '../errors/DomainErrors.dart';

part 'Perspective.freezed.dart';

/// Perspective(관점) — 거래 풀을 특정 조건으로 필터링하는 렌즈.
/// "남편 투자 현황", "가족 전체 지출" 등 다차원 필터 조합을 저장.
@freezed
class Perspective with _$Perspective {
  const Perspective._();

  const factory Perspective({
    required PerspectiveId id,
    required String name,
    required OwnerId ownerId,

    /// 시스템 기본 프리셋 여부 (true → 삭제/수정 불가)
    @Default(false) bool isSystem,

    /// T1/T2 분류축 필터 (DimensionType → 선택된 DimensionValueId 목록)
    @Default({}) Map<String, List<DimensionValueId>> mapDimensionFilters,

    /// Account 속성 필터 (상품구분/금융사 등)
    @Default({}) Map<String, List<String>> mapAccountAttributeFilters,

    /// T3 태그 필터
    @Default([]) List<TagId> listTagFilters,

    /// 기록 방향 — 정부회계 모드에서 반전
    @Default(RecordingDirection.normal) RecordingDirection recordingDirection,

    /// 기준 통화 (null = 시스템 기본 통화)
    CurrencyCode? baseCurrency,

    /// 권한 수준
    @Default(PermissionLevel.full) PermissionLevel permissionLevel,
  }) = _Perspective;

  // --- 불변조건 검증 ---

  /// INV-P1: dimensionFilters 키는 유효한 DimensionType만 허용
  static const Set<String> kValidDimensionTypes = {
    'EQUITY_TYPE',
    'LIQUIDITY',
    'ASSET_TYPE',
    'ACTIVITY_TYPE',
    'INCOME_TYPE',
  };

  bool get hasValidDimensionKeys =>
      mapDimensionFilters.keys.every((key) => kValidDimensionTypes.contains(key));

  /// INV-P2: 시스템 프리셋 수정 시도 시 예외 발생
  Perspective updateName(String newName) {
    if (isSystem) {
      throw InvariantViolationError('INV-P2: 시스템 프리셋은 수정할 수 없습니다');
    }
    return copyWith(name: newName);
  }

  Perspective updateFilters({
    Map<String, List<DimensionValueId>>? dimensionFilters,
    Map<String, List<String>>? accountAttributeFilters,
    List<TagId>? tagFilters,
  }) {
    if (isSystem) {
      throw InvariantViolationError('INV-P2: 시스템 프리셋은 수정할 수 없습니다');
    }
    return copyWith(
      mapDimensionFilters: dimensionFilters ?? mapDimensionFilters,
      mapAccountAttributeFilters: accountAttributeFilters ?? mapAccountAttributeFilters,
      listTagFilters: tagFilters ?? listTagFilters,
    );
  }

  /// 정부회계 모드 여부
  bool get isGovernmentMode => recordingDirection == RecordingDirection.inverted;
}
