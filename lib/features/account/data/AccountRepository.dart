import 'package:drift/drift.dart';

import '../../../core/interfaces/IAccountRepository.dart';
import '../../../core/domain/Account.dart';
import '../../../core/models/TypedId.dart';
import '../../../core/constants/Enums.dart';
import '../../../infrastructure/database/AppDatabase.dart' hide Account;
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
    final companion = _toCompanion(account);
    // 기존 존재 여부로 INSERT/UPDATE 분기
    final existing = await _dao.findById(account.id.value);
    if (existing == null) {
      await _dao.insertAccount(companion);
    } else {
      await _dao.updateAccount(companion);
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
      // 잘못된 값이면 ArgumentError → 데이터 무결성 문제 즉시 감지
      nature: AccountNature.values.byName(row.nature.toLowerCase()),
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
  // 도메인 엔티티 → Drift Companion 변환
  // ---------------------------------------------------------------------------

  /// Account → AccountsCompanion
  AccountsCompanion _toCompanion(Account account) {
    return AccountsCompanion(
      id: Value(account.id.value),
      name: Value(account.name),
      nature: Value(account.nature.name.toUpperCase()),
      equityTypeId: Value(account.equityTypeId.value),
      equityTypePath: Value(account.equityTypePath),
      liquidityId: Value(account.liquidityId.value),
      liquidityPath: Value(account.liquidityPath),
      assetTypeId: Value(account.assetTypeId.value),
      assetTypePath: Value(account.assetTypePath),
      defaultActivityTypeId: Value(account.defaultActivityTypeId?.value),
      defaultIncomeTypeId: Value(account.defaultIncomeTypeId?.value),
      ownerId: Value(account.ownerId.value),
      productType: Value(account.productType),
      financialInstitution: Value(account.financialInstitution),
      countrySpecific: Value(account.countrySpecific),
      isActive: Value(account.isActive),
    );
  }
}
