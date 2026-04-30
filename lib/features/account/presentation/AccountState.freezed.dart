// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'AccountState.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountState {

/// 최상위 계정 목록 (5대 분류: 자산/부채/자본/수익/비용)
 List<Account> get listRoots;/// 전체 활성 계정 flat 목록 — 계정명 조회용
 List<Account> get listAll;/// 펼쳐진 노드 ID 집합 — 렌더링 시 해당 노드만 자식 표시
 Set<AccountId> get setExpandedIds;/// 검색 결과 — 검색어에 매칭되는 계정 목록
 List<Account> get listSearchResults;/// 로딩 상태
 bool get isLoading;/// 에러 메시지 (null이면 에러 없음)
 String? get errorMessage;
/// Create a copy of AccountState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountStateCopyWith<AccountState> get copyWith => _$AccountStateCopyWithImpl<AccountState>(this as AccountState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountState&&const DeepCollectionEquality().equals(other.listRoots, listRoots)&&const DeepCollectionEquality().equals(other.listAll, listAll)&&const DeepCollectionEquality().equals(other.setExpandedIds, setExpandedIds)&&const DeepCollectionEquality().equals(other.listSearchResults, listSearchResults)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(listRoots),const DeepCollectionEquality().hash(listAll),const DeepCollectionEquality().hash(setExpandedIds),const DeepCollectionEquality().hash(listSearchResults),isLoading,errorMessage);

