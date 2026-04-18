import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/TypedId.dart';
import '../constants/Enums.dart';
import '../errors/DomainErrors.dart';

part 'Account.freezed.dart';

/// 소유자 지분율 — 공동명의 자산의 지분 배분.
/// shareRatio: 배율 10000 (33.33% = 3333).
@freezed
class OwnerShare with _$OwnerShare {
  const factory OwnerShare({
    required OwnerId ownerId,

    /// 지분율 (배율 10000, 합계=10000)
    required int shareRatio,
  }) = _OwnerShare;
}

/// 계정과목 — 돈의 위치/용도를 분류하는 항목. Aggregate Root.
/// 불변조건 INV-A1~A5를 보호한다.
@freezed
class Account with _$Account {
  const Account._();

  const factory Account({
    required AccountId id,
    required String name,

    /// 5대 계정 성격 — 차변/대변 정상 방향 결정, 재무제표 위치 결정
    required AccountNature nature,

    /// T1 자기자본성 (이중 저장: FK=쓰기, Path=읽기)
    required DimensionValueId equityTypeId,
    required String equityTypePath,

    /// T1 유동성 (이중 저장)
    required DimensionValueId liquidityId,
    required String liquidityPath,

    /// T1 자산종류 (이중 저장)
    required DimensionValueId assetTypeId,
    required String assetTypePath,

    /// T2 활동구분 기본값 (JEL에서 Override 가능)
    DimensionValueId? defaultActivityTypeId,

    /// T2 소득유형 기본값 (수익/비용 계정만 해당)
    DimensionValueId? defaultIncomeTypeId,

    /// T2 기본 소유자
    required OwnerId ownerId,

    /// Account 속성: 상품구분 (예금/적금/주식 등)
    String? productType,

    /// Account 속성: 금융사 (우리은행/국민은행 등)
    String? financialInstitution,

    /// 국가별 추가 정보 (JSON, 확장용)
    String? countrySpecific,

    /// 활성 여부 — 비활성 계정은 새 JEL 참조 불가 (INV-A5)
    @Default(true) bool isActive,

    /// 공동명의 지분율 — 합계=10000 (INV-A3)
    @Default([]) List<OwnerShare> listOwnerShares,
  }) = _Account;

  // ---------------------------------------------------------------------------
  // 팩토리 메서드
  // ---------------------------------------------------------------------------

  /// 계정과목 생성 — INV-A3 검증 (지분율 합계).
  /// INV-A1(유효 트리 노드), INV-A2(유동성 종속), INV-A4(nature-equity 일치)
  /// 검증은 Repository/UseCase 레벨에서 DimensionValue 테이블 참조하여 수행.
  static Account create({
    required AccountId id,
    required String name,
    required AccountNature nature,
    required DimensionValueId equityTypeId,
    required String equityTypePath,
    required DimensionValueId liquidityId,
    required String liquidityPath,
    required DimensionValueId assetTypeId,
    required String assetTypePath,
    required OwnerId ownerId,
    DimensionValueId? defaultActivityTypeId,
    DimensionValueId? defaultIncomeTypeId,
    String? productType,
    String? financialInstitution,
    List<OwnerShare>? listOwnerShares,
  }) {
    final shares = listOwnerShares ?? [];

    // INV-A3: 지분율 합계 검증 (지분 목록이 있는 경우)
    if (shares.isNotEmpty) {
      _validateOwnerSharesSum(shares);
    }

    return Account(
      id: id,
      name: name,
      nature: nature,
      equityTypeId: equityTypeId,
      equityTypePath: equityTypePath,
      liquidityId: liquidityId,
      liquidityPath: liquidityPath,
      assetTypeId: assetTypeId,
      assetTypePath: assetTypePath,
      ownerId: ownerId,
      defaultActivityTypeId: defaultActivityTypeId,
      defaultIncomeTypeId: defaultIncomeTypeId,
      productType: productType,
      financialInstitution: financialInstitution,
      listOwnerShares: shares,
    );
  }

  /// 계정 비활성화 — INV-A5 적용.
  /// 비활성화된 계정은 새 JEL에서 참조할 수 없다 (UseCase 레벨에서 체크).
  Account deactivate() {
    return copyWith(isActive: false);
  }

  /// 계정 재활성화
  Account activate() {
    return copyWith(isActive: true);
  }

  /// 공동명의 지분율 변경 — INV-A3 검증.
  Account updateOwnerShares(List<OwnerShare> listOwnerShares) {
    if (listOwnerShares.isNotEmpty) {
      _validateOwnerSharesSum(listOwnerShares);
    }
    return copyWith(listOwnerShares: listOwnerShares);
  }

  // ---------------------------------------------------------------------------
  // 불변조건 검증 헬퍼
  // ---------------------------------------------------------------------------

  /// INV-A3: 지분율 합계 = 10000 (100%)
  static void _validateOwnerSharesSum(List<OwnerShare> listOwnerShares) {
    final int totalRatio =
        listOwnerShares.fold(0, (sum, s) => sum + s.shareRatio);
    if (totalRatio != 10000) {
      throw InvariantViolationError(
        'INV-A3: 공동명의 지분율 합계는 10000(100%)이어야 합니다. 현재: $totalRatio',
      );
    }
  }
}
