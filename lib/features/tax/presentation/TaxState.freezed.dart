// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'TaxState.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TaxState {

/// 자동 판정 결과 목록
 List<DeductibilityClassificationResult> get listAutoResults;/// 미판정 항목 (undetermined) 목록 — 수동 검토 대상
 List<DeductibilityClassificationResult> get listPendingItems;/// 세무조정 확정 여부
 bool get isSettlementConfirmed; bool get isLoading; String? get errorMessage;
/// Create a copy of TaxState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaxStateCopyWith<TaxState> get copyWith => _$TaxStateCopyWithImpl<TaxState>(this as TaxState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaxState&&const DeepCollectionEquality().equals(other.listAutoResults, listAutoResults)&&const DeepCollectionEquality().equals(other.listPendingItems, listPendingItems)&&(identical(other.isSettlementConfirmed, isSettlementConfirmed) || other.isSettlementConfirmed == isSettlementConfirmed)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(listAutoResults),const DeepCollectionEquality().hash(listPendingItems),isSettlementConfirmed,isLoading,errorMessage);

@override
String toString() {
  return 'TaxState(listAutoResults: $listAutoResults, listPendingItems: $listPendingItems, isSettlementConfirmed: $isSettlementConfirmed, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $TaxStateCopyWith<$Res>  {
  factory $TaxStateCopyWith(TaxState value, $Res Function(TaxState) _then) = _$TaxStateCopyWithImpl;
@useResult
$Res call({
 List<DeductibilityClassificationResult> listAutoResults, List<DeductibilityClassificationResult> listPendingItems, bool isSettlementConfirmed, bool isLoading, String? errorMessage
});




}
/// @nodoc
class _$TaxStateCopyWithImpl<$Res>
    implements $TaxStateCopyWith<$Res> {
  _$TaxStateCopyWithImpl(this._self, this._then);

  final TaxState _self;
  final $Res Function(TaxState) _then;

/// Create a copy of TaxState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? listAutoResults = null,Object? listPendingItems = null,Object? isSettlementConfirmed = null,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
listAutoResults: null == listAutoResults ? _self.listAutoResults : listAutoResults // ignore: cast_nullable_to_non_nullable
as List<DeductibilityClassificationResult>,listPendingItems: null == listPendingItems ? _self.listPendingItems : listPendingItems // ignore: cast_nullable_to_non_nullable
as List<DeductibilityClassificationResult>,isSettlementConfirmed: null == isSettlementConfirmed ? _self.isSettlementConfirmed : isSettlementConfirmed // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TaxState].
extension TaxStatePatterns on TaxState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaxState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaxState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaxState value)  $default,){
final _that = this;
switch (_that) {
case _TaxState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaxState value)?  $default,){
final _that = this;
switch (_that) {
case _TaxState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DeductibilityClassificationResult> listAutoResults,  List<DeductibilityClassificationResult> listPendingItems,  bool isSettlementConfirmed,  bool isLoading,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaxState() when $default != null:
return $default(_that.listAutoResults,_that.listPendingItems,_that.isSettlementConfirmed,_that.isLoading,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DeductibilityClassificationResult> listAutoResults,  List<DeductibilityClassificationResult> listPendingItems,  bool isSettlementConfirmed,  bool isLoading,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _TaxState():
return $default(_that.listAutoResults,_that.listPendingItems,_that.isSettlementConfirmed,_that.isLoading,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DeductibilityClassificationResult> listAutoResults,  List<DeductibilityClassificationResult> listPendingItems,  bool isSettlementConfirmed,  bool isLoading,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _TaxState() when $default != null:
return $default(_that.listAutoResults,_that.listPendingItems,_that.isSettlementConfirmed,_that.isLoading,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _TaxState implements TaxState {
  const _TaxState({final  List<DeductibilityClassificationResult> listAutoResults = const [], final  List<DeductibilityClassificationResult> listPendingItems = const [], this.isSettlementConfirmed = false, this.isLoading = false, this.errorMessage}): _listAutoResults = listAutoResults,_listPendingItems = listPendingItems;
  

/// 자동 판정 결과 목록
 final  List<DeductibilityClassificationResult> _listAutoResults;
/// 자동 판정 결과 목록
@override@JsonKey() List<DeductibilityClassificationResult> get listAutoResults {
  if (_listAutoResults is EqualUnmodifiableListView) return _listAutoResults;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_listAutoResults);
}

/// 미판정 항목 (undetermined) 목록 — 수동 검토 대상
 final  List<DeductibilityClassificationResult> _listPendingItems;
/// 미판정 항목 (undetermined) 목록 — 수동 검토 대상
@override@JsonKey() List<DeductibilityClassificationResult> get listPendingItems {
  if (_listPendingItems is EqualUnmodifiableListView) return _listPendingItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_listPendingItems);
}

/// 세무조정 확정 여부
@override@JsonKey() final  bool isSettlementConfirmed;
@override@JsonKey() final  bool isLoading;
@override final  String? errorMessage;

/// Create a copy of TaxState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaxStateCopyWith<_TaxState> get copyWith => __$TaxStateCopyWithImpl<_TaxState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaxState&&const DeepCollectionEquality().equals(other._listAutoResults, _listAutoResults)&&const DeepCollectionEquality().equals(other._listPendingItems, _listPendingItems)&&(identical(other.isSettlementConfirmed, isSettlementConfirmed) || other.isSettlementConfirmed == isSettlementConfirmed)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_listAutoResults),const DeepCollectionEquality().hash(_listPendingItems),isSettlementConfirmed,isLoading,errorMessage);

@override
String toString() {
  return 'TaxState(listAutoResults: $listAutoResults, listPendingItems: $listPendingItems, isSettlementConfirmed: $isSettlementConfirmed, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$TaxStateCopyWith<$Res> implements $TaxStateCopyWith<$Res> {
  factory _$TaxStateCopyWith(_TaxState value, $Res Function(_TaxState) _then) = __$TaxStateCopyWithImpl;
@override @useResult
$Res call({
 List<DeductibilityClassificationResult> listAutoResults, List<DeductibilityClassificationResult> listPendingItems, bool isSettlementConfirmed, bool isLoading, String? errorMessage
});




}
/// @nodoc
class __$TaxStateCopyWithImpl<$Res>
    implements _$TaxStateCopyWith<$Res> {
  __$TaxStateCopyWithImpl(this._self, this._then);

  final _TaxState _self;
  final $Res Function(_TaxState) _then;

/// Create a copy of TaxState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? listAutoResults = null,Object? listPendingItems = null,Object? isSettlementConfirmed = null,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_TaxState(
listAutoResults: null == listAutoResults ? _self._listAutoResults : listAutoResults // ignore: cast_nullable_to_non_nullable
as List<DeductibilityClassificationResult>,listPendingItems: null == listPendingItems ? _self._listPendingItems : listPendingItems // ignore: cast_nullable_to_non_nullable
as List<DeductibilityClassificationResult>,isSettlementConfirmed: null == isSettlementConfirmed ? _self.isSettlementConfirmed : isSettlementConfirmed // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
