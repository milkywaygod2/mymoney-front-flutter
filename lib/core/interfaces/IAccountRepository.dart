import '../models/TypedId.dart';
import '../constants/Enums.dart';

// Account는 Sofia 워크트리에서 동시 작성 중 — 머지 후 import 경로 확정
// import '../domain/Account.dart';

/// 계정과목(Account) 저장소 인터페이스.
/// 계정과목 CRUD + 분류축 경로 기반 조회.
abstract interface class IAccountRepository {
  /// ID로 계정 조회
  Future<dynamic> findById(AccountId id);

  /// 계정 성격(nature)별 조회
  Future<List<dynamic>> findByNature(AccountNature nature);

  /// 분류축 경로 접두사 기반 조회 (Materialized Path LIKE 검색)
  Future<List<dynamic>> findByDimensionPath(
    DimensionType dimensionType,
    String pathPrefix,
  );

  /// 활성 계정만 조회
  Future<List<dynamic>> findActive();

  /// 계정 저장 (생성 + 수정)
  Future<void> save(dynamic account);
}
