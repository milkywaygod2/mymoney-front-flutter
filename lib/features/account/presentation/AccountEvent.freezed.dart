// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'AccountEvent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AccountEvent()';
}


}

/// @nodoc
class $AccountEventCopyWith<$Res>  {
$AccountEventCopyWith(AccountEvent _, $Res Function(AccountEvent) __);
}


/// Adds pattern-matching-related methods to [AccountEvent].
extension AccountEventPatterns on AccountEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadAccountTree value)?  loadTree,TResult Function( CreateAccount value)?  createAccount,TResult Function( DeactivateAccount value)?  deactivateAccount,TResult Function( ExpandNode value)?  expandNode,TResult Function( CollapseNode value)?  collapseNode,TResult Function( SearchAccounts value)?  searchAccounts,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadAccountTree() when loadTree != null:
return loadTree(_that);case CreateAccount() when createAccount != null:
return createAccount(_that);case DeactivateAccount() when deactivateAccount != null:
return deactivateAccount(_that);case ExpandNode() when expandNode != null:
return expandNode(_that);case CollapseNode() when collapseNode != null:
return collapseNode(_that);case SearchAccounts() when searchAccounts != null:
return searchAccounts(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadAccountTree value)  loadTree,required TResult Function( CreateAccount value)  createAccount,required TResult Function( DeactivateAccount value)  deactivateAccount,required TResult Function( ExpandNode value)  expandNode,required TResult Function( CollapseNode value)  collapseNode,required TResult Function( SearchAccounts value)  searchAccounts,}){
final _that = this;
switch (_that) {
case LoadAccountTree():
return loadTree(_that);case CreateAccount():
return createAccount(_that);case DeactivateAccount():
return deactivateAccount(_that);case ExpandNode():
return expandNode(_that);case CollapseNode():
return collapseNode(_that);case SearchAccounts():
return searchAccounts(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadAccountTree value)?  loadTree,TResult? Function( CreateAccount value)?  createAccount,TResult? Function( DeactivateAccount value)?  deactivateAccount,TResult? Function( ExpandNode value)?  expandNode,TResult? Function( CollapseNode value)?  collapseNode,TResult? Function( SearchAccounts value)?  searchAccounts,}){
final _that = this;
switch (_that) {
case LoadAccountTree() when loadTree != null:
return loadTree(_that);case CreateAccount() when createAccount != null:
return createAccount(_that);case DeactivateAccount() when deactivateAccount != null:
return deactivateAccount(_that);case ExpandNode() when expandNode != null:
return expandNode(_that);case CollapseNode() when collapseNode != null:
return collapseNode(_that);case SearchAccounts() when searchAccounts != null:
return searchAccounts(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loadTree,TResult Function( String name,  AccountNature nature,  DimensionValueId equityTypeId,  String equityTypePath,  DimensionValueId liquidityId,  String liquidityPath,  DimensionValueId assetTypeId,  String assetTypePath,  OwnerId ownerId,  DimensionValueId? defaultActivityTypeId,  DimensionValueId? defaultIncomeTypeId,  String? productType,  String? financialInstitution)?  createAccount,TResult Function( AccountId id)?  deactivateAccount,TResult Function( AccountId id)?  expandNode,TResult Function( AccountId id)?  collapseNode,TResult Function( String query)?  searchAccounts,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadAccountTree() when loadTree != null:
return loadTree();case CreateAccount() when createAccount != null:
return createAccount(_that.name,_that.nature,_that.equityTypeId,_that.equityTypePath,_that.liquidityId,_that.liquidityPath,_that.assetTypeId,_that.assetTypePath,_that.ownerId,_that.defaultActivityTypeId,_that.defaultIncomeTypeId,_that.productType,_that.financialInstitution);case DeactivateAccount() when deactivateAccount != null:
return deactivateAccount(_that.id);case ExpandNode() when expandNode != null:
return expandNode(_that.id);case CollapseNode() when collapseNode != null:
return collapseNode(_that.id);case SearchAccounts() when searchAccounts != null:
return searchAccounts(_that.query);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loadTree,required TResult Function( String name,  AccountNature nature,  DimensionValueId equityTypeId,  String equityTypePath,  DimensionValueId liquidityId,  String liquidityPath,  DimensionValueId assetTypeId,  String assetTypePath,  OwnerId ownerId,  DimensionValueId? defaultActivityTypeId,  DimensionValueId? defaultIncomeTypeId,  String? productType,  String? financialInstitution)  createAccount,required TResult Function( AccountId id)  deactivateAccount,required TResult Function( AccountId id)  expandNode,required TResult Function( AccountId id)  collapseNode,required TResult Function( String query)  searchAccounts,}) {final _that = this;
switch (_that) {
case LoadAccountTree():
return loadTree();case CreateAccount():
return createAccount(_that.name,_that.nature,_that.equityTypeId,_that.equityTypePath,_that.liquidityId,_that.liquidityPath,_that.assetTypeId,_that.assetTypePath,_that.ownerId,_that.defaultActivityTypeId,_that.defaultIncomeTypeId,_that.productType,_that.financialInstitution);case DeactivateAccount():
return deactivateAccount(_that.id);case ExpandNode():
return expandNode(_that.id);case CollapseNode():
return collapseNode(_that.id);case SearchAccounts():
return searchAccounts(_that.query);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loadTree,TResult? Function( String name,  AccountNature nature,  DimensionValueId equityTypeId,  String equityTypePath,  DimensionValueId liquidityId,  String liquidityPath,  DimensionValueId assetTypeId,  String assetTypePath,  OwnerId ownerId,  DimensionValueId? defaultActivityTypeId,  DimensionValueId? defaultIncomeTypeId,  String? productType,  String? financialInstitution)?  createAccount,TResult? Function( AccountId id)?  deactivateAccount,TResult? Function( AccountId id)?  expandNode,TResult? Function( AccountId id)?  collapseNode,TResult? Function( String query)?  searchAccounts,}) {final _that = this;
switch (_that) {
case LoadAccountTree() when loadTree != null:
return loadTree();case CreateAccount() when createAccount != null:
return createAccount(_that.name,_that.nature,_that.equityTypeId,_that.equityTypePath,_that.liquidityId,_that.liquidityPath,_that.assetTypeId,_that.assetTypePath,_that.ownerId,_that.defaultActivityTypeId,_that.defaultIncomeTypeId,_that.productType,_that.financialInstitution);case DeactivateAccount() when deactivateAccount != null:
return deactivateAccount(_that.id);case ExpandNode() when expandNode != null:
return expandNode(_that.id);case CollapseNode() when collapseNode != null:
return collapseNode(_that.id);case SearchAccounts() when searchAccounts != null:
return searchAccounts(_that.query);case _:
  return null;

}
}

}

