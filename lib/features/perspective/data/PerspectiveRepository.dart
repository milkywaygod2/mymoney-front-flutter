import '../../../core/constants/Enums.dart';
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
    final row = await _dao.findById(id.value);
    if (row == null) return null;
    return _toDomain(row);
  }

  @override
  Future<List<domain.Perspective>> findByOwner(OwnerId ownerId) async {
    final listRows = await _dao.findByOwner(ownerId.value);
    return listRows.map(_toDomain).toList();
  }

  @override
  Future<List<domain.Perspective>> findSystem() async {
    final listRows = await _dao.findSystem();
    return listRows.map(_toDomain).toList();
  }

  @override
  Future<void> save(domain.Perspective perspective) async {
    // TODO: domain -> Drift Companion 변환 + insert/update
    throw UnimplementedError('PerspectiveRepository.save');
  }

  @override
  Future<void> delete(PerspectiveId id) async {
    await _dao.deletePerspective(id.value);
  }

  /// Drift Perspective row -> domain.Perspective 변환
  domain.Perspective _toDomain(dynamic row) {
    return domain.Perspective(
      id: PerspectiveId(row.id as int),
      name: row.name as String,
      ownerId: OwnerId(row.ownerId as int),
      isSystem: row.isSystem as bool,
      mapDimensionFilters: const {},
      mapAccountAttributeFilters: const {},
      listTagFilters: const [],
      recordingDirection: RecordingDirection.normal,
      baseCurrency: null,
      permissionLevel: PermissionLevel.full,
    );
  }
}
