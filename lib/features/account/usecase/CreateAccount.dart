import '../../../core/constants/Enums.dart';
import '../../../core/domain/Account.dart';
import '../../../core/errors/DomainErrors.dart';
import '../../../core/interfaces/IAccountRepository.dart';
import '../../../core/models/TypedId.dart';

/// 계정과목 생성 (CW 섹션 12.2: leaf 하위만, nature 상속)
class CreateAccount {
  CreateAccount(this._repository);
  final IAccountRepository _repository;

  Future<Account> execute({
    required String name, required AccountNature nature,
    required DimensionValueId equityTypeId, required String equityTypePath,
    required DimensionValueId liquidityId, required String liquidityPath,
    required DimensionValueId assetTypeId, required String assetTypePath,
    required OwnerId ownerId,
    DimensionValueId? defaultActivityTypeId, DimensionValueId? defaultIncomeTypeId,
    String? productType, String? financialInstitution,
  }) async {
    final listExisting = await _repository.findByDimensionPath(DimensionType.equityType, equityTypePath);
    final hasChildren = listExisting.any(
      (a) => a.equityTypePath.startsWith('$equityTypePath.') && a.equityTypePath != equityTypePath,
    );
    if (hasChildren) {
      throw InvariantViolationError('중간 노드에는 계정을 추가할 수 없습니다: $equityTypePath');
    }
    final account = Account.create(
      id: const AccountId(0), name: name, nature: nature,
      equityTypeId: equityTypeId, equityTypePath: equityTypePath,
      liquidityId: liquidityId, liquidityPath: liquidityPath,
      assetTypeId: assetTypeId, assetTypePath: assetTypePath,
      ownerId: ownerId, defaultActivityTypeId: defaultActivityTypeId,
      defaultIncomeTypeId: defaultIncomeTypeId,
      productType: productType, financialInstitution: financialInstitution,
      listOwnerShares: [OwnerShare(ownerId: ownerId, shareRatio: 10000)],
    );
    await _repository.save(account);
    return account;
  }
}