/// @nodoc


class LoadAccountTree implements AccountEvent {
  const LoadAccountTree();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadAccountTree);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AccountEvent.loadTree()';
}


}




/// @nodoc


class CreateAccount implements AccountEvent {
  const CreateAccount({required this.name, required this.nature, required this.equityTypeId, required this.equityTypePath, required this.liquidityId, required this.liquidityPath, required this.assetTypeId, required this.assetTypePath, required this.ownerId, this.defaultActivityTypeId, this.defaultIncomeTypeId, this.productType, this.financialInstitution});
  

 final  String name;
 final  AccountNature nature;
 final  DimensionValueId equityTypeId;
 final  String equityTypePath;
 final  DimensionValueId liquidityId;
 final  String liquidityPath;
 final  DimensionValueId assetTypeId;
 final  String assetTypePath;
 final  OwnerId ownerId;
 final  DimensionValueId? defaultActivityTypeId;
 final  DimensionValueId? defaultIncomeTypeId;
 final  String? productType;
 final  String? financialInstitution;

/// Create a copy of AccountEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateAccountCopyWith<CreateAccount> get copyWith => _$CreateAccountCopyWithImpl<CreateAccount>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateAccount&&(identical(other.name, name) || other.name == name)&&(identical(other.nature, nature) || other.nature == nature)&&(identical(other.equityTypeId, equityTypeId) || other.equityTypeId == equityTypeId)&&(identical(other.equityTypePath, equityTypePath) || other.equityTypePath == equityTypePath)&&(identical(other.liquidityId, liquidityId) || other.liquidityId == liquidityId)&&(identical(other.liquidityPath, liquidityPath) || other.liquidityPath == liquidityPath)&&(identical(other.assetTypeId, assetTypeId) || other.assetTypeId == assetTypeId)&&(identical(other.assetTypePath, assetTypePath) || other.assetTypePath == assetTypePath)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.defaultActivityTypeId, defaultActivityTypeId) || other.defaultActivityTypeId == defaultActivityTypeId)&&(identical(other.defaultIncomeTypeId, defaultIncomeTypeId) || other.defaultIncomeTypeId == defaultIncomeTypeId)&&(identical(other.productType, productType) || other.productType == productType)&&(identical(other.financialInstitution, financialInstitution) || other.financialInstitution == financialInstitution));
}


