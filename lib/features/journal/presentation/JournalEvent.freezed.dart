// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'JournalEvent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JournalEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JournalEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JournalEvent()';
}


}

/// @nodoc
class $JournalEventCopyWith<$Res>  {
$JournalEventCopyWith(JournalEvent _, $Res Function(JournalEvent) __);
}


/// Adds pattern-matching-related methods to [JournalEvent].
extension JournalEventPatterns on JournalEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadTransactions value)?  loadTransactions,TResult Function( SelectTransaction value)?  selectTransaction,TResult Function( CreateTransactionEvent value)?  createTransaction,TResult Function( PostTransactionEvent value)?  postTransaction,TResult Function( DeleteTransactionEvent value)?  deleteTransaction,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadTransactions() when loadTransactions != null:
return loadTransactions(_that);case SelectTransaction() when selectTransaction != null:
return selectTransaction(_that);case CreateTransactionEvent() when createTransaction != null:
return createTransaction(_that);case PostTransactionEvent() when postTransaction != null:
return postTransaction(_that);case DeleteTransactionEvent() when deleteTransaction != null:
return deleteTransaction(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadTransactions value)  loadTransactions,required TResult Function( SelectTransaction value)  selectTransaction,required TResult Function( CreateTransactionEvent value)  createTransaction,required TResult Function( PostTransactionEvent value)  postTransaction,required TResult Function( DeleteTransactionEvent value)  deleteTransaction,}){
final _that = this;
switch (_that) {
case LoadTransactions():
return loadTransactions(_that);case SelectTransaction():
return selectTransaction(_that);case CreateTransactionEvent():
return createTransaction(_that);case PostTransactionEvent():
return postTransaction(_that);case DeleteTransactionEvent():
return deleteTransaction(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadTransactions value)?  loadTransactions,TResult? Function( SelectTransaction value)?  selectTransaction,TResult? Function( CreateTransactionEvent value)?  createTransaction,TResult? Function( PostTransactionEvent value)?  postTransaction,TResult? Function( DeleteTransactionEvent value)?  deleteTransaction,}){
final _that = this;
switch (_that) {
case LoadTransactions() when loadTransactions != null:
return loadTransactions(_that);case SelectTransaction() when selectTransaction != null:
return selectTransaction(_that);case CreateTransactionEvent() when createTransaction != null:
return createTransaction(_that);case PostTransactionEvent() when postTransaction != null:
return postTransaction(_that);case DeleteTransactionEvent() when deleteTransaction != null:
return deleteTransaction(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int? limit,  Perspective? perspective)?  loadTransactions,TResult Function( TransactionId id)?  selectTransaction,TResult Function( DateTime date,  String description,  List<JournalEntryLineInput> listLineInputs,  CounterpartyId? counterpartyId,  String? counterpartyName)?  createTransaction,TResult Function( TransactionId id,  PeriodId periodId)?  postTransaction,TResult Function( TransactionId id)?  deleteTransaction,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadTransactions() when loadTransactions != null:
return loadTransactions(_that.limit,_that.perspective);case SelectTransaction() when selectTransaction != null:
return selectTransaction(_that.id);case CreateTransactionEvent() when createTransaction != null:
return createTransaction(_that.date,_that.description,_that.listLineInputs,_that.counterpartyId,_that.counterpartyName);case PostTransactionEvent() when postTransaction != null:
return postTransaction(_that.id,_that.periodId);case DeleteTransactionEvent() when deleteTransaction != null:
return deleteTransaction(_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int? limit,  Perspective? perspective)  loadTransactions,required TResult Function( TransactionId id)  selectTransaction,required TResult Function( DateTime date,  String description,  List<JournalEntryLineInput> listLineInputs,  CounterpartyId? counterpartyId,  String? counterpartyName)  createTransaction,required TResult Function( TransactionId id,  PeriodId periodId)  postTransaction,required TResult Function( TransactionId id)  deleteTransaction,}) {final _that = this;
switch (_that) {
case LoadTransactions():
return loadTransactions(_that.limit,_that.perspective);case SelectTransaction():
return selectTransaction(_that.id);case CreateTransactionEvent():
return createTransaction(_that.date,_that.description,_that.listLineInputs,_that.counterpartyId,_that.counterpartyName);case PostTransactionEvent():
return postTransaction(_that.id,_that.periodId);case DeleteTransactionEvent():
return deleteTransaction(_that.id);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int? limit,  Perspective? perspective)?  loadTransactions,TResult? Function( TransactionId id)?  selectTransaction,TResult? Function( DateTime date,  String description,  List<JournalEntryLineInput> listLineInputs,  CounterpartyId? counterpartyId,  String? counterpartyName)?  createTransaction,TResult? Function( TransactionId id,  PeriodId periodId)?  postTransaction,TResult? Function( TransactionId id)?  deleteTransaction,}) {final _that = this;
switch (_that) {
case LoadTransactions() when loadTransactions != null:
return loadTransactions(_that.limit,_that.perspective);case SelectTransaction() when selectTransaction != null:
return selectTransaction(_that.id);case CreateTransactionEvent() when createTransaction != null:
return createTransaction(_that.date,_that.description,_that.listLineInputs,_that.counterpartyId,_that.counterpartyName);case PostTransactionEvent() when postTransaction != null:
return postTransaction(_that.id,_that.periodId);case DeleteTransactionEvent() when deleteTransaction != null:
return deleteTransaction(_that.id);case _:
  return null;

}
}

}

