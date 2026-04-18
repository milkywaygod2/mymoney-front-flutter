import 'package:drift/drift.dart';

import '../../../infrastructure/database/AppDatabase.dart';
import '../../../infrastructure/database/tables/PerspectiveTable.dart';

part 'PerspectiveDao.g.dart';

/// Perspective Drift DAO
@DriftAccessor(tables: [Perspectives])
class PerspectiveDao extends DatabaseAccessor<AppDatabase>
    with _$PerspectiveDaoMixin {
  PerspectiveDao(super.db);

  Future<List<Perspective>> findAll() => select(perspectives).get();

  Future<Perspective?> findById(int id) =>
      (select(perspectives)..where((p) => p.id.equals(id))).getSingleOrNull();

  Future<List<Perspective>> findByOwner(int ownerId) =>
      (select(perspectives)..where((p) => p.ownerId.equals(ownerId))).get();

  Future<List<Perspective>> findSystem() =>
      (select(perspectives)..where((p) => p.isSystem.equals(true))).get();

  Future<int> insertPerspective(PerspectivesCompanion entry) =>
      into(perspectives).insert(entry);

  Future<bool> updatePerspective(PerspectivesCompanion entry) =>
      update(perspectives).replace(entry);

  Future<int> deletePerspective(int id) =>
      (delete(perspectives)..where((p) => p.id.equals(id))).go();
}