@override
int get hashCode => Object.hash(runtimeType,name,nature,equityTypeId,equityTypePath,liquidityId,liquidityPath,assetTypeId,assetTypePath,ownerId,defaultActivityTypeId,defaultIncomeTypeId,productType,financialInstitution);

@override
String toString() {
  return 'AccountEvent.createAccount(name: $name, nature: $nature, equityTypeId: $equityTypeId, equityTypePath: $equityTypePath, liquidityId: $liquidityId, liquidityPath: $liquidityPath, assetTypeId: $assetTypeId, assetTypePath: $assetTypePath, ownerId: $ownerId, defaultActivityTypeId: $defaultActivityTypeId, defaultIncomeTypeId: $defaultIncomeTypeId, productType: $productType, financialInstitution: $financialInstitution)';
}


}

/// @nodoc
abstract mixin class $CreateAccountCopyWith<$Res> implements $AccountEventCopyWith<$Res> {
  factory $CreateAccountCopyWith(CreateAccount value, $Res Function(CreateAccount) _then) = _$CreateAccountCopyWithImpl;
@useResult
$Res call({
 String name, AccountNature nature, DimensionValueId equityTypeId, String equityTypePath, DimensionValueId liquidityId, String liquidityPath, DimensionValueId assetTypeId, String assetTypePath, OwnerId ownerId, DimensionValueId? defaultActivityTypeId, DimensionValueId? defaultIncomeTypeId, String? productType, String? financialInstitution
});




}
/// @nodoc
class _$CreateAccountCopyWithImpl<$Res>
    implements $CreateAccountCopyWith<$Res> {
  _$CreateAccountCopyWithImpl(this._self, this._then);

  final CreateAccount _self;
  final $Res Function(CreateAccount) _then;

/// Create a copy of AccountEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,Object? nature = null,Object? equityTypeId = null,Object? equityTypePath = null,Object? liquidityId = null,Object? liquidityPath = null,Object? assetTypeId = null,Object? assetTypePath = null,Object? ownerId = null,Object? defaultActivityTypeId = freezed,Object? defaultIncomeTypeId = freezed,Object? productType = freezed,Object? financialInstitution = freezed,}) {
  return _then(CreateAccount(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nature: null == nature ? _self.nature : nature // ignore: cast_nullable_to_non_nullable
as AccountNature,equityTypeId: null == equityTypeId ? _self.equityTypeId : equityTypeId // ignore: cast_nullable_to_non_nullable
as DimensionValueId,equityTypePath: null == equityTypePath ? _self.equityTypePath : equityTypePath // ignore: cast_nullable_to_non_nullable
as String,liquidityId: null == liquidityId ? _self.liquidityId : liquidityId // ignore: cast_nullable_to_non_nullable
as DimensionValueId,liquidityPath: null == liquidityPath ? _self.liquidityPath : liquidityPath // ignore: cast_nullable_to_non_nullable
as String,assetTypeId: null == assetTypeId ? _self.assetTypeId : assetTypeId // ignore: cast_nullable_to_non_nullable
as DimensionValueId,assetTypePath: null == assetTypePath ? _self.assetTypePath : assetTypePath // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as OwnerId,defaultActivityTypeId: freezed == defaultActivityTypeId ? _self.defaultActivityTypeId : defaultActivityTypeId // ignore: cast_nullable_to_non_nullable
as DimensionValueId?,defaultIncomeTypeId: freezed == defaultIncomeTypeId ? _self.defaultIncomeTypeId : defaultIncomeTypeId // ignore: cast_nullable_to_non_nullable
as DimensionValueId?,productType: freezed == productType ? _self.productType : productType // ignore: cast_nullable_to_non_nullable
as String?,financialInstitution: freezed == financialInstitution ? _self.financialInstitution : financialInstitution // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class DeactivateAccount implements AccountEvent {
  const DeactivateAccount({required this.id});
  

 final  AccountId id;

/// Create a copy of AccountEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeactivateAccountCopyWith<DeactivateAccount> get copyWith => _$DeactivateAccountCopyWithImpl<DeactivateAccount>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeactivateAccount&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'AccountEvent.deactivateAccount(id: $id)';
}


}

/// @nodoc
abstract mixin class $DeactivateAccountCopyWith<$Res> implements $AccountEventCopyWith<$Res> {
  factory $DeactivateAccountCopyWith(DeactivateAccount value, $Res Function(DeactivateAccount) _then) = _$DeactivateAccountCopyWithImpl;
@useResult
$Res call({
 AccountId id
});




}
/// @nodoc
class _$DeactivateAccountCopyWithImpl<$Res>
    implements $DeactivateAccountCopyWith<$Res> {
  _$DeactivateAccountCopyWithImpl(this._self, this._then);

  final DeactivateAccount _self;
  final $Res Function(DeactivateAccount) _then;

/// Create a copy of AccountEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(DeactivateAccount(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as AccountId,
  ));
}


}

