// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppDatabase.dart';

// ignore_for_file: type=lint
class $DimensionValuesTable extends DimensionValues
    with TableInfo<$DimensionValuesTable, DimensionValue> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DimensionValuesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dimensionTypeMeta = const VerificationMeta(
    'dimensionType',
  );
  @override
  late final GeneratedColumn<String> dimensionType = GeneratedColumn<String>(
    'dimension_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES dimension_values (id)',
    ),
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ALL'),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dimensionType,
    code,
    name,
    parentId,
    path,
    entityType,
    sortOrder,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dimension_values';
  @override
  VerificationContext validateIntegrity(
    Insertable<DimensionValue> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('dimension_type')) {
      context.handle(
        _dimensionTypeMeta,
        dimensionType.isAcceptableOrUnknown(
          data['dimension_type']!,
          _dimensionTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dimensionTypeMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DimensionValue map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DimensionValue(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      dimensionType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}dimension_type'],
          )!,
      code:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}code'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_id'],
      ),
      path:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}path'],
          )!,
      entityType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}entity_type'],
          )!,
      sortOrder:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}sort_order'],
          )!,
      isActive:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_active'],
          )!,
    );
  }

  @override
  $DimensionValuesTable createAlias(String alias) {
    return $DimensionValuesTable(attachedDatabase, alias);
  }
}

class DimensionValue extends DataClass implements Insertable<DimensionValue> {
  final int id;

  /// EQUITY_TYPE | LIQUIDITY | ASSET_TYPE | ACTIVITY_TYPE | INCOME_TYPE
  final String dimensionType;

  /// 코드값 (예: "ASSET", "CURRENT", "CASH")
  final String code;

  /// 표시명 (예: "자산", "유동", "현금성")
  final String name;

  /// 트리 자기참조 — 상위 노드 (null = 루트)
  final int? parentId;

  /// Materialized Path 캐시 (예: "ASSET.CURRENT.CASH")
  final String path;

  /// 회계주체 유형별 필터 (ALL | HOUSEHOLD | CORPORATE | GOVERNMENT)
  final String entityType;
  final int sortOrder;
  final bool isActive;
  const DimensionValue({
    required this.id,
    required this.dimensionType,
    required this.code,
    required this.name,
    this.parentId,
    required this.path,
    required this.entityType,
    required this.sortOrder,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['dimension_type'] = Variable<String>(dimensionType);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    map['path'] = Variable<String>(path);
    map['entity_type'] = Variable<String>(entityType);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  DimensionValuesCompanion toCompanion(bool nullToAbsent) {
    return DimensionValuesCompanion(
      id: Value(id),
      dimensionType: Value(dimensionType),
      code: Value(code),
      name: Value(name),
      parentId:
          parentId == null && nullToAbsent
              ? const Value.absent()
              : Value(parentId),
      path: Value(path),
      entityType: Value(entityType),
      sortOrder: Value(sortOrder),
      isActive: Value(isActive),
    );
  }

  factory DimensionValue.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DimensionValue(
      id: serializer.fromJson<int>(json['id']),
      dimensionType: serializer.fromJson<String>(json['dimensionType']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      parentId: serializer.fromJson<int?>(json['parentId']),
      path: serializer.fromJson<String>(json['path']),
      entityType: serializer.fromJson<String>(json['entityType']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dimensionType': serializer.toJson<String>(dimensionType),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'parentId': serializer.toJson<int?>(parentId),
      'path': serializer.toJson<String>(path),
      'entityType': serializer.toJson<String>(entityType),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  DimensionValue copyWith({
    int? id,
    String? dimensionType,
    String? code,
    String? name,
    Value<int?> parentId = const Value.absent(),
    String? path,
    String? entityType,
    int? sortOrder,
    bool? isActive,
  }) => DimensionValue(
    id: id ?? this.id,
    dimensionType: dimensionType ?? this.dimensionType,
    code: code ?? this.code,
    name: name ?? this.name,
    parentId: parentId.present ? parentId.value : this.parentId,
    path: path ?? this.path,
    entityType: entityType ?? this.entityType,
    sortOrder: sortOrder ?? this.sortOrder,
    isActive: isActive ?? this.isActive,
  );
  DimensionValue copyWithCompanion(DimensionValuesCompanion data) {
    return DimensionValue(
      id: data.id.present ? data.id.value : this.id,
      dimensionType:
          data.dimensionType.present
              ? data.dimensionType.value
              : this.dimensionType,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      path: data.path.present ? data.path.value : this.path,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DimensionValue(')
          ..write('id: $id, ')
          ..write('dimensionType: $dimensionType, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('path: $path, ')
          ..write('entityType: $entityType, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dimensionType,
    code,
    name,
    parentId,
    path,
    entityType,
    sortOrder,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DimensionValue &&
          other.id == this.id &&
          other.dimensionType == this.dimensionType &&
          other.code == this.code &&
          other.name == this.name &&
          other.parentId == this.parentId &&
          other.path == this.path &&
          other.entityType == this.entityType &&
          other.sortOrder == this.sortOrder &&
          other.isActive == this.isActive);
}

class DimensionValuesCompanion extends UpdateCompanion<DimensionValue> {
  final Value<int> id;
  final Value<String> dimensionType;
  final Value<String> code;
  final Value<String> name;
  final Value<int?> parentId;
  final Value<String> path;
  final Value<String> entityType;
  final Value<int> sortOrder;
  final Value<bool> isActive;
  const DimensionValuesCompanion({
    this.id = const Value.absent(),
    this.dimensionType = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.parentId = const Value.absent(),
    this.path = const Value.absent(),
    this.entityType = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  DimensionValuesCompanion.insert({
    this.id = const Value.absent(),
    required String dimensionType,
    required String code,
    required String name,
    this.parentId = const Value.absent(),
    required String path,
    this.entityType = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : dimensionType = Value(dimensionType),
       code = Value(code),
       name = Value(name),
       path = Value(path);
  static Insertable<DimensionValue> custom({
    Expression<int>? id,
    Expression<String>? dimensionType,
    Expression<String>? code,
    Expression<String>? name,
    Expression<int>? parentId,
    Expression<String>? path,
    Expression<String>? entityType,
    Expression<int>? sortOrder,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dimensionType != null) 'dimension_type': dimensionType,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (parentId != null) 'parent_id': parentId,
      if (path != null) 'path': path,
      if (entityType != null) 'entity_type': entityType,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isActive != null) 'is_active': isActive,
    });
  }

  DimensionValuesCompanion copyWith({
    Value<int>? id,
    Value<String>? dimensionType,
    Value<String>? code,
    Value<String>? name,
    Value<int?>? parentId,
    Value<String>? path,
    Value<String>? entityType,
    Value<int>? sortOrder,
    Value<bool>? isActive,
  }) {
    return DimensionValuesCompanion(
      id: id ?? this.id,
      dimensionType: dimensionType ?? this.dimensionType,
      code: code ?? this.code,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      path: path ?? this.path,
      entityType: entityType ?? this.entityType,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dimensionType.present) {
      map['dimension_type'] = Variable<String>(dimensionType.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DimensionValuesCompanion(')
          ..write('id: $id, ')
          ..write('dimensionType: $dimensionType, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('path: $path, ')
          ..write('entityType: $entityType, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $OwnersTable extends Owners with TableInfo<$OwnersTable, Owner> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OwnersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'owners';
  @override
  VerificationContext validateIntegrity(
    Insertable<Owner> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Owner map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Owner(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      isActive:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_active'],
          )!,
    );
  }

  @override
  $OwnersTable createAlias(String alias) {
    return $OwnersTable(attachedDatabase, alias);
  }
}

class Owner extends DataClass implements Insertable<Owner> {
  final int id;

  /// 이름 (예: "형두", "유리")
  final String name;
  final bool isActive;
  const Owner({required this.id, required this.name, required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  OwnersCompanion toCompanion(bool nullToAbsent) {
    return OwnersCompanion(
      id: Value(id),
      name: Value(name),
      isActive: Value(isActive),
    );
  }

  factory Owner.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Owner(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Owner copyWith({int? id, String? name, bool? isActive}) => Owner(
    id: id ?? this.id,
    name: name ?? this.name,
    isActive: isActive ?? this.isActive,
  );
  Owner copyWithCompanion(OwnersCompanion data) {
    return Owner(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Owner(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Owner &&
          other.id == this.id &&
          other.name == this.name &&
          other.isActive == this.isActive);
}

class OwnersCompanion extends UpdateCompanion<Owner> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> isActive;
  const OwnersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  OwnersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.isActive = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Owner> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isActive != null) 'is_active': isActive,
    });
  }

  OwnersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<bool>? isActive,
  }) {
    return OwnersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OwnersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _natureMeta = const VerificationMeta('nature');
  @override
  late final GeneratedColumn<String> nature = GeneratedColumn<String>(
    'nature',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _equityTypeIdMeta = const VerificationMeta(
    'equityTypeId',
  );
  @override
  late final GeneratedColumn<int> equityTypeId = GeneratedColumn<int>(
    'equity_type_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES dimension_values (id)',
    ),
  );
  static const VerificationMeta _equityTypePathMeta = const VerificationMeta(
    'equityTypePath',
  );
  @override
  late final GeneratedColumn<String> equityTypePath = GeneratedColumn<String>(
    'equity_type_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _liquidityIdMeta = const VerificationMeta(
    'liquidityId',
  );
  @override
  late final GeneratedColumn<int> liquidityId = GeneratedColumn<int>(
    'liquidity_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES dimension_values (id)',
    ),
  );
  static const VerificationMeta _liquidityPathMeta = const VerificationMeta(
    'liquidityPath',
  );
  @override
  late final GeneratedColumn<String> liquidityPath = GeneratedColumn<String>(
    'liquidity_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assetTypeIdMeta = const VerificationMeta(
    'assetTypeId',
  );
  @override
  late final GeneratedColumn<int> assetTypeId = GeneratedColumn<int>(
    'asset_type_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES dimension_values (id)',
    ),
  );
  static const VerificationMeta _assetTypePathMeta = const VerificationMeta(
    'assetTypePath',
  );
  @override
  late final GeneratedColumn<String> assetTypePath = GeneratedColumn<String>(
    'asset_type_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultActivityTypeIdMeta =
      const VerificationMeta('defaultActivityTypeId');
  @override
  late final GeneratedColumn<int> defaultActivityTypeId = GeneratedColumn<int>(
    'default_activity_type_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES dimension_values (id)',
    ),
  );
  static const VerificationMeta _defaultIncomeTypeIdMeta =
      const VerificationMeta('defaultIncomeTypeId');
  @override
  late final GeneratedColumn<int> defaultIncomeTypeId = GeneratedColumn<int>(
    'default_income_type_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES dimension_values (id)',
    ),
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<int> ownerId = GeneratedColumn<int>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES owners (id)',
    ),
  );
  static const VerificationMeta _productTypeMeta = const VerificationMeta(
    'productType',
  );
  @override
  late final GeneratedColumn<String> productType = GeneratedColumn<String>(
    'product_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _financialInstitutionMeta =
      const VerificationMeta('financialInstitution');
  @override
  late final GeneratedColumn<String> financialInstitution =
      GeneratedColumn<String>(
        'financial_institution',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _countrySpecificMeta = const VerificationMeta(
    'countrySpecific',
  );
  @override
  late final GeneratedColumn<String> countrySpecific = GeneratedColumn<String>(
    'country_specific',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    nature,
    equityTypeId,
    equityTypePath,
    liquidityId,
    liquidityPath,
    assetTypeId,
    assetTypePath,
    defaultActivityTypeId,
    defaultIncomeTypeId,
    ownerId,
    productType,
    financialInstitution,
    countrySpecific,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Account> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('nature')) {
      context.handle(
        _natureMeta,
        nature.isAcceptableOrUnknown(data['nature']!, _natureMeta),
      );
    } else if (isInserting) {
      context.missing(_natureMeta);
    }
    if (data.containsKey('equity_type_id')) {
      context.handle(
        _equityTypeIdMeta,
        equityTypeId.isAcceptableOrUnknown(
          data['equity_type_id']!,
          _equityTypeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_equityTypeIdMeta);
    }
    if (data.containsKey('equity_type_path')) {
      context.handle(
        _equityTypePathMeta,
        equityTypePath.isAcceptableOrUnknown(
          data['equity_type_path']!,
          _equityTypePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_equityTypePathMeta);
    }
    if (data.containsKey('liquidity_id')) {
      context.handle(
        _liquidityIdMeta,
        liquidityId.isAcceptableOrUnknown(
          data['liquidity_id']!,
          _liquidityIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_liquidityIdMeta);
    }
    if (data.containsKey('liquidity_path')) {
      context.handle(
        _liquidityPathMeta,
        liquidityPath.isAcceptableOrUnknown(
          data['liquidity_path']!,
          _liquidityPathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_liquidityPathMeta);
    }
    if (data.containsKey('asset_type_id')) {
      context.handle(
        _assetTypeIdMeta,
        assetTypeId.isAcceptableOrUnknown(
          data['asset_type_id']!,
          _assetTypeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_assetTypeIdMeta);
    }
    if (data.containsKey('asset_type_path')) {
      context.handle(
        _assetTypePathMeta,
        assetTypePath.isAcceptableOrUnknown(
          data['asset_type_path']!,
          _assetTypePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_assetTypePathMeta);
    }
    if (data.containsKey('default_activity_type_id')) {
      context.handle(
        _defaultActivityTypeIdMeta,
        defaultActivityTypeId.isAcceptableOrUnknown(
          data['default_activity_type_id']!,
          _defaultActivityTypeIdMeta,
        ),
      );
    }
    if (data.containsKey('default_income_type_id')) {
      context.handle(
        _defaultIncomeTypeIdMeta,
        defaultIncomeTypeId.isAcceptableOrUnknown(
          data['default_income_type_id']!,
          _defaultIncomeTypeIdMeta,
        ),
      );
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('product_type')) {
      context.handle(
        _productTypeMeta,
        productType.isAcceptableOrUnknown(
          data['product_type']!,
          _productTypeMeta,
        ),
      );
    }
    if (data.containsKey('financial_institution')) {
      context.handle(
        _financialInstitutionMeta,
        financialInstitution.isAcceptableOrUnknown(
          data['financial_institution']!,
          _financialInstitutionMeta,
        ),
      );
    }
    if (data.containsKey('country_specific')) {
      context.handle(
        _countrySpecificMeta,
        countrySpecific.isAcceptableOrUnknown(
          data['country_specific']!,
          _countrySpecificMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      nature:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}nature'],
          )!,
      equityTypeId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}equity_type_id'],
          )!,
      equityTypePath:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}equity_type_path'],
          )!,
      liquidityId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}liquidity_id'],
          )!,
      liquidityPath:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}liquidity_path'],
          )!,
      assetTypeId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}asset_type_id'],
          )!,
      assetTypePath:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}asset_type_path'],
          )!,
      defaultActivityTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_activity_type_id'],
      ),
      defaultIncomeTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_income_type_id'],
      ),
      ownerId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}owner_id'],
          )!,
      productType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_type'],
      ),
      financialInstitution: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}financial_institution'],
      ),
      countrySpecific: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country_specific'],
      ),
      isActive:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_active'],
          )!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }
}

class Account extends DataClass implements Insertable<Account> {
  final int id;

  /// 계정명 (예: "우리은행 보통예금")
  final String name;

  /// 계정 성격: ASSET | LIABILITY | EQUITY | REVENUE | EXPENSE
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

  /// 상품구분 (예: 예금, 적금, 주식, 보험)
  final String? productType;

  /// 금융사 (예: 우리은행, 국민은행)
  final String? financialInstitution;

  /// 국가별 추가 정보 (JSON, 확장 예약)
  final String? countrySpecific;
  final bool isActive;
  const Account({
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
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['nature'] = Variable<String>(nature);
    map['equity_type_id'] = Variable<int>(equityTypeId);
    map['equity_type_path'] = Variable<String>(equityTypePath);
    map['liquidity_id'] = Variable<int>(liquidityId);
    map['liquidity_path'] = Variable<String>(liquidityPath);
    map['asset_type_id'] = Variable<int>(assetTypeId);
    map['asset_type_path'] = Variable<String>(assetTypePath);
    if (!nullToAbsent || defaultActivityTypeId != null) {
      map['default_activity_type_id'] = Variable<int>(defaultActivityTypeId);
    }
    if (!nullToAbsent || defaultIncomeTypeId != null) {
      map['default_income_type_id'] = Variable<int>(defaultIncomeTypeId);
    }
    map['owner_id'] = Variable<int>(ownerId);
    if (!nullToAbsent || productType != null) {
      map['product_type'] = Variable<String>(productType);
    }
    if (!nullToAbsent || financialInstitution != null) {
      map['financial_institution'] = Variable<String>(financialInstitution);
    }
    if (!nullToAbsent || countrySpecific != null) {
      map['country_specific'] = Variable<String>(countrySpecific);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      name: Value(name),
      nature: Value(nature),
      equityTypeId: Value(equityTypeId),
      equityTypePath: Value(equityTypePath),
      liquidityId: Value(liquidityId),
      liquidityPath: Value(liquidityPath),
      assetTypeId: Value(assetTypeId),
      assetTypePath: Value(assetTypePath),
      defaultActivityTypeId:
          defaultActivityTypeId == null && nullToAbsent
              ? const Value.absent()
              : Value(defaultActivityTypeId),
      defaultIncomeTypeId:
          defaultIncomeTypeId == null && nullToAbsent
              ? const Value.absent()
              : Value(defaultIncomeTypeId),
      ownerId: Value(ownerId),
      productType:
          productType == null && nullToAbsent
              ? const Value.absent()
              : Value(productType),
      financialInstitution:
          financialInstitution == null && nullToAbsent
              ? const Value.absent()
              : Value(financialInstitution),
      countrySpecific:
          countrySpecific == null && nullToAbsent
              ? const Value.absent()
              : Value(countrySpecific),
      isActive: Value(isActive),
    );
  }

  factory Account.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nature: serializer.fromJson<String>(json['nature']),
      equityTypeId: serializer.fromJson<int>(json['equityTypeId']),
      equityTypePath: serializer.fromJson<String>(json['equityTypePath']),
      liquidityId: serializer.fromJson<int>(json['liquidityId']),
      liquidityPath: serializer.fromJson<String>(json['liquidityPath']),
      assetTypeId: serializer.fromJson<int>(json['assetTypeId']),
      assetTypePath: serializer.fromJson<String>(json['assetTypePath']),
      defaultActivityTypeId: serializer.fromJson<int?>(
        json['defaultActivityTypeId'],
      ),
      defaultIncomeTypeId: serializer.fromJson<int?>(
        json['defaultIncomeTypeId'],
      ),
      ownerId: serializer.fromJson<int>(json['ownerId']),
      productType: serializer.fromJson<String?>(json['productType']),
      financialInstitution: serializer.fromJson<String?>(
        json['financialInstitution'],
      ),
      countrySpecific: serializer.fromJson<String?>(json['countrySpecific']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'nature': serializer.toJson<String>(nature),
      'equityTypeId': serializer.toJson<int>(equityTypeId),
      'equityTypePath': serializer.toJson<String>(equityTypePath),
      'liquidityId': serializer.toJson<int>(liquidityId),
      'liquidityPath': serializer.toJson<String>(liquidityPath),
      'assetTypeId': serializer.toJson<int>(assetTypeId),
      'assetTypePath': serializer.toJson<String>(assetTypePath),
      'defaultActivityTypeId': serializer.toJson<int?>(defaultActivityTypeId),
      'defaultIncomeTypeId': serializer.toJson<int?>(defaultIncomeTypeId),
      'ownerId': serializer.toJson<int>(ownerId),
      'productType': serializer.toJson<String?>(productType),
      'financialInstitution': serializer.toJson<String?>(financialInstitution),
      'countrySpecific': serializer.toJson<String?>(countrySpecific),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Account copyWith({
    int? id,
    String? name,
    String? nature,
    int? equityTypeId,
    String? equityTypePath,
    int? liquidityId,
    String? liquidityPath,
    int? assetTypeId,
    String? assetTypePath,
    Value<int?> defaultActivityTypeId = const Value.absent(),
    Value<int?> defaultIncomeTypeId = const Value.absent(),
    int? ownerId,
    Value<String?> productType = const Value.absent(),
    Value<String?> financialInstitution = const Value.absent(),
    Value<String?> countrySpecific = const Value.absent(),
    bool? isActive,
  }) => Account(
    id: id ?? this.id,
    name: name ?? this.name,
    nature: nature ?? this.nature,
    equityTypeId: equityTypeId ?? this.equityTypeId,
    equityTypePath: equityTypePath ?? this.equityTypePath,
    liquidityId: liquidityId ?? this.liquidityId,
    liquidityPath: liquidityPath ?? this.liquidityPath,
    assetTypeId: assetTypeId ?? this.assetTypeId,
    assetTypePath: assetTypePath ?? this.assetTypePath,
    defaultActivityTypeId:
        defaultActivityTypeId.present
            ? defaultActivityTypeId.value
            : this.defaultActivityTypeId,
    defaultIncomeTypeId:
        defaultIncomeTypeId.present
            ? defaultIncomeTypeId.value
            : this.defaultIncomeTypeId,
    ownerId: ownerId ?? this.ownerId,
    productType: productType.present ? productType.value : this.productType,
    financialInstitution:
        financialInstitution.present
            ? financialInstitution.value
            : this.financialInstitution,
    countrySpecific:
        countrySpecific.present ? countrySpecific.value : this.countrySpecific,
    isActive: isActive ?? this.isActive,
  );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nature: data.nature.present ? data.nature.value : this.nature,
      equityTypeId:
          data.equityTypeId.present
              ? data.equityTypeId.value
              : this.equityTypeId,
      equityTypePath:
          data.equityTypePath.present
              ? data.equityTypePath.value
              : this.equityTypePath,
      liquidityId:
          data.liquidityId.present ? data.liquidityId.value : this.liquidityId,
      liquidityPath:
          data.liquidityPath.present
              ? data.liquidityPath.value
              : this.liquidityPath,
      assetTypeId:
          data.assetTypeId.present ? data.assetTypeId.value : this.assetTypeId,
      assetTypePath:
          data.assetTypePath.present
              ? data.assetTypePath.value
              : this.assetTypePath,
      defaultActivityTypeId:
          data.defaultActivityTypeId.present
              ? data.defaultActivityTypeId.value
              : this.defaultActivityTypeId,
      defaultIncomeTypeId:
          data.defaultIncomeTypeId.present
              ? data.defaultIncomeTypeId.value
              : this.defaultIncomeTypeId,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      productType:
          data.productType.present ? data.productType.value : this.productType,
      financialInstitution:
          data.financialInstitution.present
              ? data.financialInstitution.value
              : this.financialInstitution,
      countrySpecific:
          data.countrySpecific.present
              ? data.countrySpecific.value
              : this.countrySpecific,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nature: $nature, ')
          ..write('equityTypeId: $equityTypeId, ')
          ..write('equityTypePath: $equityTypePath, ')
          ..write('liquidityId: $liquidityId, ')
          ..write('liquidityPath: $liquidityPath, ')
          ..write('assetTypeId: $assetTypeId, ')
          ..write('assetTypePath: $assetTypePath, ')
          ..write('defaultActivityTypeId: $defaultActivityTypeId, ')
          ..write('defaultIncomeTypeId: $defaultIncomeTypeId, ')
          ..write('ownerId: $ownerId, ')
          ..write('productType: $productType, ')
          ..write('financialInstitution: $financialInstitution, ')
          ..write('countrySpecific: $countrySpecific, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    nature,
    equityTypeId,
    equityTypePath,
    liquidityId,
    liquidityPath,
    assetTypeId,
    assetTypePath,
    defaultActivityTypeId,
    defaultIncomeTypeId,
    ownerId,
    productType,
    financialInstitution,
    countrySpecific,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.id == this.id &&
          other.name == this.name &&
          other.nature == this.nature &&
          other.equityTypeId == this.equityTypeId &&
          other.equityTypePath == this.equityTypePath &&
          other.liquidityId == this.liquidityId &&
          other.liquidityPath == this.liquidityPath &&
          other.assetTypeId == this.assetTypeId &&
          other.assetTypePath == this.assetTypePath &&
          other.defaultActivityTypeId == this.defaultActivityTypeId &&
          other.defaultIncomeTypeId == this.defaultIncomeTypeId &&
          other.ownerId == this.ownerId &&
          other.productType == this.productType &&
          other.financialInstitution == this.financialInstitution &&
          other.countrySpecific == this.countrySpecific &&
          other.isActive == this.isActive);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> nature;
  final Value<int> equityTypeId;
  final Value<String> equityTypePath;
  final Value<int> liquidityId;
  final Value<String> liquidityPath;
  final Value<int> assetTypeId;
  final Value<String> assetTypePath;
  final Value<int?> defaultActivityTypeId;
  final Value<int?> defaultIncomeTypeId;
  final Value<int> ownerId;
  final Value<String?> productType;
  final Value<String?> financialInstitution;
  final Value<String?> countrySpecific;
  final Value<bool> isActive;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nature = const Value.absent(),
    this.equityTypeId = const Value.absent(),
    this.equityTypePath = const Value.absent(),
    this.liquidityId = const Value.absent(),
    this.liquidityPath = const Value.absent(),
    this.assetTypeId = const Value.absent(),
    this.assetTypePath = const Value.absent(),
    this.defaultActivityTypeId = const Value.absent(),
    this.defaultIncomeTypeId = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.productType = const Value.absent(),
    this.financialInstitution = const Value.absent(),
    this.countrySpecific = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  AccountsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String nature,
    required int equityTypeId,
    required String equityTypePath,
    required int liquidityId,
    required String liquidityPath,
    required int assetTypeId,
    required String assetTypePath,
    this.defaultActivityTypeId = const Value.absent(),
    this.defaultIncomeTypeId = const Value.absent(),
    required int ownerId,
    this.productType = const Value.absent(),
    this.financialInstitution = const Value.absent(),
    this.countrySpecific = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : name = Value(name),
       nature = Value(nature),
       equityTypeId = Value(equityTypeId),
       equityTypePath = Value(equityTypePath),
       liquidityId = Value(liquidityId),
       liquidityPath = Value(liquidityPath),
       assetTypeId = Value(assetTypeId),
       assetTypePath = Value(assetTypePath),
       ownerId = Value(ownerId);
  static Insertable<Account> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? nature,
    Expression<int>? equityTypeId,
    Expression<String>? equityTypePath,
    Expression<int>? liquidityId,
    Expression<String>? liquidityPath,
    Expression<int>? assetTypeId,
    Expression<String>? assetTypePath,
    Expression<int>? defaultActivityTypeId,
    Expression<int>? defaultIncomeTypeId,
    Expression<int>? ownerId,
    Expression<String>? productType,
    Expression<String>? financialInstitution,
    Expression<String>? countrySpecific,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nature != null) 'nature': nature,
      if (equityTypeId != null) 'equity_type_id': equityTypeId,
      if (equityTypePath != null) 'equity_type_path': equityTypePath,
      if (liquidityId != null) 'liquidity_id': liquidityId,
      if (liquidityPath != null) 'liquidity_path': liquidityPath,
      if (assetTypeId != null) 'asset_type_id': assetTypeId,
      if (assetTypePath != null) 'asset_type_path': assetTypePath,
      if (defaultActivityTypeId != null)
        'default_activity_type_id': defaultActivityTypeId,
      if (defaultIncomeTypeId != null)
        'default_income_type_id': defaultIncomeTypeId,
      if (ownerId != null) 'owner_id': ownerId,
      if (productType != null) 'product_type': productType,
      if (financialInstitution != null)
        'financial_institution': financialInstitution,
      if (countrySpecific != null) 'country_specific': countrySpecific,
      if (isActive != null) 'is_active': isActive,
    });
  }

  AccountsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? nature,
    Value<int>? equityTypeId,
    Value<String>? equityTypePath,
    Value<int>? liquidityId,
    Value<String>? liquidityPath,
    Value<int>? assetTypeId,
    Value<String>? assetTypePath,
    Value<int?>? defaultActivityTypeId,
    Value<int?>? defaultIncomeTypeId,
    Value<int>? ownerId,
    Value<String?>? productType,
    Value<String?>? financialInstitution,
    Value<String?>? countrySpecific,
    Value<bool>? isActive,
  }) {
    return AccountsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nature: nature ?? this.nature,
      equityTypeId: equityTypeId ?? this.equityTypeId,
      equityTypePath: equityTypePath ?? this.equityTypePath,
      liquidityId: liquidityId ?? this.liquidityId,
      liquidityPath: liquidityPath ?? this.liquidityPath,
      assetTypeId: assetTypeId ?? this.assetTypeId,
      assetTypePath: assetTypePath ?? this.assetTypePath,
      defaultActivityTypeId:
          defaultActivityTypeId ?? this.defaultActivityTypeId,
      defaultIncomeTypeId: defaultIncomeTypeId ?? this.defaultIncomeTypeId,
      ownerId: ownerId ?? this.ownerId,
      productType: productType ?? this.productType,
      financialInstitution: financialInstitution ?? this.financialInstitution,
      countrySpecific: countrySpecific ?? this.countrySpecific,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nature.present) {
      map['nature'] = Variable<String>(nature.value);
    }
    if (equityTypeId.present) {
      map['equity_type_id'] = Variable<int>(equityTypeId.value);
    }
    if (equityTypePath.present) {
      map['equity_type_path'] = Variable<String>(equityTypePath.value);
    }
    if (liquidityId.present) {
      map['liquidity_id'] = Variable<int>(liquidityId.value);
    }
    if (liquidityPath.present) {
      map['liquidity_path'] = Variable<String>(liquidityPath.value);
    }
    if (assetTypeId.present) {
      map['asset_type_id'] = Variable<int>(assetTypeId.value);
    }
    if (assetTypePath.present) {
      map['asset_type_path'] = Variable<String>(assetTypePath.value);
    }
    if (defaultActivityTypeId.present) {
      map['default_activity_type_id'] = Variable<int>(
        defaultActivityTypeId.value,
      );
    }
    if (defaultIncomeTypeId.present) {
      map['default_income_type_id'] = Variable<int>(defaultIncomeTypeId.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<int>(ownerId.value);
    }
    if (productType.present) {
      map['product_type'] = Variable<String>(productType.value);
    }
    if (financialInstitution.present) {
      map['financial_institution'] = Variable<String>(
        financialInstitution.value,
      );
    }
    if (countrySpecific.present) {
      map['country_specific'] = Variable<String>(countrySpecific.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nature: $nature, ')
          ..write('equityTypeId: $equityTypeId, ')
          ..write('equityTypePath: $equityTypePath, ')
          ..write('liquidityId: $liquidityId, ')
          ..write('liquidityPath: $liquidityPath, ')
          ..write('assetTypeId: $assetTypeId, ')
          ..write('assetTypePath: $assetTypePath, ')
          ..write('defaultActivityTypeId: $defaultActivityTypeId, ')
          ..write('defaultIncomeTypeId: $defaultIncomeTypeId, ')
          ..write('ownerId: $ownerId, ')
          ..write('productType: $productType, ')
          ..write('financialInstitution: $financialInstitution, ')
          ..write('countrySpecific: $countrySpecific, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $AccountOwnerSharesTable extends AccountOwnerShares
    with TableInfo<$AccountOwnerSharesTable, AccountOwnerShare> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountOwnerSharesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<int> ownerId = GeneratedColumn<int>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES owners (id)',
    ),
  );
  static const VerificationMeta _shareRatioMeta = const VerificationMeta(
    'shareRatio',
  );
  @override
  late final GeneratedColumn<int> shareRatio = GeneratedColumn<int>(
    'share_ratio',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [accountId, ownerId, shareRatio];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'account_owner_shares';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccountOwnerShare> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('share_ratio')) {
      context.handle(
        _shareRatioMeta,
        shareRatio.isAcceptableOrUnknown(data['share_ratio']!, _shareRatioMeta),
      );
    } else if (isInserting) {
      context.missing(_shareRatioMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {accountId, ownerId};
  @override
  AccountOwnerShare map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountOwnerShare(
      accountId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}account_id'],
          )!,
      ownerId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}owner_id'],
          )!,
      shareRatio:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}share_ratio'],
          )!,
    );
  }

  @override
  $AccountOwnerSharesTable createAlias(String alias) {
    return $AccountOwnerSharesTable(attachedDatabase, alias);
  }
}

