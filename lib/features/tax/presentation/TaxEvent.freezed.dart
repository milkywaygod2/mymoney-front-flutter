// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'TaxEvent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TaxEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaxEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TaxEvent()';
}


}

/// @nodoc
class $TaxEventCopyWith<$Res>  {
$TaxEventCopyWith(TaxEvent _, $Res Function(TaxEvent) __);
}


/// Adds pattern-matching-related methods to [TaxEvent].
extension TaxEventPatterns on TaxEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RunAutoClassification value)?  runAutoClassification,TResult Function( LoadPendingItems value)?  loadPendingItems,TResult Function( OverrideDeductibility value)?  overrideDeductibility,TResult Function( ConfirmSettlement value)?  confirmSettlement,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RunAutoClassification() when runAutoClassification != null:
return runAutoClassification(_that);case LoadPendingItems() when loadPendingItems != null:
return loadPendingItems(_that);case OverrideDeductibility() when overrideDeductibility != null:
return overrideDeductibility(_that);case ConfirmSettlement() when confirmSettlement != null:
return confirmSettlement(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RunAutoClassification value)  runAutoClassification,required TResult Function( LoadPendingItems value)  loadPendingItems,required TResult Function( OverrideDeductibility value)  overrideDeductibility,required TResult Function( ConfirmSettlement value)  confirmSettlement,}){
final _that = this;
switch (_that) {
case RunAutoClassification():
return runAutoClassification(_that);case LoadPendingItems():
return loadPendingItems(_that);case OverrideDeductibility():
return overrideDeductibility(_that);case ConfirmSettlement():
return confirmSettlement(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RunAutoClassification value)?  runAutoClassification,TResult? Function( LoadPendingItems value)?  loadPendingItems,TResult? Function( OverrideDeductibility value)?  overrideDeductibility,TResult? Function( ConfirmSettlement value)?  confirmSettlement,}){
final _that = this;
switch (_that) {
case RunAutoClassification() when runAutoClassification != null:
return runAutoClassification(_that);case LoadPendingItems() when loadPendingItems != null:
return loadPendingItems(_that);case OverrideDeductibility() when overrideDeductibility != null:
return overrideDeductibility(_that);case ConfirmSettlement() when confirmSettlement != null:
return confirmSettlement(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<TransactionId> listTransactionIds,  DateTime asOfDate)?  runAutoClassification,TResult Function()?  loadPendingItems,TResult Function( TransactionId transactionId,  JournalEntryLineId lineId,  Deductibility deductibility,  String? memo)?  overrideDeductibility,TResult Function( DateTime asOfDate)?  confirmSettlement,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RunAutoClassification() when runAutoClassification != null:
return runAutoClassification(_that.listTransactionIds,_that.asOfDate);case LoadPendingItems() when loadPendingItems != null:
return loadPendingItems();case OverrideDeductibility() when overrideDeductibility != null:
return overrideDeductibility(_that.transactionId,_that.lineId,_that.deductibility,_that.memo);case ConfirmSettlement() when confirmSettlement != null:
return confirmSettlement(_that.asOfDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<TransactionId> listTransactionIds,  DateTime asOfDate)  runAutoClassification,required TResult Function()  loadPendingItems,required TResult Function( TransactionId transactionId,  JournalEntryLineId lineId,  Deductibility deductibility,  String? memo)  overrideDeductibility,required TResult Function( DateTime asOfDate)  confirmSettlement,}) {final _that = this;
switch (_that) {
case RunAutoClassification():
return runAutoClassification(_that.listTransactionIds,_that.asOfDate);case LoadPendingItems():
return loadPendingItems();case OverrideDeductibility():
return overrideDeductibility(_that.transactionId,_that.lineId,_that.deductibility,_that.memo);case ConfirmSettlement():
return confirmSettlement(_that.asOfDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<TransactionId> listTransactionIds,  DateTime asOfDate)?  runAutoClassification,TResult? Function()?  loadPendingItems,TResult? Function( TransactionId transactionId,  JournalEntryLineId lineId,  Deductibility deductibility,  String? memo)?  overrideDeductibility,TResult? Function( DateTime asOfDate)?  confirmSettlement,}) {final _that = this;
switch (_that) {
case RunAutoClassification() when runAutoClassification != null:
return runAutoClassification(_that.listTransactionIds,_that.asOfDate);case LoadPendingItems() when loadPendingItems != null:
return loadPendingItems();case OverrideDeductibility() when overrideDeductibility != null:
return overrideDeductibility(_that.transactionId,_that.lineId,_that.deductibility,_that.memo);case ConfirmSettlement() when confirmSettlement != null:
return confirmSettlement(_that.asOfDate);case _:
  return null;

}
}

}

/// @nodoc


class RunAutoClassification implements TaxEvent {
  const RunAutoClassification({required final  List<TransactionId> listTransactionIds, required this.asOfDate}): _listTransactionIds = listTransactionIds;
  

 final  List<TransactionId> _listTransactionIds;
 List<TransactionId> get listTransactionIds {
  if (_listTransactionIds is EqualUnmodifiableListView) return _listTransactionIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_listTransactionIds);
}

 final  DateTime asOfDate;

/// Create a copy of TaxEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RunAutoClassificationCopyWith<RunAutoClassification> get copyWith => _$RunAutoClassificationCopyWithImpl<RunAutoClassification>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RunAutoClassification&&const DeepCollectionEquality().equals(other._listTransactionIds, _listTransactionIds)&&(identical(other.asOfDate, asOfDate) || other.asOfDate == asOfDate));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_listTransactionIds),asOfDate);

