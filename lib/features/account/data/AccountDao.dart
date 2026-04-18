import 'package:drift/drift.dart';

// TODO: Ryan이 Drift 테이블 작성 완료 후 실제 import 경로로 교체
// import '../../../infrastructure/database/AppDatabase.dart';
// import '../../../infrastructure/database/tables/Accounts.dart';
// import '../../../infrastructure/database/tables/AccountOwnerShares.dart';
// import '../../../infrastructure/database/tables/DimensionValues.dart';
// import '../../../infrastructure/database/tables/Owners.dart';

// TODO: AppDatabase 타입이 확정되면 제네릭 교체
// part 'AccountDao.g.dart';

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

/// Account DAO — 계정과목 CRUD + Path 기반 조회.
/// Drift @DriftAccessor로 생성되며, AppDatabase를 주입받는다.
///
/// TODO: Ryan의 Drift 테이블 머지 후 @DriftAccessor 어노테이션 활성화:
/// @DriftAccessor(tables: [Accounts, DimensionValues, AccountOwnerShares, Owners])
/// class AccountDao extends DatabaseAccessor<AppDatabase> with _$AccountDaoMixin {
class AccountDao {
  // TODO: AppDatabase 확정 후 super(db) 생성자로 교체
  // AccountDao(super.db);

  // ---------------------------------------------------------------------------
  // CRUD
  // ---------------------------------------------------------------------------

  /// 계정 생성 — Accounts 테이블에 INSERT
  Future<int> insertAccount(Map<String, dynamic> mapEntry) async {
    // TODO: Drift Companion 사용으로 교체
    // return into(accounts).insert(AccountsCompanion(...));
    throw UnimplementedError('Drift 테이블 머지 후 구현');
  }

  /// 계정 수정 — Accounts 테이블 UPDATE
  Future<bool> updateAccount(int id, Map<String, dynamic> mapEntry) async {
    // TODO: Drift update 구현
    // return (update(accounts)..where((a) => a.id.equals(id))).write(...);
    throw UnimplementedError('Drift 테이블 머지 후 구현');
  }

  /// 계정 삭제 — 물리 삭제 (비활성화 권장, 삭제는 예외적)
  Future<int> deleteAccount(int id) async {
    // TODO: Drift delete 구현
    // return (delete(accounts)..where((a) => a.id.equals(id))).go();
    throw UnimplementedError('Drift 테이블 머지 후 구현');
  }

  // ---------------------------------------------------------------------------
  // 조회
  // ---------------------------------------------------------------------------

  /// ID로 계정 조회 — OwnerShares JOIN 포함
  Future<AccountWithShares?> findById(int id) async {
    // TODO: Drift JOIN 쿼리 구현
    // select(accounts).join([
    //   leftOuterJoin(accountOwnerShares,
    //     accountOwnerShares.accountId.equalsExp(accounts.id)),
    // ])..where(accounts.id.equals(id));
    throw UnimplementedError('Drift 테이블 머지 후 구현');
  }

  /// 계정 성격(nature)별 조회
  Future<List<AccountWithShares>> findByNature(String nature) async {
    // TODO: WHERE accounts.nature = :nature
    throw UnimplementedError('Drift 테이블 머지 후 구현');
  }

  /// 분류축 경로 접두사 기반 조회 (Materialized Path LIKE 검색)
  /// dimensionType에 따라 equityTypePath/liquidityPath/assetTypePath 사용
  Future<List<AccountWithShares>> findByDimensionPath(
    String dimensionType,
    String pathPrefix,
  ) async {
    // TODO: Drift 쿼리 — dimensionType에 따라 컬럼 선택 후 LIKE
    // 예: WHERE equity_type_path LIKE 'ASSET.CURRENT%'
    // switch (dimensionType) {
    //   case 'equityType': column = accounts.equityTypePath;
    //   case 'liquidity': column = accounts.liquidityPath;
    //   case 'assetType': column = accounts.assetTypePath;
    // }
    // select(accounts)..where((a) => column.like('$pathPrefix%'));
    throw UnimplementedError('Drift 테이블 머지 후 구현');
  }

  /// 활성 계정만 조회
  Future<List<AccountWithShares>> findActive() async {
    // TODO: WHERE is_active = true
    throw UnimplementedError('Drift 테이블 머지 후 구현');
  }

  // ---------------------------------------------------------------------------
  // Stream 조회 (실시간 갱신)
  // ---------------------------------------------------------------------------

  /// 전체 계정 트리 실시간 감시 — UI 트리뷰 갱신용
  Stream<List<AccountWithShares>> watchAccountTree() {
    // TODO: Drift watch 쿼리
    // return (select(accounts)
    //   ..where((a) => a.isActive.equals(true))
    //   ..orderBy([(a) => OrderingTerm.asc(a.equityTypePath)]))
    //   .watch()
    //   .asyncMap((listRows) => _attachOwnerShares(listRows));
    throw UnimplementedError('Drift 테이블 머지 후 구현');
  }
}
