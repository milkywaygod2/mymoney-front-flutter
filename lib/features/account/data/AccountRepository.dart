import '../../../core/interfaces/IAccountRepository.dart';
import '../../../core/domain/Account.dart';
import '../../../core/models/TypedId.dart';
import '../../../core/constants/Enums.dart';
import 'AccountDao.dart';

/// IAccountRepository 구현체 — AccountDao를 주입받아
/// Drift 데이터 ↔ 도메인 엔티티(Account) 변환을 담당.
class AccountRepository implements IAccountRepository {
  AccountRepository(this._dao);

  final AccountDao _dao;

  @override
  Future<Account?> findById(AccountId id) async {
    final row = await _dao.findById(id.value);
    if (row == null) return null;
    return _toDomain(row);
  }

  @override
  Future<List<Account>> findByNature(AccountNature nature) async {
    final listRows = await _dao.findByNature(nature.name);
    return listRows.map(_toDomain).toList();
  }

  @override
  Future<List<Account>> findByDimensionPath(
    DimensionType dimensionType,
    String pathPrefix,
  ) async {
    final listRows = await _dao.findByDimensionPath(
      dimensionType.name,
      pathPrefix,
    );
    return listRows.map(_toDomain).toList();
  }

  @override
  Future<List<Account>> findActive() async {
    final listRows = await _dao.findActive();
    return listRows.map(_toDomain).toList();
  }

  @override
  Future<void> save(Account account) async {
    // 기존 존재 여부로 INSERT/UPDATE 분기
    final existing = await _dao.findById(account.id.value);
    if (existing == null) {
      await _dao.insertAccount(_toMap(account));
    } else {
      await _dao.updateAccount(account.id.value, _toMap(account));
    }
    // TODO: OwnerShares 별도 테이블 동기화
    // 1. 기존 shares 삭제
    // 2. 새 shares 일괄 INSERT
  }

  // ---------------------------------------------------------------------------
  // Drift row → 도메인 엔티티 변환
  // ---------------------------------------------------------------------------

  /// AccountWithShares → Account 도메인 엔티티
  Account _toDomain(AccountWithShares row) {
    return Account(
      id: AccountId(row.id),
      name: row.name,
      nature: AccountNature.values.firstWhere(
        (n) => n.name == row.nature,
        orElse: () => AccountNature.asset,
      ),
      equityTypeId: DimensionValueId(row.equityTypeId),
      equityTypePath: row.equityTypePath,
      liquidityId: DimensionValueId(row.liquidityId),
      liquidityPath: row.liquidityPath,
      assetTypeId: DimensionValueId(row.assetTypeId),
      assetTypePath: row.assetTypePath,
      defaultActivityTypeId: row.defaultActivityTypeId != null
          ? DimensionValueId(row.defaultActivityTypeId!)
          : null,
      defaultIncomeTypeId: row.defaultIncomeTypeId != null
          ? DimensionValueId(row.defaultIncomeTypeId!)
          : null,
      ownerId: OwnerId(row.ownerId),
      productType: row.productType,
      financialInstitution: row.financialInstitution,
      countrySpecific: row.countrySpecific,
      isActive: row.isActive,
      listOwnerShares: row.listOwnerShares
          .map((s) => OwnerShare(
                ownerId: OwnerId(s.ownerId),
                shareRatio: s.shareRatio,
              ))
          .toList(),
    );
  }

  // ---------------------------------------------------------------------------
  // 도메인 엔티티 → Drift 데이터 변환
  // ---------------------------------------------------------------------------

  /// Account → Map (Drift Companion 확정 전 임시)
  Map<String, dynamic> _toMap(Account account) {
    return {
      'id': account.id.value,
      'name': account.name,
      'nature': account.nature.name,
      'equityTypeId': account.equityTypeId.value,
      'equityTypePath': account.equityTypePath,
      'liquidityId': account.liquidityId.value,
      'liquidityPath': account.liquidityPath,
      'assetTypeId': account.assetTypeId.value,
      'assetTypePath': account.assetTypePath,
      'defaultActivityTypeId': account.defaultActivityTypeId?.value,
      'defaultIncomeTypeId': account.defaultIncomeTypeId?.value,
      'ownerId': account.ownerId.value,
      'productType': account.productType,
      'financialInstitution': account.financialInstitution,
      'countrySpecific': account.countrySpecific,
      'isActive': account.isActive,
    };
  }
}