/// @nodoc


class LoadTransactions implements JournalEvent {
  const LoadTransactions({this.limit, this.perspective});
  

 final  int? limit;
 final  Perspective? perspective;

/// Create a copy of JournalEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadTransactionsCopyWith<LoadTransactions> get copyWith => _$LoadTransactionsCopyWithImpl<LoadTransactions>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadTransactions&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.perspective, perspective) || other.perspective == perspective));
}


@override
int get hashCode => Object.hash(runtimeType,limit,perspective);

@override
String toString() {
  return 'JournalEvent.loadTransactions(limit: $limit, perspective: $perspective)';
}


}

/// @nodoc
abstract mixin class $LoadTransactionsCopyWith<$Res> implements $JournalEventCopyWith<$Res> {
  factory $LoadTransactionsCopyWith(LoadTransactions value, $Res Function(LoadTransactions) _then) = _$LoadTransactionsCopyWithImpl;
@useResult
$Res call({
 int? limit, Perspective? perspective
});


$PerspectiveCopyWith<$Res>? get perspective;

}
/// @nodoc
class _$LoadTransactionsCopyWithImpl<$Res>
    implements $LoadTransactionsCopyWith<$Res> {
  _$LoadTransactionsCopyWithImpl(this._self, this._then);

  final LoadTransactions _self;
  final $Res Function(LoadTransactions) _then;

/// Create a copy of JournalEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? limit = freezed,Object? perspective = freezed,}) {
  return _then(LoadTransactions(
limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,perspective: freezed == perspective ? _self.perspective : perspective // ignore: cast_nullable_to_non_nullable
as Perspective?,
  ));
}

/// Create a copy of JournalEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PerspectiveCopyWith<$Res>? get perspective {
    if (_self.perspective == null) {
    return null;
  }

  return $PerspectiveCopyWith<$Res>(_self.perspective!, (value) {
    return _then(_self.copyWith(perspective: value));
  });
}
}

/// @nodoc


class SelectTransaction implements JournalEvent {
  const SelectTransaction({required this.id});
  

 final  TransactionId id;

/// Create a copy of JournalEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SelectTransactionCopyWith<SelectTransaction> get copyWith => _$SelectTransactionCopyWithImpl<SelectTransaction>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelectTransaction&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'JournalEvent.selectTransaction(id: $id)';
}


}

/// @nodoc
abstract mixin class $SelectTransactionCopyWith<$Res> implements $JournalEventCopyWith<$Res> {
  factory $SelectTransactionCopyWith(SelectTransaction value, $Res Function(SelectTransaction) _then) = _$SelectTransactionCopyWithImpl;
@useResult
$Res call({
 TransactionId id
});




}
/// @nodoc
class _$SelectTransactionCopyWithImpl<$Res>
    implements $SelectTransactionCopyWith<$Res> {
  _$SelectTransactionCopyWithImpl(this._self, this._then);

  final SelectTransaction _self;
  final $Res Function(SelectTransaction) _then;

/// Create a copy of JournalEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(SelectTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as TransactionId,
  ));
}


}

/// @nodoc


class CreateTransactionEvent implements JournalEvent {
  const CreateTransactionEvent({required this.date, required this.description, required final  List<JournalEntryLineInput> listLineInputs, this.counterpartyId, this.counterpartyName}): _listLineInputs = listLineInputs;
  

 final  DateTime date;
 final  String description;
 final  List<JournalEntryLineInput> _listLineInputs;
 List<JournalEntryLineInput> get listLineInputs {
  if (_listLineInputs is EqualUnmodifiableListView) return _listLineInputs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_listLineInputs);
}

 final  CounterpartyId? counterpartyId;
 final  String? counterpartyName;

/// Create a copy of JournalEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateTransactionEventCopyWith<CreateTransactionEvent> get copyWith => _$CreateTransactionEventCopyWithImpl<CreateTransactionEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTransactionEvent&&(identical(other.date, date) || other.date == date)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._listLineInputs, _listLineInputs)&&(identical(other.counterpartyId, counterpartyId) || other.counterpartyId == counterpartyId)&&(identical(other.counterpartyName, counterpartyName) || other.counterpartyName == counterpartyName));
}


