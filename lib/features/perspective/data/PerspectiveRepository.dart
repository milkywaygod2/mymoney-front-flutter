import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/constants/Enums.dart';
import '../../../core/domain/Perspective.dart' as domain;
import '../../../core/errors/DomainErrors.dart';
import '../../../core/interfaces/IPerspectiveRepository.dart';
import '../../../core/models/TypedId.dart';
import '../../../infrastructure/database/AppDatabase.dart';
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
    // mapDimensionFilters: Map<String, List<DimensionValueId>> → JSON
    final mapDimJson = perspective.mapDimensionFilters.map(
      (k, v) => MapEntry(k, v.map((id) => id.value).toList()),
    );
    // mapAccountAttributeFilters: Map<String, List<String>> → JSON
    final mapAttrJson = perspective.mapAccountAttributeFilters;
    // listTagFilters: List<TagId> → JSON
    final listTagJson = perspective.listTagFilters.map((t) => t.value).toList();

    final companion = PerspectivesCompanion(
      id: perspective.id.value == 0
          ? const Value.absent()
          : Value(perspective.id.value),
      name: Value(perspective.name),
      ownerId: Value(perspective.ownerId.value),
      isSystem: Value(perspective.isSystem),
      dimensionFilters: Value(jsonEncode(mapDimJson)),
      accountAttributeFilters: Value(jsonEncode(mapAttrJson)),
      tagFilters: Value(jsonEncode(listTagJson)),
      recordingDirection: Value(perspective.recordingDirection.name.toUpperCase()),
      baseCurrency: Value(perspective.baseCurrency?.name),
      permissionLevel: Value(perspective.permissionLevel.name.toUpperCase()),
    );

    final existing = await _dao.findById(perspective.id.value);
    if (existing == null) {
      await _dao.insertPerspective(companion);
    } else {
      await _dao.updatePerspective(companion);
    }
  }

  @override
  Future<void> delete(PerspectiveId id) async {
    final row = await _dao.findById(id.value);
    if (row != null && row.isSystem) {
      throw const SystemPresetModificationError();
    }
    await _dao.deletePerspective(id.value);
  }

  /// Drift Perspective row -> domain.Perspective 변환
  domain.Perspective _toDomain(dynamic row) {
    // dimensionFilters JSON 파싱: {"EQUITY_TYPE":[1,2,3],...}
    Map<String, List<DimensionValueId>> mapDimFilters = const {};
    try {
      final rawDim = row.dimensionFilters as String?;
      if (rawDim != null && rawDim.isNotEmpty) {
        final decoded = jsonDecode(rawDim) as Map<String, dynamic>;
        mapDimFilters = decoded.map(
          (k, v) => MapEntry(
            k,
            (v as List).map((id) => DimensionValueId(id as int)).toList(),
          ),
        );
      }
    } catch (_) {}

    // accountAttributeFilters JSON 파싱: {"currency":["KRW"],...}
    Map<String, List<String>> mapAttrFilters = const {};
    try {
      final rawAttr = row.accountAttributeFilters as String?;
      if (rawAttr != null && rawAttr.isNotEmpty) {
        final decoded = jsonDecode(rawAttr) as Map<String, dynamic>;
        mapAttrFilters = decoded.map(
          (k, v) => MapEntry(k, (v as List).cast<String>()),
        );
      }
    } catch (_) {}

    // tagFilters JSON 파싱: [1,2,3]
    List<TagId> listTagFilters = const [];
    try {
      final rawTags = row.tagFilters as String?;
      if (rawTags != null && rawTags.isNotEmpty) {
        final decoded = jsonDecode(rawTags) as List;
        listTagFilters = decoded.map((id) => TagId(id as int)).toList();
      }
    } catch (_) {}

    // recordingDirection 파싱 (대소문자 무관)
    RecordingDirection direction = RecordingDirection.normal;
    try {
      final rawDir = row.recordingDirection as String?;
      if (rawDir != null) {
        direction = RecordingDirection.values.byName(rawDir.toLowerCase());
      }
    } catch (_) {}

    // permissionLevel 파싱
    PermissionLevel permission = PermissionLevel.full;
    try {
      final rawPerm = row.permissionLevel as String?;
      if (rawPerm != null) {
        permission = PermissionLevel.values.byName(rawPerm.toLowerCase());
      }
    } catch (_) {}

    return domain.Perspective(
      id: PerspectiveId(row.id as int),
      name: row.name as String,
      ownerId: OwnerId(row.ownerId as int),
      isSystem: row.isSystem as bool,
      mapDimensionFilters: mapDimFilters,
      mapAccountAttributeFilters: mapAttrFilters,
      listTagFilters: listTagFilters,
      recordingDirection: direction,
      baseCurrency: null, // TODO: CurrencyCode 파싱 (row.baseCurrency)
      permissionLevel: permission,
    );
  }
}