class AccountOwnerShare extends DataClass
    implements Insertable<AccountOwnerShare> {
  final int accountId;
  final int ownerId;

  /// 지분율 (배율 kShareRatioMultiplier=10000)
  final int shareRatio;
  const AccountOwnerShare({
    required this.accountId,
    required this.ownerId,
    required this.shareRatio,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['account_id'] = Variable<int>(accountId);
    map['owner_id'] = Variable<int>(ownerId);
    map['share_ratio'] = Variable<int>(shareRatio);
    return map;
  }

  AccountOwnerSharesCompanion toCompanion(bool nullToAbsent) {
    return AccountOwnerSharesCompanion(
      accountId: Value(accountId),
      ownerId: Value(ownerId),
      shareRatio: Value(shareRatio),
    );
  }

  factory AccountOwnerShare.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountOwnerShare(
      accountId: serializer.fromJson<int>(json['accountId']),
      ownerId: serializer.fromJson<int>(json['ownerId']),
      shareRatio: serializer.fromJson<int>(json['shareRatio']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'accountId': serializer.toJson<int>(accountId),
      'ownerId': serializer.toJson<int>(ownerId),
      'shareRatio': serializer.toJson<int>(shareRatio),
    };
  }

  AccountOwnerShare copyWith({int? accountId, int? ownerId, int? shareRatio}) =>
      AccountOwnerShare(
        accountId: accountId ?? this.accountId,
        ownerId: ownerId ?? this.ownerId,
        shareRatio: shareRatio ?? this.shareRatio,
      );
  AccountOwnerShare copyWithCompanion(AccountOwnerSharesCompanion data) {
    return AccountOwnerShare(
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      shareRatio:
          data.shareRatio.present ? data.shareRatio.value : this.shareRatio,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountOwnerShare(')
          ..write('accountId: $accountId, ')
          ..write('ownerId: $ownerId, ')
          ..write('shareRatio: $shareRatio')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(accountId, ownerId, shareRatio);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountOwnerShare &&
          other.accountId == this.accountId &&
          other.ownerId == this.ownerId &&
          other.shareRatio == this.shareRatio);
}

class AccountOwnerSharesCompanion extends UpdateCompanion<AccountOwnerShare> {
  final Value<int> accountId;
  final Value<int> ownerId;
  final Value<int> shareRatio;
  final Value<int> rowid;
  const AccountOwnerSharesCompanion({
    this.accountId = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.shareRatio = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountOwnerSharesCompanion.insert({
    required int accountId,
    required int ownerId,
    required int shareRatio,
    this.rowid = const Value.absent(),
  }) : accountId = Value(accountId),
       ownerId = Value(ownerId),
       shareRatio = Value(shareRatio);
  static Insertable<AccountOwnerShare> custom({
    Expression<int>? accountId,
    Expression<int>? ownerId,
    Expression<int>? shareRatio,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (accountId != null) 'account_id': accountId,
      if (ownerId != null) 'owner_id': ownerId,
      if (shareRatio != null) 'share_ratio': shareRatio,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountOwnerSharesCompanion copyWith({
    Value<int>? accountId,
    Value<int>? ownerId,
    Value<int>? shareRatio,
    Value<int>? rowid,
  }) {
    return AccountOwnerSharesCompanion(
      accountId: accountId ?? this.accountId,
      ownerId: ownerId ?? this.ownerId,
      shareRatio: shareRatio ?? this.shareRatio,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<int>(ownerId.value);
    }
    if (shareRatio.present) {
      map['share_ratio'] = Variable<int>(shareRatio.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountOwnerSharesCompanion(')
          ..write('accountId: $accountId, ')
          ..write('ownerId: $ownerId, ')
          ..write('shareRatio: $shareRatio, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CounterpartiesTable extends Counterparties
    with TableInfo<$CounterpartiesTable, Counterparty> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CounterpartiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _identifierMeta = const VerificationMeta(
    'identifier',
  );
  @override
  late final GeneratedColumn<String> identifier = GeneratedColumn<String>(
    'identifier',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _identifierTypeMeta = const VerificationMeta(
    'identifierType',
  );
  @override
  late final GeneratedColumn<String> identifierType = GeneratedColumn<String>(
    'identifier_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('NONE'),
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _confidenceLevelMeta = const VerificationMeta(
    'confidenceLevel',
  );
  @override
  late final GeneratedColumn<String> confidenceLevel = GeneratedColumn<String>(
    'confidence_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNKNOWN'),
  );
  static const VerificationMeta _isRelatedPartyMeta = const VerificationMeta(
    'isRelatedParty',
  );
  @override
  late final GeneratedColumn<bool> isRelatedParty = GeneratedColumn<bool>(
    'is_related_party',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_related_party" IN (0, 1))',
    ),
  );
  static const VerificationMeta _counterpartyTypeMeta = const VerificationMeta(
    'counterpartyType',
  );
  @override
  late final GeneratedColumn<String> counterpartyType = GeneratedColumn<String>(
    'counterparty_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _countryCodeMeta = const VerificationMeta(
    'countryCode',
  );
  @override
  late final GeneratedColumn<String> countryCode = GeneratedColumn<String>(
    'country_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    identifier,
    identifierType,
    phone,
    address,
    confidenceLevel,
    isRelatedParty,
    counterpartyType,
    countryCode,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'counterparties';
  @override
  VerificationContext validateIntegrity(
    Insertable<Counterparty> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('identifier')) {
      context.handle(
        _identifierMeta,
        identifier.isAcceptableOrUnknown(data['identifier']!, _identifierMeta),
      );
    }
    if (data.containsKey('identifier_type')) {
      context.handle(
        _identifierTypeMeta,
        identifierType.isAcceptableOrUnknown(
          data['identifier_type']!,
          _identifierTypeMeta,
        ),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('confidence_level')) {
      context.handle(
        _confidenceLevelMeta,
        confidenceLevel.isAcceptableOrUnknown(
          data['confidence_level']!,
          _confidenceLevelMeta,
        ),
      );
    }
    if (data.containsKey('is_related_party')) {
      context.handle(
        _isRelatedPartyMeta,
        isRelatedParty.isAcceptableOrUnknown(
          data['is_related_party']!,
          _isRelatedPartyMeta,
        ),
      );
    }
    if (data.containsKey('counterparty_type')) {
      context.handle(
        _counterpartyTypeMeta,
        counterpartyType.isAcceptableOrUnknown(
          data['counterparty_type']!,
          _counterpartyTypeMeta,
        ),
      );
    }
    if (data.containsKey('country_code')) {
      context.handle(
        _countryCodeMeta,
        countryCode.isAcceptableOrUnknown(
          data['country_code']!,
          _countryCodeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Counterparty map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Counterparty(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      identifier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}identifier'],
      ),
      identifierType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}identifier_type'],
          )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      confidenceLevel:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}confidence_level'],
          )!,
      isRelatedParty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_related_party'],
      ),
      counterpartyType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}counterparty_type'],
      ),
      countryCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country_code'],
      ),
    );
  }

  @override
  $CounterpartiesTable createAlias(String alias) {
    return $CounterpartiesTable(attachedDatabase, alias);
  }
}

class Counterparty extends DataClass implements Insertable<Counterparty> {
  final int id;
  final String name;

  /// 고유번호 (사업자번호/주민번호)
  final String? identifier;

  /// BUSINESS | PERSONAL | NONE
  final String identifierType;
  final String? phone;
  final String? address;

  /// VERIFIED | INFERRED | UNKNOWN
  final String confidenceLevel;

  /// 세무 확장 예약
  final bool? isRelatedParty;
  final String? counterpartyType;

  /// 해외 확장 예약 (CRS/FATCA)
  final String? countryCode;
  const Counterparty({
    required this.id,
    required this.name,
    this.identifier,
    required this.identifierType,
    this.phone,
    this.address,
    required this.confidenceLevel,
    this.isRelatedParty,
    this.counterpartyType,
    this.countryCode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || identifier != null) {
      map['identifier'] = Variable<String>(identifier);
    }
    map['identifier_type'] = Variable<String>(identifierType);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    map['confidence_level'] = Variable<String>(confidenceLevel);
    if (!nullToAbsent || isRelatedParty != null) {
      map['is_related_party'] = Variable<bool>(isRelatedParty);
    }
    if (!nullToAbsent || counterpartyType != null) {
      map['counterparty_type'] = Variable<String>(counterpartyType);
    }
    if (!nullToAbsent || countryCode != null) {
      map['country_code'] = Variable<String>(countryCode);
    }
    return map;
  }

  CounterpartiesCompanion toCompanion(bool nullToAbsent) {
    return CounterpartiesCompanion(
      id: Value(id),
      name: Value(name),
      identifier:
          identifier == null && nullToAbsent
              ? const Value.absent()
              : Value(identifier),
      identifierType: Value(identifierType),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      address:
          address == null && nullToAbsent
              ? const Value.absent()
              : Value(address),
      confidenceLevel: Value(confidenceLevel),
      isRelatedParty:
          isRelatedParty == null && nullToAbsent
              ? const Value.absent()
              : Value(isRelatedParty),
      counterpartyType:
          counterpartyType == null && nullToAbsent
              ? const Value.absent()
              : Value(counterpartyType),
      countryCode:
          countryCode == null && nullToAbsent
              ? const Value.absent()
              : Value(countryCode),
    );
  }

  factory Counterparty.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Counterparty(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      identifier: serializer.fromJson<String?>(json['identifier']),
      identifierType: serializer.fromJson<String>(json['identifierType']),
      phone: serializer.fromJson<String?>(json['phone']),
      address: serializer.fromJson<String?>(json['address']),
      confidenceLevel: serializer.fromJson<String>(json['confidenceLevel']),
      isRelatedParty: serializer.fromJson<bool?>(json['isRelatedParty']),
      counterpartyType: serializer.fromJson<String?>(json['counterpartyType']),
      countryCode: serializer.fromJson<String?>(json['countryCode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'identifier': serializer.toJson<String?>(identifier),
      'identifierType': serializer.toJson<String>(identifierType),
      'phone': serializer.toJson<String?>(phone),
      'address': serializer.toJson<String?>(address),
      'confidenceLevel': serializer.toJson<String>(confidenceLevel),
      'isRelatedParty': serializer.toJson<bool?>(isRelatedParty),
      'counterpartyType': serializer.toJson<String?>(counterpartyType),
      'countryCode': serializer.toJson<String?>(countryCode),
    };
  }

  Counterparty copyWith({
    int? id,
    String? name,
    Value<String?> identifier = const Value.absent(),
    String? identifierType,
    Value<String?> phone = const Value.absent(),
    Value<String?> address = const Value.absent(),
    String? confidenceLevel,
    Value<bool?> isRelatedParty = const Value.absent(),
    Value<String?> counterpartyType = const Value.absent(),
    Value<String?> countryCode = const Value.absent(),
  }) => Counterparty(
    id: id ?? this.id,
    name: name ?? this.name,
    identifier: identifier.present ? identifier.value : this.identifier,
    identifierType: identifierType ?? this.identifierType,
    phone: phone.present ? phone.value : this.phone,
    address: address.present ? address.value : this.address,
    confidenceLevel: confidenceLevel ?? this.confidenceLevel,
    isRelatedParty:
        isRelatedParty.present ? isRelatedParty.value : this.isRelatedParty,
    counterpartyType:
        counterpartyType.present
            ? counterpartyType.value
            : this.counterpartyType,
    countryCode: countryCode.present ? countryCode.value : this.countryCode,
  );
  Counterparty copyWithCompanion(CounterpartiesCompanion data) {
    return Counterparty(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      identifier:
          data.identifier.present ? data.identifier.value : this.identifier,
      identifierType:
          data.identifierType.present
              ? data.identifierType.value
              : this.identifierType,
      phone: data.phone.present ? data.phone.value : this.phone,
      address: data.address.present ? data.address.value : this.address,
      confidenceLevel:
          data.confidenceLevel.present
              ? data.confidenceLevel.value
              : this.confidenceLevel,
      isRelatedParty:
          data.isRelatedParty.present
              ? data.isRelatedParty.value
              : this.isRelatedParty,
      counterpartyType:
          data.counterpartyType.present
              ? data.counterpartyType.value
              : this.counterpartyType,
      countryCode:
          data.countryCode.present ? data.countryCode.value : this.countryCode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Counterparty(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('identifier: $identifier, ')
          ..write('identifierType: $identifierType, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('confidenceLevel: $confidenceLevel, ')
          ..write('isRelatedParty: $isRelatedParty, ')
          ..write('counterpartyType: $counterpartyType, ')
          ..write('countryCode: $countryCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    identifier,
    identifierType,
    phone,
    address,
    confidenceLevel,
    isRelatedParty,
    counterpartyType,
    countryCode,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Counterparty &&
          other.id == this.id &&
          other.name == this.name &&
          other.identifier == this.identifier &&
          other.identifierType == this.identifierType &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.confidenceLevel == this.confidenceLevel &&
          other.isRelatedParty == this.isRelatedParty &&
          other.counterpartyType == this.counterpartyType &&
          other.countryCode == this.countryCode);
}

class CounterpartiesCompanion extends UpdateCompanion<Counterparty> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> identifier;
  final Value<String> identifierType;
  final Value<String?> phone;
  final Value<String?> address;
  final Value<String> confidenceLevel;
  final Value<bool?> isRelatedParty;
  final Value<String?> counterpartyType;
  final Value<String?> countryCode;
  const CounterpartiesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.identifier = const Value.absent(),
    this.identifierType = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.confidenceLevel = const Value.absent(),
    this.isRelatedParty = const Value.absent(),
    this.counterpartyType = const Value.absent(),
    this.countryCode = const Value.absent(),
  });
  CounterpartiesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.identifier = const Value.absent(),
    this.identifierType = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.confidenceLevel = const Value.absent(),
    this.isRelatedParty = const Value.absent(),
    this.counterpartyType = const Value.absent(),
    this.countryCode = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Counterparty> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? identifier,
    Expression<String>? identifierType,
    Expression<String>? phone,
    Expression<String>? address,
    Expression<String>? confidenceLevel,
    Expression<bool>? isRelatedParty,
    Expression<String>? counterpartyType,
    Expression<String>? countryCode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (identifier != null) 'identifier': identifier,
      if (identifierType != null) 'identifier_type': identifierType,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (confidenceLevel != null) 'confidence_level': confidenceLevel,
      if (isRelatedParty != null) 'is_related_party': isRelatedParty,
      if (counterpartyType != null) 'counterparty_type': counterpartyType,
      if (countryCode != null) 'country_code': countryCode,
    });
  }

  CounterpartiesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? identifier,
    Value<String>? identifierType,
    Value<String?>? phone,
    Value<String?>? address,
    Value<String>? confidenceLevel,
    Value<bool?>? isRelatedParty,
    Value<String?>? counterpartyType,
    Value<String?>? countryCode,
  }) {
    return CounterpartiesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      identifier: identifier ?? this.identifier,
      identifierType: identifierType ?? this.identifierType,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      confidenceLevel: confidenceLevel ?? this.confidenceLevel,
      isRelatedParty: isRelatedParty ?? this.isRelatedParty,
      counterpartyType: counterpartyType ?? this.counterpartyType,
      countryCode: countryCode ?? this.countryCode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (identifier.present) {
      map['identifier'] = Variable<String>(identifier.value);
    }
    if (identifierType.present) {
      map['identifier_type'] = Variable<String>(identifierType.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (confidenceLevel.present) {
      map['confidence_level'] = Variable<String>(confidenceLevel.value);
    }
    if (isRelatedParty.present) {
      map['is_related_party'] = Variable<bool>(isRelatedParty.value);
    }
    if (counterpartyType.present) {
      map['counterparty_type'] = Variable<String>(counterpartyType.value);
    }
    if (countryCode.present) {
      map['country_code'] = Variable<String>(countryCode.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CounterpartiesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('identifier: $identifier, ')
          ..write('identifierType: $identifierType, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('confidenceLevel: $confidenceLevel, ')
          ..write('isRelatedParty: $isRelatedParty, ')
          ..write('counterpartyType: $counterpartyType, ')
          ..write('countryCode: $countryCode')
          ..write(')'))
        .toString();
  }
}

class $CounterpartyAliasesTable extends CounterpartyAliases
    with TableInfo<$CounterpartyAliasesTable, CounterpartyAliase> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CounterpartyAliasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _counterpartyIdMeta = const VerificationMeta(
    'counterpartyId',
  );
  @override
  late final GeneratedColumn<int> counterpartyId = GeneratedColumn<int>(
    'counterparty_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES counterparties (id)',
    ),
  );
  static const VerificationMeta _aliasMeta = const VerificationMeta('alias');
  @override
  late final GeneratedColumn<String> alias = GeneratedColumn<String>(
    'alias',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, counterpartyId, alias];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'counterparty_aliases';
  @override
  VerificationContext validateIntegrity(
    Insertable<CounterpartyAliase> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('counterparty_id')) {
      context.handle(
        _counterpartyIdMeta,
        counterpartyId.isAcceptableOrUnknown(
          data['counterparty_id']!,
          _counterpartyIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_counterpartyIdMeta);
    }
    if (data.containsKey('alias')) {
      context.handle(
        _aliasMeta,
        alias.isAcceptableOrUnknown(data['alias']!, _aliasMeta),
      );
    } else if (isInserting) {
      context.missing(_aliasMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CounterpartyAliase map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CounterpartyAliase(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      counterpartyId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}counterparty_id'],
          )!,
      alias:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}alias'],
          )!,
    );
  }

  @override
  $CounterpartyAliasesTable createAlias(String alias) {
    return $CounterpartyAliasesTable(attachedDatabase, alias);
  }
}

class CounterpartyAliase extends DataClass
    implements Insertable<CounterpartyAliase> {
  final int id;
  final int counterpartyId;

  /// 별칭 (예: "스타벅스", "STARBUCKS GANGNAM")
  final String alias;
  const CounterpartyAliase({
    required this.id,
    required this.counterpartyId,
    required this.alias,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['counterparty_id'] = Variable<int>(counterpartyId);
    map['alias'] = Variable<String>(alias);
    return map;
  }

  CounterpartyAliasesCompanion toCompanion(bool nullToAbsent) {
    return CounterpartyAliasesCompanion(
      id: Value(id),
      counterpartyId: Value(counterpartyId),
      alias: Value(alias),
    );
  }

  factory CounterpartyAliase.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CounterpartyAliase(
      id: serializer.fromJson<int>(json['id']),
      counterpartyId: serializer.fromJson<int>(json['counterpartyId']),
      alias: serializer.fromJson<String>(json['alias']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'counterpartyId': serializer.toJson<int>(counterpartyId),
      'alias': serializer.toJson<String>(alias),
    };
  }

  CounterpartyAliase copyWith({int? id, int? counterpartyId, String? alias}) =>
      CounterpartyAliase(
        id: id ?? this.id,
        counterpartyId: counterpartyId ?? this.counterpartyId,
        alias: alias ?? this.alias,
      );
  CounterpartyAliase copyWithCompanion(CounterpartyAliasesCompanion data) {
    return CounterpartyAliase(
      id: data.id.present ? data.id.value : this.id,
      counterpartyId:
          data.counterpartyId.present
              ? data.counterpartyId.value
              : this.counterpartyId,
      alias: data.alias.present ? data.alias.value : this.alias,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CounterpartyAliase(')
          ..write('id: $id, ')
          ..write('counterpartyId: $counterpartyId, ')
          ..write('alias: $alias')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, counterpartyId, alias);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CounterpartyAliase &&
          other.id == this.id &&
          other.counterpartyId == this.counterpartyId &&
          other.alias == this.alias);
}

class CounterpartyAliasesCompanion extends UpdateCompanion<CounterpartyAliase> {
  final Value<int> id;
  final Value<int> counterpartyId;
  final Value<String> alias;
  const CounterpartyAliasesCompanion({
    this.id = const Value.absent(),
    this.counterpartyId = const Value.absent(),
    this.alias = const Value.absent(),
  });
  CounterpartyAliasesCompanion.insert({
    this.id = const Value.absent(),
    required int counterpartyId,
    required String alias,
  }) : counterpartyId = Value(counterpartyId),
       alias = Value(alias);
  static Insertable<CounterpartyAliase> custom({
    Expression<int>? id,
    Expression<int>? counterpartyId,
    Expression<String>? alias,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (counterpartyId != null) 'counterparty_id': counterpartyId,
      if (alias != null) 'alias': alias,
    });
  }

  CounterpartyAliasesCompanion copyWith({
    Value<int>? id,
    Value<int>? counterpartyId,
    Value<String>? alias,
  }) {
    return CounterpartyAliasesCompanion(
      id: id ?? this.id,
      counterpartyId: counterpartyId ?? this.counterpartyId,
      alias: alias ?? this.alias,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (counterpartyId.present) {
      map['counterparty_id'] = Variable<int>(counterpartyId.value);
    }
    if (alias.present) {
      map['alias'] = Variable<String>(alias.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CounterpartyAliasesCompanion(')
          ..write('id: $id, ')
          ..write('counterpartyId: $counterpartyId, ')
          ..write('alias: $alias')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('DRAFT'),
  );
  static const VerificationMeta _voidedByMeta = const VerificationMeta(
    'voidedBy',
  );
  @override
  late final GeneratedColumn<int> voidedBy = GeneratedColumn<int>(
    'voided_by',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transactions (id)',
    ),
  );
  static const VerificationMeta _counterpartyIdMeta = const VerificationMeta(
    'counterpartyId',
  );
  @override
  late final GeneratedColumn<int> counterpartyId = GeneratedColumn<int>(
    'counterparty_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES counterparties (id)',
    ),
  );
  static const VerificationMeta _counterpartyNameMeta = const VerificationMeta(
    'counterpartyName',
  );
  @override
  late final GeneratedColumn<String> counterpartyName = GeneratedColumn<String>(
    'counterparty_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
    'confidence',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _periodIdMeta = const VerificationMeta(
    'periodId',
  );
  @override
  late final GeneratedColumn<int> periodId = GeneratedColumn<int>(
    'period_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('SYNCED'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    description,
    status,
    voidedBy,
    counterpartyId,
    counterpartyName,
    source,
    confidence,
    periodId,
    syncStatus,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Transaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('voided_by')) {
      context.handle(
        _voidedByMeta,
        voidedBy.isAcceptableOrUnknown(data['voided_by']!, _voidedByMeta),
      );
    }
    if (data.containsKey('counterparty_id')) {
      context.handle(
        _counterpartyIdMeta,
        counterpartyId.isAcceptableOrUnknown(
          data['counterparty_id']!,
          _counterpartyIdMeta,
        ),
      );
    }
    if (data.containsKey('counterparty_name')) {
      context.handle(
        _counterpartyNameMeta,
        counterpartyName.isAcceptableOrUnknown(
          data['counterparty_name']!,
          _counterpartyNameMeta,
        ),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    if (data.containsKey('period_id')) {
      context.handle(
        _periodIdMeta,
        periodId.isAcceptableOrUnknown(data['period_id']!, _periodIdMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      date:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}date'],
          )!,
      description:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}description'],
          )!,
      status:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}status'],
          )!,
      voidedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}voided_by'],
      ),
      counterpartyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}counterparty_id'],
      ),
      counterpartyName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}counterparty_name'],
      ),
      source:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}source'],
          )!,
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence'],
      ),
      periodId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}period_id'],
      ),
      syncStatus:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}sync_status'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final int id;
  final DateTime date;

  /// 적요
  final String description;

  /// DRAFT | POSTED | VOIDED
  final String status;

  /// 역분개 추적 — 이 거래를 무효로 만든 거래 ID
  final int? voidedBy;
  final int? counterpartyId;

  /// 거래처명 비정규화 캐시 (기록시점 유지, 감사 추적)
  final String? counterpartyName;

  /// MANUAL | OCR | CARD_API | CSV_IMPORT | NTS_IMPORT | SYSTEM_SETTLEMENT
  final String source;

  /// AI 분류 신뢰도 (0.0~1.0)
  final double? confidence;

  /// 손익귀속기간 FK
  final int? periodId;

  /// SYNCED | PENDING | SENDING | CONFLICT | FAILED
  final String syncStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Transaction({
    required this.id,
    required this.date,
    required this.description,
    required this.status,
    this.voidedBy,
    this.counterpartyId,
    this.counterpartyName,
    required this.source,
    this.confidence,
    this.periodId,
    required this.syncStatus,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['description'] = Variable<String>(description);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || voidedBy != null) {
      map['voided_by'] = Variable<int>(voidedBy);
    }
    if (!nullToAbsent || counterpartyId != null) {
      map['counterparty_id'] = Variable<int>(counterpartyId);
    }
    if (!nullToAbsent || counterpartyName != null) {
      map['counterparty_name'] = Variable<String>(counterpartyName);
    }
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || confidence != null) {
      map['confidence'] = Variable<double>(confidence);
    }
    if (!nullToAbsent || periodId != null) {
      map['period_id'] = Variable<int>(periodId);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      date: Value(date),
      description: Value(description),
      status: Value(status),
      voidedBy:
          voidedBy == null && nullToAbsent
              ? const Value.absent()
              : Value(voidedBy),
      counterpartyId:
          counterpartyId == null && nullToAbsent
              ? const Value.absent()
              : Value(counterpartyId),
      counterpartyName:
          counterpartyName == null && nullToAbsent
              ? const Value.absent()
              : Value(counterpartyName),
      source: Value(source),
      confidence:
          confidence == null && nullToAbsent
              ? const Value.absent()
              : Value(confidence),
      periodId:
          periodId == null && nullToAbsent
              ? const Value.absent()
              : Value(periodId),
      syncStatus: Value(syncStatus),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Transaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      description: serializer.fromJson<String>(json['description']),
      status: serializer.fromJson<String>(json['status']),
      voidedBy: serializer.fromJson<int?>(json['voidedBy']),
      counterpartyId: serializer.fromJson<int?>(json['counterpartyId']),
      counterpartyName: serializer.fromJson<String?>(json['counterpartyName']),
      source: serializer.fromJson<String>(json['source']),
      confidence: serializer.fromJson<double?>(json['confidence']),
      periodId: serializer.fromJson<int?>(json['periodId']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'description': serializer.toJson<String>(description),
      'status': serializer.toJson<String>(status),
      'voidedBy': serializer.toJson<int?>(voidedBy),
      'counterpartyId': serializer.toJson<int?>(counterpartyId),
      'counterpartyName': serializer.toJson<String?>(counterpartyName),
      'source': serializer.toJson<String>(source),
      'confidence': serializer.toJson<double?>(confidence),
      'periodId': serializer.toJson<int?>(periodId),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Transaction copyWith({
    int? id,
    DateTime? date,
    String? description,
    String? status,
    Value<int?> voidedBy = const Value.absent(),
    Value<int?> counterpartyId = const Value.absent(),
    Value<String?> counterpartyName = const Value.absent(),
    String? source,
    Value<double?> confidence = const Value.absent(),
    Value<int?> periodId = const Value.absent(),
    String? syncStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Transaction(
    id: id ?? this.id,
    date: date ?? this.date,
    description: description ?? this.description,
    status: status ?? this.status,
    voidedBy: voidedBy.present ? voidedBy.value : this.voidedBy,
    counterpartyId:
        counterpartyId.present ? counterpartyId.value : this.counterpartyId,
    counterpartyName:
        counterpartyName.present
            ? counterpartyName.value
            : this.counterpartyName,
    source: source ?? this.source,
    confidence: confidence.present ? confidence.value : this.confidence,
    periodId: periodId.present ? periodId.value : this.periodId,
    syncStatus: syncStatus ?? this.syncStatus,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      description:
          data.description.present ? data.description.value : this.description,
      status: data.status.present ? data.status.value : this.status,
      voidedBy: data.voidedBy.present ? data.voidedBy.value : this.voidedBy,
      counterpartyId:
          data.counterpartyId.present
              ? data.counterpartyId.value
              : this.counterpartyId,
      counterpartyName:
          data.counterpartyName.present
              ? data.counterpartyName.value
              : this.counterpartyName,
      source: data.source.present ? data.source.value : this.source,
      confidence:
          data.confidence.present ? data.confidence.value : this.confidence,
      periodId: data.periodId.present ? data.periodId.value : this.periodId,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('voidedBy: $voidedBy, ')
          ..write('counterpartyId: $counterpartyId, ')
          ..write('counterpartyName: $counterpartyName, ')
          ..write('source: $source, ')
          ..write('confidence: $confidence, ')
          ..write('periodId: $periodId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    description,
    status,
    voidedBy,
    counterpartyId,
    counterpartyName,
    source,
    confidence,
    periodId,
    syncStatus,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.date == this.date &&
          other.description == this.description &&
          other.status == this.status &&
          other.voidedBy == this.voidedBy &&
          other.counterpartyId == this.counterpartyId &&
          other.counterpartyName == this.counterpartyName &&
          other.source == this.source &&
          other.confidence == this.confidence &&
          other.periodId == this.periodId &&
          other.syncStatus == this.syncStatus &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> description;
  final Value<String> status;
  final Value<int?> voidedBy;
  final Value<int?> counterpartyId;
  final Value<String?> counterpartyName;
  final Value<String> source;
  final Value<double?> confidence;
  final Value<int?> periodId;
  final Value<String> syncStatus;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.voidedBy = const Value.absent(),
    this.counterpartyId = const Value.absent(),
    this.counterpartyName = const Value.absent(),
    this.source = const Value.absent(),
    this.confidence = const Value.absent(),
    this.periodId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required String description,
    this.status = const Value.absent(),
    this.voidedBy = const Value.absent(),
    this.counterpartyId = const Value.absent(),
    this.counterpartyName = const Value.absent(),
    required String source,
    this.confidence = const Value.absent(),
    this.periodId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : date = Value(date),
       description = Value(description),
       source = Value(source);
  static Insertable<Transaction> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? description,
    Expression<String>? status,
    Expression<int>? voidedBy,
    Expression<int>? counterpartyId,
    Expression<String>? counterpartyName,
    Expression<String>? source,
    Expression<double>? confidence,
    Expression<int>? periodId,
    Expression<String>? syncStatus,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
      if (voidedBy != null) 'voided_by': voidedBy,
      if (counterpartyId != null) 'counterparty_id': counterpartyId,
      if (counterpartyName != null) 'counterparty_name': counterpartyName,
      if (source != null) 'source': source,
      if (confidence != null) 'confidence': confidence,
      if (periodId != null) 'period_id': periodId,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TransactionsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<String>? description,
    Value<String>? status,
    Value<int?>? voidedBy,
    Value<int?>? counterpartyId,
    Value<String?>? counterpartyName,
    Value<String>? source,
    Value<double?>? confidence,
    Value<int?>? periodId,
    Value<String>? syncStatus,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      description: description ?? this.description,
      status: status ?? this.status,
      voidedBy: voidedBy ?? this.voidedBy,
      counterpartyId: counterpartyId ?? this.counterpartyId,
      counterpartyName: counterpartyName ?? this.counterpartyName,
      source: source ?? this.source,
      confidence: confidence ?? this.confidence,
      periodId: periodId ?? this.periodId,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (voidedBy.present) {
      map['voided_by'] = Variable<int>(voidedBy.value);
    }
    if (counterpartyId.present) {
      map['counterparty_id'] = Variable<int>(counterpartyId.value);
    }
    if (counterpartyName.present) {
      map['counterparty_name'] = Variable<String>(counterpartyName.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (periodId.present) {
      map['period_id'] = Variable<int>(periodId.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('voidedBy: $voidedBy, ')
          ..write('counterpartyId: $counterpartyId, ')
          ..write('counterpartyName: $counterpartyName, ')
          ..write('source: $source, ')
          ..write('confidence: $confidence, ')
          ..write('periodId: $periodId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $JournalEntryLinesTable extends JournalEntryLines
    with TableInfo<$JournalEntryLinesTable, JournalEntryLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalEntryLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<int> transactionId = GeneratedColumn<int>(
    'transaction_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transactions (id)',
    ),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _entryTypeMeta = const VerificationMeta(
    'entryType',
  );
  @override
  late final GeneratedColumn<String> entryType = GeneratedColumn<String>(
    'entry_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalAmountMeta = const VerificationMeta(
    'originalAmount',
  );
  @override
  late final GeneratedColumn<int> originalAmount = GeneratedColumn<int>(
    'original_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalCurrencyMeta = const VerificationMeta(
    'originalCurrency',
  );
  @override
  late final GeneratedColumn<String> originalCurrency = GeneratedColumn<String>(
    'original_currency',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 3,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exchangeRateAtTradeMeta =
      const VerificationMeta('exchangeRateAtTrade');
  @override
  late final GeneratedColumn<int> exchangeRateAtTrade = GeneratedColumn<int>(
    'exchange_rate_at_trade',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baseCurrencyMeta = const VerificationMeta(
    'baseCurrency',
  );
  @override
  late final GeneratedColumn<String> baseCurrency = GeneratedColumn<String>(
    'base_currency',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 3,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baseAmountMeta = const VerificationMeta(
    'baseAmount',
  );
  @override
  late final GeneratedColumn<int> baseAmount = GeneratedColumn<int>(
    'base_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activityTypeOverrideMeta =
      const VerificationMeta('activityTypeOverride');
  @override
  late final GeneratedColumn<int> activityTypeOverride = GeneratedColumn<int>(
    'activity_type_override',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES dimension_values (id)',
    ),
  );
  static const VerificationMeta _ownerIdOverrideMeta = const VerificationMeta(
    'ownerIdOverride',
  );
  @override
  late final GeneratedColumn<int> ownerIdOverride = GeneratedColumn<int>(
    'owner_id_override',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES owners (id)',
    ),
  );
  static const VerificationMeta _incomeTypeOverrideMeta =
      const VerificationMeta('incomeTypeOverride');
  @override
  late final GeneratedColumn<int> incomeTypeOverride = GeneratedColumn<int>(
    'income_type_override',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES dimension_values (id)',
    ),
  );
  static const VerificationMeta _deductibilityMeta = const VerificationMeta(
    'deductibility',
  );
  @override
  late final GeneratedColumn<String> deductibility = GeneratedColumn<String>(
    'deductibility',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UNDETERMINED'),
  );
  static const VerificationMeta _beneficiaryIdMeta = const VerificationMeta(
    'beneficiaryId',
  );
  @override
  late final GeneratedColumn<int> beneficiaryId = GeneratedColumn<int>(
    'beneficiary_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES owners (id)',
    ),
  );
  static const VerificationMeta _taxClassificationMeta = const VerificationMeta(
    'taxClassification',
  );
  @override
  late final GeneratedColumn<String> taxClassification =
      GeneratedColumn<String>(
        'tax_classification',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  @override
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
    'memo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    transactionId,
    accountId,
    entryType,
    originalAmount,
    originalCurrency,
    exchangeRateAtTrade,
    baseCurrency,
    baseAmount,
    activityTypeOverride,
    ownerIdOverride,
    incomeTypeOverride,
    deductibility,
    beneficiaryId,
    taxClassification,
    memo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_entry_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalEntryLine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('entry_type')) {
      context.handle(
        _entryTypeMeta,
        entryType.isAcceptableOrUnknown(data['entry_type']!, _entryTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entryTypeMeta);
    }
    if (data.containsKey('original_amount')) {
      context.handle(
        _originalAmountMeta,
        originalAmount.isAcceptableOrUnknown(
          data['original_amount']!,
          _originalAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalAmountMeta);
    }
    if (data.containsKey('original_currency')) {
      context.handle(
        _originalCurrencyMeta,
        originalCurrency.isAcceptableOrUnknown(
          data['original_currency']!,
          _originalCurrencyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalCurrencyMeta);
    }
    if (data.containsKey('exchange_rate_at_trade')) {
      context.handle(
        _exchangeRateAtTradeMeta,
        exchangeRateAtTrade.isAcceptableOrUnknown(
          data['exchange_rate_at_trade']!,
          _exchangeRateAtTradeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exchangeRateAtTradeMeta);
    }
    if (data.containsKey('base_currency')) {
      context.handle(
        _baseCurrencyMeta,
        baseCurrency.isAcceptableOrUnknown(
          data['base_currency']!,
          _baseCurrencyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_baseCurrencyMeta);
    }
    if (data.containsKey('base_amount')) {
      context.handle(
        _baseAmountMeta,
        baseAmount.isAcceptableOrUnknown(data['base_amount']!, _baseAmountMeta),
      );
    } else if (isInserting) {
      context.missing(_baseAmountMeta);
    }
    if (data.containsKey('activity_type_override')) {
      context.handle(
        _activityTypeOverrideMeta,
        activityTypeOverride.isAcceptableOrUnknown(
          data['activity_type_override']!,
          _activityTypeOverrideMeta,
        ),
      );
    }
    if (data.containsKey('owner_id_override')) {
      context.handle(
        _ownerIdOverrideMeta,
        ownerIdOverride.isAcceptableOrUnknown(
          data['owner_id_override']!,
          _ownerIdOverrideMeta,
        ),
      );
    }
    if (data.containsKey('income_type_override')) {
      context.handle(
        _incomeTypeOverrideMeta,
        incomeTypeOverride.isAcceptableOrUnknown(
          data['income_type_override']!,
          _incomeTypeOverrideMeta,
        ),
      );
    }
    if (data.containsKey('deductibility')) {
      context.handle(
        _deductibilityMeta,
        deductibility.isAcceptableOrUnknown(
          data['deductibility']!,
          _deductibilityMeta,
        ),
      );
    }
    if (data.containsKey('beneficiary_id')) {
      context.handle(
        _beneficiaryIdMeta,
        beneficiaryId.isAcceptableOrUnknown(
          data['beneficiary_id']!,
          _beneficiaryIdMeta,
        ),
      );
    }
    if (data.containsKey('tax_classification')) {
      context.handle(
        _taxClassificationMeta,
        taxClassification.isAcceptableOrUnknown(
          data['tax_classification']!,
          _taxClassificationMeta,
        ),
      );
    }
    if (data.containsKey('memo')) {
      context.handle(
        _memoMeta,
        memo.isAcceptableOrUnknown(data['memo']!, _memoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JournalEntryLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalEntryLine(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      transactionId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}transaction_id'],
          )!,
      accountId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}account_id'],
          )!,
      entryType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}entry_type'],
          )!,
      originalAmount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}original_amount'],
          )!,
      originalCurrency:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}original_currency'],
          )!,
      exchangeRateAtTrade:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}exchange_rate_at_trade'],
          )!,
      baseCurrency:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}base_currency'],
          )!,
      baseAmount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}base_amount'],
          )!,
      activityTypeOverride: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}activity_type_override'],
      ),
      ownerIdOverride: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}owner_id_override'],
      ),
      incomeTypeOverride: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}income_type_override'],
      ),
      deductibility:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}deductibility'],
          )!,
      beneficiaryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}beneficiary_id'],
      ),
      taxClassification: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tax_classification'],
      ),
      memo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}memo'],
      ),
    );
  }

  @override
  $JournalEntryLinesTable createAlias(String alias) {
    return $JournalEntryLinesTable(attachedDatabase, alias);
  }
}