/// @nodoc


class ExpandNode implements AccountEvent {
  const ExpandNode({required this.id});
  

 final  AccountId id;

/// Create a copy of AccountEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpandNodeCopyWith<ExpandNode> get copyWith => _$ExpandNodeCopyWithImpl<ExpandNode>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpandNode&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'AccountEvent.expandNode(id: $id)';
}


}

/// @nodoc
abstract mixin class $ExpandNodeCopyWith<$Res> implements $AccountEventCopyWith<$Res> {
  factory $ExpandNodeCopyWith(ExpandNode value, $Res Function(ExpandNode) _then) = _$ExpandNodeCopyWithImpl;
@useResult
$Res call({
 AccountId id
});




}
/// @nodoc
class _$ExpandNodeCopyWithImpl<$Res>
    implements $ExpandNodeCopyWith<$Res> {
  _$ExpandNodeCopyWithImpl(this._self, this._then);

  final ExpandNode _self;
  final $Res Function(ExpandNode) _then;

/// Create a copy of AccountEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(ExpandNode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as AccountId,
  ));
}


}

/// @nodoc


class CollapseNode implements AccountEvent {
  const CollapseNode({required this.id});
  

 final  AccountId id;

/// Create a copy of AccountEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CollapseNodeCopyWith<CollapseNode> get copyWith => _$CollapseNodeCopyWithImpl<CollapseNode>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollapseNode&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'AccountEvent.collapseNode(id: $id)';
}


}

/// @nodoc
abstract mixin class $CollapseNodeCopyWith<$Res> implements $AccountEventCopyWith<$Res> {
  factory $CollapseNodeCopyWith(CollapseNode value, $Res Function(CollapseNode) _then) = _$CollapseNodeCopyWithImpl;
@useResult
$Res call({
 AccountId id
});




}
/// @nodoc
class _$CollapseNodeCopyWithImpl<$Res>
    implements $CollapseNodeCopyWith<$Res> {
  _$CollapseNodeCopyWithImpl(this._self, this._then);

  final CollapseNode _self;
  final $Res Function(CollapseNode) _then;

/// Create a copy of AccountEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(CollapseNode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as AccountId,
  ));
}


}

/// @nodoc


class SearchAccounts implements AccountEvent {
  const SearchAccounts({required this.query});
  

 final  String query;

/// Create a copy of AccountEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchAccountsCopyWith<SearchAccounts> get copyWith => _$SearchAccountsCopyWithImpl<SearchAccounts>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchAccounts&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,query);

@override
String toString() {
  return 'AccountEvent.searchAccounts(query: $query)';
}


}

/// @nodoc
abstract mixin class $SearchAccountsCopyWith<$Res> implements $AccountEventCopyWith<$Res> {
  factory $SearchAccountsCopyWith(SearchAccounts value, $Res Function(SearchAccounts) _then) = _$SearchAccountsCopyWithImpl;
@useResult
$Res call({
 String query
});




}
/// @nodoc
class _$SearchAccountsCopyWithImpl<$Res>
    implements $SearchAccountsCopyWith<$Res> {
  _$SearchAccountsCopyWithImpl(this._self, this._then);

  final SearchAccounts _self;
  final $Res Function(SearchAccounts) _then;

/// Create a copy of AccountEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(SearchAccounts(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
