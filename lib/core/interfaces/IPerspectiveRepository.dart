import '../models/TypedId.dart';
import '../domain/Perspective.dart';

/// Perspective(관점) 저장소 인터페이스.
/// 프리셋 CRUD + 시스템 프리셋 보호.
abstract interface class IPerspectiveRepository {
  /// ID로 관점 조회
  Future<Perspective?> findById(PerspectiveId id);

  /// 소유자별 관점 목록 조회
  Future<List<Perspective>> findByOwner(OwnerId ownerId);

  /// 시스템 기본 프리셋 목록 조회
  Future<List<Perspective>> findSystem();

  /// 관점 저장 (생성 + 수정)
  Future<void> save(Perspective perspective);

  /// 관점 삭제 — INV-P2: isSystem==true이면 거부
  Future<void> delete(PerspectiveId id);
}