class JournalEntryLine extends DataClass
    implements Insertable<JournalEntryLine> {
  final int id;
  final int transactionId;
  final int accountId;

  /// DEBIT | CREDIT
  final String entryType;

  /// 거래원화 최소 단위 int (불변)
  final int originalAmount;

  /// ISO 4217 통화 코드 (T1 구조축, TEXT 필드)
  final String originalCurrency;

  /// 거래시점 환율 (배율 1,000,000, 불변)
  final int exchangeRateAtTrade;

  /// 기준통화 코드
  final String baseCurrency;

  /// 기준통화 환산액 (파생, 불변)
  final int baseAmount;
  final int? activityTypeOverride;
  final int? ownerIdOverride;
  final int? incomeTypeOverride;

  /// 손익금구분 (기본: UNDETERMINED)
  final String deductibility;

  /// 실질 수혜자 (세무 실질과세 원칙)
  final int? beneficiaryId;
  final String? taxClassification;
  final String? memo;
  const JournalEntryLine({
    required this.id,
    required this.transactionId,
    required this.accountId,
    required this.entryType,
    required this.originalAmount,
    required this.originalCurrency,
    required this.exchangeRateAtTrade,
    required this.baseCurrency,
    required this.baseAmount,
    this.activityTypeOverride,
    this.ownerIdOverride,
    this.incomeTypeOverride,
    required this.deductibility,
    this.beneficiaryId,
    this.taxClassification,
    this.memo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['transaction_id'] = Variable<int>(transactionId);
    map['account_id'] = Variable<int>(accountId);
    map['entry_type'] = Variable<String>(entryType);
    map['original_amount'] = Variable<int>(originalAmount);
    map['original_currency'] = Variable<String>(originalCurrency);
    map['exchange_rate_at_trade'] = Variable<int>(exchangeRateAtTrade);
    map['base_currency'] = Variable<String>(baseCurrency);
    map['base_amount'] = Variable<int>(baseAmount);
    if (!nullToAbsent || activityTypeOverride != null) {
      map['activity_type_override'] = Variable<int>(activityTypeOverride);
    }
    if (!nullToAbsent || ownerIdOverride != null) {
      map['owner_id_override'] = Variable<int>(ownerIdOverride);
    }
    if (!nullToAbsent || incomeTypeOverride != null) {
      map['income_type_override'] = Variable<int>(incomeTypeOverride);
    }
    map['deductibility'] = Variable<String>(deductibility);
    if (!nullToAbsent || beneficiaryId != null) {
      map['beneficiary_id'] = Variable<int>(beneficiaryId);
    }
    if (!nullToAbsent || taxClassification != null) {
      map['tax_classification'] = Variable<String>(taxClassification);
    }
    if (!nullToAbsent || memo != null) {
      map['memo'] = Variable<String>(memo);
    }
    return map;
  }

  JournalEntryLinesCompanion toCompanion(bool nullToAbsent) {
    return JournalEntryLinesCompanion(
      id: Value(id),
      transactionId: Value(transactionId),
      accountId: Value(accountId),
      entryType: Value(entryType),
      originalAmount: Value(originalAmount),
      originalCurrency: Value(originalCurrency),
      exchangeRateAtTrade: Value(exchangeRateAtTrade),
      baseCurrency: Value(baseCurrency),
      baseAmount: Value(baseAmount),
      activityTypeOverride:
          activityTypeOverride == null && nullToAbsent
              ? const Value.absent()
              : Value(activityTypeOverride),
      ownerIdOverride:
          ownerIdOverride == null && nullToAbsent
              ? const Value.absent()
              : Value(ownerIdOverride),
      incomeTypeOverride:
          incomeTypeOverride == null && nullToAbsent
              ? const Value.absent()
              : Value(incomeTypeOverride),
      deductibility: Value(deductibility),
      beneficiaryId:
          beneficiaryId == null && nullToAbsent
              ? const Value.absent()
              : Value(beneficiaryId),
      taxClassification:
          taxClassification == null && nullToAbsent
              ? const Value.absent()
              : Value(taxClassification),
      memo: memo == null && nullToAbsent ? const Value.absent() : Value(memo),
    );
  }

  factory JournalEntryLine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalEntryLine(
      id: serializer.fromJson<int>(json['id']),
      transactionId: serializer.fromJson<int>(json['transactionId']),
      accountId: serializer.fromJson<int>(json['accountId']),
      entryType: serializer.fromJson<String>(json['entryType']),
      originalAmount: serializer.fromJson<int>(json['originalAmount']),
      originalCurrency: serializer.fromJson<String>(json['originalCurrency']),
      exchangeRateAtTrade: serializer.fromJson<int>(
        json['exchangeRateAtTrade'],
      ),
      baseCurrency: serializer.fromJson<String>(json['baseCurrency']),
      baseAmount: serializer.fromJson<int>(json['baseAmount']),
      activityTypeOverride: serializer.fromJson<int?>(
        json['activityTypeOverride'],
      ),
      ownerIdOverride: serializer.fromJson<int?>(json['ownerIdOverride']),
      incomeTypeOverride: serializer.fromJson<int?>(json['incomeTypeOverride']),
      deductibility: serializer.fromJson<String>(json['deductibility']),
      beneficiaryId: serializer.fromJson<int?>(json['beneficiaryId']),
      taxClassification: serializer.fromJson<String?>(
        json['taxClassification'],
      ),
      memo: serializer.fromJson<String?>(json['memo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'transactionId': serializer.toJson<int>(transactionId),
      'accountId': serializer.toJson<int>(accountId),
      'entryType': serializer.toJson<String>(entryType),
      'originalAmount': serializer.toJson<int>(originalAmount),
      'originalCurrency': serializer.toJson<String>(originalCurrency),
      'exchangeRateAtTrade': serializer.toJson<int>(exchangeRateAtTrade),
      'baseCurrency': serializer.toJson<String>(baseCurrency),
      'baseAmount': serializer.toJson<int>(baseAmount),
      'activityTypeOverride': serializer.toJson<int?>(activityTypeOverride),
      'ownerIdOverride': serializer.toJson<int?>(ownerIdOverride),
      'incomeTypeOverride': serializer.toJson<int?>(incomeTypeOverride),
      'deductibility': serializer.toJson<String>(deductibility),
      'beneficiaryId': serializer.toJson<int?>(beneficiaryId),
      'taxClassification': serializer.toJson<String?>(taxClassification),
      'memo': serializer.toJson<String?>(memo),
    };
  }

  JournalEntryLine copyWith({
    int? id,
    int? transactionId,
    int? accountId,
    String? entryType,
    int? originalAmount,
    String? originalCurrency,
    int? exchangeRateAtTrade,
    String? baseCurrency,
    int? baseAmount,
    Value<int?> activityTypeOverride = const Value.absent(),
    Value<int?> ownerIdOverride = const Value.absent(),
    Value<int?> incomeTypeOverride = const Value.absent(),
    String? deductibility,
    Value<int?> beneficiaryId = const Value.absent(),
    Value<String?> taxClassification = const Value.absent(),
    Value<String?> memo = const Value.absent(),
  }) => JournalEntryLine(
    id: id ?? this.id,
    transactionId: transactionId ?? this.transactionId,
    accountId: accountId ?? this.accountId,
    entryType: entryType ?? this.entryType,
    originalAmount: originalAmount ?? this.originalAmount,
    originalCurrency: originalCurrency ?? this.originalCurrency,
    exchangeRateAtTrade: exchangeRateAtTrade ?? this.exchangeRateAtTrade,
    baseCurrency: baseCurrency ?? this.baseCurrency,
    baseAmount: baseAmount ?? this.baseAmount,
    activityTypeOverride:
        activityTypeOverride.present
            ? activityTypeOverride.value
            : this.activityTypeOverride,
    ownerIdOverride:
        ownerIdOverride.present ? ownerIdOverride.value : this.ownerIdOverride,
    incomeTypeOverride:
        incomeTypeOverride.present
            ? incomeTypeOverride.value
            : this.incomeTypeOverride,
    deductibility: deductibility ?? this.deductibility,
    beneficiaryId:
        beneficiaryId.present ? beneficiaryId.value : this.beneficiaryId,
    taxClassification:
        taxClassification.present
            ? taxClassification.value
            : this.taxClassification,
    memo: memo.present ? memo.value : this.memo,
  );
  JournalEntryLine copyWithCompanion(JournalEntryLinesCompanion data) {
    return JournalEntryLine(
      id: data.id.present ? data.id.value : this.id,
      transactionId:
          data.transactionId.present
              ? data.transactionId.value
              : this.transactionId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      entryType: data.entryType.present ? data.entryType.value : this.entryType,
      originalAmount:
          data.originalAmount.present
              ? data.originalAmount.value
              : this.originalAmount,
      originalCurrency:
          data.originalCurrency.present
              ? data.originalCurrency.value
              : this.originalCurrency,
      exchangeRateAtTrade:
          data.exchangeRateAtTrade.present
              ? data.exchangeRateAtTrade.value
              : this.exchangeRateAtTrade,
      baseCurrency:
          data.baseCurrency.present
              ? data.baseCurrency.value
              : this.baseCurrency,
      baseAmount:
          data.baseAmount.present ? data.baseAmount.value : this.baseAmount,
      activityTypeOverride:
          data.activityTypeOverride.present
              ? data.activityTypeOverride.value
              : this.activityTypeOverride,
      ownerIdOverride:
          data.ownerIdOverride.present
              ? data.ownerIdOverride.value
              : this.ownerIdOverride,
      incomeTypeOverride:
          data.incomeTypeOverride.present
              ? data.incomeTypeOverride.value
              : this.incomeTypeOverride,
      deductibility:
          data.deductibility.present
              ? data.deductibility.value
              : this.deductibility,
      beneficiaryId:
          data.beneficiaryId.present
              ? data.beneficiaryId.value
              : this.beneficiaryId,
      taxClassification:
          data.taxClassification.present
              ? data.taxClassification.value
              : this.taxClassification,
      memo: data.memo.present ? data.memo.value : this.memo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntryLine(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('accountId: $accountId, ')
          ..write('entryType: $entryType, ')
          ..write('originalAmount: $originalAmount, ')
          ..write('originalCurrency: $originalCurrency, ')
          ..write('exchangeRateAtTrade: $exchangeRateAtTrade, ')
          ..write('baseCurrency: $baseCurrency, ')
          ..write('baseAmount: $baseAmount, ')
          ..write('activityTypeOverride: $activityTypeOverride, ')
          ..write('ownerIdOverride: $ownerIdOverride, ')
          ..write('incomeTypeOverride: $incomeTypeOverride, ')
          ..write('deductibility: $deductibility, ')
          ..write('beneficiaryId: $beneficiaryId, ')
          ..write('taxClassification: $taxClassification, ')
          ..write('memo: $memo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    transactionId,
    accountId,
    entryType,
    originalAmount,
    originalCurrency,
    exchangeRateAtTrade,
    baseCurrency,
    baseAmount,
    activityTypeOverride,
    ownerIdOverride,
    incomeTypeOverride,
    deductibility,
    beneficiaryId,
    taxClassification,
    memo,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalEntryLine &&
          other.id == this.id &&
          other.transactionId == this.transactionId &&
          other.accountId == this.accountId &&
          other.entryType == this.entryType &&
          other.originalAmount == this.originalAmount &&
          other.originalCurrency == this.originalCurrency &&
          other.exchangeRateAtTrade == this.exchangeRateAtTrade &&
          other.baseCurrency == this.baseCurrency &&
          other.baseAmount == this.baseAmount &&
          other.activityTypeOverride == this.activityTypeOverride &&
          other.ownerIdOverride == this.ownerIdOverride &&
          other.incomeTypeOverride == this.incomeTypeOverride &&
          other.deductibility == this.deductibility &&
          other.beneficiaryId == this.beneficiaryId &&
          other.taxClassification == this.taxClassification &&
          other.memo == this.memo);
}

class JournalEntryLinesCompanion extends UpdateCompanion<JournalEntryLine> {
  final Value<int> id;
  final Value<int> transactionId;
  final Value<int> accountId;
  final Value<String> entryType;
  final Value<int> originalAmount;
  final Value<String> originalCurrency;
  final Value<int> exchangeRateAtTrade;
  final Value<String> baseCurrency;
  final Value<int> baseAmount;
  final Value<int?> activityTypeOverride;
  final Value<int?> ownerIdOverride;
  final Value<int?> incomeTypeOverride;
  final Value<String> deductibility;
  final Value<int?> beneficiaryId;
  final Value<String?> taxClassification;
  final Value<String?> memo;
  const JournalEntryLinesCompanion({
    this.id = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.entryType = const Value.absent(),
    this.originalAmount = const Value.absent(),
    this.originalCurrency = const Value.absent(),
    this.exchangeRateAtTrade = const Value.absent(),
    this.baseCurrency = const Value.absent(),
    this.baseAmount = const Value.absent(),
    this.activityTypeOverride = const Value.absent(),
    this.ownerIdOverride = const Value.absent(),
    this.incomeTypeOverride = const Value.absent(),
    this.deductibility = const Value.absent(),
    this.beneficiaryId = const Value.absent(),
    this.taxClassification = const Value.absent(),
    this.memo = const Value.absent(),
  });
  JournalEntryLinesCompanion.insert({
    this.id = const Value.absent(),
    required int transactionId,
    required int accountId,
    required String entryType,
    required int originalAmount,
    required String originalCurrency,
    required int exchangeRateAtTrade,
    required String baseCurrency,
    required int baseAmount,
    this.activityTypeOverride = const Value.absent(),
    this.ownerIdOverride = const Value.absent(),
    this.incomeTypeOverride = const Value.absent(),
    this.deductibility = const Value.absent(),
    this.beneficiaryId = const Value.absent(),
    this.taxClassification = const Value.absent(),
    this.memo = const Value.absent(),
  }) : transactionId = Value(transactionId),
       accountId = Value(accountId),
       entryType = Value(entryType),
       originalAmount = Value(originalAmount),
       originalCurrency = Value(originalCurrency),
       exchangeRateAtTrade = Value(exchangeRateAtTrade),
       baseCurrency = Value(baseCurrency),
       baseAmount = Value(baseAmount);
  static Insertable<JournalEntryLine> custom({
    Expression<int>? id,
    Expression<int>? transactionId,
    Expression<int>? accountId,
    Expression<String>? entryType,
    Expression<int>? originalAmount,
    Expression<String>? originalCurrency,
    Expression<int>? exchangeRateAtTrade,
    Expression<String>? baseCurrency,
    Expression<int>? baseAmount,
    Expression<int>? activityTypeOverride,
    Expression<int>? ownerIdOverride,
    Expression<int>? incomeTypeOverride,
    Expression<String>? deductibility,
    Expression<int>? beneficiaryId,
    Expression<String>? taxClassification,
    Expression<String>? memo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionId != null) 'transaction_id': transactionId,
      if (accountId != null) 'account_id': accountId,
      if (entryType != null) 'entry_type': entryType,
      if (originalAmount != null) 'original_amount': originalAmount,
      if (originalCurrency != null) 'original_currency': originalCurrency,
      if (exchangeRateAtTrade != null)
        'exchange_rate_at_trade': exchangeRateAtTrade,
      if (baseCurrency != null) 'base_currency': baseCurrency,
      if (baseAmount != null) 'base_amount': baseAmount,
      if (activityTypeOverride != null)
        'activity_type_override': activityTypeOverride,
      if (ownerIdOverride != null) 'owner_id_override': ownerIdOverride,
      if (incomeTypeOverride != null)
        'income_type_override': incomeTypeOverride,
      if (deductibility != null) 'deductibility': deductibility,
      if (beneficiaryId != null) 'beneficiary_id': beneficiaryId,
      if (taxClassification != null) 'tax_classification': taxClassification,
      if (memo != null) 'memo': memo,
    });
  }

  JournalEntryLinesCompanion copyWith({
    Value<int>? id,
    Value<int>? transactionId,
    Value<int>? accountId,
    Value<String>? entryType,
    Value<int>? originalAmount,
    Value<String>? originalCurrency,
    Value<int>? exchangeRateAtTrade,
    Value<String>? baseCurrency,
    Value<int>? baseAmount,
    Value<int?>? activityTypeOverride,
    Value<int?>? ownerIdOverride,
    Value<int?>? incomeTypeOverride,
    Value<String>? deductibility,
    Value<int?>? beneficiaryId,
    Value<String?>? taxClassification,
    Value<String?>? memo,
  }) {
    return JournalEntryLinesCompanion(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      accountId: accountId ?? this.accountId,
      entryType: entryType ?? this.entryType,
      originalAmount: originalAmount ?? this.originalAmount,
      originalCurrency: originalCurrency ?? this.originalCurrency,
      exchangeRateAtTrade: exchangeRateAtTrade ?? this.exchangeRateAtTrade,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      baseAmount: baseAmount ?? this.baseAmount,
      activityTypeOverride: activityTypeOverride ?? this.activityTypeOverride,
      ownerIdOverride: ownerIdOverride ?? this.ownerIdOverride,
      incomeTypeOverride: incomeTypeOverride ?? this.incomeTypeOverride,
      deductibility: deductibility ?? this.deductibility,
      beneficiaryId: beneficiaryId ?? this.beneficiaryId,
      taxClassification: taxClassification ?? this.taxClassification,
      memo: memo ?? this.memo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<int>(transactionId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (entryType.present) {
      map['entry_type'] = Variable<String>(entryType.value);
    }
    if (originalAmount.present) {
      map['original_amount'] = Variable<int>(originalAmount.value);
    }
    if (originalCurrency.present) {
      map['original_currency'] = Variable<String>(originalCurrency.value);
    }
    if (exchangeRateAtTrade.present) {
      map['exchange_rate_at_trade'] = Variable<int>(exchangeRateAtTrade.value);
    }
    if (baseCurrency.present) {
      map['base_currency'] = Variable<String>(baseCurrency.value);
    }
    if (baseAmount.present) {
      map['base_amount'] = Variable<int>(baseAmount.value);
    }
    if (activityTypeOverride.present) {
      map['activity_type_override'] = Variable<int>(activityTypeOverride.value);
    }
    if (ownerIdOverride.present) {
      map['owner_id_override'] = Variable<int>(ownerIdOverride.value);
    }
    if (incomeTypeOverride.present) {
      map['income_type_override'] = Variable<int>(incomeTypeOverride.value);
    }
    if (deductibility.present) {
      map['deductibility'] = Variable<String>(deductibility.value);
    }
    if (beneficiaryId.present) {
      map['beneficiary_id'] = Variable<int>(beneficiaryId.value);
    }
    if (taxClassification.present) {
      map['tax_classification'] = Variable<String>(taxClassification.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntryLinesCompanion(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('accountId: $accountId, ')
          ..write('entryType: $entryType, ')
          ..write('originalAmount: $originalAmount, ')
          ..write('originalCurrency: $originalCurrency, ')
          ..write('exchangeRateAtTrade: $exchangeRateAtTrade, ')
          ..write('baseCurrency: $baseCurrency, ')
          ..write('baseAmount: $baseAmount, ')
          ..write('activityTypeOverride: $activityTypeOverride, ')
          ..write('ownerIdOverride: $ownerIdOverride, ')
          ..write('incomeTypeOverride: $incomeTypeOverride, ')
          ..write('deductibility: $deductibility, ')
          ..write('beneficiaryId: $beneficiaryId, ')
          ..write('taxClassification: $taxClassification, ')
          ..write('memo: $memo')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, category];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final int id;

  /// 태그명 (고유, 예: "#출근길")
  final String name;

  /// 태그 그룹 (향후 확장)
  final String? category;
  const Tag({required this.id, required this.name, this.category});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      name: Value(name),
      category:
          category == null && nullToAbsent
              ? const Value.absent()
              : Value(category),
    );
  }

  factory Tag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String?>(json['category']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String?>(category),
    };
  }

  Tag copyWith({
    int? id,
    String? name,
    Value<String?> category = const Value.absent(),
  }) => Tag(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category.present ? category.value : this.category,
  );
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, category);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> category;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
  });
  TagsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.category = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Tag> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? category,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
    });
  }

  TagsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? category,
  }) {
    return TagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }
}

class $TransactionTagsTable extends TransactionTags
    with TableInfo<$TransactionTagsTable, TransactionTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<int> transactionId = GeneratedColumn<int>(
    'transaction_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transactions (id)',
    ),
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<int> tagId = GeneratedColumn<int>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tags (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [transactionId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {transactionId, tagId};
  @override
  TransactionTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionTag(
      transactionId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}transaction_id'],
          )!,
      tagId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}tag_id'],
          )!,
    );
  }

  @override
  $TransactionTagsTable createAlias(String alias) {
    return $TransactionTagsTable(attachedDatabase, alias);
  }
}

class TransactionTag extends DataClass implements Insertable<TransactionTag> {
  final int transactionId;
  final int tagId;
  const TransactionTag({required this.transactionId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['transaction_id'] = Variable<int>(transactionId);
    map['tag_id'] = Variable<int>(tagId);
    return map;
  }

  TransactionTagsCompanion toCompanion(bool nullToAbsent) {
    return TransactionTagsCompanion(
      transactionId: Value(transactionId),
      tagId: Value(tagId),
    );
  }

  factory TransactionTag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionTag(
      transactionId: serializer.fromJson<int>(json['transactionId']),
      tagId: serializer.fromJson<int>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'transactionId': serializer.toJson<int>(transactionId),
      'tagId': serializer.toJson<int>(tagId),
    };
  }

  TransactionTag copyWith({int? transactionId, int? tagId}) => TransactionTag(
    transactionId: transactionId ?? this.transactionId,
    tagId: tagId ?? this.tagId,
  );
  TransactionTag copyWithCompanion(TransactionTagsCompanion data) {
    return TransactionTag(
      transactionId:
          data.transactionId.present
              ? data.transactionId.value
              : this.transactionId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionTag(')
          ..write('transactionId: $transactionId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(transactionId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionTag &&
          other.transactionId == this.transactionId &&
          other.tagId == this.tagId);
}

class TransactionTagsCompanion extends UpdateCompanion<TransactionTag> {
  final Value<int> transactionId;
  final Value<int> tagId;
  final Value<int> rowid;
  const TransactionTagsCompanion({
    this.transactionId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionTagsCompanion.insert({
    required int transactionId,
    required int tagId,
    this.rowid = const Value.absent(),
  }) : transactionId = Value(transactionId),
       tagId = Value(tagId);
  static Insertable<TransactionTag> custom({
    Expression<int>? transactionId,
    Expression<int>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (transactionId != null) 'transaction_id': transactionId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionTagsCompanion copyWith({
    Value<int>? transactionId,
    Value<int>? tagId,
    Value<int>? rowid,
  }) {
    return TransactionTagsCompanion(
      transactionId: transactionId ?? this.transactionId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (transactionId.present) {
      map['transaction_id'] = Variable<int>(transactionId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<int>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionTagsCompanion(')
          ..write('transactionId: $transactionId, ')
          ..write('tagId: $tagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PerspectivesTable extends Perspectives
    with TableInfo<$PerspectivesTable, Perspective> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PerspectivesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<int> ownerId = GeneratedColumn<int>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES owners (id)',
    ),
  );
  static const VerificationMeta _isSystemMeta = const VerificationMeta(
    'isSystem',
  );
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
    'is_system',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_system" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dimensionFiltersMeta = const VerificationMeta(
    'dimensionFilters',
  );
  @override
  late final GeneratedColumn<String> dimensionFilters = GeneratedColumn<String>(
    'dimension_filters',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _accountAttributeFiltersMeta =
      const VerificationMeta('accountAttributeFilters');
  @override
  late final GeneratedColumn<String> accountAttributeFilters =
      GeneratedColumn<String>(
        'account_attribute_filters',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('{}'),
      );
  static const VerificationMeta _tagFiltersMeta = const VerificationMeta(
    'tagFilters',
  );
  @override
  late final GeneratedColumn<String> tagFilters = GeneratedColumn<String>(
    'tag_filters',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _recordingDirectionMeta =
      const VerificationMeta('recordingDirection');
  @override
  late final GeneratedColumn<String> recordingDirection =
      GeneratedColumn<String>(
        'recording_direction',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('NORMAL'),
      );
  static const VerificationMeta _baseCurrencyMeta = const VerificationMeta(
    'baseCurrency',
  );
  @override
  late final GeneratedColumn<String> baseCurrency = GeneratedColumn<String>(
    'base_currency',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _permissionLevelMeta = const VerificationMeta(
    'permissionLevel',
  );
  @override
  late final GeneratedColumn<String> permissionLevel = GeneratedColumn<String>(
    'permission_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('FULL'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    ownerId,
    isSystem,
    dimensionFilters,
    accountAttributeFilters,
    tagFilters,
    recordingDirection,
    baseCurrency,
    permissionLevel,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'perspectives';
  @override
  VerificationContext validateIntegrity(
    Insertable<Perspective> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('is_system')) {
      context.handle(
        _isSystemMeta,
        isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta),
      );
    }
    if (data.containsKey('dimension_filters')) {
      context.handle(
        _dimensionFiltersMeta,
        dimensionFilters.isAcceptableOrUnknown(
          data['dimension_filters']!,
          _dimensionFiltersMeta,
        ),
      );
    }
    if (data.containsKey('account_attribute_filters')) {
      context.handle(
        _accountAttributeFiltersMeta,
        accountAttributeFilters.isAcceptableOrUnknown(
          data['account_attribute_filters']!,
          _accountAttributeFiltersMeta,
        ),
      );
    }
    if (data.containsKey('tag_filters')) {
      context.handle(
        _tagFiltersMeta,
        tagFilters.isAcceptableOrUnknown(data['tag_filters']!, _tagFiltersMeta),
      );
    }
    if (data.containsKey('recording_direction')) {
      context.handle(
        _recordingDirectionMeta,
        recordingDirection.isAcceptableOrUnknown(
          data['recording_direction']!,
          _recordingDirectionMeta,
        ),
      );
    }
    if (data.containsKey('base_currency')) {
      context.handle(
        _baseCurrencyMeta,
        baseCurrency.isAcceptableOrUnknown(
          data['base_currency']!,
          _baseCurrencyMeta,
        ),
      );
    }
    if (data.containsKey('permission_level')) {
      context.handle(
        _permissionLevelMeta,
        permissionLevel.isAcceptableOrUnknown(
          data['permission_level']!,
          _permissionLevelMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Perspective map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Perspective(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      ownerId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}owner_id'],
          )!,
      isSystem:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_system'],
          )!,
      dimensionFilters:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}dimension_filters'],
          )!,
      accountAttributeFilters:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}account_attribute_filters'],
          )!,
      tagFilters:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}tag_filters'],
          )!,
      recordingDirection:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}recording_direction'],
          )!,
      baseCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_currency'],
      ),
      permissionLevel:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}permission_level'],
          )!,
    );
  }

  @override
  $PerspectivesTable createAlias(String alias) {
    return $PerspectivesTable(attachedDatabase, alias);
  }
}

class Perspective extends DataClass implements Insertable<Perspective> {
  final int id;
  final String name;
  final int ownerId;
  final bool isSystem;

  /// T1/T2 분류축 필터 (JSON)
  final String dimensionFilters;

  /// 계정 속성 필터 — 상품구분/금융사 (JSON)
  final String accountAttributeFilters;

  /// T3 태그 필터 (JSON)
  final String tagFilters;

  /// NORMAL | INVERTED (정부회계)
  final String recordingDirection;
  final String? baseCurrency;

