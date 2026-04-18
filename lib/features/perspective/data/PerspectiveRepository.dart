import '../../../core/domain/Perspective.dart' as domain;
import '../../../core/interfaces/IPerspectiveRepository.dart';
import '../../../core/models/TypedId.dart';
import 'PerspectiveDao.dart';

/// IPerspectiveRepository 구현체
class PerspectiveRepository implements IPerspectiveRepository {
  PerspectiveRepository(this._dao);
  final PerspectiveDao _dao;

  @override
  Future<domain.Perspective?> findById(PerspectiveId id) async {
    // TODO: Drift row -> domain.Perspective 변환
    throw UnimplementedError();
  }

  @override
  Future<List<domain.Perspective>> findByOwner(OwnerId ownerId) async {
    throw UnimplementedError();
  }

  @override
  Future<List<domain.Perspective>> findSystem() async {
    throw UnimplementedError();
  }

  @override
  Future<void> save(domain.Perspective perspective) async {
    throw UnimplementedError();
  }

  @override
  Future<void> delete(PerspectiveId id) async {
    throw UnimplementedError();
  }
}