@override
String toString() {
  return 'AccountState(listRoots: $listRoots, listAll: $listAll, setExpandedIds: $setExpandedIds, listSearchResults: $listSearchResults, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $AccountStateCopyWith<$Res>  {
  factory $AccountStateCopyWith(AccountState value, $Res Function(AccountState) _then) = _$AccountStateCopyWithImpl;
@useResult
$Res call({
 List<Account> listRoots, List<Account> listAll, Set<AccountId> setExpandedIds, List<Account> listSearchResults, bool isLoading, String? errorMessage
});




}
/// @nodoc
class _$AccountStateCopyWithImpl<$Res>
    implements $AccountStateCopyWith<$Res> {
  _$AccountStateCopyWithImpl(this._self, this._then);

  final AccountState _self;
  final $Res Function(AccountState) _then;

/// Create a copy of AccountState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? listRoots = null,Object? listAll = null,Object? setExpandedIds = null,Object? listSearchResults = null,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
listRoots: null == listRoots ? _self.listRoots : listRoots // ignore: cast_nullable_to_non_nullable
as List<Account>,listAll: null == listAll ? _self.listAll : listAll // ignore: cast_nullable_to_non_nullable
as List<Account>,setExpandedIds: null == setExpandedIds ? _self.setExpandedIds : setExpandedIds // ignore: cast_nullable_to_non_nullable
as Set<AccountId>,listSearchResults: null == listSearchResults ? _self.listSearchResults : listSearchResults // ignore: cast_nullable_to_non_nullable
as List<Account>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountState].
extension AccountStatePatterns on AccountState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountState value)  $default,){
final _that = this;
switch (_that) {
case _AccountState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountState value)?  $default,){
final _that = this;
switch (_that) {
case _AccountState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Account> listRoots,  List<Account> listAll,  Set<AccountId> setExpandedIds,  List<Account> listSearchResults,  bool isLoading,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountState() when $default != null:
return $default(_that.listRoots,_that.listAll,_that.setExpandedIds,_that.listSearchResults,_that.isLoading,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Account> listRoots,  List<Account> listAll,  Set<AccountId> setExpandedIds,  List<Account> listSearchResults,  bool isLoading,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _AccountState():
return $default(_that.listRoots,_that.listAll,_that.setExpandedIds,_that.listSearchResults,_that.isLoading,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Account> listRoots,  List<Account> listAll,  Set<AccountId> setExpandedIds,  List<Account> listSearchResults,  bool isLoading,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _AccountState() when $default != null:
return $default(_that.listRoots,_that.listAll,_that.setExpandedIds,_that.listSearchResults,_that.isLoading,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _AccountState implements AccountState {
  const _AccountState({final  List<Account> listRoots = const [], final  List<Account> listAll = const [], final  Set<AccountId> setExpandedIds = const {}, final  List<Account> listSearchResults = const [], this.isLoading = false, this.errorMessage}): _listRoots = listRoots,_listAll = listAll,_setExpandedIds = setExpandedIds,_listSearchResults = listSearchResults;
  

/// 최상위 계정 목록 (5대 분류: 자산/부채/자본/수익/비용)
 final  List<Account> _listRoots;
/// 최상위 계정 목록 (5대 분류: 자산/부채/자본/수익/비용)
@override@JsonKey() List<Account> get listRoots {
  if (_listRoots is EqualUnmodifiableListView) return _listRoots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_listRoots);
}

/// 전체 활성 계정 flat 목록 — 계정명 조회용
 final  List<Account> _listAll;
/// 전체 활성 계정 flat 목록 — 계정명 조회용
@override@JsonKey() List<Account> get listAll {
  if (_listAll is EqualUnmodifiableListView) return _listAll;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_listAll);
}

/// 펼쳐진 노드 ID 집합 — 렌더링 시 해당 노드만 자식 표시
 final  Set<AccountId> _setExpandedIds;
/// 펼쳐진 노드 ID 집합 — 렌더링 시 해당 노드만 자식 표시
@override@JsonKey() Set<AccountId> get setExpandedIds {
  if (_setExpandedIds is EqualUnmodifiableSetView) return _setExpandedIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_setExpandedIds);
}

/// 검색 결과 — 검색어에 매칭되는 계정 목록
 final  List<Account> _listSearchResults;
/// 검색 결과 — 검색어에 매칭되는 계정 목록
@override@JsonKey() List<Account> get listSearchResults {
  if (_listSearchResults is EqualUnmodifiableListView) return _listSearchResults;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_listSearchResults);
}

/// 로딩 상태
@override@JsonKey() final  bool isLoading;
/// 에러 메시지 (null이면 에러 없음)
@override final  String? errorMessage;

/// Create a copy of AccountState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountStateCopyWith<_AccountState> get copyWith => __$AccountStateCopyWithImpl<_AccountState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountState&&const DeepCollectionEquality().equals(other._listRoots, _listRoots)&&const DeepCollectionEquality().equals(other._listAll, _listAll)&&const DeepCollectionEquality().equals(other._setExpandedIds, _setExpandedIds)&&const DeepCollectionEquality().equals(other._listSearchResults, _listSearchResults)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_listRoots),const DeepCollectionEquality().hash(_listAll),const DeepCollectionEquality().hash(_setExpandedIds),const DeepCollectionEquality().hash(_listSearchResults),isLoading,errorMessage);

@override
String toString() {
  return 'AccountState(listRoots: $listRoots, listAll: $listAll, setExpandedIds: $setExpandedIds, listSearchResults: $listSearchResults, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$AccountStateCopyWith<$Res> implements $AccountStateCopyWith<$Res> {
  factory _$AccountStateCopyWith(_AccountState value, $Res Function(_AccountState) _then) = __$AccountStateCopyWithImpl;
@override @useResult
$Res call({
 List<Account> listRoots, List<Account> listAll, Set<AccountId> setExpandedIds, List<Account> listSearchResults, bool isLoading, String? errorMessage
});




}
/// @nodoc
class __$AccountStateCopyWithImpl<$Res>
    implements _$AccountStateCopyWith<$Res> {
  __$AccountStateCopyWithImpl(this._self, this._then);

  final _AccountState _self;
  final $Res Function(_AccountState) _then;

/// Create a copy of AccountState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? listRoots = null,Object? listAll = null,Object? setExpandedIds = null,Object? listSearchResults = null,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_AccountState(
listRoots: null == listRoots ? _self._listRoots : listRoots // ignore: cast_nullable_to_non_nullable
as List<Account>,listAll: null == listAll ? _self._listAll : listAll // ignore: cast_nullable_to_non_nullable
as List<Account>,setExpandedIds: null == setExpandedIds ? _self._setExpandedIds : setExpandedIds // ignore: cast_nullable_to_non_nullable
as Set<AccountId>,listSearchResults: null == listSearchResults ? _self._listSearchResults : listSearchResults // ignore: cast_nullable_to_non_nullable
as List<Account>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