  /// FULL | READ_ONLY | RESTRICTED
  final String permissionLevel;
  const Perspective({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.isSystem,
    required this.dimensionFilters,
    required this.accountAttributeFilters,
    required this.tagFilters,
    required this.recordingDirection,
    this.baseCurrency,
    required this.permissionLevel,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['owner_id'] = Variable<int>(ownerId);
    map['is_system'] = Variable<bool>(isSystem);
    map['dimension_filters'] = Variable<String>(dimensionFilters);
    map['account_attribute_filters'] = Variable<String>(
      accountAttributeFilters,
    );
    map['tag_filters'] = Variable<String>(tagFilters);
    map['recording_direction'] = Variable<String>(recordingDirection);
    if (!nullToAbsent || baseCurrency != null) {
      map['base_currency'] = Variable<String>(baseCurrency);
    }
    map['permission_level'] = Variable<String>(permissionLevel);
    return map;
  }

  PerspectivesCompanion toCompanion(bool nullToAbsent) {
    return PerspectivesCompanion(
      id: Value(id),
      name: Value(name),
      ownerId: Value(ownerId),
      isSystem: Value(isSystem),
      dimensionFilters: Value(dimensionFilters),
      accountAttributeFilters: Value(accountAttributeFilters),
      tagFilters: Value(tagFilters),
      recordingDirection: Value(recordingDirection),
      baseCurrency:
          baseCurrency == null && nullToAbsent
              ? const Value.absent()
              : Value(baseCurrency),
      permissionLevel: Value(permissionLevel),
    );
  }

  factory Perspective.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Perspective(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      ownerId: serializer.fromJson<int>(json['ownerId']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
      dimensionFilters: serializer.fromJson<String>(json['dimensionFilters']),
      accountAttributeFilters: serializer.fromJson<String>(
        json['accountAttributeFilters'],
      ),
      tagFilters: serializer.fromJson<String>(json['tagFilters']),
      recordingDirection: serializer.fromJson<String>(
        json['recordingDirection'],
      ),
      baseCurrency: serializer.fromJson<String?>(json['baseCurrency']),
      permissionLevel: serializer.fromJson<String>(json['permissionLevel']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'ownerId': serializer.toJson<int>(ownerId),
      'isSystem': serializer.toJson<bool>(isSystem),
      'dimensionFilters': serializer.toJson<String>(dimensionFilters),
      'accountAttributeFilters': serializer.toJson<String>(
        accountAttributeFilters,
      ),
      'tagFilters': serializer.toJson<String>(tagFilters),
      'recordingDirection': serializer.toJson<String>(recordingDirection),
      'baseCurrency': serializer.toJson<String?>(baseCurrency),
      'permissionLevel': serializer.toJson<String>(permissionLevel),
    };
  }

  Perspective copyWith({
    int? id,
    String? name,
    int? ownerId,
    bool? isSystem,
    String? dimensionFilters,
    String? accountAttributeFilters,
    String? tagFilters,
    String? recordingDirection,
    Value<String?> baseCurrency = const Value.absent(),
    String? permissionLevel,
  }) => Perspective(
    id: id ?? this.id,
    name: name ?? this.name,
    ownerId: ownerId ?? this.ownerId,
    isSystem: isSystem ?? this.isSystem,
    dimensionFilters: dimensionFilters ?? this.dimensionFilters,
    accountAttributeFilters:
        accountAttributeFilters ?? this.accountAttributeFilters,
    tagFilters: tagFilters ?? this.tagFilters,
    recordingDirection: recordingDirection ?? this.recordingDirection,
    baseCurrency: baseCurrency.present ? baseCurrency.value : this.baseCurrency,
    permissionLevel: permissionLevel ?? this.permissionLevel,
  );
  Perspective copyWithCompanion(PerspectivesCompanion data) {
    return Perspective(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
      dimensionFilters:
          data.dimensionFilters.present
              ? data.dimensionFilters.value
              : this.dimensionFilters,
      accountAttributeFilters:
          data.accountAttributeFilters.present
              ? data.accountAttributeFilters.value
              : this.accountAttributeFilters,
      tagFilters:
          data.tagFilters.present ? data.tagFilters.value : this.tagFilters,
      recordingDirection:
          data.recordingDirection.present
              ? data.recordingDirection.value
              : this.recordingDirection,
      baseCurrency:
          data.baseCurrency.present
              ? data.baseCurrency.value
              : this.baseCurrency,
      permissionLevel:
          data.permissionLevel.present
              ? data.permissionLevel.value
              : this.permissionLevel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Perspective(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('ownerId: $ownerId, ')
          ..write('isSystem: $isSystem, ')
          ..write('dimensionFilters: $dimensionFilters, ')
          ..write('accountAttributeFilters: $accountAttributeFilters, ')
          ..write('tagFilters: $tagFilters, ')
          ..write('recordingDirection: $recordingDirection, ')
          ..write('baseCurrency: $baseCurrency, ')
          ..write('permissionLevel: $permissionLevel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    ownerId,
    isSystem,
    dimensionFilters,
    accountAttributeFilters,
    tagFilters,
    recordingDirection,
    baseCurrency,
    permissionLevel,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Perspective &&
          other.id == this.id &&
          other.name == this.name &&
          other.ownerId == this.ownerId &&
          other.isSystem == this.isSystem &&
          other.dimensionFilters == this.dimensionFilters &&
          other.accountAttributeFilters == this.accountAttributeFilters &&
          other.tagFilters == this.tagFilters &&
          other.recordingDirection == this.recordingDirection &&
          other.baseCurrency == this.baseCurrency &&
          other.permissionLevel == this.permissionLevel);
}

class PerspectivesCompanion extends UpdateCompanion<Perspective> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> ownerId;
  final Value<bool> isSystem;
  final Value<String> dimensionFilters;
  final Value<String> accountAttributeFilters;
  final Value<String> tagFilters;
  final Value<String> recordingDirection;
  final Value<String?> baseCurrency;
  final Value<String> permissionLevel;
  const PerspectivesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.dimensionFilters = const Value.absent(),
    this.accountAttributeFilters = const Value.absent(),
    this.tagFilters = const Value.absent(),
    this.recordingDirection = const Value.absent(),
    this.baseCurrency = const Value.absent(),
    this.permissionLevel = const Value.absent(),
  });
  PerspectivesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int ownerId,
    this.isSystem = const Value.absent(),
    this.dimensionFilters = const Value.absent(),
    this.accountAttributeFilters = const Value.absent(),
    this.tagFilters = const Value.absent(),
    this.recordingDirection = const Value.absent(),
    this.baseCurrency = const Value.absent(),
    this.permissionLevel = const Value.absent(),
  }) : name = Value(name),
       ownerId = Value(ownerId);
  static Insertable<Perspective> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? ownerId,
    Expression<bool>? isSystem,
    Expression<String>? dimensionFilters,
    Expression<String>? accountAttributeFilters,
    Expression<String>? tagFilters,
    Expression<String>? recordingDirection,
    Expression<String>? baseCurrency,
    Expression<String>? permissionLevel,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (ownerId != null) 'owner_id': ownerId,
      if (isSystem != null) 'is_system': isSystem,
      if (dimensionFilters != null) 'dimension_filters': dimensionFilters,
      if (accountAttributeFilters != null)
        'account_attribute_filters': accountAttributeFilters,
      if (tagFilters != null) 'tag_filters': tagFilters,
      if (recordingDirection != null) 'recording_direction': recordingDirection,
      if (baseCurrency != null) 'base_currency': baseCurrency,
      if (permissionLevel != null) 'permission_level': permissionLevel,
    });
  }

  PerspectivesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? ownerId,
    Value<bool>? isSystem,
    Value<String>? dimensionFilters,
    Value<String>? accountAttributeFilters,
    Value<String>? tagFilters,
    Value<String>? recordingDirection,
    Value<String?>? baseCurrency,
    Value<String>? permissionLevel,
  }) {
    return PerspectivesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      isSystem: isSystem ?? this.isSystem,
      dimensionFilters: dimensionFilters ?? this.dimensionFilters,
      accountAttributeFilters:
          accountAttributeFilters ?? this.accountAttributeFilters,
      tagFilters: tagFilters ?? this.tagFilters,
      recordingDirection: recordingDirection ?? this.recordingDirection,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      permissionLevel: permissionLevel ?? this.permissionLevel,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<int>(ownerId.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    if (dimensionFilters.present) {
      map['dimension_filters'] = Variable<String>(dimensionFilters.value);
    }
    if (accountAttributeFilters.present) {
      map['account_attribute_filters'] = Variable<String>(
        accountAttributeFilters.value,
      );
    }
    if (tagFilters.present) {
      map['tag_filters'] = Variable<String>(tagFilters.value);
    }
    if (recordingDirection.present) {
      map['recording_direction'] = Variable<String>(recordingDirection.value);
    }
    if (baseCurrency.present) {
      map['base_currency'] = Variable<String>(baseCurrency.value);
    }
    if (permissionLevel.present) {
      map['permission_level'] = Variable<String>(permissionLevel.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PerspectivesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('ownerId: $ownerId, ')
          ..write('isSystem: $isSystem, ')
          ..write('dimensionFilters: $dimensionFilters, ')
          ..write('accountAttributeFilters: $accountAttributeFilters, ')
          ..write('tagFilters: $tagFilters, ')
          ..write('recordingDirection: $recordingDirection, ')
          ..write('baseCurrency: $baseCurrency, ')
          ..write('permissionLevel: $permissionLevel')
          ..write(')'))
        .toString();
  }
}

class $ExchangeRatesTable extends ExchangeRates
    with TableInfo<$ExchangeRatesTable, ExchangeRate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExchangeRatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _fromCurrencyMeta = const VerificationMeta(
    'fromCurrency',
  );
  @override
  late final GeneratedColumn<String> fromCurrency = GeneratedColumn<String>(
    'from_currency',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 3,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toCurrencyMeta = const VerificationMeta(
    'toCurrency',
  );
  @override
  late final GeneratedColumn<String> toCurrency = GeneratedColumn<String>(
    'to_currency',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 3,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<int> rate = GeneratedColumn<int>(
    'rate',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _effectiveDateMeta = const VerificationMeta(
    'effectiveDate',
  );
  @override
  late final GeneratedColumn<DateTime> effectiveDate =
      GeneratedColumn<DateTime>(
        'effective_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purposeMeta = const VerificationMeta(
    'purpose',
  );
  @override
  late final GeneratedColumn<String> purpose = GeneratedColumn<String>(
    'purpose',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ACCOUNTING'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fromCurrency,
    toCurrency,
    rate,
    effectiveDate,
    source,
    purpose,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exchange_rates';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExchangeRate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('from_currency')) {
      context.handle(
        _fromCurrencyMeta,
        fromCurrency.isAcceptableOrUnknown(
          data['from_currency']!,
          _fromCurrencyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fromCurrencyMeta);
    }
    if (data.containsKey('to_currency')) {
      context.handle(
        _toCurrencyMeta,
        toCurrency.isAcceptableOrUnknown(data['to_currency']!, _toCurrencyMeta),
      );
    } else if (isInserting) {
      context.missing(_toCurrencyMeta);
    }
    if (data.containsKey('rate')) {
      context.handle(
        _rateMeta,
        rate.isAcceptableOrUnknown(data['rate']!, _rateMeta),
      );
    } else if (isInserting) {
      context.missing(_rateMeta);
    }
    if (data.containsKey('effective_date')) {
      context.handle(
        _effectiveDateMeta,
        effectiveDate.isAcceptableOrUnknown(
          data['effective_date']!,
          _effectiveDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_effectiveDateMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('purpose')) {
      context.handle(
        _purposeMeta,
        purpose.isAcceptableOrUnknown(data['purpose']!, _purposeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExchangeRate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExchangeRate(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      fromCurrency:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}from_currency'],
          )!,
      toCurrency:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}to_currency'],
          )!,
      rate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}rate'],
          )!,
      effectiveDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}effective_date'],
          )!,
      source:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}source'],
          )!,
      purpose:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}purpose'],
          )!,
    );
  }

  @override
  $ExchangeRatesTable createAlias(String alias) {
    return $ExchangeRatesTable(attachedDatabase, alias);
  }
}

class ExchangeRate extends DataClass implements Insertable<ExchangeRate> {
  final int id;
  final String fromCurrency;
  final String toCurrency;

  /// 환율 (배율 kExchangeRateMultiplier=1,000,000)
  final int rate;
  final DateTime effectiveDate;

  /// 출처 (예: "한국은행", "서울외국환중개")
  final String source;

  /// 회계용/세무용 구분 (해외 확장 예약)
  final String purpose;
  const ExchangeRate({
    required this.id,
    required this.fromCurrency,
    required this.toCurrency,
    required this.rate,
    required this.effectiveDate,
    required this.source,
    required this.purpose,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['from_currency'] = Variable<String>(fromCurrency);
    map['to_currency'] = Variable<String>(toCurrency);
    map['rate'] = Variable<int>(rate);
    map['effective_date'] = Variable<DateTime>(effectiveDate);
    map['source'] = Variable<String>(source);
    map['purpose'] = Variable<String>(purpose);
    return map;
  }

  ExchangeRatesCompanion toCompanion(bool nullToAbsent) {
    return ExchangeRatesCompanion(
      id: Value(id),
      fromCurrency: Value(fromCurrency),
      toCurrency: Value(toCurrency),
      rate: Value(rate),
      effectiveDate: Value(effectiveDate),
      source: Value(source),
      purpose: Value(purpose),
    );
  }

  factory ExchangeRate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExchangeRate(
      id: serializer.fromJson<int>(json['id']),
      fromCurrency: serializer.fromJson<String>(json['fromCurrency']),
      toCurrency: serializer.fromJson<String>(json['toCurrency']),
      rate: serializer.fromJson<int>(json['rate']),
      effectiveDate: serializer.fromJson<DateTime>(json['effectiveDate']),
      source: serializer.fromJson<String>(json['source']),
      purpose: serializer.fromJson<String>(json['purpose']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fromCurrency': serializer.toJson<String>(fromCurrency),
      'toCurrency': serializer.toJson<String>(toCurrency),
      'rate': serializer.toJson<int>(rate),
      'effectiveDate': serializer.toJson<DateTime>(effectiveDate),
      'source': serializer.toJson<String>(source),
      'purpose': serializer.toJson<String>(purpose),
    };
  }

  ExchangeRate copyWith({
    int? id,
    String? fromCurrency,
    String? toCurrency,
    int? rate,
    DateTime? effectiveDate,
    String? source,
    String? purpose,
  }) => ExchangeRate(
    id: id ?? this.id,
    fromCurrency: fromCurrency ?? this.fromCurrency,
    toCurrency: toCurrency ?? this.toCurrency,
    rate: rate ?? this.rate,
    effectiveDate: effectiveDate ?? this.effectiveDate,
    source: source ?? this.source,
    purpose: purpose ?? this.purpose,
  );
  ExchangeRate copyWithCompanion(ExchangeRatesCompanion data) {
    return ExchangeRate(
      id: data.id.present ? data.id.value : this.id,
      fromCurrency:
          data.fromCurrency.present
              ? data.fromCurrency.value
              : this.fromCurrency,
      toCurrency:
          data.toCurrency.present ? data.toCurrency.value : this.toCurrency,
      rate: data.rate.present ? data.rate.value : this.rate,
      effectiveDate:
          data.effectiveDate.present
              ? data.effectiveDate.value
              : this.effectiveDate,
      source: data.source.present ? data.source.value : this.source,
      purpose: data.purpose.present ? data.purpose.value : this.purpose,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExchangeRate(')
          ..write('id: $id, ')
          ..write('fromCurrency: $fromCurrency, ')
          ..write('toCurrency: $toCurrency, ')
          ..write('rate: $rate, ')
          ..write('effectiveDate: $effectiveDate, ')
          ..write('source: $source, ')
          ..write('purpose: $purpose')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fromCurrency,
    toCurrency,
    rate,
    effectiveDate,
    source,
    purpose,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExchangeRate &&
          other.id == this.id &&
          other.fromCurrency == this.fromCurrency &&
          other.toCurrency == this.toCurrency &&
          other.rate == this.rate &&
          other.effectiveDate == this.effectiveDate &&
          other.source == this.source &&
          other.purpose == this.purpose);
}

class ExchangeRatesCompanion extends UpdateCompanion<ExchangeRate> {
  final Value<int> id;
  final Value<String> fromCurrency;
  final Value<String> toCurrency;
  final Value<int> rate;
  final Value<DateTime> effectiveDate;
  final Value<String> source;
  final Value<String> purpose;
  const ExchangeRatesCompanion({
    this.id = const Value.absent(),
    this.fromCurrency = const Value.absent(),
    this.toCurrency = const Value.absent(),
    this.rate = const Value.absent(),
    this.effectiveDate = const Value.absent(),
    this.source = const Value.absent(),
    this.purpose = const Value.absent(),
  });
  ExchangeRatesCompanion.insert({
    this.id = const Value.absent(),
    required String fromCurrency,
    required String toCurrency,
    required int rate,
    required DateTime effectiveDate,
    required String source,
    this.purpose = const Value.absent(),
  }) : fromCurrency = Value(fromCurrency),
       toCurrency = Value(toCurrency),
       rate = Value(rate),
       effectiveDate = Value(effectiveDate),
       source = Value(source);
  static Insertable<ExchangeRate> custom({
    Expression<int>? id,
    Expression<String>? fromCurrency,
    Expression<String>? toCurrency,
    Expression<int>? rate,
    Expression<DateTime>? effectiveDate,
    Expression<String>? source,
    Expression<String>? purpose,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fromCurrency != null) 'from_currency': fromCurrency,
      if (toCurrency != null) 'to_currency': toCurrency,
      if (rate != null) 'rate': rate,
      if (effectiveDate != null) 'effective_date': effectiveDate,
      if (source != null) 'source': source,
      if (purpose != null) 'purpose': purpose,
    });
  }

  ExchangeRatesCompanion copyWith({
    Value<int>? id,
    Value<String>? fromCurrency,
    Value<String>? toCurrency,
    Value<int>? rate,
    Value<DateTime>? effectiveDate,
    Value<String>? source,
    Value<String>? purpose,
  }) {
    return ExchangeRatesCompanion(
      id: id ?? this.id,
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      rate: rate ?? this.rate,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      source: source ?? this.source,
      purpose: purpose ?? this.purpose,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fromCurrency.present) {
      map['from_currency'] = Variable<String>(fromCurrency.value);
    }
    if (toCurrency.present) {
      map['to_currency'] = Variable<String>(toCurrency.value);
    }
    if (rate.present) {
      map['rate'] = Variable<int>(rate.value);
    }
    if (effectiveDate.present) {
      map['effective_date'] = Variable<DateTime>(effectiveDate.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (purpose.present) {
      map['purpose'] = Variable<String>(purpose.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExchangeRatesCompanion(')
          ..write('id: $id, ')
          ..write('fromCurrency: $fromCurrency, ')
          ..write('toCurrency: $toCurrency, ')
          ..write('rate: $rate, ')
          ..write('effectiveDate: $effectiveDate, ')
          ..write('source: $source, ')
          ..write('purpose: $purpose')
          ..write(')'))
        .toString();
  }
}

class $LegalParametersTable extends LegalParameters
    with TableInfo<$LegalParametersTable, LegalParameter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegalParametersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _countryCodeMeta = const VerificationMeta(
    'countryCode',
  );
  @override
  late final GeneratedColumn<String> countryCode = GeneratedColumn<String>(
    'country_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('KR'),
  );
  static const VerificationMeta _domainMeta = const VerificationMeta('domain');
  @override
  late final GeneratedColumn<String> domain = GeneratedColumn<String>(
    'domain',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paramTypeMeta = const VerificationMeta(
    'paramType',
  );
  @override
  late final GeneratedColumn<String> paramType = GeneratedColumn<String>(
    'param_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tableDataMeta = const VerificationMeta(
    'tableData',
  );
  @override
  late final GeneratedColumn<String> tableData = GeneratedColumn<String>(
    'table_data',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _formulaMeta = const VerificationMeta(
    'formula',
  );
  @override
  late final GeneratedColumn<String> formula = GeneratedColumn<String>(
    'formula',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _inputVariablesMeta = const VerificationMeta(
    'inputVariables',
  );
  @override
  late final GeneratedColumn<String> inputVariables = GeneratedColumn<String>(
    'input_variables',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _effectiveFromMeta = const VerificationMeta(
    'effectiveFrom',
  );
  @override
  late final GeneratedColumn<DateTime> effectiveFrom =
      GeneratedColumn<DateTime>(
        'effective_from',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _effectiveToMeta = const VerificationMeta(
    'effectiveTo',
  );
  @override
  late final GeneratedColumn<DateTime> effectiveTo = GeneratedColumn<DateTime>(
    'effective_to',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _applicationBasisMeta = const VerificationMeta(
    'applicationBasis',
  );
  @override
  late final GeneratedColumn<String> applicationBasis = GeneratedColumn<String>(
    'application_basis',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _retroactiveMeta = const VerificationMeta(
    'retroactive',
  );
  @override
  late final GeneratedColumn<bool> retroactive = GeneratedColumn<bool>(
    'retroactive',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("retroactive" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sourceLawMeta = const VerificationMeta(
    'sourceLaw',
  );
  @override
  late final GeneratedColumn<String> sourceLaw = GeneratedColumn<String>(
    'source_law',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _conditionsMeta = const VerificationMeta(
    'conditions',
  );
  @override
  late final GeneratedColumn<String> conditions = GeneratedColumn<String>(
    'conditions',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    countryCode,
    domain,
    key,
    paramType,
    value,
    tableData,
    formula,
    inputVariables,
    effectiveFrom,
    effectiveTo,
    applicationBasis,
    retroactive,
    sourceLaw,
    conditions,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'legal_parameters';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegalParameter> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('country_code')) {
      context.handle(
        _countryCodeMeta,
        countryCode.isAcceptableOrUnknown(
          data['country_code']!,
          _countryCodeMeta,
        ),
      );
    }
    if (data.containsKey('domain')) {
      context.handle(
        _domainMeta,
        domain.isAcceptableOrUnknown(data['domain']!, _domainMeta),
      );
    } else if (isInserting) {
      context.missing(_domainMeta);
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('param_type')) {
      context.handle(
        _paramTypeMeta,
        paramType.isAcceptableOrUnknown(data['param_type']!, _paramTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_paramTypeMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    if (data.containsKey('table_data')) {
      context.handle(
        _tableDataMeta,
        tableData.isAcceptableOrUnknown(data['table_data']!, _tableDataMeta),
      );
    }
    if (data.containsKey('formula')) {
      context.handle(
        _formulaMeta,
        formula.isAcceptableOrUnknown(data['formula']!, _formulaMeta),
      );
    }
    if (data.containsKey('input_variables')) {
      context.handle(
        _inputVariablesMeta,
        inputVariables.isAcceptableOrUnknown(
          data['input_variables']!,
          _inputVariablesMeta,
        ),
      );
    }
    if (data.containsKey('effective_from')) {
      context.handle(
        _effectiveFromMeta,
        effectiveFrom.isAcceptableOrUnknown(
          data['effective_from']!,
          _effectiveFromMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_effectiveFromMeta);
    }
    if (data.containsKey('effective_to')) {
      context.handle(
        _effectiveToMeta,
        effectiveTo.isAcceptableOrUnknown(
          data['effective_to']!,
          _effectiveToMeta,
        ),
      );
    }
    if (data.containsKey('application_basis')) {
      context.handle(
        _applicationBasisMeta,
        applicationBasis.isAcceptableOrUnknown(
          data['application_basis']!,
          _applicationBasisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_applicationBasisMeta);
    }
    if (data.containsKey('retroactive')) {
      context.handle(
        _retroactiveMeta,
        retroactive.isAcceptableOrUnknown(
          data['retroactive']!,
          _retroactiveMeta,
        ),
      );
    }
    if (data.containsKey('source_law')) {
      context.handle(
        _sourceLawMeta,
        sourceLaw.isAcceptableOrUnknown(data['source_law']!, _sourceLawMeta),
      );
    }
    if (data.containsKey('conditions')) {
      context.handle(
        _conditionsMeta,
        conditions.isAcceptableOrUnknown(data['conditions']!, _conditionsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LegalParameter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegalParameter(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      countryCode:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}country_code'],
          )!,
      domain:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}domain'],
          )!,
      key:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}key'],
          )!,
      paramType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}param_type'],
          )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      ),
      tableData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}table_data'],
      ),
      formula: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}formula'],
      ),
      inputVariables: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}input_variables'],
      ),
      effectiveFrom:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}effective_from'],
          )!,
      effectiveTo: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}effective_to'],
      ),
      applicationBasis:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}application_basis'],
          )!,
      retroactive:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}retroactive'],
          )!,
      sourceLaw: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_law'],
      ),
      conditions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conditions'],
      ),
    );
  }

  @override
  $LegalParametersTable createAlias(String alias) {
    return $LegalParametersTable(attachedDatabase, alias);
  }
}

class LegalParameter extends DataClass implements Insertable<LegalParameter> {
  final int id;
  final String countryCode;

  /// ACCOUNTING | CAPITAL | TAX
  final String domain;

  /// 파라미터 키 (예: "접대비_한도율")
  final String key;

  /// VALUE | TABLE | FORMULA
  final String paramType;

  /// 단순값 (JSON)
  final String? value;

  /// 구간 테이블 (JSON, 누진세율 등)
  final String? tableData;

  /// 수식 문자열
  final String? formula;

  /// 수식 입력 변수 (JSON)
  final String? inputVariables;
  final DateTime effectiveFrom;
  final DateTime? effectiveTo;

  /// TRANSACTION_DATE | FISCAL_YEAR | FILING_DEADLINE
  final String applicationBasis;
  final bool retroactive;

  /// 근거 법령 (예: "법인세법 제25조")
  final String? sourceLaw;

  /// 국가별 특수 조건 (JSON)
  final String? conditions;
  const LegalParameter({
    required this.id,
    required this.countryCode,
    required this.domain,
    required this.key,
    required this.paramType,
    this.value,
    this.tableData,
    this.formula,
    this.inputVariables,
    required this.effectiveFrom,
    this.effectiveTo,
    required this.applicationBasis,
    required this.retroactive,
    this.sourceLaw,
    this.conditions,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['country_code'] = Variable<String>(countryCode);
    map['domain'] = Variable<String>(domain);
    map['key'] = Variable<String>(key);
    map['param_type'] = Variable<String>(paramType);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<String>(value);
    }
    if (!nullToAbsent || tableData != null) {
      map['table_data'] = Variable<String>(tableData);
    }
    if (!nullToAbsent || formula != null) {
      map['formula'] = Variable<String>(formula);
    }
    if (!nullToAbsent || inputVariables != null) {
      map['input_variables'] = Variable<String>(inputVariables);
    }
    map['effective_from'] = Variable<DateTime>(effectiveFrom);
    if (!nullToAbsent || effectiveTo != null) {
      map['effective_to'] = Variable<DateTime>(effectiveTo);
    }
    map['application_basis'] = Variable<String>(applicationBasis);
    map['retroactive'] = Variable<bool>(retroactive);
    if (!nullToAbsent || sourceLaw != null) {
      map['source_law'] = Variable<String>(sourceLaw);
    }
    if (!nullToAbsent || conditions != null) {
      map['conditions'] = Variable<String>(conditions);
    }
    return map;
  }

  LegalParametersCompanion toCompanion(bool nullToAbsent) {
    return LegalParametersCompanion(
      id: Value(id),
      countryCode: Value(countryCode),
      domain: Value(domain),
      key: Value(key),
      paramType: Value(paramType),
      value:
          value == null && nullToAbsent ? const Value.absent() : Value(value),
      tableData:
          tableData == null && nullToAbsent
              ? const Value.absent()
              : Value(tableData),
      formula:
          formula == null && nullToAbsent
              ? const Value.absent()
              : Value(formula),
      inputVariables:
          inputVariables == null && nullToAbsent
              ? const Value.absent()
              : Value(inputVariables),
      effectiveFrom: Value(effectiveFrom),
      effectiveTo:
          effectiveTo == null && nullToAbsent
              ? const Value.absent()
              : Value(effectiveTo),
      applicationBasis: Value(applicationBasis),
      retroactive: Value(retroactive),
      sourceLaw:
          sourceLaw == null && nullToAbsent
              ? const Value.absent()
              : Value(sourceLaw),
      conditions:
          conditions == null && nullToAbsent
              ? const Value.absent()
              : Value(conditions),
    );
  }

  factory LegalParameter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegalParameter(
      id: serializer.fromJson<int>(json['id']),
      countryCode: serializer.fromJson<String>(json['countryCode']),
      domain: serializer.fromJson<String>(json['domain']),
      key: serializer.fromJson<String>(json['key']),
      paramType: serializer.fromJson<String>(json['paramType']),
      value: serializer.fromJson<String?>(json['value']),
      tableData: serializer.fromJson<String?>(json['tableData']),
      formula: serializer.fromJson<String?>(json['formula']),
      inputVariables: serializer.fromJson<String?>(json['inputVariables']),
      effectiveFrom: serializer.fromJson<DateTime>(json['effectiveFrom']),
      effectiveTo: serializer.fromJson<DateTime?>(json['effectiveTo']),
      applicationBasis: serializer.fromJson<String>(json['applicationBasis']),
      retroactive: serializer.fromJson<bool>(json['retroactive']),
      sourceLaw: serializer.fromJson<String?>(json['sourceLaw']),
      conditions: serializer.fromJson<String?>(json['conditions']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'countryCode': serializer.toJson<String>(countryCode),
      'domain': serializer.toJson<String>(domain),
      'key': serializer.toJson<String>(key),
      'paramType': serializer.toJson<String>(paramType),
      'value': serializer.toJson<String?>(value),
      'tableData': serializer.toJson<String?>(tableData),
      'formula': serializer.toJson<String?>(formula),
      'inputVariables': serializer.toJson<String?>(inputVariables),
      'effectiveFrom': serializer.toJson<DateTime>(effectiveFrom),
      'effectiveTo': serializer.toJson<DateTime?>(effectiveTo),
      'applicationBasis': serializer.toJson<String>(applicationBasis),
      'retroactive': serializer.toJson<bool>(retroactive),
      'sourceLaw': serializer.toJson<String?>(sourceLaw),
      'conditions': serializer.toJson<String?>(conditions),
    };
  }

  LegalParameter copyWith({
    int? id,
    String? countryCode,
    String? domain,
    String? key,
    String? paramType,
    Value<String?> value = const Value.absent(),
    Value<String?> tableData = const Value.absent(),
    Value<String?> formula = const Value.absent(),
    Value<String?> inputVariables = const Value.absent(),
    DateTime? effectiveFrom,
    Value<DateTime?> effectiveTo = const Value.absent(),
    String? applicationBasis,
    bool? retroactive,
    Value<String?> sourceLaw = const Value.absent(),
    Value<String?> conditions = const Value.absent(),
  }) => LegalParameter(
    id: id ?? this.id,
    countryCode: countryCode ?? this.countryCode,
    domain: domain ?? this.domain,
    key: key ?? this.key,
    paramType: paramType ?? this.paramType,
    value: value.present ? value.value : this.value,
    tableData: tableData.present ? tableData.value : this.tableData,
    formula: formula.present ? formula.value : this.formula,
    inputVariables:
        inputVariables.present ? inputVariables.value : this.inputVariables,
    effectiveFrom: effectiveFrom ?? this.effectiveFrom,
    effectiveTo: effectiveTo.present ? effectiveTo.value : this.effectiveTo,
    applicationBasis: applicationBasis ?? this.applicationBasis,
    retroactive: retroactive ?? this.retroactive,
    sourceLaw: sourceLaw.present ? sourceLaw.value : this.sourceLaw,
    conditions: conditions.present ? conditions.value : this.conditions,
  );
  LegalParameter copyWithCompanion(LegalParametersCompanion data) {
    return LegalParameter(
      id: data.id.present ? data.id.value : this.id,
      countryCode:
          data.countryCode.present ? data.countryCode.value : this.countryCode,
      domain: data.domain.present ? data.domain.value : this.domain,
      key: data.key.present ? data.key.value : this.key,
      paramType: data.paramType.present ? data.paramType.value : this.paramType,
      value: data.value.present ? data.value.value : this.value,
      tableData: data.tableData.present ? data.tableData.value : this.tableData,
      formula: data.formula.present ? data.formula.value : this.formula,
      inputVariables:
          data.inputVariables.present
              ? data.inputVariables.value
              : this.inputVariables,
      effectiveFrom:
          data.effectiveFrom.present
              ? data.effectiveFrom.value
              : this.effectiveFrom,
      effectiveTo:
          data.effectiveTo.present ? data.effectiveTo.value : this.effectiveTo,
      applicationBasis:
          data.applicationBasis.present
              ? data.applicationBasis.value
              : this.applicationBasis,
      retroactive:
          data.retroactive.present ? data.retroactive.value : this.retroactive,
      sourceLaw: data.sourceLaw.present ? data.sourceLaw.value : this.sourceLaw,
      conditions:
          data.conditions.present ? data.conditions.value : this.conditions,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegalParameter(')
          ..write('id: $id, ')
          ..write('countryCode: $countryCode, ')
          ..write('domain: $domain, ')
          ..write('key: $key, ')
          ..write('paramType: $paramType, ')
          ..write('value: $value, ')
          ..write('tableData: $tableData, ')
          ..write('formula: $formula, ')
          ..write('inputVariables: $inputVariables, ')
          ..write('effectiveFrom: $effectiveFrom, ')
          ..write('effectiveTo: $effectiveTo, ')
          ..write('applicationBasis: $applicationBasis, ')
          ..write('retroactive: $retroactive, ')
          ..write('sourceLaw: $sourceLaw, ')
          ..write('conditions: $conditions')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    countryCode,
    domain,
    key,
    paramType,
    value,
    tableData,
    formula,
    inputVariables,
    effectiveFrom,
    effectiveTo,
    applicationBasis,
    retroactive,
    sourceLaw,
    conditions,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegalParameter &&
          other.id == this.id &&
          other.countryCode == this.countryCode &&
          other.domain == this.domain &&
          other.key == this.key &&
          other.paramType == this.paramType &&
          other.value == this.value &&
          other.tableData == this.tableData &&
          other.formula == this.formula &&
          other.inputVariables == this.inputVariables &&
          other.effectiveFrom == this.effectiveFrom &&
          other.effectiveTo == this.effectiveTo &&
          other.applicationBasis == this.applicationBasis &&
          other.retroactive == this.retroactive &&
          other.sourceLaw == this.sourceLaw &&
          other.conditions == this.conditions);
}

class LegalParametersCompanion extends UpdateCompanion<LegalParameter> {
  final Value<int> id;
  final Value<String> countryCode;
  final Value<String> domain;
  final Value<String> key;
  final Value<String> paramType;
  final Value<String?> value;
  final Value<String?> tableData;
  final Value<String?> formula;
  final Value<String?> inputVariables;
  final Value<DateTime> effectiveFrom;
  final Value<DateTime?> effectiveTo;
  final Value<String> applicationBasis;
  final Value<bool> retroactive;
  final Value<String?> sourceLaw;
  final Value<String?> conditions;
  const LegalParametersCompanion({
    this.id = const Value.absent(),
    this.countryCode = const Value.absent(),
    this.domain = const Value.absent(),
    this.key = const Value.absent(),
    this.paramType = const Value.absent(),
    this.value = const Value.absent(),
    this.tableData = const Value.absent(),
    this.formula = const Value.absent(),
    this.inputVariables = const Value.absent(),
    this.effectiveFrom = const Value.absent(),
    this.effectiveTo = const Value.absent(),
    this.applicationBasis = const Value.absent(),
    this.retroactive = const Value.absent(),
    this.sourceLaw = const Value.absent(),
    this.conditions = const Value.absent(),
  });
  LegalParametersCompanion.insert({
    this.id = const Value.absent(),
    this.countryCode = const Value.absent(),
    required String domain,
    required String key,
    required String paramType,
    this.value = const Value.absent(),
    this.tableData = const Value.absent(),
    this.formula = const Value.absent(),
    this.inputVariables = const Value.absent(),
    required DateTime effectiveFrom,
    this.effectiveTo = const Value.absent(),
    required String applicationBasis,
    this.retroactive = const Value.absent(),
    this.sourceLaw = const Value.absent(),
    this.conditions = const Value.absent(),
  }) : domain = Value(domain),
       key = Value(key),
       paramType = Value(paramType),
       effectiveFrom = Value(effectiveFrom),
       applicationBasis = Value(applicationBasis);
  static Insertable<LegalParameter> custom({
    Expression<int>? id,
    Expression<String>? countryCode,
    Expression<String>? domain,
    Expression<String>? key,
    Expression<String>? paramType,
    Expression<String>? value,
    Expression<String>? tableData,
    Expression<String>? formula,
    Expression<String>? inputVariables,
    Expression<DateTime>? effectiveFrom,
    Expression<DateTime>? effectiveTo,
    Expression<String>? applicationBasis,
    Expression<bool>? retroactive,
    Expression<String>? sourceLaw,
    Expression<String>? conditions,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (countryCode != null) 'country_code': countryCode,
      if (domain != null) 'domain': domain,
      if (key != null) 'key': key,
      if (paramType != null) 'param_type': paramType,
      if (value != null) 'value': value,
      if (tableData != null) 'table_data': tableData,
      if (formula != null) 'formula': formula,
      if (inputVariables != null) 'input_variables': inputVariables,
      if (effectiveFrom != null) 'effective_from': effectiveFrom,
      if (effectiveTo != null) 'effective_to': effectiveTo,
      if (applicationBasis != null) 'application_basis': applicationBasis,
      if (retroactive != null) 'retroactive': retroactive,
      if (sourceLaw != null) 'source_law': sourceLaw,
      if (conditions != null) 'conditions': conditions,
    });
  }

  LegalParametersCompanion copyWith({
    Value<int>? id,
    Value<String>? countryCode,
    Value<String>? domain,
    Value<String>? key,
    Value<String>? paramType,
    Value<String?>? value,
    Value<String?>? tableData,
    Value<String?>? formula,
    Value<String?>? inputVariables,
    Value<DateTime>? effectiveFrom,
    Value<DateTime?>? effectiveTo,
    Value<String>? applicationBasis,
    Value<bool>? retroactive,
    Value<String?>? sourceLaw,
    Value<String?>? conditions,
  }) {
    return LegalParametersCompanion(
      id: id ?? this.id,
      countryCode: countryCode ?? this.countryCode,
      domain: domain ?? this.domain,
      key: key ?? this.key,
      paramType: paramType ?? this.paramType,
      value: value ?? this.value,
      tableData: tableData ?? this.tableData,
      formula: formula ?? this.formula,
      inputVariables: inputVariables ?? this.inputVariables,
      effectiveFrom: effectiveFrom ?? this.effectiveFrom,
      effectiveTo: effectiveTo ?? this.effectiveTo,
      applicationBasis: applicationBasis ?? this.applicationBasis,
      retroactive: retroactive ?? this.retroactive,
      sourceLaw: sourceLaw ?? this.sourceLaw,
      conditions: conditions ?? this.conditions,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (countryCode.present) {
      map['country_code'] = Variable<String>(countryCode.value);
    }
    if (domain.present) {
      map['domain'] = Variable<String>(domain.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (paramType.present) {
      map['param_type'] = Variable<String>(paramType.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (tableData.present) {
      map['table_data'] = Variable<String>(tableData.value);
    }
    if (formula.present) {
      map['formula'] = Variable<String>(formula.value);
    }
    if (inputVariables.present) {
      map['input_variables'] = Variable<String>(inputVariables.value);
    }
    if (effectiveFrom.present) {
      map['effective_from'] = Variable<DateTime>(effectiveFrom.value);
    }
    if (effectiveTo.present) {
      map['effective_to'] = Variable<DateTime>(effectiveTo.value);
    }
    if (applicationBasis.present) {
      map['application_basis'] = Variable<String>(applicationBasis.value);
    }
    if (retroactive.present) {
      map['retroactive'] = Variable<bool>(retroactive.value);
    }
    if (sourceLaw.present) {
      map['source_law'] = Variable<String>(sourceLaw.value);
    }
    if (conditions.present) {
      map['conditions'] = Variable<String>(conditions.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegalParametersCompanion(')
          ..write('id: $id, ')
          ..write('countryCode: $countryCode, ')
          ..write('domain: $domain, ')
          ..write('key: $key, ')
          ..write('paramType: $paramType, ')
          ..write('value: $value, ')
          ..write('tableData: $tableData, ')
          ..write('formula: $formula, ')
          ..write('inputVariables: $inputVariables, ')
          ..write('effectiveFrom: $effectiveFrom, ')
          ..write('effectiveTo: $effectiveTo, ')
          ..write('applicationBasis: $applicationBasis, ')
          ..write('retroactive: $retroactive, ')
          ..write('sourceLaw: $sourceLaw, ')
          ..write('conditions: $conditions')
          ..write(')'))
        .toString();
  }
}

class $ClassificationRulesTable extends ClassificationRules
    with TableInfo<$ClassificationRulesTable, ClassificationRule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClassificationRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _patternMeta = const VerificationMeta(
    'pattern',
  );
  @override
  late final GeneratedColumn<String> pattern = GeneratedColumn<String>(
    'pattern',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _patternTypeMeta = const VerificationMeta(
    'patternType',
  );
  @override
  late final GeneratedColumn<String> patternType = GeneratedColumn<String>(
    'pattern_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _counterpartyIdMeta = const VerificationMeta(
    'counterpartyId',
  );
  @override
  late final GeneratedColumn<int> counterpartyId = GeneratedColumn<int>(
    'counterparty_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES counterparties (id)',
    ),
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isSystemRuleMeta = const VerificationMeta(
    'isSystemRule',
  );
  @override
  late final GeneratedColumn<bool> isSystemRule = GeneratedColumn<bool>(
    'is_system_rule',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_system_rule" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isUserRuleMeta = const VerificationMeta(
    'isUserRule',
  );
  @override
  late final GeneratedColumn<bool> isUserRule = GeneratedColumn<bool>(
    'is_user_rule',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_user_rule" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    pattern,
    patternType,
    accountId,
    counterpartyId,
    priority,
    isSystemRule,
    isUserRule,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'classification_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClassificationRule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pattern')) {
      context.handle(
        _patternMeta,
        pattern.isAcceptableOrUnknown(data['pattern']!, _patternMeta),
      );
    } else if (isInserting) {
      context.missing(_patternMeta);
    }
    if (data.containsKey('pattern_type')) {
      context.handle(
        _patternTypeMeta,
        patternType.isAcceptableOrUnknown(
          data['pattern_type']!,
          _patternTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_patternTypeMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('counterparty_id')) {
      context.handle(
        _counterpartyIdMeta,
        counterpartyId.isAcceptableOrUnknown(
          data['counterparty_id']!,
          _counterpartyIdMeta,
        ),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('is_system_rule')) {
      context.handle(
        _isSystemRuleMeta,
        isSystemRule.isAcceptableOrUnknown(
          data['is_system_rule']!,
          _isSystemRuleMeta,
        ),
      );
    }
    if (data.containsKey('is_user_rule')) {
      context.handle(
        _isUserRuleMeta,
        isUserRule.isAcceptableOrUnknown(
          data['is_user_rule']!,
          _isUserRuleMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ClassificationRule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClassificationRule(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      pattern:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}pattern'],
          )!,
      patternType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}pattern_type'],
          )!,
      accountId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}account_id'],
          )!,
      counterpartyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}counterparty_id'],
      ),
      priority:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}priority'],
          )!,
      isSystemRule:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_system_rule'],
          )!,
      isUserRule:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_user_rule'],
          )!,
    );
  }

