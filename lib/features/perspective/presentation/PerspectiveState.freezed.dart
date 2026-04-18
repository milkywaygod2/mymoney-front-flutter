// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'PerspectiveState.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PerspectiveState {

 List<Perspective> get listPresets; PerspectiveId? get activePresetId; Perspective? get effectivePerspective; bool get isCustomFilterOpen; bool get isLoading; String? get errorMessage;
/// Create a copy of PerspectiveState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PerspectiveStateCopyWith<PerspectiveState> get copyWith => _$PerspectiveStateCopyWithImpl<PerspectiveState>(this as PerspectiveState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PerspectiveState&&const DeepCollectionEquality().equals(other.listPresets, listPresets)&&(identical(other.activePresetId, activePresetId) || other.activePresetId == activePresetId)&&(identical(other.effectivePerspective, effectivePerspective) || other.effectivePerspective == effectivePerspective)&&(identical(other.isCustomFilterOpen, isCustomFilterOpen) || other.isCustomFilterOpen == isCustomFilterOpen)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(listPresets),activePresetId,effectivePerspective,isCustomFilterOpen,isLoading,errorMessage);

@override
String toString() {
  return 'PerspectiveState(listPresets: $listPresets, activePresetId: $activePresetId, effectivePerspective: $effectivePerspective, isCustomFilterOpen: $isCustomFilterOpen, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $PerspectiveStateCopyWith<$Res>  {
  factory $PerspectiveStateCopyWith(PerspectiveState value, $Res Function(PerspectiveState) _then) = _$PerspectiveStateCopyWithImpl;
@useResult
$Res call({
 List<Perspective> listPresets, PerspectiveId? activePresetId, Perspective? effectivePerspective, bool isCustomFilterOpen, bool isLoading, String? errorMessage
});


$PerspectiveCopyWith<$Res>? get effectivePerspective;

}
/// @nodoc
class _$PerspectiveStateCopyWithImpl<$Res>
    implements $PerspectiveStateCopyWith<$Res> {
  _$PerspectiveStateCopyWithImpl(this._self, this._then);

  final PerspectiveState _self;
  final $Res Function(PerspectiveState) _then;

/// Create a copy of PerspectiveState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? listPresets = null,Object? activePresetId = freezed,Object? effectivePerspective = freezed,Object? isCustomFilterOpen = null,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
listPresets: null == listPresets ? _self.listPresets : listPresets // ignore: cast_nullable_to_non_nullable
as List<Perspective>,activePresetId: freezed == activePresetId ? _self.activePresetId : activePresetId // ignore: cast_nullable_to_non_nullable
as PerspectiveId?,effectivePerspective: freezed == effectivePerspective ? _self.effectivePerspective : effectivePerspective // ignore: cast_nullable_to_non_nullable
as Perspective?,isCustomFilterOpen: null == isCustomFilterOpen ? _self.isCustomFilterOpen : isCustomFilterOpen // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of PerspectiveState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PerspectiveCopyWith<$Res>? get effectivePerspective {
    if (_self.effectivePerspective == null) {
    return null;
  }

  return $PerspectiveCopyWith<$Res>(_self.effectivePerspective!, (value) {
    return _then(_self.copyWith(effectivePerspective: value));
  });
}
}


