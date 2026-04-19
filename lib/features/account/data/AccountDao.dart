import 'package:drift/drift.dart';

import '../../../infrastructure/database/AppDatabase.dart';
import '../../../infrastructure/database/tables/AccountOwnerShareTable.dart';
import '../../../infrastructure/database/tables/AccountTable.dart';

part 'AccountDao.g.dart';

/// Account + OwnerShares 조인 결과를 담는 데이터 클래스
class AccountWithShares {
  AccountWithShares({
    required this.id,
    required this.name,
    required this.nature,
    required this.equityTypeId,
    required this.equityTypePath,
    required this.liquidityId,
    required this.liquidityPath,
    required this.assetTypeId,
    required this.assetTypePath,
    this.defaultActivityTypeId,
    this.defaultIncomeTypeId,
    required this.ownerId,
    this.productType,
    this.financialInstitution,
    this.countrySpecific,
    required this.isActive,
    this.listOwnerShares = const [],
  });

  final int id;
  final String name;
  final String nature;
  final int equityTypeId;
  final String equityTypePath;
  final int liquidityId;
  final String liquidityPath;
  final int assetTypeId;
  final String assetTypePath;
  final int? defaultActivityTypeId;
  final int? defaultIncomeTypeId;
  final int ownerId;
  final String? productType;
  final String? financialInstitution;
  final String? countrySpecific;
  final bool isActive;
  final List<OwnerShareRow> listOwnerShares;
}

/// OwnerShares 테이블 행 데이터
class OwnerShareRow {
  OwnerShareRow({required this.ownerId, required this.shareRatio});

  final int ownerId;
  final int shareRatio;
}