@override
String toString() {
  return 'TaxEvent.runAutoClassification(listTransactionIds: $listTransactionIds, asOfDate: $asOfDate)';
}


}

/// @nodoc
abstract mixin class $RunAutoClassificationCopyWith<$Res> implements $TaxEventCopyWith<$Res> {
  factory $RunAutoClassificationCopyWith(RunAutoClassification value, $Res Function(RunAutoClassification) _then) = _$RunAutoClassificationCopyWithImpl;
@useResult
$Res call({
 List<TransactionId> listTransactionIds, DateTime asOfDate
});




}
/// @nodoc
class _$RunAutoClassificationCopyWithImpl<$Res>
    implements $RunAutoClassificationCopyWith<$Res> {
  _$RunAutoClassificationCopyWithImpl(this._self, this._then);

  final RunAutoClassification _self;
  final $Res Function(RunAutoClassification) _then;

/// Create a copy of TaxEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? listTransactionIds = null,Object? asOfDate = null,}) {
  return _then(RunAutoClassification(
listTransactionIds: null == listTransactionIds ? _self._listTransactionIds : listTransactionIds // ignore: cast_nullable_to_non_nullable
as List<TransactionId>,asOfDate: null == asOfDate ? _self.asOfDate : asOfDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc


class LoadPendingItems implements TaxEvent {
  const LoadPendingItems();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadPendingItems);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TaxEvent.loadPendingItems()';
}


}




/// @nodoc


class OverrideDeductibility implements TaxEvent {
  const OverrideDeductibility({required this.transactionId, required this.lineId, required this.deductibility, this.memo});
  

 final  TransactionId transactionId;
 final  JournalEntryLineId lineId;
 final  Deductibility deductibility;
 final  String? memo;

/// Create a copy of TaxEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OverrideDeductibilityCopyWith<OverrideDeductibility> get copyWith => _$OverrideDeductibilityCopyWithImpl<OverrideDeductibility>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OverrideDeductibility&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.lineId, lineId) || other.lineId == lineId)&&(identical(other.deductibility, deductibility) || other.deductibility == deductibility)&&(identical(other.memo, memo) || other.memo == memo));
}


@override
int get hashCode => Object.hash(runtimeType,transactionId,lineId,deductibility,memo);

@override
String toString() {
  return 'TaxEvent.overrideDeductibility(transactionId: $transactionId, lineId: $lineId, deductibility: $deductibility, memo: $memo)';
}


}

/// @nodoc
abstract mixin class $OverrideDeductibilityCopyWith<$Res> implements $TaxEventCopyWith<$Res> {
  factory $OverrideDeductibilityCopyWith(OverrideDeductibility value, $Res Function(OverrideDeductibility) _then) = _$OverrideDeductibilityCopyWithImpl;
@useResult
$Res call({
 TransactionId transactionId, JournalEntryLineId lineId, Deductibility deductibility, String? memo
});




}
/// @nodoc
class _$OverrideDeductibilityCopyWithImpl<$Res>
    implements $OverrideDeductibilityCopyWith<$Res> {
  _$OverrideDeductibilityCopyWithImpl(this._self, this._then);

  final OverrideDeductibility _self;
  final $Res Function(OverrideDeductibility) _then;

/// Create a copy of TaxEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? transactionId = null,Object? lineId = null,Object? deductibility = null,Object? memo = freezed,}) {
  return _then(OverrideDeductibility(
transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as TransactionId,lineId: null == lineId ? _self.lineId : lineId // ignore: cast_nullable_to_non_nullable
as JournalEntryLineId,deductibility: null == deductibility ? _self.deductibility : deductibility // ignore: cast_nullable_to_non_nullable
as Deductibility,memo: freezed == memo ? _self.memo : memo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ConfirmSettlement implements TaxEvent {
  const ConfirmSettlement({required this.asOfDate});
  

 final  DateTime asOfDate;

/// Create a copy of TaxEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConfirmSettlementCopyWith<ConfirmSettlement> get copyWith => _$ConfirmSettlementCopyWithImpl<ConfirmSettlement>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConfirmSettlement&&(identical(other.asOfDate, asOfDate) || other.asOfDate == asOfDate));
}


@override
int get hashCode => Object.hash(runtimeType,asOfDate);

@override
String toString() {
  return 'TaxEvent.confirmSettlement(asOfDate: $asOfDate)';
}


}

/// @nodoc
abstract mixin class $ConfirmSettlementCopyWith<$Res> implements $TaxEventCopyWith<$Res> {
  factory $ConfirmSettlementCopyWith(ConfirmSettlement value, $Res Function(ConfirmSettlement) _then) = _$ConfirmSettlementCopyWithImpl;
@useResult
$Res call({
 DateTime asOfDate
});




}
/// @nodoc
class _$ConfirmSettlementCopyWithImpl<$Res>
    implements $ConfirmSettlementCopyWith<$Res> {
  _$ConfirmSettlementCopyWithImpl(this._self, this._then);

  final ConfirmSettlement _self;
  final $Res Function(ConfirmSettlement) _then;

/// Create a copy of TaxEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? asOfDate = null,}) {
  return _then(ConfirmSettlement(
asOfDate: null == asOfDate ? _self.asOfDate : asOfDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
