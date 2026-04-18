// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PerspectiveDao.dart';

// ignore_for_file: type=lint
mixin _$PerspectiveDaoMixin on DatabaseAccessor<AppDatabase> {
  $OwnersTable get owners => attachedDatabase.owners;
  $PerspectivesTable get perspectives => attachedDatabase.perspectives;
  PerspectiveDaoManager get managers => PerspectiveDaoManager(this);
}

class PerspectiveDaoManager {
  final _$PerspectiveDaoMixin _db;
  PerspectiveDaoManager(this._db);
  $$OwnersTableTableManager get owners =>
      $$OwnersTableTableManager(_db.attachedDatabase, _db.owners);
  $$PerspectivesTableTableManager get perspectives =>
      $$PerspectivesTableTableManager(_db.attachedDatabase, _db.perspectives);
}
