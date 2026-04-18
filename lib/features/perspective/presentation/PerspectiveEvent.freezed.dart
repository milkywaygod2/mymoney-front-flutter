// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'PerspectiveEvent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PerspectiveEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PerspectiveEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PerspectiveEvent()';
}


}

/// @nodoc
class $PerspectiveEventCopyWith<$Res>  {
$PerspectiveEventCopyWith(PerspectiveEvent _, $Res Function(PerspectiveEvent) __);
}


/// Adds pattern-matching-related methods to [PerspectiveEvent].
extension PerspectiveEventPatterns on PerspectiveEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadPresets value)?  loadPresets,TResult Function( SelectPreset value)?  selectPreset,TResult Function( OpenCustomFilter value)?  openCustomFilter,TResult Function( ApplyCustomFilter value)?  applyCustomFilter,TResult Function( SaveAsPreset value)?  saveAsPreset,TResult Function( DeletePreset value)?  deletePreset,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadPresets() when loadPresets != null:
return loadPresets(_that);case SelectPreset() when selectPreset != null:
return selectPreset(_that);case OpenCustomFilter() when openCustomFilter != null:
return openCustomFilter(_that);case ApplyCustomFilter() when applyCustomFilter != null:
return applyCustomFilter(_that);case SaveAsPreset() when saveAsPreset != null:
return saveAsPreset(_that);case DeletePreset() when deletePreset != null:
return deletePreset(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadPresets value)  loadPresets,required TResult Function( SelectPreset value)  selectPreset,required TResult Function( OpenCustomFilter value)  openCustomFilter,required TResult Function( ApplyCustomFilter value)  applyCustomFilter,required TResult Function( SaveAsPreset value)  saveAsPreset,required TResult Function( DeletePreset value)  deletePreset,}){
final _that = this;
switch (_that) {
case LoadPresets():
return loadPresets(_that);case SelectPreset():
return selectPreset(_that);case OpenCustomFilter():
return openCustomFilter(_that);case ApplyCustomFilter():
return applyCustomFilter(_that);case SaveAsPreset():
return saveAsPreset(_that);case DeletePreset():
return deletePreset(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadPresets value)?  loadPresets,TResult? Function( SelectPreset value)?  selectPreset,TResult? Function( OpenCustomFilter value)?  openCustomFilter,TResult? Function( ApplyCustomFilter value)?  applyCustomFilter,TResult? Function( SaveAsPreset value)?  saveAsPreset,TResult? Function( DeletePreset value)?  deletePreset,}){
final _that = this;
switch (_that) {
case LoadPresets() when loadPresets != null:
return loadPresets(_that);case SelectPreset() when selectPreset != null:
return selectPreset(_that);case OpenCustomFilter() when openCustomFilter != null:
return openCustomFilter(_that);case ApplyCustomFilter() when applyCustomFilter != null:
return applyCustomFilter(_that);case SaveAsPreset() when saveAsPreset != null:
return saveAsPreset(_that);case DeletePreset() when deletePreset != null:
return deletePreset(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loadPresets,TResult Function( PerspectiveId id)?  selectPreset,TResult Function()?  openCustomFilter,TResult Function( Map<String, List<int>>? mapDimensionFilters,  Map<String, List<String>>? mapAttributeFilters,  List<int>? listTagIds)?  applyCustomFilter,TResult Function( String name)?  saveAsPreset,TResult Function( PerspectiveId id)?  deletePreset,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadPresets() when loadPresets != null:
return loadPresets();case SelectPreset() when selectPreset != null:
return selectPreset(_that.id);case OpenCustomFilter() when openCustomFilter != null:
return openCustomFilter();case ApplyCustomFilter() when applyCustomFilter != null:
return applyCustomFilter(_that.mapDimensionFilters,_that.mapAttributeFilters,_that.listTagIds);case SaveAsPreset() when saveAsPreset != null:
return saveAsPreset(_that.name);case DeletePreset() when deletePreset != null:
return deletePreset(_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loadPresets,required TResult Function( PerspectiveId id)  selectPreset,required TResult Function()  openCustomFilter,required TResult Function( Map<String, List<int>>? mapDimensionFilters,  Map<String, List<String>>? mapAttributeFilters,  List<int>? listTagIds)  applyCustomFilter,required TResult Function( String name)  saveAsPreset,required TResult Function( PerspectiveId id)  deletePreset,}) {final _that = this;
switch (_that) {
case LoadPresets():
return loadPresets();case SelectPreset():
return selectPreset(_that.id);case OpenCustomFilter():
return openCustomFilter();case ApplyCustomFilter():
return applyCustomFilter(_that.mapDimensionFilters,_that.mapAttributeFilters,_that.listTagIds);case SaveAsPreset():
return saveAsPreset(_that.name);case DeletePreset():
return deletePreset(_that.id);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loadPresets,TResult? Function( PerspectiveId id)?  selectPreset,TResult? Function()?  openCustomFilter,TResult? Function( Map<String, List<int>>? mapDimensionFilters,  Map<String, List<String>>? mapAttributeFilters,  List<int>? listTagIds)?  applyCustomFilter,TResult? Function( String name)?  saveAsPreset,TResult? Function( PerspectiveId id)?  deletePreset,}) {final _that = this;
switch (_that) {
case LoadPresets() when loadPresets != null:
return loadPresets();case SelectPreset() when selectPreset != null:
return selectPreset(_that.id);case OpenCustomFilter() when openCustomFilter != null:
return openCustomFilter();case ApplyCustomFilter() when applyCustomFilter != null:
return applyCustomFilter(_that.mapDimensionFilters,_that.mapAttributeFilters,_that.listTagIds);case SaveAsPreset() when saveAsPreset != null:
return saveAsPreset(_that.name);case DeletePreset() when deletePreset != null:
return deletePreset(_that.id);case _:
  return null;

}
}

}

/// @nodoc


class LoadPresets implements PerspectiveEvent {
  const LoadPresets();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadPresets);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PerspectiveEvent.loadPresets()';
}


}