/// Adds pattern-matching-related methods to [PerspectiveState].
extension PerspectiveStatePatterns on PerspectiveState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PerspectiveState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PerspectiveState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PerspectiveState value)  $default,){
final _that = this;
switch (_that) {
case _PerspectiveState():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PerspectiveState value)?  $default,){
final _that = this;
switch (_that) {
case _PerspectiveState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Perspective> listPresets,  PerspectiveId? activePresetId,  Perspective? effectivePerspective,  bool isCustomFilterOpen,  bool isLoading,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PerspectiveState() when $default != null:
return $default(_that.listPresets,_that.activePresetId,_that.effectivePerspective,_that.isCustomFilterOpen,_that.isLoading,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Perspective> listPresets,  PerspectiveId? activePresetId,  Perspective? effectivePerspective,  bool isCustomFilterOpen,  bool isLoading,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _PerspectiveState():
return $default(_that.listPresets,_that.activePresetId,_that.effectivePerspective,_that.isCustomFilterOpen,_that.isLoading,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Perspective> listPresets,  PerspectiveId? activePresetId,  Perspective? effectivePerspective,  bool isCustomFilterOpen,  bool isLoading,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _PerspectiveState() when $default != null:
return $default(_that.listPresets,_that.activePresetId,_that.effectivePerspective,_that.isCustomFilterOpen,_that.isLoading,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _PerspectiveState implements PerspectiveState {
  const _PerspectiveState({final  List<Perspective> listPresets = const [], this.activePresetId, this.effectivePerspective, this.isCustomFilterOpen = false, this.isLoading = false, this.errorMessage}): _listPresets = listPresets;
  

 final  List<Perspective> _listPresets;
@override@JsonKey() List<Perspective> get listPresets {
  if (_listPresets is EqualUnmodifiableListView) return _listPresets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_listPresets);
}

@override final  PerspectiveId? activePresetId;
@override final  Perspective? effectivePerspective;
@override@JsonKey() final  bool isCustomFilterOpen;
@override@JsonKey() final  bool isLoading;
@override final  String? errorMessage;

/// Create a copy of PerspectiveState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PerspectiveStateCopyWith<_PerspectiveState> get copyWith => __$PerspectiveStateCopyWithImpl<_PerspectiveState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PerspectiveState&&const DeepCollectionEquality().equals(other._listPresets, _listPresets)&&(identical(other.activePresetId, activePresetId) || other.activePresetId == activePresetId)&&(identical(other.effectivePerspective, effectivePerspective) || other.effectivePerspective == effectivePerspective)&&(identical(other.isCustomFilterOpen, isCustomFilterOpen) || other.isCustomFilterOpen == isCustomFilterOpen)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_listPresets),activePresetId,effectivePerspective,isCustomFilterOpen,isLoading,errorMessage);

@override
String toString() {
  return 'PerspectiveState(listPresets: $listPresets, activePresetId: $activePresetId, effectivePerspective: $effectivePerspective, isCustomFilterOpen: $isCustomFilterOpen, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$PerspectiveStateCopyWith<$Res> implements $PerspectiveStateCopyWith<$Res> {
  factory _$PerspectiveStateCopyWith(_PerspectiveState value, $Res Function(_PerspectiveState) _then) = __$PerspectiveStateCopyWithImpl;
@override @useResult
$Res call({
 List<Perspective> listPresets, PerspectiveId? activePresetId, Perspective? effectivePerspective, bool isCustomFilterOpen, bool isLoading, String? errorMessage
});


@override $PerspectiveCopyWith<$Res>? get effectivePerspective;

}
/// @nodoc
class __$PerspectiveStateCopyWithImpl<$Res>
    implements _$PerspectiveStateCopyWith<$Res> {
  __$PerspectiveStateCopyWithImpl(this._self, this._then);

  final _PerspectiveState _self;
  final $Res Function(_PerspectiveState) _then;

/// Create a copy of PerspectiveState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? listPresets = null,Object? activePresetId = freezed,Object? effectivePerspective = freezed,Object? isCustomFilterOpen = null,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_PerspectiveState(
listPresets: null == listPresets ? _self._listPresets : listPresets // ignore: cast_nullable_to_non_nullable
as List<Perspective>,activePresetId: freezed == activePresetId ? _self.activePresetId : activePresetId // ignore: cast_nullable_to_non_nullable
as PerspectiveId?,effectivePerspective: freezed == effectivePerspective ? _self.effectivePerspective : effectivePerspective // ignore: cast_nullable_to_non_nullable
as Perspective?,isCustomFilterOpen: null == isCustomFilterOpen ? _self.isCustomFilterOpen : isCustomFilterOpen // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of PerspectiveState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PerspectiveCopyWith<$Res>? get effectivePerspective {
    if (_self.effectivePerspective == null) {
    return null;
  }

  return $PerspectiveCopyWith<$Res>(_self.effectivePerspective!, (value) {
    return _then(_self.copyWith(effectivePerspective: value));
  });
}
}

// dart format on
