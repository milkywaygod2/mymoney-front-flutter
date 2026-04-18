import '../models/TypedId.dart';
import '../domain/Counterparty.dart';

/// Counterparty(거래처) 저장소 인터페이스.
/// 거래처 CRUD + 별칭(alias) 매칭 + 유일성 검증.
abstract interface class ICounterpartyRepository {
  /// ID로 거래처 조회
  Future<Counterparty?> findById(CounterpartyId id);

  /// 별칭으로 거래처 조회 (OCR 텍스트 → 거래처 매핑)
  Future<Counterparty?> findByAlias(String alias);

  /// 이름/별칭 검색 (부분 일치)
  Future<List<Counterparty>> search(String query);

  /// 거래처 저장 (생성 + 수정)
  Future<void> save(Counterparty counterparty);

  /// 별칭 유일성 검증 — INV-C3: 전체 거래처에서 별칭 중복 불가
  Future<bool> isAliasUnique(String alias);
}