/// Account DAO — 계정과목 CRUD + Path 기반 조회
@DriftAccessor(tables: [Accounts, AccountOwnerShares])
class AccountDao extends DatabaseAccessor<AppDatabase>
    with _$AccountDaoMixin {
  AccountDao(super.db);

  // ---------------------------------------------------------------------------
  // CRUD
  // ---------------------------------------------------------------------------

  /// 계정 생성 — Accounts 테이블에 INSERT
  Future<int> insertAccount(AccountsCompanion companion) =>
      into(accounts).insert(companion);

  /// 계정 수정 — Accounts 테이블 UPDATE (전체 교체)
  Future<bool> updateAccount(AccountsCompanion companion) =>
      update(accounts).replace(companion);

  /// 계정 삭제 — 물리 삭제 (비활성화 권장, 삭제는 예외적)
  Future<int> deleteAccount(int id) =>
      (delete(accounts)..where((a) => a.id.equals(id))).go();

  // ---------------------------------------------------------------------------
  // 조회
  // ---------------------------------------------------------------------------

  /// ID로 계정 조회 — OwnerShares LEFT JOIN 포함
  Future<AccountWithShares?> findById(int id) async {
    final query = select(accounts).join([
      leftOuterJoin(
        accountOwnerShares,
        accountOwnerShares.accountId.equalsExp(accounts.id),
      ),
    ])..where(accounts.id.equals(id));

    final listRows = await query.get();
    if (listRows.isEmpty) return null;
    return _toAccountWithShares(listRows);
  }

  /// 계정 성격(nature)별 조회
  Future<List<AccountWithShares>> findByNature(String nature) async {
    final query = select(accounts).join([
      leftOuterJoin(
        accountOwnerShares,
        accountOwnerShares.accountId.equalsExp(accounts.id),
      ),
    ])..where(accounts.nature.equals(nature));

    return _groupByAccount(await query.get());
  }

  /// 분류축 경로 접두사 기반 조회 (Materialized Path LIKE 검색)
  /// [dimensionType]: 'equityType' | 'liquidity' | 'assetType'
  Future<List<AccountWithShares>> findByDimensionPath(
    String dimensionType,
    String pathPrefix,
  ) async {
    final query = select(accounts).join([
      leftOuterJoin(
        accountOwnerShares,
        accountOwnerShares.accountId.equalsExp(accounts.id),
      ),
    ]);

    switch (dimensionType) {
      case 'equityType':
        query.where(accounts.equityTypePath.like('$pathPrefix%'));
      case 'liquidity':
        query.where(accounts.liquidityPath.like('$pathPrefix%'));
      case 'assetType':
        query.where(accounts.assetTypePath.like('$pathPrefix%'));
      default:
        // 유효하지 않은 dimensionType → 빈 목록 반환 (전체 조회 방지)
        return [];
    }

    return _groupByAccount(await query.get());
  }

  /// 활성 계정만 조회
  Future<List<AccountWithShares>> findActive() async {
    final query = select(accounts).join([
      leftOuterJoin(
        accountOwnerShares,
        accountOwnerShares.accountId.equalsExp(accounts.id),
      ),
    ])..where(accounts.isActive.equals(true));

    return _groupByAccount(await query.get());
  }

  // ---------------------------------------------------------------------------
  // Stream 조회 (실시간 갱신)
  // ---------------------------------------------------------------------------

  /// 전체 계정 트리 실시간 감시 — UI 트리뷰 갱신용
  Stream<List<AccountWithShares>> watchAccountTree() {
    final query = (select(accounts)
      ..where((a) => a.isActive.equals(true))
      ..orderBy([(a) => OrderingTerm.asc(a.equityTypePath)]));

    return query.watch().asyncMap((listRows) async {
      if (listRows.isEmpty) return [];
      final listIds = listRows.map((r) => r.id).toList();
      final listShares = await (select(accountOwnerShares)
            ..where((s) => s.accountId.isIn(listIds)))
          .get();
      return listRows.map((row) {
        final rowShares = listShares
            .where((s) => s.accountId == row.id)
            .map((s) => OwnerShareRow(ownerId: s.ownerId, shareRatio: s.shareRatio))
            .toList();
        return _accountRowToWithShares(row, rowShares);
      }).toList();
    });
  }

  // ---------------------------------------------------------------------------
  // 내부 변환 헬퍼
  // ---------------------------------------------------------------------------

  /// JOIN 결과 rows (단일 account) → AccountWithShares
  AccountWithShares _toAccountWithShares(
    List<TypedResult> listRows,
  ) {
    final firstRow = listRows.first.readTable(accounts);
    final listShares = listRows
        .map((r) => r.readTableOrNull(accountOwnerShares))
        .whereType<AccountOwnerShare>()
        .map((s) => OwnerShareRow(ownerId: s.ownerId, shareRatio: s.shareRatio))
        .toList();
    return _accountRowToWithShares(firstRow, listShares);
  }

  /// JOIN 결과 rows (복수 account) → AccountWithShares 목록
  List<AccountWithShares> _groupByAccount(List<TypedResult> listRows) {
    final mapGroups = <int, List<TypedResult>>{};
    for (final row in listRows) {
      final accountRow = row.readTable(accounts);
      mapGroups.putIfAbsent(accountRow.id, () => []).add(row);
    }
    return mapGroups.values
        .map((listGroupRows) => _toAccountWithShares(listGroupRows))
        .toList();
  }

  /// Account row + shares → AccountWithShares
  AccountWithShares _accountRowToWithShares(
    Account row,
    List<OwnerShareRow> listShares,
  ) {
    return AccountWithShares(
      id: row.id,
      name: row.name,
      nature: row.nature,
      equityTypeId: row.equityTypeId,
      equityTypePath: row.equityTypePath,
      liquidityId: row.liquidityId,
      liquidityPath: row.liquidityPath,
      assetTypeId: row.assetTypeId,
      assetTypePath: row.assetTypePath,
      defaultActivityTypeId: row.defaultActivityTypeId,
      defaultIncomeTypeId: row.defaultIncomeTypeId,
      ownerId: row.ownerId,
      productType: row.productType,
      financialInstitution: row.financialInstitution,
      countrySpecific: row.countrySpecific,
      isActive: row.isActive,
      listOwnerShares: listShares,
    );
  }
}