/// @nodoc


class SelectPreset implements PerspectiveEvent {
  const SelectPreset({required this.id});
  

 final  PerspectiveId id;

/// Create a copy of PerspectiveEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SelectPresetCopyWith<SelectPreset> get copyWith => _$SelectPresetCopyWithImpl<SelectPreset>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelectPreset&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'PerspectiveEvent.selectPreset(id: $id)';
}


}

/// @nodoc
abstract mixin class $SelectPresetCopyWith<$Res> implements $PerspectiveEventCopyWith<$Res> {
  factory $SelectPresetCopyWith(SelectPreset value, $Res Function(SelectPreset) _then) = _$SelectPresetCopyWithImpl;
@useResult
$Res call({
 PerspectiveId id
});




}
/// @nodoc
class _$SelectPresetCopyWithImpl<$Res>
    implements $SelectPresetCopyWith<$Res> {
  _$SelectPresetCopyWithImpl(this._self, this._then);

  final SelectPreset _self;
  final $Res Function(SelectPreset) _then;

/// Create a copy of PerspectiveEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(SelectPreset(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as PerspectiveId,
  ));
}


}

/// @nodoc


class OpenCustomFilter implements PerspectiveEvent {
  const OpenCustomFilter();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpenCustomFilter);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PerspectiveEvent.openCustomFilter()';
}


}




/// @nodoc


class ApplyCustomFilter implements PerspectiveEvent {
  const ApplyCustomFilter({final  Map<String, List<int>>? mapDimensionFilters, final  Map<String, List<String>>? mapAttributeFilters, final  List<int>? listTagIds}): _mapDimensionFilters = mapDimensionFilters,_mapAttributeFilters = mapAttributeFilters,_listTagIds = listTagIds;
  