  @override
  $ClassificationRulesTable createAlias(String alias) {
    return $ClassificationRulesTable(attachedDatabase, alias);
  }
}

class ClassificationRule extends DataClass
    implements Insertable<ClassificationRule> {
  final int id;

  /// 매칭 패턴 (예: "스타벅스", "STARBUCKS*")
  final String pattern;

  /// EXACT | CONTAINS | REGEX
  final String patternType;
  final int accountId;
  final int? counterpartyId;

  /// 우선순위 (높을수록 우선, 사용자 규칙 > 시스템 규칙)
  final int priority;
  final bool isSystemRule;
  final bool isUserRule;
  const ClassificationRule({
    required this.id,
    required this.pattern,
    required this.patternType,
    required this.accountId,
    this.counterpartyId,
    required this.priority,
    required this.isSystemRule,
    required this.isUserRule,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pattern'] = Variable<String>(pattern);
    map['pattern_type'] = Variable<String>(patternType);
    map['account_id'] = Variable<int>(accountId);
    if (!nullToAbsent || counterpartyId != null) {
      map['counterparty_id'] = Variable<int>(counterpartyId);
    }
    map['priority'] = Variable<int>(priority);
    map['is_system_rule'] = Variable<bool>(isSystemRule);
    map['is_user_rule'] = Variable<bool>(isUserRule);
    return map;
  }

  ClassificationRulesCompanion toCompanion(bool nullToAbsent) {
    return ClassificationRulesCompanion(
      id: Value(id),
      pattern: Value(pattern),
      patternType: Value(patternType),
      accountId: Value(accountId),
      counterpartyId:
          counterpartyId == null && nullToAbsent
              ? const Value.absent()
              : Value(counterpartyId),
      priority: Value(priority),
      isSystemRule: Value(isSystemRule),
      isUserRule: Value(isUserRule),
    );
  }

  factory ClassificationRule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClassificationRule(
      id: serializer.fromJson<int>(json['id']),
      pattern: serializer.fromJson<String>(json['pattern']),
      patternType: serializer.fromJson<String>(json['patternType']),
      accountId: serializer.fromJson<int>(json['accountId']),
      counterpartyId: serializer.fromJson<int?>(json['counterpartyId']),
      priority: serializer.fromJson<int>(json['priority']),
      isSystemRule: serializer.fromJson<bool>(json['isSystemRule']),
      isUserRule: serializer.fromJson<bool>(json['isUserRule']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pattern': serializer.toJson<String>(pattern),
      'patternType': serializer.toJson<String>(patternType),
      'accountId': serializer.toJson<int>(accountId),
      'counterpartyId': serializer.toJson<int?>(counterpartyId),
      'priority': serializer.toJson<int>(priority),
      'isSystemRule': serializer.toJson<bool>(isSystemRule),
      'isUserRule': serializer.toJson<bool>(isUserRule),
    };
  }

  ClassificationRule copyWith({
    int? id,
    String? pattern,
    String? patternType,
    int? accountId,
    Value<int?> counterpartyId = const Value.absent(),
    int? priority,
    bool? isSystemRule,
    bool? isUserRule,
  }) => ClassificationRule(
    id: id ?? this.id,
    pattern: pattern ?? this.pattern,
    patternType: patternType ?? this.patternType,
    accountId: accountId ?? this.accountId,
    counterpartyId:
        counterpartyId.present ? counterpartyId.value : this.counterpartyId,
    priority: priority ?? this.priority,
    isSystemRule: isSystemRule ?? this.isSystemRule,
    isUserRule: isUserRule ?? this.isUserRule,
  );
  ClassificationRule copyWithCompanion(ClassificationRulesCompanion data) {
    return ClassificationRule(
      id: data.id.present ? data.id.value : this.id,
      pattern: data.pattern.present ? data.pattern.value : this.pattern,
      patternType:
          data.patternType.present ? data.patternType.value : this.patternType,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      counterpartyId:
          data.counterpartyId.present
              ? data.counterpartyId.value
              : this.counterpartyId,
      priority: data.priority.present ? data.priority.value : this.priority,
      isSystemRule:
          data.isSystemRule.present
              ? data.isSystemRule.value
              : this.isSystemRule,
      isUserRule:
          data.isUserRule.present ? data.isUserRule.value : this.isUserRule,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClassificationRule(')
          ..write('id: $id, ')
          ..write('pattern: $pattern, ')
          ..write('patternType: $patternType, ')
          ..write('accountId: $accountId, ')
          ..write('counterpartyId: $counterpartyId, ')
          ..write('priority: $priority, ')
          ..write('isSystemRule: $isSystemRule, ')
          ..write('isUserRule: $isUserRule')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    pattern,
    patternType,
    accountId,
    counterpartyId,
    priority,
    isSystemRule,
    isUserRule,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClassificationRule &&
          other.id == this.id &&
          other.pattern == this.pattern &&
          other.patternType == this.patternType &&
          other.accountId == this.accountId &&
          other.counterpartyId == this.counterpartyId &&
          other.priority == this.priority &&
          other.isSystemRule == this.isSystemRule &&
          other.isUserRule == this.isUserRule);
}

class ClassificationRulesCompanion extends UpdateCompanion<ClassificationRule> {
  final Value<int> id;
  final Value<String> pattern;
  final Value<String> patternType;
  final Value<int> accountId;
  final Value<int?> counterpartyId;
  final Value<int> priority;
  final Value<bool> isSystemRule;
  final Value<bool> isUserRule;
  const ClassificationRulesCompanion({
    this.id = const Value.absent(),
    this.pattern = const Value.absent(),
    this.patternType = const Value.absent(),
    this.accountId = const Value.absent(),
    this.counterpartyId = const Value.absent(),
    this.priority = const Value.absent(),
    this.isSystemRule = const Value.absent(),
    this.isUserRule = const Value.absent(),
  });
  ClassificationRulesCompanion.insert({
    this.id = const Value.absent(),
    required String pattern,
    required String patternType,
    required int accountId,
    this.counterpartyId = const Value.absent(),
    this.priority = const Value.absent(),
    this.isSystemRule = const Value.absent(),
    this.isUserRule = const Value.absent(),
  }) : pattern = Value(pattern),
       patternType = Value(patternType),
       accountId = Value(accountId);
  static Insertable<ClassificationRule> custom({
    Expression<int>? id,
    Expression<String>? pattern,
    Expression<String>? patternType,
    Expression<int>? accountId,
    Expression<int>? counterpartyId,
    Expression<int>? priority,
    Expression<bool>? isSystemRule,
    Expression<bool>? isUserRule,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pattern != null) 'pattern': pattern,
      if (patternType != null) 'pattern_type': patternType,
      if (accountId != null) 'account_id': accountId,
      if (counterpartyId != null) 'counterparty_id': counterpartyId,
      if (priority != null) 'priority': priority,
      if (isSystemRule != null) 'is_system_rule': isSystemRule,
      if (isUserRule != null) 'is_user_rule': isUserRule,
    });
  }

  ClassificationRulesCompanion copyWith({
    Value<int>? id,
    Value<String>? pattern,
    Value<String>? patternType,
    Value<int>? accountId,
    Value<int?>? counterpartyId,
    Value<int>? priority,
    Value<bool>? isSystemRule,
    Value<bool>? isUserRule,
  }) {
    return ClassificationRulesCompanion(
      id: id ?? this.id,
      pattern: pattern ?? this.pattern,
      patternType: patternType ?? this.patternType,
      accountId: accountId ?? this.accountId,
      counterpartyId: counterpartyId ?? this.counterpartyId,
      priority: priority ?? this.priority,
      isSystemRule: isSystemRule ?? this.isSystemRule,
      isUserRule: isUserRule ?? this.isUserRule,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pattern.present) {
      map['pattern'] = Variable<String>(pattern.value);
    }
    if (patternType.present) {
      map['pattern_type'] = Variable<String>(patternType.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (counterpartyId.present) {
      map['counterparty_id'] = Variable<int>(counterpartyId.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (isSystemRule.present) {
      map['is_system_rule'] = Variable<bool>(isSystemRule.value);
    }
    if (isUserRule.present) {
      map['is_user_rule'] = Variable<bool>(isUserRule.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClassificationRulesCompanion(')
          ..write('id: $id, ')
          ..write('pattern: $pattern, ')
          ..write('patternType: $patternType, ')
          ..write('accountId: $accountId, ')
          ..write('counterpartyId: $counterpartyId, ')
          ..write('priority: $priority, ')
          ..write('isSystemRule: $isSystemRule, ')
          ..write('isUserRule: $isUserRule')
          ..write(')'))
        .toString();
  }
}

class $FiscalPeriodsTable extends FiscalPeriods
    with TableInfo<$FiscalPeriodsTable, FiscalPeriod> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FiscalPeriodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isClosedMeta = const VerificationMeta(
    'isClosed',
  );
  @override
  late final GeneratedColumn<bool> isClosed = GeneratedColumn<bool>(
    'is_closed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_closed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    startDate,
    endDate,
    isClosed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fiscal_periods';
  @override
  VerificationContext validateIntegrity(
    Insertable<FiscalPeriod> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('is_closed')) {
      context.handle(
        _isClosedMeta,
        isClosed.isAcceptableOrUnknown(data['is_closed']!, _isClosedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FiscalPeriod map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FiscalPeriod(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      startDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}start_date'],
          )!,
      endDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}end_date'],
          )!,
      isClosed:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_closed'],
          )!,
    );
  }

  @override
  $FiscalPeriodsTable createAlias(String alias) {
    return $FiscalPeriodsTable(attachedDatabase, alias);
  }
}

class FiscalPeriod extends DataClass implements Insertable<FiscalPeriod> {
  final int id;

  /// 기간명 (예: "2026년 2분기")
  final String name;
  final DateTime startDate;
  final DateTime endDate;

  /// 결산 마감 여부 — true면 해당 기간 수정 불가
  final bool isClosed;
  const FiscalPeriod({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.isClosed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['is_closed'] = Variable<bool>(isClosed);
    return map;
  }

  FiscalPeriodsCompanion toCompanion(bool nullToAbsent) {
    return FiscalPeriodsCompanion(
      id: Value(id),
      name: Value(name),
      startDate: Value(startDate),
      endDate: Value(endDate),
      isClosed: Value(isClosed),
    );
  }

  factory FiscalPeriod.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FiscalPeriod(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      isClosed: serializer.fromJson<bool>(json['isClosed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'isClosed': serializer.toJson<bool>(isClosed),
    };
  }

  FiscalPeriod copyWith({
    int? id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    bool? isClosed,
  }) => FiscalPeriod(
    id: id ?? this.id,
    name: name ?? this.name,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    isClosed: isClosed ?? this.isClosed,
  );
  FiscalPeriod copyWithCompanion(FiscalPeriodsCompanion data) {
    return FiscalPeriod(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      isClosed: data.isClosed.present ? data.isClosed.value : this.isClosed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FiscalPeriod(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('isClosed: $isClosed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, startDate, endDate, isClosed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FiscalPeriod &&
          other.id == this.id &&
          other.name == this.name &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.isClosed == this.isClosed);
}

class FiscalPeriodsCompanion extends UpdateCompanion<FiscalPeriod> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<bool> isClosed;
  const FiscalPeriodsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.isClosed = const Value.absent(),
  });
  FiscalPeriodsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    this.isClosed = const Value.absent(),
  }) : name = Value(name),
       startDate = Value(startDate),
       endDate = Value(endDate);
  static Insertable<FiscalPeriod> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<bool>? isClosed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (isClosed != null) 'is_closed': isClosed,
    });
  }

  FiscalPeriodsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<bool>? isClosed,
  }) {
    return FiscalPeriodsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isClosed: isClosed ?? this.isClosed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (isClosed.present) {
      map['is_closed'] = Variable<bool>(isClosed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FiscalPeriodsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('isClosed: $isClosed')
          ..write(')'))
        .toString();
  }
}

class $OutboxEntriesTable extends OutboxEntries
    with TableInfo<$OutboxEntriesTable, OutboxEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<int> entityId = GeneratedColumn<int>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PENDING'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _attemptedAtMeta = const VerificationMeta(
    'attemptedAt',
  );
  @override
  late final GeneratedColumn<DateTime> attemptedAt = GeneratedColumn<DateTime>(
    'attempted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _attemptCountMeta = const VerificationMeta(
    'attemptCount',
  );
  @override
  late final GeneratedColumn<int> attemptCount = GeneratedColumn<int>(
    'attempt_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverResponseMeta = const VerificationMeta(
    'serverResponse',
  );
  @override
  late final GeneratedColumn<String> serverResponse = GeneratedColumn<String>(
    'server_response',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    entityId,
    operation,
    payload,
    status,
    createdAt,
    attemptedAt,
    attemptCount,
    errorMessage,
    serverResponse,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('attempted_at')) {
      context.handle(
        _attemptedAtMeta,
        attemptedAt.isAcceptableOrUnknown(
          data['attempted_at']!,
          _attemptedAtMeta,
        ),
      );
    }
    if (data.containsKey('attempt_count')) {
      context.handle(
        _attemptCountMeta,
        attemptCount.isAcceptableOrUnknown(
          data['attempt_count']!,
          _attemptCountMeta,
        ),
      );
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    if (data.containsKey('server_response')) {
      context.handle(
        _serverResponseMeta,
        serverResponse.isAcceptableOrUnknown(
          data['server_response']!,
          _serverResponseMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OutboxEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxEntry(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      entityType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}entity_type'],
          )!,
      entityId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}entity_id'],
          )!,
      operation:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}operation'],
          )!,
      payload:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}payload'],
          )!,
      status:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}status'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      attemptedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}attempted_at'],
      ),
      attemptCount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}attempt_count'],
          )!,
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
      serverResponse: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_response'],
      ),
    );
  }

  @override
  $OutboxEntriesTable createAlias(String alias) {
    return $OutboxEntriesTable(attachedDatabase, alias);
  }
}

class OutboxEntry extends DataClass implements Insertable<OutboxEntry> {
  final int id;

  /// TRANSACTION | ACCOUNT | COUNTERPARTY 등
  final String entityType;
  final int entityId;

  /// CREATE | UPDATE | DELETE
  final String operation;

  /// 변경 내용 (JSON)
  final String payload;

  /// PENDING | SENDING | SYNCED | CONFLICT | FAILED (CW 섹션 5)
  final String status;
  final DateTime createdAt;
  final DateTime? attemptedAt;
  final int attemptCount;
  final String? errorMessage;
  final String? serverResponse;
  const OutboxEntry({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.operation,
    required this.payload,
    required this.status,
    required this.createdAt,
    this.attemptedAt,
    required this.attemptCount,
    this.errorMessage,
    this.serverResponse,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<int>(entityId);
    map['operation'] = Variable<String>(operation);
    map['payload'] = Variable<String>(payload);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || attemptedAt != null) {
      map['attempted_at'] = Variable<DateTime>(attemptedAt);
    }
    map['attempt_count'] = Variable<int>(attemptCount);
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    if (!nullToAbsent || serverResponse != null) {
      map['server_response'] = Variable<String>(serverResponse);
    }
    return map;
  }