@override
int get hashCode => Object.hash(runtimeType,date,description,const DeepCollectionEquality().hash(_listLineInputs),counterpartyId,counterpartyName);

@override
String toString() {
  return 'JournalEvent.createTransaction(date: $date, description: $description, listLineInputs: $listLineInputs, counterpartyId: $counterpartyId, counterpartyName: $counterpartyName)';
}


}

/// @nodoc
abstract mixin class $CreateTransactionEventCopyWith<$Res> implements $JournalEventCopyWith<$Res> {
  factory $CreateTransactionEventCopyWith(CreateTransactionEvent value, $Res Function(CreateTransactionEvent) _then) = _$CreateTransactionEventCopyWithImpl;
@useResult
$Res call({
 DateTime date, String description, List<JournalEntryLineInput> listLineInputs, CounterpartyId? counterpartyId, String? counterpartyName
});




}
/// @nodoc
class _$CreateTransactionEventCopyWithImpl<$Res>
    implements $CreateTransactionEventCopyWith<$Res> {
  _$CreateTransactionEventCopyWithImpl(this._self, this._then);

  final CreateTransactionEvent _self;
  final $Res Function(CreateTransactionEvent) _then;

/// Create a copy of JournalEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? date = null,Object? description = null,Object? listLineInputs = null,Object? counterpartyId = freezed,Object? counterpartyName = freezed,}) {
  return _then(CreateTransactionEvent(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,listLineInputs: null == listLineInputs ? _self._listLineInputs : listLineInputs // ignore: cast_nullable_to_non_nullable
as List<JournalEntryLineInput>,counterpartyId: freezed == counterpartyId ? _self.counterpartyId : counterpartyId // ignore: cast_nullable_to_non_nullable
as CounterpartyId?,counterpartyName: freezed == counterpartyName ? _self.counterpartyName : counterpartyName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class PostTransactionEvent implements JournalEvent {
  const PostTransactionEvent({required this.id, required this.periodId});
  

 final  TransactionId id;
 final  PeriodId periodId;

/// Create a copy of JournalEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostTransactionEventCopyWith<PostTransactionEvent> get copyWith => _$PostTransactionEventCopyWithImpl<PostTransactionEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostTransactionEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.periodId, periodId) || other.periodId == periodId));
}


@override
int get hashCode => Object.hash(runtimeType,id,periodId);

@override
String toString() {
  return 'JournalEvent.postTransaction(id: $id, periodId: $periodId)';
}


}

/// @nodoc
abstract mixin class $PostTransactionEventCopyWith<$Res> implements $JournalEventCopyWith<$Res> {
  factory $PostTransactionEventCopyWith(PostTransactionEvent value, $Res Function(PostTransactionEvent) _then) = _$PostTransactionEventCopyWithImpl;
@useResult
$Res call({
 TransactionId id, PeriodId periodId
});




}
/// @nodoc
class _$PostTransactionEventCopyWithImpl<$Res>
    implements $PostTransactionEventCopyWith<$Res> {
  _$PostTransactionEventCopyWithImpl(this._self, this._then);

  final PostTransactionEvent _self;
  final $Res Function(PostTransactionEvent) _then;

/// Create a copy of JournalEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? periodId = null,}) {
  return _then(PostTransactionEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as TransactionId,periodId: null == periodId ? _self.periodId : periodId // ignore: cast_nullable_to_non_nullable
as PeriodId,
  ));
}


}

/// @nodoc


class DeleteTransactionEvent implements JournalEvent {
  const DeleteTransactionEvent({required this.id});
  

 final  TransactionId id;

/// Create a copy of JournalEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeleteTransactionEventCopyWith<DeleteTransactionEvent> get copyWith => _$DeleteTransactionEventCopyWithImpl<DeleteTransactionEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteTransactionEvent&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'JournalEvent.deleteTransaction(id: $id)';
}


}

/// @nodoc
abstract mixin class $DeleteTransactionEventCopyWith<$Res> implements $JournalEventCopyWith<$Res> {
  factory $DeleteTransactionEventCopyWith(DeleteTransactionEvent value, $Res Function(DeleteTransactionEvent) _then) = _$DeleteTransactionEventCopyWithImpl;
@useResult
$Res call({
 TransactionId id
});




}
/// @nodoc
class _$DeleteTransactionEventCopyWithImpl<$Res>
    implements $DeleteTransactionEventCopyWith<$Res> {
  _$DeleteTransactionEventCopyWithImpl(this._self, this._then);

  final DeleteTransactionEvent _self;
  final $Res Function(DeleteTransactionEvent) _then;

/// Create a copy of JournalEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(DeleteTransactionEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as TransactionId,
  ));
}


}

// dart format on
