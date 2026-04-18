import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/TypedId.dart';
import '../../../core/constants/Enums.dart';

part 'AccountEvent.freezed.dart';

/// 계정과목 BLoC 이벤트
@freezed
abstract class AccountEvent with _$AccountEvent {
  /// 계정과목 트리 로딩
  const factory AccountEvent.loadTree() = LoadAccountTree;

  /// 계정과목 생성
  const factory AccountEvent.createAccount({
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
  }) = CreateAccount;

  /// 계정과목 비활성화 (소프트 삭제)
  const factory AccountEvent.deactivateAccount({
    required AccountId id,
  }) = DeactivateAccount;

  /// 트리 노드 펼치기
  const factory AccountEvent.expandNode({
    required AccountId id,
  }) = ExpandNode;

  /// 트리 노드 접기
  const factory AccountEvent.collapseNode({
    required AccountId id,
  }) = CollapseNode;

  /// 계정과목 검색
  const factory AccountEvent.searchAccounts({
    required String query,
  }) = SearchAccounts;
}