  OutboxEntriesCompanion toCompanion(bool nullToAbsent) {
    return OutboxEntriesCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      operation: Value(operation),
      payload: Value(payload),
      status: Value(status),
      createdAt: Value(createdAt),
      attemptedAt:
          attemptedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(attemptedAt),
      attemptCount: Value(attemptCount),
      errorMessage:
          errorMessage == null && nullToAbsent
              ? const Value.absent()
              : Value(errorMessage),
      serverResponse:
          serverResponse == null && nullToAbsent
              ? const Value.absent()
              : Value(serverResponse),
    );
  }

  factory OutboxEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxEntry(
      id: serializer.fromJson<int>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<int>(json['entityId']),
      operation: serializer.fromJson<String>(json['operation']),
      payload: serializer.fromJson<String>(json['payload']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      attemptedAt: serializer.fromJson<DateTime?>(json['attemptedAt']),
      attemptCount: serializer.fromJson<int>(json['attemptCount']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      serverResponse: serializer.fromJson<String?>(json['serverResponse']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<int>(entityId),
      'operation': serializer.toJson<String>(operation),
      'payload': serializer.toJson<String>(payload),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'attemptedAt': serializer.toJson<DateTime?>(attemptedAt),
      'attemptCount': serializer.toJson<int>(attemptCount),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'serverResponse': serializer.toJson<String?>(serverResponse),
    };
  }

  OutboxEntry copyWith({
    int? id,
    String? entityType,
    int? entityId,
    String? operation,
    String? payload,
    String? status,
    DateTime? createdAt,
    Value<DateTime?> attemptedAt = const Value.absent(),
    int? attemptCount,
    Value<String?> errorMessage = const Value.absent(),
    Value<String?> serverResponse = const Value.absent(),
  }) => OutboxEntry(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    operation: operation ?? this.operation,
    payload: payload ?? this.payload,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    attemptedAt: attemptedAt.present ? attemptedAt.value : this.attemptedAt,
    attemptCount: attemptCount ?? this.attemptCount,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
    serverResponse:
        serverResponse.present ? serverResponse.value : this.serverResponse,
  );
  OutboxEntry copyWithCompanion(OutboxEntriesCompanion data) {
    return OutboxEntry(
      id: data.id.present ? data.id.value : this.id,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operation: data.operation.present ? data.operation.value : this.operation,
      payload: data.payload.present ? data.payload.value : this.payload,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      attemptedAt:
          data.attemptedAt.present ? data.attemptedAt.value : this.attemptedAt,
      attemptCount:
          data.attemptCount.present
              ? data.attemptCount.value
              : this.attemptCount,
      errorMessage:
          data.errorMessage.present
              ? data.errorMessage.value
              : this.errorMessage,
      serverResponse:
          data.serverResponse.present
              ? data.serverResponse.value
              : this.serverResponse,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxEntry(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('attemptedAt: $attemptedAt, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('serverResponse: $serverResponse')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entityType,
    entityId,
    operation,
    payload,
    status,
    createdAt,
    attemptedAt,
    attemptCount,
    errorMessage,
    serverResponse,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxEntry &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.operation == this.operation &&
          other.payload == this.payload &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.attemptedAt == this.attemptedAt &&
          other.attemptCount == this.attemptCount &&
          other.errorMessage == this.errorMessage &&
          other.serverResponse == this.serverResponse);
}

class OutboxEntriesCompanion extends UpdateCompanion<OutboxEntry> {
  final Value<int> id;
  final Value<String> entityType;
  final Value<int> entityId;
  final Value<String> operation;
  final Value<String> payload;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime?> attemptedAt;
  final Value<int> attemptCount;
  final Value<String?> errorMessage;
  final Value<String?> serverResponse;
  const OutboxEntriesCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operation = const Value.absent(),
    this.payload = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.attemptedAt = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.serverResponse = const Value.absent(),
  });
  OutboxEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String entityType,
    required int entityId,
    required String operation,
    required String payload,
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.attemptedAt = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.serverResponse = const Value.absent(),
  }) : entityType = Value(entityType),
       entityId = Value(entityId),
       operation = Value(operation),
       payload = Value(payload);
  static Insertable<OutboxEntry> custom({
    Expression<int>? id,
    Expression<String>? entityType,
    Expression<int>? entityId,
    Expression<String>? operation,
    Expression<String>? payload,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? attemptedAt,
    Expression<int>? attemptCount,
    Expression<String>? errorMessage,
    Expression<String>? serverResponse,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (operation != null) 'operation': operation,
      if (payload != null) 'payload': payload,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (attemptedAt != null) 'attempted_at': attemptedAt,
      if (attemptCount != null) 'attempt_count': attemptCount,
      if (errorMessage != null) 'error_message': errorMessage,
      if (serverResponse != null) 'server_response': serverResponse,
    });
  }

  OutboxEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? entityType,
    Value<int>? entityId,
    Value<String>? operation,
    Value<String>? payload,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime?>? attemptedAt,
    Value<int>? attemptCount,
    Value<String?>? errorMessage,
    Value<String?>? serverResponse,
  }) {
    return OutboxEntriesCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      payload: payload ?? this.payload,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      attemptedAt: attemptedAt ?? this.attemptedAt,
      attemptCount: attemptCount ?? this.attemptCount,
      errorMessage: errorMessage ?? this.errorMessage,
      serverResponse: serverResponse ?? this.serverResponse,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<int>(entityId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (attemptedAt.present) {
      map['attempted_at'] = Variable<DateTime>(attemptedAt.value);
    }
    if (attemptCount.present) {
      map['attempt_count'] = Variable<int>(attemptCount.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (serverResponse.present) {
      map['server_response'] = Variable<String>(serverResponse.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxEntriesCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('attemptedAt: $attemptedAt, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('serverResponse: $serverResponse')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DimensionValuesTable dimensionValues = $DimensionValuesTable(
    this,
  );
  late final $OwnersTable owners = $OwnersTable(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $AccountOwnerSharesTable accountOwnerShares =
      $AccountOwnerSharesTable(this);
  late final $CounterpartiesTable counterparties = $CounterpartiesTable(this);
  late final $CounterpartyAliasesTable counterpartyAliases =
      $CounterpartyAliasesTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $JournalEntryLinesTable journalEntryLines =
      $JournalEntryLinesTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $TransactionTagsTable transactionTags = $TransactionTagsTable(
    this,
  );
  late final $PerspectivesTable perspectives = $PerspectivesTable(this);
  late final $ExchangeRatesTable exchangeRates = $ExchangeRatesTable(this);
  late final $LegalParametersTable legalParameters = $LegalParametersTable(
    this,
  );
  late final $ClassificationRulesTable classificationRules =
      $ClassificationRulesTable(this);
  late final $FiscalPeriodsTable fiscalPeriods = $FiscalPeriodsTable(this);
  late final $OutboxEntriesTable outboxEntries = $OutboxEntriesTable(this);
  late final AccountDao accountDao = AccountDao(this as AppDatabase);
  late final TransactionDao transactionDao = TransactionDao(
    this as AppDatabase,
  );
  late final PerspectiveDao perspectiveDao = PerspectiveDao(
    this as AppDatabase,
  );
  late final CounterpartyDao counterpartyDao = CounterpartyDao(
    this as AppDatabase,
  );
  late final ExchangeRateDao exchangeRateDao = ExchangeRateDao(
    this as AppDatabase,
  );
  late final LegalParameterDao legalParameterDao = LegalParameterDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    dimensionValues,
    owners,
    accounts,
    accountOwnerShares,
    counterparties,
    counterpartyAliases,
    transactions,
    journalEntryLines,
    tags,
    transactionTags,
    perspectives,
    exchangeRates,
    legalParameters,
    classificationRules,
    fiscalPeriods,
    outboxEntries,
  ];
}

typedef $$DimensionValuesTableCreateCompanionBuilder =
    DimensionValuesCompanion Function({
      Value<int> id,
      required String dimensionType,
      required String code,
      required String name,
      Value<int?> parentId,
      required String path,
      Value<String> entityType,
      Value<int> sortOrder,
      Value<bool> isActive,
    });
typedef $$DimensionValuesTableUpdateCompanionBuilder =
    DimensionValuesCompanion Function({
      Value<int> id,
      Value<String> dimensionType,
      Value<String> code,
      Value<String> name,
      Value<int?> parentId,
      Value<String> path,
      Value<String> entityType,
      Value<int> sortOrder,
      Value<bool> isActive,
    });

final class $$DimensionValuesTableReferences
    extends
        BaseReferences<_$AppDatabase, $DimensionValuesTable, DimensionValue> {
  $$DimensionValuesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DimensionValuesTable _parentIdTable(_$AppDatabase db) =>
      db.dimensionValues.createAlias(
        $_aliasNameGenerator(
          db.dimensionValues.parentId,
          db.dimensionValues.id,
        ),
      );

  $$DimensionValuesTableProcessedTableManager? get parentId {
    final $_column = $_itemColumn<int>('parent_id');
    if ($_column == null) return null;
    final manager = $$DimensionValuesTableTableManager(
      $_db,
      $_db.dimensionValues,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DimensionValuesTableFilterComposer
    extends Composer<_$AppDatabase, $DimensionValuesTable> {
  $$DimensionValuesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dimensionType => $composableBuilder(
    column: $table.dimensionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  $$DimensionValuesTableFilterComposer get parentId {
    final $$DimensionValuesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.dimensionValues,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DimensionValuesTableFilterComposer(
            $db: $db,
            $table: $db.dimensionValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DimensionValuesTableOrderingComposer
    extends Composer<_$AppDatabase, $DimensionValuesTable> {
  $$DimensionValuesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dimensionType => $composableBuilder(
    column: $table.dimensionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  $$DimensionValuesTableOrderingComposer get parentId {
    final $$DimensionValuesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.dimensionValues,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DimensionValuesTableOrderingComposer(
            $db: $db,
            $table: $db.dimensionValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DimensionValuesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DimensionValuesTable> {
  $$DimensionValuesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dimensionType => $composableBuilder(
    column: $table.dimensionType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$DimensionValuesTableAnnotationComposer get parentId {
    final $$DimensionValuesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.dimensionValues,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DimensionValuesTableAnnotationComposer(
            $db: $db,
            $table: $db.dimensionValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DimensionValuesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DimensionValuesTable,
          DimensionValue,
          $$DimensionValuesTableFilterComposer,
          $$DimensionValuesTableOrderingComposer,
          $$DimensionValuesTableAnnotationComposer,
          $$DimensionValuesTableCreateCompanionBuilder,
          $$DimensionValuesTableUpdateCompanionBuilder,
          (DimensionValue, $$DimensionValuesTableReferences),
          DimensionValue,
          PrefetchHooks Function({bool parentId})
        > {
  $$DimensionValuesTableTableManager(
    _$AppDatabase db,
    $DimensionValuesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$DimensionValuesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$DimensionValuesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$DimensionValuesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> dimensionType = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int?> parentId = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => DimensionValuesCompanion(
                id: id,
                dimensionType: dimensionType,
                code: code,
                name: name,
                parentId: parentId,
                path: path,
                entityType: entityType,
                sortOrder: sortOrder,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String dimensionType,
                required String code,
                required String name,
                Value<int?> parentId = const Value.absent(),
                required String path,
                Value<String> entityType = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => DimensionValuesCompanion.insert(
                id: id,
                dimensionType: dimensionType,
                code: code,
                name: name,
                parentId: parentId,
                path: path,
                entityType: entityType,
                sortOrder: sortOrder,
                isActive: isActive,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$DimensionValuesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({parentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (parentId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.parentId,
                            referencedTable: $$DimensionValuesTableReferences
                                ._parentIdTable(db),
                            referencedColumn:
                                $$DimensionValuesTableReferences
                                    ._parentIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DimensionValuesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DimensionValuesTable,
      DimensionValue,
      $$DimensionValuesTableFilterComposer,
      $$DimensionValuesTableOrderingComposer,
      $$DimensionValuesTableAnnotationComposer,
      $$DimensionValuesTableCreateCompanionBuilder,
      $$DimensionValuesTableUpdateCompanionBuilder,
      (DimensionValue, $$DimensionValuesTableReferences),
      DimensionValue,
      PrefetchHooks Function({bool parentId})
    >;
typedef $$OwnersTableCreateCompanionBuilder =
    OwnersCompanion Function({
      Value<int> id,
      required String name,
      Value<bool> isActive,
    });
typedef $$OwnersTableUpdateCompanionBuilder =
    OwnersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<bool> isActive,
    });

final class $$OwnersTableReferences
    extends BaseReferences<_$AppDatabase, $OwnersTable, Owner> {
  $$OwnersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AccountsTable, List<Account>> _accountsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.accounts,
    aliasName: $_aliasNameGenerator(db.owners.id, db.accounts.ownerId),
  );

  $$AccountsTableProcessedTableManager get accountsRefs {
    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.ownerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_accountsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AccountOwnerSharesTable, List<AccountOwnerShare>>
  _accountOwnerSharesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.accountOwnerShares,
        aliasName: $_aliasNameGenerator(
          db.owners.id,
          db.accountOwnerShares.ownerId,
        ),
      );

  $$AccountOwnerSharesTableProcessedTableManager get accountOwnerSharesRefs {
    final manager = $$AccountOwnerSharesTableTableManager(
      $_db,
      $_db.accountOwnerShares,
    ).filter((f) => f.ownerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _accountOwnerSharesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PerspectivesTable, List<Perspective>>
  _perspectivesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.perspectives,
    aliasName: $_aliasNameGenerator(db.owners.id, db.perspectives.ownerId),
  );

  $$PerspectivesTableProcessedTableManager get perspectivesRefs {
    final manager = $$PerspectivesTableTableManager(
      $_db,
      $_db.perspectives,
    ).filter((f) => f.ownerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_perspectivesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OwnersTableFilterComposer
    extends Composer<_$AppDatabase, $OwnersTable> {
  $$OwnersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> accountsRefs(
    Expression<bool> Function($$AccountsTableFilterComposer f) f,
  ) {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.ownerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> accountOwnerSharesRefs(
    Expression<bool> Function($$AccountOwnerSharesTableFilterComposer f) f,
  ) {
    final $$AccountOwnerSharesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.accountOwnerShares,
      getReferencedColumn: (t) => t.ownerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountOwnerSharesTableFilterComposer(
            $db: $db,
            $table: $db.accountOwnerShares,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> perspectivesRefs(
    Expression<bool> Function($$PerspectivesTableFilterComposer f) f,
  ) {
    final $$PerspectivesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.perspectives,
      getReferencedColumn: (t) => t.ownerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PerspectivesTableFilterComposer(
            $db: $db,
            $table: $db.perspectives,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OwnersTableOrderingComposer
    extends Composer<_$AppDatabase, $OwnersTable> {
  $$OwnersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OwnersTableAnnotationComposer
    extends Composer<_$AppDatabase, $OwnersTable> {
  $$OwnersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> accountsRefs<T extends Object>(
    Expression<T> Function($$AccountsTableAnnotationComposer a) f,
  ) {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.ownerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> accountOwnerSharesRefs<T extends Object>(
    Expression<T> Function($$AccountOwnerSharesTableAnnotationComposer a) f,
  ) {
    final $$AccountOwnerSharesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.accountOwnerShares,
          getReferencedColumn: (t) => t.ownerId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AccountOwnerSharesTableAnnotationComposer(
                $db: $db,
                $table: $db.accountOwnerShares,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> perspectivesRefs<T extends Object>(
    Expression<T> Function($$PerspectivesTableAnnotationComposer a) f,
  ) {
    final $$PerspectivesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.perspectives,
      getReferencedColumn: (t) => t.ownerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PerspectivesTableAnnotationComposer(
            $db: $db,
            $table: $db.perspectives,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OwnersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OwnersTable,
          Owner,
          $$OwnersTableFilterComposer,
          $$OwnersTableOrderingComposer,
          $$OwnersTableAnnotationComposer,
          $$OwnersTableCreateCompanionBuilder,
          $$OwnersTableUpdateCompanionBuilder,
          (Owner, $$OwnersTableReferences),
          Owner,
          PrefetchHooks Function({
            bool accountsRefs,
            bool accountOwnerSharesRefs,
            bool perspectivesRefs,
          })
        > {
  $$OwnersTableTableManager(_$AppDatabase db, $OwnersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$OwnersTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$OwnersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$OwnersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => OwnersCompanion(id: id, name: name, isActive: isActive),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<bool> isActive = const Value.absent(),
              }) => OwnersCompanion.insert(
                id: id,
                name: name,
                isActive: isActive,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$OwnersTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            accountsRefs = false,
            accountOwnerSharesRefs = false,
            perspectivesRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (accountsRefs) db.accounts,
                if (accountOwnerSharesRefs) db.accountOwnerShares,
                if (perspectivesRefs) db.perspectives,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (accountsRefs)
                    await $_getPrefetchedData<Owner, $OwnersTable, Account>(
                      currentTable: table,
                      referencedTable: $$OwnersTableReferences
                          ._accountsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$OwnersTableReferences(
                                db,
                                table,
                                p0,
                              ).accountsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.ownerId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (accountOwnerSharesRefs)
                    await $_getPrefetchedData<
                      Owner,
                      $OwnersTable,
                      AccountOwnerShare
                    >(
                      currentTable: table,
                      referencedTable: $$OwnersTableReferences
                          ._accountOwnerSharesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$OwnersTableReferences(
                                db,
                                table,
                                p0,
                              ).accountOwnerSharesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.ownerId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (perspectivesRefs)
                    await $_getPrefetchedData<Owner, $OwnersTable, Perspective>(
                      currentTable: table,
                      referencedTable: $$OwnersTableReferences
                          ._perspectivesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$OwnersTableReferences(
                                db,
                                table,
                                p0,
                              ).perspectivesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.ownerId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$OwnersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OwnersTable,
      Owner,
      $$OwnersTableFilterComposer,
      $$OwnersTableOrderingComposer,
      $$OwnersTableAnnotationComposer,
      $$OwnersTableCreateCompanionBuilder,
      $$OwnersTableUpdateCompanionBuilder,
      (Owner, $$OwnersTableReferences),
      Owner,
      PrefetchHooks Function({
        bool accountsRefs,
        bool accountOwnerSharesRefs,
        bool perspectivesRefs,
      })
    >;
typedef $$AccountsTableCreateCompanionBuilder =
    AccountsCompanion Function({
      Value<int> id,
      required String name,
      required String nature,
      required int equityTypeId,
      required String equityTypePath,
      required int liquidityId,
      required String liquidityPath,
      required int assetTypeId,
      required String assetTypePath,
      Value<int?> defaultActivityTypeId,
      Value<int?> defaultIncomeTypeId,
      required int ownerId,
      Value<String?> productType,
      Value<String?> financialInstitution,
      Value<String?> countrySpecific,
      Value<bool> isActive,
    });
typedef $$AccountsTableUpdateCompanionBuilder =
    AccountsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> nature,
      Value<int> equityTypeId,
      Value<String> equityTypePath,
      Value<int> liquidityId,
      Value<String> liquidityPath,
      Value<int> assetTypeId,
      Value<String> assetTypePath,
      Value<int?> defaultActivityTypeId,
      Value<int?> defaultIncomeTypeId,
      Value<int> ownerId,
      Value<String?> productType,
      Value<String?> financialInstitution,
      Value<String?> countrySpecific,
      Value<bool> isActive,
    });

final class $$AccountsTableReferences
    extends BaseReferences<_$AppDatabase, $AccountsTable, Account> {
  $$AccountsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DimensionValuesTable _equityTypeIdTable(_$AppDatabase db) =>
      db.dimensionValues.createAlias(
        $_aliasNameGenerator(db.accounts.equityTypeId, db.dimensionValues.id),
      );

  $$DimensionValuesTableProcessedTableManager get equityTypeId {
    final $_column = $_itemColumn<int>('equity_type_id')!;

    final manager = $$DimensionValuesTableTableManager(
      $_db,
      $_db.dimensionValues,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_equityTypeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DimensionValuesTable _liquidityIdTable(_$AppDatabase db) =>
      db.dimensionValues.createAlias(
        $_aliasNameGenerator(db.accounts.liquidityId, db.dimensionValues.id),
      );

  $$DimensionValuesTableProcessedTableManager get liquidityId {
    final $_column = $_itemColumn<int>('liquidity_id')!;

    final manager = $$DimensionValuesTableTableManager(
      $_db,
      $_db.dimensionValues,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_liquidityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DimensionValuesTable _assetTypeIdTable(_$AppDatabase db) =>
      db.dimensionValues.createAlias(
        $_aliasNameGenerator(db.accounts.assetTypeId, db.dimensionValues.id),
      );

  $$DimensionValuesTableProcessedTableManager get assetTypeId {
    final $_column = $_itemColumn<int>('asset_type_id')!;

    final manager = $$DimensionValuesTableTableManager(
      $_db,
      $_db.dimensionValues,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_assetTypeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DimensionValuesTable _defaultActivityTypeIdTable(_$AppDatabase db) =>
      db.dimensionValues.createAlias(
        $_aliasNameGenerator(
          db.accounts.defaultActivityTypeId,
          db.dimensionValues.id,
        ),
      );

  $$DimensionValuesTableProcessedTableManager? get defaultActivityTypeId {
    final $_column = $_itemColumn<int>('default_activity_type_id');
    if ($_column == null) return null;
    final manager = $$DimensionValuesTableTableManager(
      $_db,
      $_db.dimensionValues,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _defaultActivityTypeIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DimensionValuesTable _defaultIncomeTypeIdTable(_$AppDatabase db) =>
      db.dimensionValues.createAlias(
        $_aliasNameGenerator(
          db.accounts.defaultIncomeTypeId,
          db.dimensionValues.id,
        ),
      );

  $$DimensionValuesTableProcessedTableManager? get defaultIncomeTypeId {
    final $_column = $_itemColumn<int>('default_income_type_id');
    if ($_column == null) return null;
    final manager = $$DimensionValuesTableTableManager(
      $_db,
      $_db.dimensionValues,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_defaultIncomeTypeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $OwnersTable _ownerIdTable(_$AppDatabase db) => db.owners.createAlias(
    $_aliasNameGenerator(db.accounts.ownerId, db.owners.id),
  );

  $$OwnersTableProcessedTableManager get ownerId {
    final $_column = $_itemColumn<int>('owner_id')!;

    final manager = $$OwnersTableTableManager(
      $_db,
      $_db.owners,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ownerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$AccountOwnerSharesTable, List<AccountOwnerShare>>
  _accountOwnerSharesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.accountOwnerShares,
        aliasName: $_aliasNameGenerator(
          db.accounts.id,
          db.accountOwnerShares.accountId,
        ),
      );

  $$AccountOwnerSharesTableProcessedTableManager get accountOwnerSharesRefs {
    final manager = $$AccountOwnerSharesTableTableManager(
      $_db,
      $_db.accountOwnerShares,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _accountOwnerSharesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$JournalEntryLinesTable, List<JournalEntryLine>>
  _journalEntryLinesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.journalEntryLines,
        aliasName: $_aliasNameGenerator(
          db.accounts.id,
          db.journalEntryLines.accountId,
        ),
      );

  $$JournalEntryLinesTableProcessedTableManager get journalEntryLinesRefs {
    final manager = $$JournalEntryLinesTableTableManager(
      $_db,
      $_db.journalEntryLines,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _journalEntryLinesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ClassificationRulesTable,
    List<ClassificationRule>
  >
  _classificationRulesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.classificationRules,
        aliasName: $_aliasNameGenerator(
          db.accounts.id,
          db.classificationRules.accountId,
        ),
      );

  $$ClassificationRulesTableProcessedTableManager get classificationRulesRefs {
    final manager = $$ClassificationRulesTableTableManager(
      $_db,
      $_db.classificationRules,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _classificationRulesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nature => $composableBuilder(
    column: $table.nature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equityTypePath => $composableBuilder(
    column: $table.equityTypePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get liquidityPath => $composableBuilder(
    column: $table.liquidityPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assetTypePath => $composableBuilder(
    column: $table.assetTypePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productType => $composableBuilder(
    column: $table.productType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get financialInstitution => $composableBuilder(
    column: $table.financialInstitution,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get countrySpecific => $composableBuilder(
    column: $table.countrySpecific,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  $$DimensionValuesTableFilterComposer get equityTypeId {
    final $$DimensionValuesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equityTypeId,
      referencedTable: $db.dimensionValues,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DimensionValuesTableFilterComposer(
            $db: $db,
            $table: $db.dimensionValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DimensionValuesTableFilterComposer get liquidityId {
    final $$DimensionValuesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.liquidityId,
      referencedTable: $db.dimensionValues,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DimensionValuesTableFilterComposer(
            $db: $db,
            $table: $db.dimensionValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DimensionValuesTableFilterComposer get assetTypeId {
    final $$DimensionValuesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assetTypeId,
      referencedTable: $db.dimensionValues,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DimensionValuesTableFilterComposer(
            $db: $db,
            $table: $db.dimensionValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DimensionValuesTableFilterComposer get defaultActivityTypeId {
    final $$DimensionValuesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.defaultActivityTypeId,
      referencedTable: $db.dimensionValues,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DimensionValuesTableFilterComposer(
            $db: $db,
            $table: $db.dimensionValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DimensionValuesTableFilterComposer get defaultIncomeTypeId {
    final $$DimensionValuesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.defaultIncomeTypeId,
      referencedTable: $db.dimensionValues,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DimensionValuesTableFilterComposer(
            $db: $db,
            $table: $db.dimensionValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OwnersTableFilterComposer get ownerId {
    final $$OwnersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerId,
      referencedTable: $db.owners,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OwnersTableFilterComposer(
            $db: $db,
            $table: $db.owners,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> accountOwnerSharesRefs(
    Expression<bool> Function($$AccountOwnerSharesTableFilterComposer f) f,
  ) {
    final $$AccountOwnerSharesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.accountOwnerShares,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountOwnerSharesTableFilterComposer(
            $db: $db,
            $table: $db.accountOwnerShares,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> journalEntryLinesRefs(
    Expression<bool> Function($$JournalEntryLinesTableFilterComposer f) f,
  ) {
    final $$JournalEntryLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journalEntryLines,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntryLinesTableFilterComposer(
            $db: $db,
            $table: $db.journalEntryLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> classificationRulesRefs(
    Expression<bool> Function($$ClassificationRulesTableFilterComposer f) f,
  ) {
    final $$ClassificationRulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.classificationRules,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassificationRulesTableFilterComposer(
            $db: $db,
            $table: $db.classificationRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nature => $composableBuilder(
    column: $table.nature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equityTypePath => $composableBuilder(
    column: $table.equityTypePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get liquidityPath => $composableBuilder(
    column: $table.liquidityPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assetTypePath => $composableBuilder(
    column: $table.assetTypePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productType => $composableBuilder(
    column: $table.productType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get financialInstitution => $composableBuilder(
    column: $table.financialInstitution,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get countrySpecific => $composableBuilder(
    column: $table.countrySpecific,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  $$DimensionValuesTableOrderingComposer get equityTypeId {
    final $$DimensionValuesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equityTypeId,
      referencedTable: $db.dimensionValues,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DimensionValuesTableOrderingComposer(
            $db: $db,
            $table: $db.dimensionValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DimensionValuesTableOrderingComposer get liquidityId {
    final $$DimensionValuesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.liquidityId,
      referencedTable: $db.dimensionValues,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DimensionValuesTableOrderingComposer(
            $db: $db,
            $table: $db.dimensionValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DimensionValuesTableOrderingComposer get assetTypeId {
    final $$DimensionValuesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assetTypeId,
      referencedTable: $db.dimensionValues,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DimensionValuesTableOrderingComposer(
            $db: $db,
            $table: $db.dimensionValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DimensionValuesTableOrderingComposer get defaultActivityTypeId {
    final $$DimensionValuesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.defaultActivityTypeId,
      referencedTable: $db.dimensionValues,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DimensionValuesTableOrderingComposer(
            $db: $db,
            $table: $db.dimensionValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DimensionValuesTableOrderingComposer get defaultIncomeTypeId {
    final $$DimensionValuesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.defaultIncomeTypeId,
      referencedTable: $db.dimensionValues,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DimensionValuesTableOrderingComposer(
            $db: $db,
            $table: $db.dimensionValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OwnersTableOrderingComposer get ownerId {
    final $$OwnersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerId,
      referencedTable: $db.owners,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OwnersTableOrderingComposer(
            $db: $db,
            $table: $db.owners,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nature =>
      $composableBuilder(column: $table.nature, builder: (column) => column);

  GeneratedColumn<String> get equityTypePath => $composableBuilder(
    column: $table.equityTypePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get liquidityPath => $composableBuilder(
    column: $table.liquidityPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get assetTypePath => $composableBuilder(
    column: $table.assetTypePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productType => $composableBuilder(
    column: $table.productType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get financialInstitution => $composableBuilder(
    column: $table.financialInstitution,
    builder: (column) => column,
  );

  GeneratedColumn<String> get countrySpecific => $composableBuilder(
    column: $table.countrySpecific,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$DimensionValuesTableAnnotationComposer get equityTypeId {
    final $$DimensionValuesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equityTypeId,
      referencedTable: $db.dimensionValues,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DimensionValuesTableAnnotationComposer(
            $db: $db,
            $table: $db.dimensionValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DimensionValuesTableAnnotationComposer get liquidityId {
    final $$DimensionValuesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.liquidityId,
      referencedTable: $db.dimensionValues,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DimensionValuesTableAnnotationComposer(
            $db: $db,
            $table: $db.dimensionValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DimensionValuesTableAnnotationComposer get assetTypeId {
    final $$DimensionValuesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assetTypeId,
      referencedTable: $db.dimensionValues,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DimensionValuesTableAnnotationComposer(
            $db: $db,
            $table: $db.dimensionValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DimensionValuesTableAnnotationComposer get defaultActivityTypeId {
    final $$DimensionValuesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.defaultActivityTypeId,
      referencedTable: $db.dimensionValues,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DimensionValuesTableAnnotationComposer(
            $db: $db,
            $table: $db.dimensionValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DimensionValuesTableAnnotationComposer get defaultIncomeTypeId {
    final $$DimensionValuesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.defaultIncomeTypeId,
      referencedTable: $db.dimensionValues,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DimensionValuesTableAnnotationComposer(
            $db: $db,
            $table: $db.dimensionValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OwnersTableAnnotationComposer get ownerId {
    final $$OwnersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerId,
      referencedTable: $db.owners,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OwnersTableAnnotationComposer(
            $db: $db,
            $table: $db.owners,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> accountOwnerSharesRefs<T extends Object>(
    Expression<T> Function($$AccountOwnerSharesTableAnnotationComposer a) f,
  ) {
    final $$AccountOwnerSharesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.accountOwnerShares,
          getReferencedColumn: (t) => t.accountId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AccountOwnerSharesTableAnnotationComposer(
                $db: $db,
                $table: $db.accountOwnerShares,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> journalEntryLinesRefs<T extends Object>(
    Expression<T> Function($$JournalEntryLinesTableAnnotationComposer a) f,
  ) {
    final $$JournalEntryLinesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.journalEntryLines,
          getReferencedColumn: (t) => t.accountId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$JournalEntryLinesTableAnnotationComposer(
                $db: $db,
                $table: $db.journalEntryLines,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> classificationRulesRefs<T extends Object>(
    Expression<T> Function($$ClassificationRulesTableAnnotationComposer a) f,
  ) {
    final $$ClassificationRulesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.classificationRules,
          getReferencedColumn: (t) => t.accountId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ClassificationRulesTableAnnotationComposer(
                $db: $db,
                $table: $db.classificationRules,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$AccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountsTable,
          Account,
          $$AccountsTableFilterComposer,
          $$AccountsTableOrderingComposer,
          $$AccountsTableAnnotationComposer,
          $$AccountsTableCreateCompanionBuilder,
          $$AccountsTableUpdateCompanionBuilder,
          (Account, $$AccountsTableReferences),
          Account,
          PrefetchHooks Function({
            bool equityTypeId,
            bool liquidityId,
            bool assetTypeId,
            bool defaultActivityTypeId,
            bool defaultIncomeTypeId,
            bool ownerId,
            bool accountOwnerSharesRefs,
            bool journalEntryLinesRefs,
            bool classificationRulesRefs,
          })
        > {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> nature = const Value.absent(),
                Value<int> equityTypeId = const Value.absent(),
                Value<String> equityTypePath = const Value.absent(),
                Value<int> liquidityId = const Value.absent(),
                Value<String> liquidityPath = const Value.absent(),
                Value<int> assetTypeId = const Value.absent(),
                Value<String> assetTypePath = const Value.absent(),
                Value<int?> defaultActivityTypeId = const Value.absent(),
                Value<int?> defaultIncomeTypeId = const Value.absent(),
                Value<int> ownerId = const Value.absent(),
                Value<String?> productType = const Value.absent(),
                Value<String?> financialInstitution = const Value.absent(),
                Value<String?> countrySpecific = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => AccountsCompanion(
                id: id,
                name: name,
                nature: nature,
                equityTypeId: equityTypeId,
                equityTypePath: equityTypePath,
                liquidityId: liquidityId,
                liquidityPath: liquidityPath,
                assetTypeId: assetTypeId,
                assetTypePath: assetTypePath,
                defaultActivityTypeId: defaultActivityTypeId,
                defaultIncomeTypeId: defaultIncomeTypeId,
                ownerId: ownerId,
                productType: productType,
                financialInstitution: financialInstitution,
                countrySpecific: countrySpecific,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String nature,
                required int equityTypeId,
                required String equityTypePath,
                required int liquidityId,
                required String liquidityPath,
                required int assetTypeId,
                required String assetTypePath,
                Value<int?> defaultActivityTypeId = const Value.absent(),
                Value<int?> defaultIncomeTypeId = const Value.absent(),
                required int ownerId,
                Value<String?> productType = const Value.absent(),
                Value<String?> financialInstitution = const Value.absent(),
                Value<String?> countrySpecific = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => AccountsCompanion.insert(
                id: id,
                name: name,
                nature: nature,
                equityTypeId: equityTypeId,
                equityTypePath: equityTypePath,
                liquidityId: liquidityId,
                liquidityPath: liquidityPath,
                assetTypeId: assetTypeId,
                assetTypePath: assetTypePath,
                defaultActivityTypeId: defaultActivityTypeId,
                defaultIncomeTypeId: defaultIncomeTypeId,
                ownerId: ownerId,
                productType: productType,
                financialInstitution: financialInstitution,
                countrySpecific: countrySpecific,
                isActive: isActive,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$AccountsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            equityTypeId = false,
            liquidityId = false,
            assetTypeId = false,
            defaultActivityTypeId = false,
            defaultIncomeTypeId = false,
            ownerId = false,
            accountOwnerSharesRefs = false,
            journalEntryLinesRefs = false,
            classificationRulesRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (accountOwnerSharesRefs) db.accountOwnerShares,
                if (journalEntryLinesRefs) db.journalEntryLines,
                if (classificationRulesRefs) db.classificationRules,
              ],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (equityTypeId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.equityTypeId,
                            referencedTable: $$AccountsTableReferences
                                ._equityTypeIdTable(db),
                            referencedColumn:
                                $$AccountsTableReferences
                                    ._equityTypeIdTable(db)
                                    .id,
                          )
                          as T;
                }
                if (liquidityId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.liquidityId,
                            referencedTable: $$AccountsTableReferences
                                ._liquidityIdTable(db),
                            referencedColumn:
                                $$AccountsTableReferences
                                    ._liquidityIdTable(db)
                                    .id,
                          )
                          as T;
                }
                if (assetTypeId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.assetTypeId,
                            referencedTable: $$AccountsTableReferences
                                ._assetTypeIdTable(db),
                            referencedColumn:
                                $$AccountsTableReferences
                                    ._assetTypeIdTable(db)
                                    .id,
                          )
                          as T;
                }
                if (defaultActivityTypeId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.defaultActivityTypeId,
                            referencedTable: $$AccountsTableReferences
                                ._defaultActivityTypeIdTable(db),
                            referencedColumn:
                                $$AccountsTableReferences
                                    ._defaultActivityTypeIdTable(db)
                                    .id,
                          )
                          as T;
                }
                if (defaultIncomeTypeId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.defaultIncomeTypeId,
                            referencedTable: $$AccountsTableReferences
                                ._defaultIncomeTypeIdTable(db),
                            referencedColumn:
                                $$AccountsTableReferences
                                    ._defaultIncomeTypeIdTable(db)
                                    .id,
                          )
                          as T;
                }
                if (ownerId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.ownerId,
                            referencedTable: $$AccountsTableReferences
                                ._ownerIdTable(db),
                            referencedColumn:
                                $$AccountsTableReferences._ownerIdTable(db).id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (accountOwnerSharesRefs)
                    await $_getPrefetchedData<
                      Account,
                      $AccountsTable,
                      AccountOwnerShare
                    >(
                      currentTable: table,
                      referencedTable: $$AccountsTableReferences
                          ._accountOwnerSharesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).accountOwnerSharesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.accountId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (journalEntryLinesRefs)
                    await $_getPrefetchedData<
                      Account,
                      $AccountsTable,
                      JournalEntryLine
                    >(
                      currentTable: table,
                      referencedTable: $$AccountsTableReferences
                          ._journalEntryLinesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).journalEntryLinesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.accountId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (classificationRulesRefs)
                    await $_getPrefetchedData<
                      Account,
                      $AccountsTable,
                      ClassificationRule
                    >(
                      currentTable: table,
                      referencedTable: $$AccountsTableReferences
                          ._classificationRulesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).classificationRulesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.accountId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$AccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountsTable,
      Account,
      $$AccountsTableFilterComposer,
      $$AccountsTableOrderingComposer,
      $$AccountsTableAnnotationComposer,
      $$AccountsTableCreateCompanionBuilder,
      $$AccountsTableUpdateCompanionBuilder,
      (Account, $$AccountsTableReferences),
      Account,
      PrefetchHooks Function({
        bool equityTypeId,
        bool liquidityId,
        bool assetTypeId,
        bool defaultActivityTypeId,
        bool defaultIncomeTypeId,
        bool ownerId,
        bool accountOwnerSharesRefs,
        bool journalEntryLinesRefs,
        bool classificationRulesRefs,
      })
    >;
typedef $$AccountOwnerSharesTableCreateCompanionBuilder =
    AccountOwnerSharesCompanion Function({
      required int accountId,
      required int ownerId,
      required int shareRatio,
      Value<int> rowid,
    });
typedef $$AccountOwnerSharesTableUpdateCompanionBuilder =
    AccountOwnerSharesCompanion Function({
      Value<int> accountId,
      Value<int> ownerId,
      Value<int> shareRatio,
      Value<int> rowid,
    });

final class $$AccountOwnerSharesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AccountOwnerSharesTable,
          AccountOwnerShare
        > {
  $$AccountOwnerSharesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias(
        $_aliasNameGenerator(db.accountOwnerShares.accountId, db.accounts.id),
      );

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $OwnersTable _ownerIdTable(_$AppDatabase db) => db.owners.createAlias(
    $_aliasNameGenerator(db.accountOwnerShares.ownerId, db.owners.id),
  );

  $$OwnersTableProcessedTableManager get ownerId {
    final $_column = $_itemColumn<int>('owner_id')!;

    final manager = $$OwnersTableTableManager(
      $_db,
      $_db.owners,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ownerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AccountOwnerSharesTableFilterComposer
    extends Composer<_$AppDatabase, $AccountOwnerSharesTable> {
  $$AccountOwnerSharesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get shareRatio => $composableBuilder(
    column: $table.shareRatio,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OwnersTableFilterComposer get ownerId {
    final $$OwnersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerId,
      referencedTable: $db.owners,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OwnersTableFilterComposer(
            $db: $db,
            $table: $db.owners,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AccountOwnerSharesTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountOwnerSharesTable> {
  $$AccountOwnerSharesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get shareRatio => $composableBuilder(
    column: $table.shareRatio,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OwnersTableOrderingComposer get ownerId {
    final $$OwnersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerId,
      referencedTable: $db.owners,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OwnersTableOrderingComposer(
            $db: $db,
            $table: $db.owners,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AccountOwnerSharesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountOwnerSharesTable> {
  $$AccountOwnerSharesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get shareRatio => $composableBuilder(
    column: $table.shareRatio,
    builder: (column) => column,
  );

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OwnersTableAnnotationComposer get ownerId {
    final $$OwnersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerId,
      referencedTable: $db.owners,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OwnersTableAnnotationComposer(
            $db: $db,
            $table: $db.owners,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AccountOwnerSharesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountOwnerSharesTable,
          AccountOwnerShare,
          $$AccountOwnerSharesTableFilterComposer,
          $$AccountOwnerSharesTableOrderingComposer,
          $$AccountOwnerSharesTableAnnotationComposer,
          $$AccountOwnerSharesTableCreateCompanionBuilder,
          $$AccountOwnerSharesTableUpdateCompanionBuilder,
          (AccountOwnerShare, $$AccountOwnerSharesTableReferences),
          AccountOwnerShare,
          PrefetchHooks Function({bool accountId, bool ownerId})
        > {
  $$AccountOwnerSharesTableTableManager(
    _$AppDatabase db,
    $AccountOwnerSharesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$AccountOwnerSharesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$AccountOwnerSharesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$AccountOwnerSharesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> accountId = const Value.absent(),
                Value<int> ownerId = const Value.absent(),
                Value<int> shareRatio = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountOwnerSharesCompanion(
                accountId: accountId,
                ownerId: ownerId,
                shareRatio: shareRatio,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int accountId,
                required int ownerId,
                required int shareRatio,
                Value<int> rowid = const Value.absent(),
              }) => AccountOwnerSharesCompanion.insert(
                accountId: accountId,
                ownerId: ownerId,
                shareRatio: shareRatio,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$AccountOwnerSharesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({accountId = false, ownerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (accountId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.accountId,
                            referencedTable: $$AccountOwnerSharesTableReferences
                                ._accountIdTable(db),
                            referencedColumn:
                                $$AccountOwnerSharesTableReferences
                                    ._accountIdTable(db)
                                    .id,
                          )
                          as T;
                }
                if (ownerId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.ownerId,
                            referencedTable: $$AccountOwnerSharesTableReferences
                                ._ownerIdTable(db),
                            referencedColumn:
                                $$AccountOwnerSharesTableReferences
                                    ._ownerIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AccountOwnerSharesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountOwnerSharesTable,
      AccountOwnerShare,
      $$AccountOwnerSharesTableFilterComposer,
      $$AccountOwnerSharesTableOrderingComposer,
      $$AccountOwnerSharesTableAnnotationComposer,
      $$AccountOwnerSharesTableCreateCompanionBuilder,
      $$AccountOwnerSharesTableUpdateCompanionBuilder,
      (AccountOwnerShare, $$AccountOwnerSharesTableReferences),
      AccountOwnerShare,
      PrefetchHooks Function({bool accountId, bool ownerId})
    >;
typedef $$CounterpartiesTableCreateCompanionBuilder =
    CounterpartiesCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> identifier,
      Value<String> identifierType,
      Value<String?> phone,
      Value<String?> address,
      Value<String> confidenceLevel,
      Value<bool?> isRelatedParty,
      Value<String?> counterpartyType,
      Value<String?> countryCode,
    });
typedef $$CounterpartiesTableUpdateCompanionBuilder =
    CounterpartiesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> identifier,
      Value<String> identifierType,
      Value<String?> phone,
      Value<String?> address,
      Value<String> confidenceLevel,
      Value<bool?> isRelatedParty,
      Value<String?> counterpartyType,
      Value<String?> countryCode,
    });

final class $$CounterpartiesTableReferences
    extends BaseReferences<_$AppDatabase, $CounterpartiesTable, Counterparty> {
  $$CounterpartiesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $CounterpartyAliasesTable,
    List<CounterpartyAliase>
  >
  _counterpartyAliasesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.counterpartyAliases,
        aliasName: $_aliasNameGenerator(
          db.counterparties.id,
          db.counterpartyAliases.counterpartyId,
        ),
      );

  $$CounterpartyAliasesTableProcessedTableManager get counterpartyAliasesRefs {
    final manager = $$CounterpartyAliasesTableTableManager(
      $_db,
      $_db.counterpartyAliases,
    ).filter((f) => f.counterpartyId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _counterpartyAliasesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
  _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: $_aliasNameGenerator(
      db.counterparties.id,
      db.transactions.counterpartyId,
    ),
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.counterpartyId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ClassificationRulesTable,
    List<ClassificationRule>
  >
  _classificationRulesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.classificationRules,
        aliasName: $_aliasNameGenerator(
          db.counterparties.id,
          db.classificationRules.counterpartyId,
        ),
      );

  $$ClassificationRulesTableProcessedTableManager get classificationRulesRefs {
    final manager = $$ClassificationRulesTableTableManager(
      $_db,
      $_db.classificationRules,
    ).filter((f) => f.counterpartyId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _classificationRulesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CounterpartiesTableFilterComposer
    extends Composer<_$AppDatabase, $CounterpartiesTable> {
  $$CounterpartiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get identifier => $composableBuilder(
    column: $table.identifier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get identifierType => $composableBuilder(
    column: $table.identifierType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get confidenceLevel => $composableBuilder(
    column: $table.confidenceLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRelatedParty => $composableBuilder(
    column: $table.isRelatedParty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get counterpartyType => $composableBuilder(
    column: $table.counterpartyType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> counterpartyAliasesRefs(
    Expression<bool> Function($$CounterpartyAliasesTableFilterComposer f) f,
  ) {
    final $$CounterpartyAliasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.counterpartyAliases,
      getReferencedColumn: (t) => t.counterpartyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CounterpartyAliasesTableFilterComposer(
            $db: $db,
            $table: $db.counterpartyAliases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.counterpartyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> classificationRulesRefs(
    Expression<bool> Function($$ClassificationRulesTableFilterComposer f) f,
  ) {
    final $$ClassificationRulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.classificationRules,
      getReferencedColumn: (t) => t.counterpartyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassificationRulesTableFilterComposer(
            $db: $db,
            $table: $db.classificationRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CounterpartiesTableOrderingComposer
    extends Composer<_$AppDatabase, $CounterpartiesTable> {
  $$CounterpartiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get identifier => $composableBuilder(
    column: $table.identifier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get identifierType => $composableBuilder(
    column: $table.identifierType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confidenceLevel => $composableBuilder(
    column: $table.confidenceLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRelatedParty => $composableBuilder(
    column: $table.isRelatedParty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get counterpartyType => $composableBuilder(
    column: $table.counterpartyType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CounterpartiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CounterpartiesTable> {
  $$CounterpartiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get identifier => $composableBuilder(
    column: $table.identifier,
    builder: (column) => column,
  );

  GeneratedColumn<String> get identifierType => $composableBuilder(
    column: $table.identifierType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get confidenceLevel => $composableBuilder(
    column: $table.confidenceLevel,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isRelatedParty => $composableBuilder(
    column: $table.isRelatedParty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get counterpartyType => $composableBuilder(
    column: $table.counterpartyType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => column,
  );

  Expression<T> counterpartyAliasesRefs<T extends Object>(
    Expression<T> Function($$CounterpartyAliasesTableAnnotationComposer a) f,
  ) {
    final $$CounterpartyAliasesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.counterpartyAliases,
          getReferencedColumn: (t) => t.counterpartyId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CounterpartyAliasesTableAnnotationComposer(
                $db: $db,
                $table: $db.counterpartyAliases,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.counterpartyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> classificationRulesRefs<T extends Object>(
    Expression<T> Function($$ClassificationRulesTableAnnotationComposer a) f,
  ) {
    final $$ClassificationRulesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.classificationRules,
          getReferencedColumn: (t) => t.counterpartyId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ClassificationRulesTableAnnotationComposer(
                $db: $db,
                $table: $db.classificationRules,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CounterpartiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CounterpartiesTable,
          Counterparty,
          $$CounterpartiesTableFilterComposer,
          $$CounterpartiesTableOrderingComposer,
          $$CounterpartiesTableAnnotationComposer,
          $$CounterpartiesTableCreateCompanionBuilder,
          $$CounterpartiesTableUpdateCompanionBuilder,
          (Counterparty, $$CounterpartiesTableReferences),
          Counterparty,
          PrefetchHooks Function({
            bool counterpartyAliasesRefs,
            bool transactionsRefs,
            bool classificationRulesRefs,
          })
        > {
  $$CounterpartiesTableTableManager(
    _$AppDatabase db,
    $CounterpartiesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$CounterpartiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$CounterpartiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$CounterpartiesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> identifier = const Value.absent(),
                Value<String> identifierType = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String> confidenceLevel = const Value.absent(),
                Value<bool?> isRelatedParty = const Value.absent(),
                Value<String?> counterpartyType = const Value.absent(),
                Value<String?> countryCode = const Value.absent(),
              }) => CounterpartiesCompanion(
                id: id,
                name: name,
                identifier: identifier,
                identifierType: identifierType,
                phone: phone,
                address: address,
                confidenceLevel: confidenceLevel,
                isRelatedParty: isRelatedParty,
                counterpartyType: counterpartyType,
                countryCode: countryCode,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> identifier = const Value.absent(),
                Value<String> identifierType = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String> confidenceLevel = const Value.absent(),
                Value<bool?> isRelatedParty = const Value.absent(),
                Value<String?> counterpartyType = const Value.absent(),
                Value<String?> countryCode = const Value.absent(),
              }) => CounterpartiesCompanion.insert(
                id: id,
                name: name,
                identifier: identifier,
                identifierType: identifierType,
                phone: phone,
                address: address,
                confidenceLevel: confidenceLevel,
                isRelatedParty: isRelatedParty,
                counterpartyType: counterpartyType,
                countryCode: countryCode,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$CounterpartiesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            counterpartyAliasesRefs = false,
            transactionsRefs = false,
            classificationRulesRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (counterpartyAliasesRefs) db.counterpartyAliases,
                if (transactionsRefs) db.transactions,
                if (classificationRulesRefs) db.classificationRules,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (counterpartyAliasesRefs)
                    await $_getPrefetchedData<
                      Counterparty,
                      $CounterpartiesTable,
                      CounterpartyAliase
                    >(
                      currentTable: table,
                      referencedTable: $$CounterpartiesTableReferences
                          ._counterpartyAliasesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$CounterpartiesTableReferences(
                                db,
                                table,
                                p0,
                              ).counterpartyAliasesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.counterpartyId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (transactionsRefs)
                    await $_getPrefetchedData<
                      Counterparty,
                      $CounterpartiesTable,
                      Transaction
                    >(
                      currentTable: table,
                      referencedTable: $$CounterpartiesTableReferences
                          ._transactionsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$CounterpartiesTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.counterpartyId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (classificationRulesRefs)
                    await $_getPrefetchedData<
                      Counterparty,
                      $CounterpartiesTable,
                      ClassificationRule
                    >(
                      currentTable: table,
                      referencedTable: $$CounterpartiesTableReferences
                          ._classificationRulesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$CounterpartiesTableReferences(
                                db,
                                table,
                                p0,
                              ).classificationRulesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.counterpartyId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CounterpartiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CounterpartiesTable,
      Counterparty,
      $$CounterpartiesTableFilterComposer,
      $$CounterpartiesTableOrderingComposer,
      $$CounterpartiesTableAnnotationComposer,
      $$CounterpartiesTableCreateCompanionBuilder,
      $$CounterpartiesTableUpdateCompanionBuilder,
      (Counterparty, $$CounterpartiesTableReferences),
      Counterparty,
      PrefetchHooks Function({
        bool counterpartyAliasesRefs,
        bool transactionsRefs,
        bool classificationRulesRefs,
      })
    >;
typedef $$CounterpartyAliasesTableCreateCompanionBuilder =
    CounterpartyAliasesCompanion Function({
      Value<int> id,
      required int counterpartyId,
      required String alias,
    });
typedef $$CounterpartyAliasesTableUpdateCompanionBuilder =
    CounterpartyAliasesCompanion Function({
      Value<int> id,
      Value<int> counterpartyId,
      Value<String> alias,
    });

final class $$CounterpartyAliasesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CounterpartyAliasesTable,
          CounterpartyAliase
        > {
  $$CounterpartyAliasesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CounterpartiesTable _counterpartyIdTable(_$AppDatabase db) =>
      db.counterparties.createAlias(
        $_aliasNameGenerator(
          db.counterpartyAliases.counterpartyId,
          db.counterparties.id,
        ),
      );

  $$CounterpartiesTableProcessedTableManager get counterpartyId {
    final $_column = $_itemColumn<int>('counterparty_id')!;

    final manager = $$CounterpartiesTableTableManager(
      $_db,
      $_db.counterparties,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_counterpartyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CounterpartyAliasesTableFilterComposer
    extends Composer<_$AppDatabase, $CounterpartyAliasesTable> {
  $$CounterpartyAliasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alias => $composableBuilder(
    column: $table.alias,
    builder: (column) => ColumnFilters(column),
  );

  $$CounterpartiesTableFilterComposer get counterpartyId {
    final $$CounterpartiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.counterpartyId,
      referencedTable: $db.counterparties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CounterpartiesTableFilterComposer(
            $db: $db,
            $table: $db.counterparties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CounterpartyAliasesTableOrderingComposer
    extends Composer<_$AppDatabase, $CounterpartyAliasesTable> {
  $$CounterpartyAliasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alias => $composableBuilder(
    column: $table.alias,
    builder: (column) => ColumnOrderings(column),
  );

  $$CounterpartiesTableOrderingComposer get counterpartyId {
    final $$CounterpartiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.counterpartyId,
      referencedTable: $db.counterparties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CounterpartiesTableOrderingComposer(
            $db: $db,
            $table: $db.counterparties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CounterpartyAliasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CounterpartyAliasesTable> {
  $$CounterpartyAliasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get alias =>
      $composableBuilder(column: $table.alias, builder: (column) => column);

  $$CounterpartiesTableAnnotationComposer get counterpartyId {
    final $$CounterpartiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.counterpartyId,
      referencedTable: $db.counterparties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CounterpartiesTableAnnotationComposer(
            $db: $db,
            $table: $db.counterparties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CounterpartyAliasesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CounterpartyAliasesTable,
          CounterpartyAliase,
          $$CounterpartyAliasesTableFilterComposer,
          $$CounterpartyAliasesTableOrderingComposer,
          $$CounterpartyAliasesTableAnnotationComposer,
          $$CounterpartyAliasesTableCreateCompanionBuilder,
          $$CounterpartyAliasesTableUpdateCompanionBuilder,
          (CounterpartyAliase, $$CounterpartyAliasesTableReferences),
          CounterpartyAliase,
          PrefetchHooks Function({bool counterpartyId})
        > {
  $$CounterpartyAliasesTableTableManager(
    _$AppDatabase db,
    $CounterpartyAliasesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$CounterpartyAliasesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$CounterpartyAliasesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$CounterpartyAliasesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> counterpartyId = const Value.absent(),
                Value<String> alias = const Value.absent(),
              }) => CounterpartyAliasesCompanion(
                id: id,
                counterpartyId: counterpartyId,
                alias: alias,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int counterpartyId,
                required String alias,
              }) => CounterpartyAliasesCompanion.insert(
                id: id,
                counterpartyId: counterpartyId,
                alias: alias,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$CounterpartyAliasesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({counterpartyId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (counterpartyId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.counterpartyId,
                            referencedTable:
                                $$CounterpartyAliasesTableReferences
                                    ._counterpartyIdTable(db),
                            referencedColumn:
                                $$CounterpartyAliasesTableReferences
                                    ._counterpartyIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CounterpartyAliasesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CounterpartyAliasesTable,
      CounterpartyAliase,
      $$CounterpartyAliasesTableFilterComposer,
      $$CounterpartyAliasesTableOrderingComposer,
      $$CounterpartyAliasesTableAnnotationComposer,
      $$CounterpartyAliasesTableCreateCompanionBuilder,
      $$CounterpartyAliasesTableUpdateCompanionBuilder,
      (CounterpartyAliase, $$CounterpartyAliasesTableReferences),
      CounterpartyAliase,
      PrefetchHooks Function({bool counterpartyId})
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      required DateTime date,
      required String description,
      Value<String> status,
      Value<int?> voidedBy,
      Value<int?> counterpartyId,
      Value<String?> counterpartyName,
      required String source,
      Value<double?> confidence,
      Value<int?> periodId,
      Value<String> syncStatus,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<String> description,
      Value<String> status,
      Value<int?> voidedBy,
      Value<int?> counterpartyId,
      Value<String?> counterpartyName,
      Value<String> source,
      Value<double?> confidence,
      Value<int?> periodId,
      Value<String> syncStatus,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$TransactionsTableReferences
    extends BaseReferences<_$AppDatabase, $TransactionsTable, Transaction> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TransactionsTable _voidedByTable(_$AppDatabase db) =>
      db.transactions.createAlias(
        $_aliasNameGenerator(db.transactions.voidedBy, db.transactions.id),
      );

  $$TransactionsTableProcessedTableManager? get voidedBy {
    final $_column = $_itemColumn<int>('voided_by');
    if ($_column == null) return null;
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_voidedByTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CounterpartiesTable _counterpartyIdTable(_$AppDatabase db) =>
      db.counterparties.createAlias(
        $_aliasNameGenerator(
          db.transactions.counterpartyId,
          db.counterparties.id,
        ),
      );

  $$CounterpartiesTableProcessedTableManager? get counterpartyId {
    final $_column = $_itemColumn<int>('counterparty_id');
    if ($_column == null) return null;
    final manager = $$CounterpartiesTableTableManager(
      $_db,
      $_db.counterparties,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_counterpartyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$JournalEntryLinesTable, List<JournalEntryLine>>
  _journalEntryLinesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.journalEntryLines,
        aliasName: $_aliasNameGenerator(
          db.transactions.id,
          db.journalEntryLines.transactionId,
        ),
      );

  $$JournalEntryLinesTableProcessedTableManager get journalEntryLinesRefs {
    final manager = $$JournalEntryLinesTableTableManager(
      $_db,
      $_db.journalEntryLines,
    ).filter((f) => f.transactionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _journalEntryLinesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TransactionTagsTable, List<TransactionTag>>
  _transactionTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactionTags,
    aliasName: $_aliasNameGenerator(
      db.transactions.id,
      db.transactionTags.transactionId,
    ),
  );

  $$TransactionTagsTableProcessedTableManager get transactionTagsRefs {
    final manager = $$TransactionTagsTableTableManager(
      $_db,
      $_db.transactionTags,
    ).filter((f) => f.transactionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _transactionTagsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get counterpartyName => $composableBuilder(
    column: $table.counterpartyName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get periodId => $composableBuilder(
    column: $table.periodId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TransactionsTableFilterComposer get voidedBy {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.voidedBy,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CounterpartiesTableFilterComposer get counterpartyId {
    final $$CounterpartiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.counterpartyId,
      referencedTable: $db.counterparties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CounterpartiesTableFilterComposer(
            $db: $db,
            $table: $db.counterparties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> journalEntryLinesRefs(
    Expression<bool> Function($$JournalEntryLinesTableFilterComposer f) f,
  ) {
    final $$JournalEntryLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journalEntryLines,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntryLinesTableFilterComposer(
            $db: $db,
            $table: $db.journalEntryLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> transactionTagsRefs(
    Expression<bool> Function($$TransactionTagsTableFilterComposer f) f,
  ) {
    final $$TransactionTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionTags,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionTagsTableFilterComposer(
            $db: $db,
            $table: $db.transactionTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get counterpartyName => $composableBuilder(
    column: $table.counterpartyName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get periodId => $composableBuilder(
    column: $table.periodId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TransactionsTableOrderingComposer get voidedBy {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.voidedBy,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CounterpartiesTableOrderingComposer get counterpartyId {
    final $$CounterpartiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.counterpartyId,
      referencedTable: $db.counterparties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CounterpartiesTableOrderingComposer(
            $db: $db,
            $table: $db.counterparties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get counterpartyName => $composableBuilder(
    column: $table.counterpartyName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<int> get periodId =>
      $composableBuilder(column: $table.periodId, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$TransactionsTableAnnotationComposer get voidedBy {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.voidedBy,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CounterpartiesTableAnnotationComposer get counterpartyId {
    final $$CounterpartiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.counterpartyId,
      referencedTable: $db.counterparties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CounterpartiesTableAnnotationComposer(
            $db: $db,
            $table: $db.counterparties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> journalEntryLinesRefs<T extends Object>(
    Expression<T> Function($$JournalEntryLinesTableAnnotationComposer a) f,
  ) {
    final $$JournalEntryLinesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.journalEntryLines,
          getReferencedColumn: (t) => t.transactionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$JournalEntryLinesTableAnnotationComposer(
                $db: $db,
                $table: $db.journalEntryLines,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> transactionTagsRefs<T extends Object>(
    Expression<T> Function($$TransactionTagsTableAnnotationComposer a) f,
  ) {
    final $$TransactionTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionTags,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactionTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          Transaction,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (Transaction, $$TransactionsTableReferences),
          Transaction,
          PrefetchHooks Function({
            bool voidedBy,
            bool counterpartyId,
            bool journalEntryLinesRefs,
            bool transactionTagsRefs,
          })
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int?> voidedBy = const Value.absent(),
                Value<int?> counterpartyId = const Value.absent(),
                Value<String?> counterpartyName = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<double?> confidence = const Value.absent(),
                Value<int?> periodId = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                date: date,
                description: description,
                status: status,
                voidedBy: voidedBy,
                counterpartyId: counterpartyId,
                counterpartyName: counterpartyName,
                source: source,
                confidence: confidence,
                periodId: periodId,
                syncStatus: syncStatus,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required String description,
                Value<String> status = const Value.absent(),
                Value<int?> voidedBy = const Value.absent(),
                Value<int?> counterpartyId = const Value.absent(),
                Value<String?> counterpartyName = const Value.absent(),
                required String source,
                Value<double?> confidence = const Value.absent(),
                Value<int?> periodId = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                date: date,
                description: description,
                status: status,
                voidedBy: voidedBy,
                counterpartyId: counterpartyId,
                counterpartyName: counterpartyName,
                source: source,
                confidence: confidence,
                periodId: periodId,
                syncStatus: syncStatus,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$TransactionsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            voidedBy = false,
            counterpartyId = false,
            journalEntryLinesRefs = false,
            transactionTagsRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (journalEntryLinesRefs) db.journalEntryLines,
                if (transactionTagsRefs) db.transactionTags,
              ],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (voidedBy) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.voidedBy,
                            referencedTable: $$TransactionsTableReferences
                                ._voidedByTable(db),
                            referencedColumn:
                                $$TransactionsTableReferences
                                    ._voidedByTable(db)
                                    .id,
                          )
                          as T;
                }
                if (counterpartyId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.counterpartyId,
                            referencedTable: $$TransactionsTableReferences
                                ._counterpartyIdTable(db),
                            referencedColumn:
                                $$TransactionsTableReferences
                                    ._counterpartyIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (journalEntryLinesRefs)
                    await $_getPrefetchedData<
                      Transaction,
                      $TransactionsTable,
                      JournalEntryLine
                    >(
                      currentTable: table,
                      referencedTable: $$TransactionsTableReferences
                          ._journalEntryLinesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$TransactionsTableReferences(
                                db,
                                table,
                                p0,
                              ).journalEntryLinesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.transactionId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (transactionTagsRefs)
                    await $_getPrefetchedData<
                      Transaction,
                      $TransactionsTable,
                      TransactionTag
                    >(
                      currentTable: table,
                      referencedTable: $$TransactionsTableReferences
                          ._transactionTagsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$TransactionsTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionTagsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.transactionId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      Transaction,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (Transaction, $$TransactionsTableReferences),
      Transaction,
      PrefetchHooks Function({
        bool voidedBy,
        bool counterpartyId,
        bool journalEntryLinesRefs,
        bool transactionTagsRefs,
      })
    >;
typedef $$JournalEntryLinesTableCreateCompanionBuilder =
    JournalEntryLinesCompanion Function({
      Value<int> id,
      required int transactionId,
      required int accountId,
      required String entryType,
      required int originalAmount,
      required String originalCurrency,
      required int exchangeRateAtTrade,
      required String baseCurrency,
      required int baseAmount,
      Value<int?> activityTypeOverride,
      Value<int?> ownerIdOverride,
      Value<int?> incomeTypeOverride,
      Value<String> deductibility,
      Value<int?> beneficiaryId,
      Value<String?> taxClassification,
      Value<String?> memo,
    });
typedef $$JournalEntryLinesTableUpdateCompanionBuilder =
    JournalEntryLinesCompanion Function({
      Value<int> id,
      Value<int> transactionId,
      Value<int> accountId,
      Value<String> entryType,
      Value<int> originalAmount,
      Value<String> originalCurrency,
      Value<int> exchangeRateAtTrade,
      Value<String> baseCurrency,
      Value<int> baseAmount,
      Value<int?> activityTypeOverride,
      Value<int?> ownerIdOverride,
      Value<int?> incomeTypeOverride,
      Value<String> deductibility,
      Value<int?> beneficiaryId,
      Value<String?> taxClassification,
      Value<String?> memo,
    });

final class $$JournalEntryLinesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $JournalEntryLinesTable,
          JournalEntryLine
        > {
  $$JournalEntryLinesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TransactionsTable _transactionIdTable(_$AppDatabase db) =>
      db.transactions.createAlias(
        $_aliasNameGenerator(
          db.journalEntryLines.transactionId,
          db.transactions.id,
        ),
      );

  $$TransactionsTableProcessedTableManager get transactionId {
    final $_column = $_itemColumn<int>('transaction_id')!;

    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias(
        $_aliasNameGenerator(db.journalEntryLines.accountId, db.accounts.id),
      );

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DimensionValuesTable _activityTypeOverrideTable(_$AppDatabase db) =>
      db.dimensionValues.createAlias(
        $_aliasNameGenerator(
          db.journalEntryLines.activityTypeOverride,
          db.dimensionValues.id,
        ),
      );

  $$DimensionValuesTableProcessedTableManager? get activityTypeOverride {
    final $_column = $_itemColumn<int>('activity_type_override');
    if ($_column == null) return null;
    final manager = $$DimensionValuesTableTableManager(
      $_db,
      $_db.dimensionValues,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _activityTypeOverrideTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $OwnersTable _ownerIdOverrideTable(_$AppDatabase db) =>
      db.owners.createAlias(
        $_aliasNameGenerator(
          db.journalEntryLines.ownerIdOverride,
          db.owners.id,
        ),
      );

  $$OwnersTableProcessedTableManager? get ownerIdOverride {
    final $_column = $_itemColumn<int>('owner_id_override');
    if ($_column == null) return null;
    final manager = $$OwnersTableTableManager(
      $_db,
      $_db.owners,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ownerIdOverrideTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DimensionValuesTable _incomeTypeOverrideTable(_$AppDatabase db) =>
      db.dimensionValues.createAlias(
        $_aliasNameGenerator(
          db.journalEntryLines.incomeTypeOverride,
          db.dimensionValues.id,
        ),
      );

  $$DimensionValuesTableProcessedTableManager? get incomeTypeOverride {
    final $_column = $_itemColumn<int>('income_type_override');
    if ($_column == null) return null;
    final manager = $$DimensionValuesTableTableManager(
      $_db,
      $_db.dimensionValues,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_incomeTypeOverrideTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $OwnersTable _beneficiaryIdTable(_$AppDatabase db) =>
      db.owners.createAlias(
        $_aliasNameGenerator(db.journalEntryLines.beneficiaryId, db.owners.id),
      );

  $$OwnersTableProcessedTableManager? get beneficiaryId {
    final $_column = $_itemColumn<int>('beneficiary_id');
    if ($_column == null) return null;
    final manager = $$OwnersTableTableManager(
      $_db,
      $_db.owners,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_beneficiaryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$JournalEntryLinesTableFilterComposer
    extends Composer<_$AppDatabase, $JournalEntryLinesTable> {
  $$JournalEntryLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entryType => $composableBuilder(
    column: $table.entryType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get originalAmount => $composableBuilder(
    column: $table.originalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalCurrency => $composableBuilder(
    column: $table.originalCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get exchangeRateAtTrade => $composableBuilder(
    column: $table.exchangeRateAtTrade,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get baseCurrency => $composableBuilder(
    column: $table.baseCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get baseAmount => $composableBuilder(
    column: $table.baseAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deductibility => $composableBuilder(
    column: $table.deductibility,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taxClassification => $composableBuilder(
    column: $table.taxClassification,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnFilters(column),
  );

  $$TransactionsTableFilterComposer get transactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DimensionValuesTableFilterComposer get activityTypeOverride {
    final $$DimensionValuesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityTypeOverride,
      referencedTable: $db.dimensionValues,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DimensionValuesTableFilterComposer(
            $db: $db,
            $table: $db.dimensionValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OwnersTableFilterComposer get ownerIdOverride {
    final $$OwnersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerIdOverride,
      referencedTable: $db.owners,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OwnersTableFilterComposer(
            $db: $db,
            $table: $db.owners,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DimensionValuesTableFilterComposer get incomeTypeOverride {
    final $$DimensionValuesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.incomeTypeOverride,
      referencedTable: $db.dimensionValues,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DimensionValuesTableFilterComposer(
            $db: $db,
            $table: $db.dimensionValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OwnersTableFilterComposer get beneficiaryId {
    final $$OwnersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.beneficiaryId,
      referencedTable: $db.owners,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OwnersTableFilterComposer(
            $db: $db,
            $table: $db.owners,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JournalEntryLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $JournalEntryLinesTable> {
  $$JournalEntryLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entryType => $composableBuilder(
    column: $table.entryType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get originalAmount => $composableBuilder(
    column: $table.originalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalCurrency => $composableBuilder(
    column: $table.originalCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get exchangeRateAtTrade => $composableBuilder(
    column: $table.exchangeRateAtTrade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get baseCurrency => $composableBuilder(
    column: $table.baseCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baseAmount => $composableBuilder(
    column: $table.baseAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deductibility => $composableBuilder(
    column: $table.deductibility,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taxClassification => $composableBuilder(
    column: $table.taxClassification,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnOrderings(column),
  );

  $$TransactionsTableOrderingComposer get transactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DimensionValuesTableOrderingComposer get activityTypeOverride {
    final $$DimensionValuesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityTypeOverride,
      referencedTable: $db.dimensionValues,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DimensionValuesTableOrderingComposer(
            $db: $db,
            $table: $db.dimensionValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OwnersTableOrderingComposer get ownerIdOverride {
    final $$OwnersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerIdOverride,
      referencedTable: $db.owners,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OwnersTableOrderingComposer(
            $db: $db,
            $table: $db.owners,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DimensionValuesTableOrderingComposer get incomeTypeOverride {
    final $$DimensionValuesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.incomeTypeOverride,
      referencedTable: $db.dimensionValues,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DimensionValuesTableOrderingComposer(
            $db: $db,
            $table: $db.dimensionValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OwnersTableOrderingComposer get beneficiaryId {
    final $$OwnersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.beneficiaryId,
      referencedTable: $db.owners,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OwnersTableOrderingComposer(
            $db: $db,
            $table: $db.owners,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JournalEntryLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $JournalEntryLinesTable> {
  $$JournalEntryLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entryType =>
      $composableBuilder(column: $table.entryType, builder: (column) => column);

  GeneratedColumn<int> get originalAmount => $composableBuilder(
    column: $table.originalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get originalCurrency => $composableBuilder(
    column: $table.originalCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<int> get exchangeRateAtTrade => $composableBuilder(
    column: $table.exchangeRateAtTrade,
    builder: (column) => column,
  );

  GeneratedColumn<String> get baseCurrency => $composableBuilder(
    column: $table.baseCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<int> get baseAmount => $composableBuilder(
    column: $table.baseAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deductibility => $composableBuilder(
    column: $table.deductibility,
    builder: (column) => column,
  );

  GeneratedColumn<String> get taxClassification => $composableBuilder(
    column: $table.taxClassification,
    builder: (column) => column,
  );

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);

  $$TransactionsTableAnnotationComposer get transactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DimensionValuesTableAnnotationComposer get activityTypeOverride {
    final $$DimensionValuesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityTypeOverride,
      referencedTable: $db.dimensionValues,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DimensionValuesTableAnnotationComposer(
            $db: $db,
            $table: $db.dimensionValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OwnersTableAnnotationComposer get ownerIdOverride {
    final $$OwnersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerIdOverride,
      referencedTable: $db.owners,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OwnersTableAnnotationComposer(
            $db: $db,
            $table: $db.owners,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DimensionValuesTableAnnotationComposer get incomeTypeOverride {
    final $$DimensionValuesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.incomeTypeOverride,
      referencedTable: $db.dimensionValues,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DimensionValuesTableAnnotationComposer(
            $db: $db,
            $table: $db.dimensionValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OwnersTableAnnotationComposer get beneficiaryId {
    final $$OwnersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.beneficiaryId,
      referencedTable: $db.owners,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OwnersTableAnnotationComposer(
            $db: $db,
            $table: $db.owners,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JournalEntryLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JournalEntryLinesTable,
          JournalEntryLine,
          $$JournalEntryLinesTableFilterComposer,
          $$JournalEntryLinesTableOrderingComposer,
          $$JournalEntryLinesTableAnnotationComposer,
          $$JournalEntryLinesTableCreateCompanionBuilder,
          $$JournalEntryLinesTableUpdateCompanionBuilder,
          (JournalEntryLine, $$JournalEntryLinesTableReferences),
          JournalEntryLine,
          PrefetchHooks Function({
            bool transactionId,
            bool accountId,
            bool activityTypeOverride,
            bool ownerIdOverride,
            bool incomeTypeOverride,
            bool beneficiaryId,
          })
        > {
  $$JournalEntryLinesTableTableManager(
    _$AppDatabase db,
    $JournalEntryLinesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$JournalEntryLinesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$JournalEntryLinesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$JournalEntryLinesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> transactionId = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<String> entryType = const Value.absent(),
                Value<int> originalAmount = const Value.absent(),
                Value<String> originalCurrency = const Value.absent(),
                Value<int> exchangeRateAtTrade = const Value.absent(),
                Value<String> baseCurrency = const Value.absent(),
                Value<int> baseAmount = const Value.absent(),
                Value<int?> activityTypeOverride = const Value.absent(),
                Value<int?> ownerIdOverride = const Value.absent(),
                Value<int?> incomeTypeOverride = const Value.absent(),
                Value<String> deductibility = const Value.absent(),
                Value<int?> beneficiaryId = const Value.absent(),
                Value<String?> taxClassification = const Value.absent(),
                Value<String?> memo = const Value.absent(),
              }) => JournalEntryLinesCompanion(
                id: id,
                transactionId: transactionId,
                accountId: accountId,
                entryType: entryType,
                originalAmount: originalAmount,
                originalCurrency: originalCurrency,
                exchangeRateAtTrade: exchangeRateAtTrade,
                baseCurrency: baseCurrency,
                baseAmount: baseAmount,
                activityTypeOverride: activityTypeOverride,
                ownerIdOverride: ownerIdOverride,
                incomeTypeOverride: incomeTypeOverride,
                deductibility: deductibility,
                beneficiaryId: beneficiaryId,
                taxClassification: taxClassification,
                memo: memo,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int transactionId,
                required int accountId,
                required String entryType,
                required int originalAmount,
                required String originalCurrency,
                required int exchangeRateAtTrade,
                required String baseCurrency,
                required int baseAmount,
                Value<int?> activityTypeOverride = const Value.absent(),
                Value<int?> ownerIdOverride = const Value.absent(),
                Value<int?> incomeTypeOverride = const Value.absent(),
                Value<String> deductibility = const Value.absent(),
                Value<int?> beneficiaryId = const Value.absent(),
                Value<String?> taxClassification = const Value.absent(),
                Value<String?> memo = const Value.absent(),
              }) => JournalEntryLinesCompanion.insert(
                id: id,
                transactionId: transactionId,
                accountId: accountId,
                entryType: entryType,
                originalAmount: originalAmount,
                originalCurrency: originalCurrency,
                exchangeRateAtTrade: exchangeRateAtTrade,
                baseCurrency: baseCurrency,
                baseAmount: baseAmount,
                activityTypeOverride: activityTypeOverride,
                ownerIdOverride: ownerIdOverride,
                incomeTypeOverride: incomeTypeOverride,
                deductibility: deductibility,
                beneficiaryId: beneficiaryId,
                taxClassification: taxClassification,
                memo: memo,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$JournalEntryLinesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            transactionId = false,
            accountId = false,
            activityTypeOverride = false,
            ownerIdOverride = false,
            incomeTypeOverride = false,
            beneficiaryId = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (transactionId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.transactionId,
                            referencedTable: $$JournalEntryLinesTableReferences
                                ._transactionIdTable(db),
                            referencedColumn:
                                $$JournalEntryLinesTableReferences
                                    ._transactionIdTable(db)
                                    .id,
                          )
                          as T;
                }
                if (accountId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.accountId,
                            referencedTable: $$JournalEntryLinesTableReferences
                                ._accountIdTable(db),
                            referencedColumn:
                                $$JournalEntryLinesTableReferences
                                    ._accountIdTable(db)
                                    .id,
                          )
                          as T;
                }
                if (activityTypeOverride) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.activityTypeOverride,
                            referencedTable: $$JournalEntryLinesTableReferences
                                ._activityTypeOverrideTable(db),
                            referencedColumn:
                                $$JournalEntryLinesTableReferences
                                    ._activityTypeOverrideTable(db)
                                    .id,
                          )
                          as T;
                }
                if (ownerIdOverride) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.ownerIdOverride,
                            referencedTable: $$JournalEntryLinesTableReferences
                                ._ownerIdOverrideTable(db),
                            referencedColumn:
                                $$JournalEntryLinesTableReferences
                                    ._ownerIdOverrideTable(db)
                                    .id,
                          )
                          as T;
                }
                if (incomeTypeOverride) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.incomeTypeOverride,
                            referencedTable: $$JournalEntryLinesTableReferences
                                ._incomeTypeOverrideTable(db),
                            referencedColumn:
                                $$JournalEntryLinesTableReferences
                                    ._incomeTypeOverrideTable(db)
                                    .id,
                          )
                          as T;
                }
                if (beneficiaryId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.beneficiaryId,
                            referencedTable: $$JournalEntryLinesTableReferences
                                ._beneficiaryIdTable(db),
                            referencedColumn:
                                $$JournalEntryLinesTableReferences
                                    ._beneficiaryIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$JournalEntryLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JournalEntryLinesTable,
      JournalEntryLine,
      $$JournalEntryLinesTableFilterComposer,
      $$JournalEntryLinesTableOrderingComposer,
      $$JournalEntryLinesTableAnnotationComposer,
      $$JournalEntryLinesTableCreateCompanionBuilder,
      $$JournalEntryLinesTableUpdateCompanionBuilder,
      (JournalEntryLine, $$JournalEntryLinesTableReferences),
      JournalEntryLine,
      PrefetchHooks Function({
        bool transactionId,
        bool accountId,
        bool activityTypeOverride,
        bool ownerIdOverride,
        bool incomeTypeOverride,
        bool beneficiaryId,
      })
    >;
typedef $$TagsTableCreateCompanionBuilder =
    TagsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> category,
    });
typedef $$TagsTableUpdateCompanionBuilder =
    TagsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> category,
    });

final class $$TagsTableReferences
    extends BaseReferences<_$AppDatabase, $TagsTable, Tag> {
  $$TagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionTagsTable, List<TransactionTag>>
  _transactionTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactionTags,
    aliasName: $_aliasNameGenerator(db.tags.id, db.transactionTags.tagId),
  );

  $$TransactionTagsTableProcessedTableManager get transactionTagsRefs {
    final manager = $$TransactionTagsTableTableManager(
      $_db,
      $_db.transactionTags,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _transactionTagsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transactionTagsRefs(
    Expression<bool> Function($$TransactionTagsTableFilterComposer f) f,
  ) {
    final $$TransactionTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionTagsTableFilterComposer(
            $db: $db,
            $table: $db.transactionTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  Expression<T> transactionTagsRefs<T extends Object>(
    Expression<T> Function($$TransactionTagsTableAnnotationComposer a) f,
  ) {
    final $$TransactionTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactionTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagsTable,
          Tag,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (Tag, $$TagsTableReferences),
          Tag,
          PrefetchHooks Function({bool transactionTagsRefs})
        > {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> category = const Value.absent(),
              }) => TagsCompanion(id: id, name: name, category: category),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> category = const Value.absent(),
              }) =>
                  TagsCompanion.insert(id: id, name: name, category: category),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$TagsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({transactionTagsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transactionTagsRefs) db.transactionTags,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionTagsRefs)
                    await $_getPrefetchedData<Tag, $TagsTable, TransactionTag>(
                      currentTable: table,
                      referencedTable: $$TagsTableReferences
                          ._transactionTagsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$TagsTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionTagsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.tagId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagsTable,
      Tag,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (Tag, $$TagsTableReferences),
      Tag,
      PrefetchHooks Function({bool transactionTagsRefs})
    >;
typedef $$TransactionTagsTableCreateCompanionBuilder =
    TransactionTagsCompanion Function({
      required int transactionId,
      required int tagId,
      Value<int> rowid,
    });
typedef $$TransactionTagsTableUpdateCompanionBuilder =
    TransactionTagsCompanion Function({
      Value<int> transactionId,
      Value<int> tagId,
      Value<int> rowid,
    });

final class $$TransactionTagsTableReferences
    extends
        BaseReferences<_$AppDatabase, $TransactionTagsTable, TransactionTag> {
  $$TransactionTagsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TransactionsTable _transactionIdTable(_$AppDatabase db) =>
      db.transactions.createAlias(
        $_aliasNameGenerator(
          db.transactionTags.transactionId,
          db.transactions.id,
        ),
      );

  $$TransactionsTableProcessedTableManager get transactionId {
    final $_column = $_itemColumn<int>('transaction_id')!;

    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TagsTable _tagIdTable(_$AppDatabase db) => db.tags.createAlias(
    $_aliasNameGenerator(db.transactionTags.tagId, db.tags.id),
  );

  $$TagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<int>('tag_id')!;

    final manager = $$TagsTableTableManager(
      $_db,
      $_db.tags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TransactionTagsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionTagsTable> {
  $$TransactionTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$TransactionsTableFilterComposer get transactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableFilterComposer get tagId {
    final $$TagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableFilterComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionTagsTable> {
  $$TransactionTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$TransactionsTableOrderingComposer get transactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableOrderingComposer get tagId {
    final $$TagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableOrderingComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionTagsTable> {
  $$TransactionTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$TransactionsTableAnnotationComposer get transactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableAnnotationComposer get tagId {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionTagsTable,
          TransactionTag,
          $$TransactionTagsTableFilterComposer,
          $$TransactionTagsTableOrderingComposer,
          $$TransactionTagsTableAnnotationComposer,
          $$TransactionTagsTableCreateCompanionBuilder,
          $$TransactionTagsTableUpdateCompanionBuilder,
          (TransactionTag, $$TransactionTagsTableReferences),
          TransactionTag,
          PrefetchHooks Function({bool transactionId, bool tagId})
        > {
  $$TransactionTagsTableTableManager(
    _$AppDatabase db,
    $TransactionTagsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$TransactionTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$TransactionTagsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$TransactionTagsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> transactionId = const Value.absent(),
                Value<int> tagId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionTagsCompanion(
                transactionId: transactionId,
                tagId: tagId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int transactionId,
                required int tagId,
                Value<int> rowid = const Value.absent(),
              }) => TransactionTagsCompanion.insert(
                transactionId: transactionId,
                tagId: tagId,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$TransactionTagsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({transactionId = false, tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (transactionId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.transactionId,
                            referencedTable: $$TransactionTagsTableReferences
                                ._transactionIdTable(db),
                            referencedColumn:
                                $$TransactionTagsTableReferences
                                    ._transactionIdTable(db)
                                    .id,
                          )
                          as T;
                }
                if (tagId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.tagId,
                            referencedTable: $$TransactionTagsTableReferences
                                ._tagIdTable(db),
                            referencedColumn:
                                $$TransactionTagsTableReferences
                                    ._tagIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TransactionTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionTagsTable,
      TransactionTag,
      $$TransactionTagsTableFilterComposer,
      $$TransactionTagsTableOrderingComposer,
      $$TransactionTagsTableAnnotationComposer,
      $$TransactionTagsTableCreateCompanionBuilder,
      $$TransactionTagsTableUpdateCompanionBuilder,
      (TransactionTag, $$TransactionTagsTableReferences),
      TransactionTag,
      PrefetchHooks Function({bool transactionId, bool tagId})
    >;
typedef $$PerspectivesTableCreateCompanionBuilder =
    PerspectivesCompanion Function({
      Value<int> id,
      required String name,
      required int ownerId,
      Value<bool> isSystem,
      Value<String> dimensionFilters,
      Value<String> accountAttributeFilters,
      Value<String> tagFilters,
      Value<String> recordingDirection,
      Value<String?> baseCurrency,
      Value<String> permissionLevel,
    });
typedef $$PerspectivesTableUpdateCompanionBuilder =
    PerspectivesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> ownerId,
      Value<bool> isSystem,
      Value<String> dimensionFilters,
      Value<String> accountAttributeFilters,
      Value<String> tagFilters,
      Value<String> recordingDirection,
      Value<String?> baseCurrency,
      Value<String> permissionLevel,
    });

final class $$PerspectivesTableReferences
    extends BaseReferences<_$AppDatabase, $PerspectivesTable, Perspective> {
  $$PerspectivesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OwnersTable _ownerIdTable(_$AppDatabase db) => db.owners.createAlias(
    $_aliasNameGenerator(db.perspectives.ownerId, db.owners.id),
  );

  $$OwnersTableProcessedTableManager get ownerId {
    final $_column = $_itemColumn<int>('owner_id')!;

    final manager = $$OwnersTableTableManager(
      $_db,
      $_db.owners,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ownerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PerspectivesTableFilterComposer
    extends Composer<_$AppDatabase, $PerspectivesTable> {
  $$PerspectivesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dimensionFilters => $composableBuilder(
    column: $table.dimensionFilters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountAttributeFilters => $composableBuilder(
    column: $table.accountAttributeFilters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagFilters => $composableBuilder(
    column: $table.tagFilters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordingDirection => $composableBuilder(
    column: $table.recordingDirection,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get baseCurrency => $composableBuilder(
    column: $table.baseCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get permissionLevel => $composableBuilder(
    column: $table.permissionLevel,
    builder: (column) => ColumnFilters(column),
  );

  $$OwnersTableFilterComposer get ownerId {
    final $$OwnersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerId,
      referencedTable: $db.owners,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OwnersTableFilterComposer(
            $db: $db,
            $table: $db.owners,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PerspectivesTableOrderingComposer
    extends Composer<_$AppDatabase, $PerspectivesTable> {
  $$PerspectivesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dimensionFilters => $composableBuilder(
    column: $table.dimensionFilters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountAttributeFilters => $composableBuilder(
    column: $table.accountAttributeFilters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagFilters => $composableBuilder(
    column: $table.tagFilters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordingDirection => $composableBuilder(
    column: $table.recordingDirection,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get baseCurrency => $composableBuilder(
    column: $table.baseCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get permissionLevel => $composableBuilder(
    column: $table.permissionLevel,
    builder: (column) => ColumnOrderings(column),
  );

  $$OwnersTableOrderingComposer get ownerId {
    final $$OwnersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerId,
      referencedTable: $db.owners,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OwnersTableOrderingComposer(
            $db: $db,
            $table: $db.owners,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PerspectivesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PerspectivesTable> {
  $$PerspectivesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);

  GeneratedColumn<String> get dimensionFilters => $composableBuilder(
    column: $table.dimensionFilters,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountAttributeFilters => $composableBuilder(
    column: $table.accountAttributeFilters,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tagFilters => $composableBuilder(
    column: $table.tagFilters,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordingDirection => $composableBuilder(
    column: $table.recordingDirection,
    builder: (column) => column,
  );

  GeneratedColumn<String> get baseCurrency => $composableBuilder(
    column: $table.baseCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<String> get permissionLevel => $composableBuilder(
    column: $table.permissionLevel,
    builder: (column) => column,
  );

  $$OwnersTableAnnotationComposer get ownerId {
    final $$OwnersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerId,
      referencedTable: $db.owners,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OwnersTableAnnotationComposer(
            $db: $db,
            $table: $db.owners,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PerspectivesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PerspectivesTable,
          Perspective,
          $$PerspectivesTableFilterComposer,
          $$PerspectivesTableOrderingComposer,
          $$PerspectivesTableAnnotationComposer,
          $$PerspectivesTableCreateCompanionBuilder,
          $$PerspectivesTableUpdateCompanionBuilder,
          (Perspective, $$PerspectivesTableReferences),
          Perspective,
          PrefetchHooks Function({bool ownerId})
        > {
  $$PerspectivesTableTableManager(_$AppDatabase db, $PerspectivesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$PerspectivesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$PerspectivesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$PerspectivesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> ownerId = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
                Value<String> dimensionFilters = const Value.absent(),
                Value<String> accountAttributeFilters = const Value.absent(),
                Value<String> tagFilters = const Value.absent(),
                Value<String> recordingDirection = const Value.absent(),
                Value<String?> baseCurrency = const Value.absent(),
                Value<String> permissionLevel = const Value.absent(),
              }) => PerspectivesCompanion(
                id: id,
                name: name,
                ownerId: ownerId,
                isSystem: isSystem,
                dimensionFilters: dimensionFilters,
                accountAttributeFilters: accountAttributeFilters,
                tagFilters: tagFilters,
                recordingDirection: recordingDirection,
                baseCurrency: baseCurrency,
                permissionLevel: permissionLevel,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int ownerId,
                Value<bool> isSystem = const Value.absent(),
                Value<String> dimensionFilters = const Value.absent(),
                Value<String> accountAttributeFilters = const Value.absent(),
                Value<String> tagFilters = const Value.absent(),
                Value<String> recordingDirection = const Value.absent(),
                Value<String?> baseCurrency = const Value.absent(),
                Value<String> permissionLevel = const Value.absent(),
              }) => PerspectivesCompanion.insert(
                id: id,
                name: name,
                ownerId: ownerId,
                isSystem: isSystem,
                dimensionFilters: dimensionFilters,
                accountAttributeFilters: accountAttributeFilters,
                tagFilters: tagFilters,
                recordingDirection: recordingDirection,
                baseCurrency: baseCurrency,
                permissionLevel: permissionLevel,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$PerspectivesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({ownerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (ownerId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.ownerId,
                            referencedTable: $$PerspectivesTableReferences
                                ._ownerIdTable(db),
                            referencedColumn:
                                $$PerspectivesTableReferences
                                    ._ownerIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PerspectivesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PerspectivesTable,
      Perspective,
      $$PerspectivesTableFilterComposer,
      $$PerspectivesTableOrderingComposer,
      $$PerspectivesTableAnnotationComposer,
      $$PerspectivesTableCreateCompanionBuilder,
      $$PerspectivesTableUpdateCompanionBuilder,
      (Perspective, $$PerspectivesTableReferences),
      Perspective,
      PrefetchHooks Function({bool ownerId})
    >;
typedef $$ExchangeRatesTableCreateCompanionBuilder =
    ExchangeRatesCompanion Function({
      Value<int> id,
      required String fromCurrency,
      required String toCurrency,
      required int rate,
      required DateTime effectiveDate,
      required String source,
      Value<String> purpose,
    });
typedef $$ExchangeRatesTableUpdateCompanionBuilder =
    ExchangeRatesCompanion Function({
      Value<int> id,
      Value<String> fromCurrency,
      Value<String> toCurrency,
      Value<int> rate,
      Value<DateTime> effectiveDate,
      Value<String> source,
      Value<String> purpose,
    });

class $$ExchangeRatesTableFilterComposer
    extends Composer<_$AppDatabase, $ExchangeRatesTable> {
  $$ExchangeRatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromCurrency => $composableBuilder(
    column: $table.fromCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toCurrency => $composableBuilder(
    column: $table.toCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get effectiveDate => $composableBuilder(
    column: $table.effectiveDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purpose => $composableBuilder(
    column: $table.purpose,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExchangeRatesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExchangeRatesTable> {
  $$ExchangeRatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromCurrency => $composableBuilder(
    column: $table.fromCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toCurrency => $composableBuilder(
    column: $table.toCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get effectiveDate => $composableBuilder(
    column: $table.effectiveDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purpose => $composableBuilder(
    column: $table.purpose,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExchangeRatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExchangeRatesTable> {
  $$ExchangeRatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fromCurrency => $composableBuilder(
    column: $table.fromCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<String> get toCurrency => $composableBuilder(
    column: $table.toCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);

  GeneratedColumn<DateTime> get effectiveDate => $composableBuilder(
    column: $table.effectiveDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get purpose =>
      $composableBuilder(column: $table.purpose, builder: (column) => column);
}

class $$ExchangeRatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExchangeRatesTable,
          ExchangeRate,
          $$ExchangeRatesTableFilterComposer,
          $$ExchangeRatesTableOrderingComposer,
          $$ExchangeRatesTableAnnotationComposer,
          $$ExchangeRatesTableCreateCompanionBuilder,
          $$ExchangeRatesTableUpdateCompanionBuilder,
          (
            ExchangeRate,
            BaseReferences<_$AppDatabase, $ExchangeRatesTable, ExchangeRate>,
          ),
          ExchangeRate,
          PrefetchHooks Function()
        > {
  $$ExchangeRatesTableTableManager(_$AppDatabase db, $ExchangeRatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ExchangeRatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$ExchangeRatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ExchangeRatesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> fromCurrency = const Value.absent(),
                Value<String> toCurrency = const Value.absent(),
                Value<int> rate = const Value.absent(),
                Value<DateTime> effectiveDate = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> purpose = const Value.absent(),
              }) => ExchangeRatesCompanion(
                id: id,
                fromCurrency: fromCurrency,
                toCurrency: toCurrency,
                rate: rate,
                effectiveDate: effectiveDate,
                source: source,
                purpose: purpose,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String fromCurrency,
                required String toCurrency,
                required int rate,
                required DateTime effectiveDate,
                required String source,
                Value<String> purpose = const Value.absent(),
              }) => ExchangeRatesCompanion.insert(
                id: id,
                fromCurrency: fromCurrency,
                toCurrency: toCurrency,
                rate: rate,
                effectiveDate: effectiveDate,
                source: source,
                purpose: purpose,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExchangeRatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExchangeRatesTable,
      ExchangeRate,
      $$ExchangeRatesTableFilterComposer,
      $$ExchangeRatesTableOrderingComposer,
      $$ExchangeRatesTableAnnotationComposer,
      $$ExchangeRatesTableCreateCompanionBuilder,
      $$ExchangeRatesTableUpdateCompanionBuilder,
      (
        ExchangeRate,
        BaseReferences<_$AppDatabase, $ExchangeRatesTable, ExchangeRate>,
      ),
      ExchangeRate,
      PrefetchHooks Function()
    >;
typedef $$LegalParametersTableCreateCompanionBuilder =
    LegalParametersCompanion Function({
      Value<int> id,
      Value<String> countryCode,
      required String domain,
      required String key,
      required String paramType,
      Value<String?> value,
      Value<String?> tableData,
      Value<String?> formula,
      Value<String?> inputVariables,
      required DateTime effectiveFrom,
      Value<DateTime?> effectiveTo,
      required String applicationBasis,
      Value<bool> retroactive,
      Value<String?> sourceLaw,
      Value<String?> conditions,
    });
typedef $$LegalParametersTableUpdateCompanionBuilder =
    LegalParametersCompanion Function({
      Value<int> id,
      Value<String> countryCode,
      Value<String> domain,
      Value<String> key,
      Value<String> paramType,
      Value<String?> value,
      Value<String?> tableData,
      Value<String?> formula,
      Value<String?> inputVariables,
      Value<DateTime> effectiveFrom,
      Value<DateTime?> effectiveTo,
      Value<String> applicationBasis,
      Value<bool> retroactive,
      Value<String?> sourceLaw,
      Value<String?> conditions,
    });

class $$LegalParametersTableFilterComposer
    extends Composer<_$AppDatabase, $LegalParametersTable> {
  $$LegalParametersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get domain => $composableBuilder(
    column: $table.domain,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paramType => $composableBuilder(
    column: $table.paramType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tableData => $composableBuilder(
    column: $table.tableData,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get formula => $composableBuilder(
    column: $table.formula,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get inputVariables => $composableBuilder(
    column: $table.inputVariables,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get effectiveFrom => $composableBuilder(
    column: $table.effectiveFrom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get effectiveTo => $composableBuilder(
    column: $table.effectiveTo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get applicationBasis => $composableBuilder(
    column: $table.applicationBasis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get retroactive => $composableBuilder(
    column: $table.retroactive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceLaw => $composableBuilder(
    column: $table.sourceLaw,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conditions => $composableBuilder(
    column: $table.conditions,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LegalParametersTableOrderingComposer
    extends Composer<_$AppDatabase, $LegalParametersTable> {
  $$LegalParametersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get domain => $composableBuilder(
    column: $table.domain,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paramType => $composableBuilder(
    column: $table.paramType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tableData => $composableBuilder(
    column: $table.tableData,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get formula => $composableBuilder(
    column: $table.formula,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inputVariables => $composableBuilder(
    column: $table.inputVariables,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get effectiveFrom => $composableBuilder(
    column: $table.effectiveFrom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get effectiveTo => $composableBuilder(
    column: $table.effectiveTo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get applicationBasis => $composableBuilder(
    column: $table.applicationBasis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get retroactive => $composableBuilder(
    column: $table.retroactive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceLaw => $composableBuilder(
    column: $table.sourceLaw,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conditions => $composableBuilder(
    column: $table.conditions,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LegalParametersTableAnnotationComposer
    extends Composer<_$AppDatabase, $LegalParametersTable> {
  $$LegalParametersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get domain =>
      $composableBuilder(column: $table.domain, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get paramType =>
      $composableBuilder(column: $table.paramType, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get tableData =>
      $composableBuilder(column: $table.tableData, builder: (column) => column);

  GeneratedColumn<String> get formula =>
      $composableBuilder(column: $table.formula, builder: (column) => column);

  GeneratedColumn<String> get inputVariables => $composableBuilder(
    column: $table.inputVariables,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get effectiveFrom => $composableBuilder(
    column: $table.effectiveFrom,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get effectiveTo => $composableBuilder(
    column: $table.effectiveTo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get applicationBasis => $composableBuilder(
    column: $table.applicationBasis,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get retroactive => $composableBuilder(
    column: $table.retroactive,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceLaw =>
      $composableBuilder(column: $table.sourceLaw, builder: (column) => column);

  GeneratedColumn<String> get conditions => $composableBuilder(
    column: $table.conditions,
    builder: (column) => column,
  );
}

class $$LegalParametersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LegalParametersTable,
          LegalParameter,
          $$LegalParametersTableFilterComposer,
          $$LegalParametersTableOrderingComposer,
          $$LegalParametersTableAnnotationComposer,
          $$LegalParametersTableCreateCompanionBuilder,
          $$LegalParametersTableUpdateCompanionBuilder,
          (
            LegalParameter,
            BaseReferences<
              _$AppDatabase,
              $LegalParametersTable,
              LegalParameter
            >,
          ),
          LegalParameter,
          PrefetchHooks Function()
        > {
  $$LegalParametersTableTableManager(
    _$AppDatabase db,
    $LegalParametersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$LegalParametersTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$LegalParametersTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$LegalParametersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> countryCode = const Value.absent(),
                Value<String> domain = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<String> paramType = const Value.absent(),
                Value<String?> value = const Value.absent(),
                Value<String?> tableData = const Value.absent(),
                Value<String?> formula = const Value.absent(),
                Value<String?> inputVariables = const Value.absent(),
                Value<DateTime> effectiveFrom = const Value.absent(),
                Value<DateTime?> effectiveTo = const Value.absent(),
                Value<String> applicationBasis = const Value.absent(),
                Value<bool> retroactive = const Value.absent(),
                Value<String?> sourceLaw = const Value.absent(),
                Value<String?> conditions = const Value.absent(),
              }) => LegalParametersCompanion(
                id: id,
                countryCode: countryCode,
                domain: domain,
                key: key,
                paramType: paramType,
                value: value,
                tableData: tableData,
                formula: formula,
                inputVariables: inputVariables,
                effectiveFrom: effectiveFrom,
                effectiveTo: effectiveTo,
                applicationBasis: applicationBasis,
                retroactive: retroactive,
                sourceLaw: sourceLaw,
                conditions: conditions,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> countryCode = const Value.absent(),
                required String domain,
                required String key,
                required String paramType,
                Value<String?> value = const Value.absent(),
                Value<String?> tableData = const Value.absent(),
                Value<String?> formula = const Value.absent(),
                Value<String?> inputVariables = const Value.absent(),
                required DateTime effectiveFrom,
                Value<DateTime?> effectiveTo = const Value.absent(),
                required String applicationBasis,
                Value<bool> retroactive = const Value.absent(),
                Value<String?> sourceLaw = const Value.absent(),
                Value<String?> conditions = const Value.absent(),
              }) => LegalParametersCompanion.insert(
                id: id,
                countryCode: countryCode,
                domain: domain,
                key: key,
                paramType: paramType,
                value: value,
                tableData: tableData,
                formula: formula,
                inputVariables: inputVariables,
                effectiveFrom: effectiveFrom,
                effectiveTo: effectiveTo,
                applicationBasis: applicationBasis,
                retroactive: retroactive,
                sourceLaw: sourceLaw,
                conditions: conditions,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LegalParametersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LegalParametersTable,
      LegalParameter,
      $$LegalParametersTableFilterComposer,
      $$LegalParametersTableOrderingComposer,
      $$LegalParametersTableAnnotationComposer,
      $$LegalParametersTableCreateCompanionBuilder,
      $$LegalParametersTableUpdateCompanionBuilder,
      (
        LegalParameter,
        BaseReferences<_$AppDatabase, $LegalParametersTable, LegalParameter>,
      ),
      LegalParameter,
      PrefetchHooks Function()
    >;
typedef $$ClassificationRulesTableCreateCompanionBuilder =
    ClassificationRulesCompanion Function({
      Value<int> id,
      required String pattern,
      required String patternType,
      required int accountId,
      Value<int?> counterpartyId,
      Value<int> priority,
      Value<bool> isSystemRule,
      Value<bool> isUserRule,
    });
typedef $$ClassificationRulesTableUpdateCompanionBuilder =
    ClassificationRulesCompanion Function({
      Value<int> id,
      Value<String> pattern,
      Value<String> patternType,
      Value<int> accountId,
      Value<int?> counterpartyId,
      Value<int> priority,
      Value<bool> isSystemRule,
      Value<bool> isUserRule,
    });

final class $$ClassificationRulesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ClassificationRulesTable,
          ClassificationRule
        > {
  $$ClassificationRulesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias(
        $_aliasNameGenerator(db.classificationRules.accountId, db.accounts.id),
      );

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CounterpartiesTable _counterpartyIdTable(_$AppDatabase db) =>
      db.counterparties.createAlias(
        $_aliasNameGenerator(
          db.classificationRules.counterpartyId,
          db.counterparties.id,
        ),
      );

  $$CounterpartiesTableProcessedTableManager? get counterpartyId {
    final $_column = $_itemColumn<int>('counterparty_id');
    if ($_column == null) return null;
    final manager = $$CounterpartiesTableTableManager(
      $_db,
      $_db.counterparties,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_counterpartyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ClassificationRulesTableFilterComposer
    extends Composer<_$AppDatabase, $ClassificationRulesTable> {
  $$ClassificationRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pattern => $composableBuilder(
    column: $table.pattern,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get patternType => $composableBuilder(
    column: $table.patternType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSystemRule => $composableBuilder(
    column: $table.isSystemRule,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isUserRule => $composableBuilder(
    column: $table.isUserRule,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CounterpartiesTableFilterComposer get counterpartyId {
    final $$CounterpartiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.counterpartyId,
      referencedTable: $db.counterparties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CounterpartiesTableFilterComposer(
            $db: $db,
            $table: $db.counterparties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClassificationRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $ClassificationRulesTable> {
  $$ClassificationRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pattern => $composableBuilder(
    column: $table.pattern,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get patternType => $composableBuilder(
    column: $table.patternType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSystemRule => $composableBuilder(
    column: $table.isSystemRule,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isUserRule => $composableBuilder(
    column: $table.isUserRule,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CounterpartiesTableOrderingComposer get counterpartyId {
    final $$CounterpartiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.counterpartyId,
      referencedTable: $db.counterparties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CounterpartiesTableOrderingComposer(
            $db: $db,
            $table: $db.counterparties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClassificationRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClassificationRulesTable> {
  $$ClassificationRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get pattern =>
      $composableBuilder(column: $table.pattern, builder: (column) => column);

  GeneratedColumn<String> get patternType => $composableBuilder(
    column: $table.patternType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<bool> get isSystemRule => $composableBuilder(
    column: $table.isSystemRule,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isUserRule => $composableBuilder(
    column: $table.isUserRule,
    builder: (column) => column,
  );

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CounterpartiesTableAnnotationComposer get counterpartyId {
    final $$CounterpartiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.counterpartyId,
      referencedTable: $db.counterparties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CounterpartiesTableAnnotationComposer(
            $db: $db,
            $table: $db.counterparties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClassificationRulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClassificationRulesTable,
          ClassificationRule,
          $$ClassificationRulesTableFilterComposer,
          $$ClassificationRulesTableOrderingComposer,
          $$ClassificationRulesTableAnnotationComposer,
          $$ClassificationRulesTableCreateCompanionBuilder,
          $$ClassificationRulesTableUpdateCompanionBuilder,
          (ClassificationRule, $$ClassificationRulesTableReferences),
          ClassificationRule,
          PrefetchHooks Function({bool accountId, bool counterpartyId})
        > {
  $$ClassificationRulesTableTableManager(
    _$AppDatabase db,
    $ClassificationRulesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ClassificationRulesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$ClassificationRulesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$ClassificationRulesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> pattern = const Value.absent(),
                Value<String> patternType = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<int?> counterpartyId = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<bool> isSystemRule = const Value.absent(),
                Value<bool> isUserRule = const Value.absent(),
              }) => ClassificationRulesCompanion(
                id: id,
                pattern: pattern,
                patternType: patternType,
                accountId: accountId,
                counterpartyId: counterpartyId,
                priority: priority,
                isSystemRule: isSystemRule,
                isUserRule: isUserRule,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String pattern,
                required String patternType,
                required int accountId,
                Value<int?> counterpartyId = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<bool> isSystemRule = const Value.absent(),
                Value<bool> isUserRule = const Value.absent(),
              }) => ClassificationRulesCompanion.insert(
                id: id,
                pattern: pattern,
                patternType: patternType,
                accountId: accountId,
                counterpartyId: counterpartyId,
                priority: priority,
                isSystemRule: isSystemRule,
                isUserRule: isUserRule,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$ClassificationRulesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({accountId = false, counterpartyId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (accountId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.accountId,
                            referencedTable:
                                $$ClassificationRulesTableReferences
                                    ._accountIdTable(db),
                            referencedColumn:
                                $$ClassificationRulesTableReferences
                                    ._accountIdTable(db)
                                    .id,
                          )
                          as T;
                }
                if (counterpartyId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.counterpartyId,
                            referencedTable:
                                $$ClassificationRulesTableReferences
                                    ._counterpartyIdTable(db),
                            referencedColumn:
                                $$ClassificationRulesTableReferences
                                    ._counterpartyIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ClassificationRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClassificationRulesTable,
      ClassificationRule,
      $$ClassificationRulesTableFilterComposer,
      $$ClassificationRulesTableOrderingComposer,
      $$ClassificationRulesTableAnnotationComposer,
      $$ClassificationRulesTableCreateCompanionBuilder,
      $$ClassificationRulesTableUpdateCompanionBuilder,
      (ClassificationRule, $$ClassificationRulesTableReferences),
      ClassificationRule,
      PrefetchHooks Function({bool accountId, bool counterpartyId})
    >;
typedef $$FiscalPeriodsTableCreateCompanionBuilder =
    FiscalPeriodsCompanion Function({
      Value<int> id,
      required String name,
      required DateTime startDate,
      required DateTime endDate,
      Value<bool> isClosed,
    });
typedef $$FiscalPeriodsTableUpdateCompanionBuilder =
    FiscalPeriodsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<bool> isClosed,
    });

class $$FiscalPeriodsTableFilterComposer
    extends Composer<_$AppDatabase, $FiscalPeriodsTable> {
  $$FiscalPeriodsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isClosed => $composableBuilder(
    column: $table.isClosed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FiscalPeriodsTableOrderingComposer
    extends Composer<_$AppDatabase, $FiscalPeriodsTable> {
  $$FiscalPeriodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isClosed => $composableBuilder(
    column: $table.isClosed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FiscalPeriodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FiscalPeriodsTable> {
  $$FiscalPeriodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<bool> get isClosed =>
      $composableBuilder(column: $table.isClosed, builder: (column) => column);
}

class $$FiscalPeriodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FiscalPeriodsTable,
          FiscalPeriod,
          $$FiscalPeriodsTableFilterComposer,
          $$FiscalPeriodsTableOrderingComposer,
          $$FiscalPeriodsTableAnnotationComposer,
          $$FiscalPeriodsTableCreateCompanionBuilder,
          $$FiscalPeriodsTableUpdateCompanionBuilder,
          (
            FiscalPeriod,
            BaseReferences<_$AppDatabase, $FiscalPeriodsTable, FiscalPeriod>,
          ),
          FiscalPeriod,
          PrefetchHooks Function()
        > {
  $$FiscalPeriodsTableTableManager(_$AppDatabase db, $FiscalPeriodsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$FiscalPeriodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$FiscalPeriodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$FiscalPeriodsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<bool> isClosed = const Value.absent(),
              }) => FiscalPeriodsCompanion(
                id: id,
                name: name,
                startDate: startDate,
                endDate: endDate,
                isClosed: isClosed,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required DateTime startDate,
                required DateTime endDate,
                Value<bool> isClosed = const Value.absent(),
              }) => FiscalPeriodsCompanion.insert(
                id: id,
                name: name,
                startDate: startDate,
                endDate: endDate,
                isClosed: isClosed,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FiscalPeriodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FiscalPeriodsTable,
      FiscalPeriod,
      $$FiscalPeriodsTableFilterComposer,
      $$FiscalPeriodsTableOrderingComposer,
      $$FiscalPeriodsTableAnnotationComposer,
      $$FiscalPeriodsTableCreateCompanionBuilder,
      $$FiscalPeriodsTableUpdateCompanionBuilder,
      (
        FiscalPeriod,
        BaseReferences<_$AppDatabase, $FiscalPeriodsTable, FiscalPeriod>,
      ),
      FiscalPeriod,
      PrefetchHooks Function()
    >;
typedef $$OutboxEntriesTableCreateCompanionBuilder =
    OutboxEntriesCompanion Function({
      Value<int> id,
      required String entityType,
      required int entityId,
      required String operation,
      required String payload,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime?> attemptedAt,
      Value<int> attemptCount,
      Value<String?> errorMessage,
      Value<String?> serverResponse,
    });
typedef $$OutboxEntriesTableUpdateCompanionBuilder =
    OutboxEntriesCompanion Function({
      Value<int> id,
      Value<String> entityType,
      Value<int> entityId,
      Value<String> operation,
      Value<String> payload,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime?> attemptedAt,
      Value<int> attemptCount,
      Value<String?> errorMessage,
      Value<String?> serverResponse,
    });

class $$OutboxEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $OutboxEntriesTable> {
  $$OutboxEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get attemptedAt => $composableBuilder(
    column: $table.attemptedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverResponse => $composableBuilder(
    column: $table.serverResponse,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutboxEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $OutboxEntriesTable> {
  $$OutboxEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get attemptedAt => $composableBuilder(
    column: $table.attemptedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverResponse => $composableBuilder(
    column: $table.serverResponse,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutboxEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutboxEntriesTable> {
  $$OutboxEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get attemptedAt => $composableBuilder(
    column: $table.attemptedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serverResponse => $composableBuilder(
    column: $table.serverResponse,
    builder: (column) => column,
  );
}

class $$OutboxEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutboxEntriesTable,
          OutboxEntry,
          $$OutboxEntriesTableFilterComposer,
          $$OutboxEntriesTableOrderingComposer,
          $$OutboxEntriesTableAnnotationComposer,
          $$OutboxEntriesTableCreateCompanionBuilder,
          $$OutboxEntriesTableUpdateCompanionBuilder,
          (
            OutboxEntry,
            BaseReferences<_$AppDatabase, $OutboxEntriesTable, OutboxEntry>,
          ),
          OutboxEntry,
          PrefetchHooks Function()
        > {
  $$OutboxEntriesTableTableManager(_$AppDatabase db, $OutboxEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$OutboxEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$OutboxEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$OutboxEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<int> entityId = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> attemptedAt = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<String?> serverResponse = const Value.absent(),
              }) => OutboxEntriesCompanion(
                id: id,
                entityType: entityType,
                entityId: entityId,
                operation: operation,
                payload: payload,
                status: status,
                createdAt: createdAt,
                attemptedAt: attemptedAt,
                attemptCount: attemptCount,
                errorMessage: errorMessage,
                serverResponse: serverResponse,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String entityType,
                required int entityId,
                required String operation,
                required String payload,
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> attemptedAt = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<String?> serverResponse = const Value.absent(),
              }) => OutboxEntriesCompanion.insert(
                id: id,
                entityType: entityType,
                entityId: entityId,
                operation: operation,
                payload: payload,
                status: status,
                createdAt: createdAt,
                attemptedAt: attemptedAt,
                attemptCount: attemptCount,
                errorMessage: errorMessage,
                serverResponse: serverResponse,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutboxEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutboxEntriesTable,
      OutboxEntry,
      $$OutboxEntriesTableFilterComposer,
      $$OutboxEntriesTableOrderingComposer,
      $$OutboxEntriesTableAnnotationComposer,
      $$OutboxEntriesTableCreateCompanionBuilder,
      $$OutboxEntriesTableUpdateCompanionBuilder,
      (
        OutboxEntry,
        BaseReferences<_$AppDatabase, $OutboxEntriesTable, OutboxEntry>,
      ),
      OutboxEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DimensionValuesTableTableManager get dimensionValues =>
      $$DimensionValuesTableTableManager(_db, _db.dimensionValues);
  $$OwnersTableTableManager get owners =>
      $$OwnersTableTableManager(_db, _db.owners);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$AccountOwnerSharesTableTableManager get accountOwnerShares =>
      $$AccountOwnerSharesTableTableManager(_db, _db.accountOwnerShares);
  $$CounterpartiesTableTableManager get counterparties =>
      $$CounterpartiesTableTableManager(_db, _db.counterparties);
  $$CounterpartyAliasesTableTableManager get counterpartyAliases =>
      $$CounterpartyAliasesTableTableManager(_db, _db.counterpartyAliases);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$JournalEntryLinesTableTableManager get journalEntryLines =>
      $$JournalEntryLinesTableTableManager(_db, _db.journalEntryLines);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$TransactionTagsTableTableManager get transactionTags =>
      $$TransactionTagsTableTableManager(_db, _db.transactionTags);
  $$PerspectivesTableTableManager get perspectives =>
      $$PerspectivesTableTableManager(_db, _db.perspectives);
  $$ExchangeRatesTableTableManager get exchangeRates =>
      $$ExchangeRatesTableTableManager(_db, _db.exchangeRates);
  $$LegalParametersTableTableManager get legalParameters =>
      $$LegalParametersTableTableManager(_db, _db.legalParameters);
  $$ClassificationRulesTableTableManager get classificationRules =>
      $$ClassificationRulesTableTableManager(_db, _db.classificationRules);
  $$FiscalPeriodsTableTableManager get fiscalPeriods =>
      $$FiscalPeriodsTableTableManager(_db, _db.fiscalPeriods);
  $$OutboxEntriesTableTableManager get outboxEntries =>
      $$OutboxEntriesTableTableManager(_db, _db.outboxEntries);
}
