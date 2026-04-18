// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'JournalState.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JournalState {

 List<Transaction> get listTransactions; Transaction? get selectedTransaction; bool get isLoading; String? get errorMessage;
/// Create a copy of JournalState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JournalStateCopyWith<JournalState> get copyWith => _$JournalStateCopyWithImpl<JournalState>(this as JournalState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JournalState&&const DeepCollectionEquality().equals(other.listTransactions, listTransactions)&&(identical(other.selectedTransaction, selectedTransaction) || other.selectedTransaction == selectedTransaction)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(listTransactions),selectedTransaction,isLoading,errorMessage);

@override
String toString() {
  return 'JournalState(listTransactions: $listTransactions, selectedTransaction: $selectedTransaction, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $JournalStateCopyWith<$Res>  {
  factory $JournalStateCopyWith(JournalState value, $Res Function(JournalState) _then) = _$JournalStateCopyWithImpl;
@useResult
$Res call({
 List<Transaction> listTransactions, Transaction? selectedTransaction, bool isLoading, String? errorMessage
});


$TransactionCopyWith<$Res>? get selectedTransaction;

}
/// @nodoc
class _$JournalStateCopyWithImpl<$Res>
    implements $JournalStateCopyWith<$Res> {
  _$JournalStateCopyWithImpl(this._self, this._then);

  final JournalState _self;
  final $Res Function(JournalState) _then;

/// Create a copy of JournalState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? listTransactions = null,Object? selectedTransaction = freezed,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
listTransactions: null == listTransactions ? _self.listTransactions : listTransactions // ignore: cast_nullable_to_non_nullable
as List<Transaction>,selectedTransaction: freezed == selectedTransaction ? _self.selectedTransaction : selectedTransaction // ignore: cast_nullable_to_non_nullable
as Transaction?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of JournalState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionCopyWith<$Res>? get selectedTransaction {
    if (_self.selectedTransaction == null) {
    return null;
  }

  return $TransactionCopyWith<$Res>(_self.selectedTransaction!, (value) {
    return _then(_self.copyWith(selectedTransaction: value));
  });
}
}


/// Adds pattern-matching-related methods to [JournalState].
extension JournalStatePatterns on JournalState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JournalState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JournalState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JournalState value)  $default,){
final _that = this;
switch (_that) {
case _JournalState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JournalState value)?  $default,){
final _that = this;
switch (_that) {
case _JournalState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Transaction> listTransactions,  Transaction? selectedTransaction,  bool isLoading,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JournalState() when $default != null:
return $default(_that.listTransactions,_that.selectedTransaction,_that.isLoading,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Transaction> listTransactions,  Transaction? selectedTransaction,  bool isLoading,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _JournalState():
return $default(_that.listTransactions,_that.selectedTransaction,_that.isLoading,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Transaction> listTransactions,  Transaction? selectedTransaction,  bool isLoading,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _JournalState() when $default != null:
return $default(_that.listTransactions,_that.selectedTransaction,_that.isLoading,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _JournalState implements JournalState {
  const _JournalState({final  List<Transaction> listTransactions = const [], this.selectedTransaction, this.isLoading = false, this.errorMessage}): _listTransactions = listTransactions;
  

 final  List<Transaction> _listTransactions;
@override@JsonKey() List<Transaction> get listTransactions {
  if (_listTransactions is EqualUnmodifiableListView) return _listTransactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_listTransactions);
}

@override final  Transaction? selectedTransaction;
@override@JsonKey() final  bool isLoading;
@override final  String? errorMessage;

/// Create a copy of JournalState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JournalStateCopyWith<_JournalState> get copyWith => __$JournalStateCopyWithImpl<_JournalState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JournalState&&const DeepCollectionEquality().equals(other._listTransactions, _listTransactions)&&(identical(other.selectedTransaction, selectedTransaction) || other.selectedTransaction == selectedTransaction)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_listTransactions),selectedTransaction,isLoading,errorMessage);

@override
String toString() {
  return 'JournalState(listTransactions: $listTransactions, selectedTransaction: $selectedTransaction, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$JournalStateCopyWith<$Res> implements $JournalStateCopyWith<$Res> {
  factory _$JournalStateCopyWith(_JournalState value, $Res Function(_JournalState) _then) = __$JournalStateCopyWithImpl;
@override @useResult
$Res call({
 List<Transaction> listTransactions, Transaction? selectedTransaction, bool isLoading, String? errorMessage
});


@override $TransactionCopyWith<$Res>? get selectedTransaction;

}
/// @nodoc
class __$JournalStateCopyWithImpl<$Res>
    implements _$JournalStateCopyWith<$Res> {
  __$JournalStateCopyWithImpl(this._self, this._then);

  final _JournalState _self;
  final $Res Function(_JournalState) _then;

/// Create a copy of JournalState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? listTransactions = null,Object? selectedTransaction = freezed,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_JournalState(
listTransactions: null == listTransactions ? _self._listTransactions : listTransactions // ignore: cast_nullable_to_non_nullable
as List<Transaction>,selectedTransaction: freezed == selectedTransaction ? _self.selectedTransaction : selectedTransaction // ignore: cast_nullable_to_non_nullable
as Transaction?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of JournalState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionCopyWith<$Res>? get selectedTransaction {
    if (_self.selectedTransaction == null) {
    return null;
  }

  return $TransactionCopyWith<$Res>(_self.selectedTransaction!, (value) {
    return _then(_self.copyWith(selectedTransaction: value));
  });
}
}

// dart format on