 final  Map<String, List<int>>? _mapDimensionFilters;
 Map<String, List<int>>? get mapDimensionFilters {
  final value = _mapDimensionFilters;
  if (value == null) return null;
  if (_mapDimensionFilters is EqualUnmodifiableMapView) return _mapDimensionFilters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, List<String>>? _mapAttributeFilters;
 Map<String, List<String>>? get mapAttributeFilters {
  final value = _mapAttributeFilters;
  if (value == null) return null;
  if (_mapAttributeFilters is EqualUnmodifiableMapView) return _mapAttributeFilters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  List<int>? _listTagIds;
 List<int>? get listTagIds {
  final value = _listTagIds;
  if (value == null) return null;
  if (_listTagIds is EqualUnmodifiableListView) return _listTagIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of PerspectiveEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApplyCustomFilterCopyWith<ApplyCustomFilter> get copyWith => _$ApplyCustomFilterCopyWithImpl<ApplyCustomFilter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApplyCustomFilter&&const DeepCollectionEquality().equals(other._mapDimensionFilters, _mapDimensionFilters)&&const DeepCollectionEquality().equals(other._mapAttributeFilters, _mapAttributeFilters)&&const DeepCollectionEquality().equals(other._listTagIds, _listTagIds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_mapDimensionFilters),const DeepCollectionEquality().hash(_mapAttributeFilters),const DeepCollectionEquality().hash(_listTagIds));

@override
String toString() {
  return 'PerspectiveEvent.applyCustomFilter(mapDimensionFilters: $mapDimensionFilters, mapAttributeFilters: $mapAttributeFilters, listTagIds: $listTagIds)';
}


}

/// @nodoc
abstract mixin class $ApplyCustomFilterCopyWith<$Res> implements $PerspectiveEventCopyWith<$Res> {
  factory $ApplyCustomFilterCopyWith(ApplyCustomFilter value, $Res Function(ApplyCustomFilter) _then) = _$ApplyCustomFilterCopyWithImpl;
@useResult
$Res call({
 Map<String, List<int>>? mapDimensionFilters, Map<String, List<String>>? mapAttributeFilters, List<int>? listTagIds
});




}
/// @nodoc
class _$ApplyCustomFilterCopyWithImpl<$Res>
    implements $ApplyCustomFilterCopyWith<$Res> {
  _$ApplyCustomFilterCopyWithImpl(this._self, this._then);

  final ApplyCustomFilter _self;
  final $Res Function(ApplyCustomFilter) _then;

/// Create a copy of PerspectiveEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? mapDimensionFilters = freezed,Object? mapAttributeFilters = freezed,Object? listTagIds = freezed,}) {
  return _then(ApplyCustomFilter(
mapDimensionFilters: freezed == mapDimensionFilters ? _self._mapDimensionFilters : mapDimensionFilters // ignore: cast_nullable_to_non_nullable
as Map<String, List<int>>?,mapAttributeFilters: freezed == mapAttributeFilters ? _self._mapAttributeFilters : mapAttributeFilters // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>?,listTagIds: freezed == listTagIds ? _self._listTagIds : listTagIds // ignore: cast_nullable_to_non_nullable
as List<int>?,
  ));
}


}

/// @nodoc


class SaveAsPreset implements PerspectiveEvent {
  const SaveAsPreset({required this.name});
  

 final  String name;

/// Create a copy of PerspectiveEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaveAsPresetCopyWith<SaveAsPreset> get copyWith => _$SaveAsPresetCopyWithImpl<SaveAsPreset>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaveAsPreset&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'PerspectiveEvent.saveAsPreset(name: $name)';
}


}

/// @nodoc
abstract mixin class $SaveAsPresetCopyWith<$Res> implements $PerspectiveEventCopyWith<$Res> {
  factory $SaveAsPresetCopyWith(SaveAsPreset value, $Res Function(SaveAsPreset) _then) = _$SaveAsPresetCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class _$SaveAsPresetCopyWithImpl<$Res>
    implements $SaveAsPresetCopyWith<$Res> {
  _$SaveAsPresetCopyWithImpl(this._self, this._then);

  final SaveAsPreset _self;
  final $Res Function(SaveAsPreset) _then;

/// Create a copy of PerspectiveEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(SaveAsPreset(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class DeletePreset implements PerspectiveEvent {
  const DeletePreset({required this.id});
  

 final  PerspectiveId id;

/// Create a copy of PerspectiveEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeletePresetCopyWith<DeletePreset> get copyWith => _$DeletePresetCopyWithImpl<DeletePreset>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeletePreset&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'PerspectiveEvent.deletePreset(id: $id)';
}


}

/// @nodoc
abstract mixin class $DeletePresetCopyWith<$Res> implements $PerspectiveEventCopyWith<$Res> {
  factory $DeletePresetCopyWith(DeletePreset value, $Res Function(DeletePreset) _then) = _$DeletePresetCopyWithImpl;
@useResult
$Res call({
 PerspectiveId id
});




}
/// @nodoc
class _$DeletePresetCopyWithImpl<$Res>
    implements $DeletePresetCopyWith<$Res> {
  _$DeletePresetCopyWithImpl(this._self, this._then);

  final DeletePreset _self;
  final $Res Function(DeletePreset) _then;

/// Create a copy of PerspectiveEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(DeletePreset(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as PerspectiveId,
  ));
}


}

// dart format on
