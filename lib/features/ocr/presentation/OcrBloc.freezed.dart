// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'OcrBloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OcrEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OcrEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OcrEvent()';
}


}

/// @nodoc
class $OcrEventCopyWith<$Res>  {
$OcrEventCopyWith(OcrEvent _, $Res Function(OcrEvent) __);
}


/// Adds pattern-matching-related methods to [OcrEvent].
extension OcrEventPatterns on OcrEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CaptureImage value)?  captureImage,TResult Function( ProcessOcr value)?  processOcr,TResult Function( ClassifyTransaction value)?  classifyTransaction,TResult Function( UpdateOcrField value)?  updateField,TResult Function( ToggleRememberPattern value)?  toggleRememberPattern,TResult Function( SaveAsDraft value)?  saveAsDraft,TResult Function( RetryCapture value)?  retryCapture,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CaptureImage() when captureImage != null:
return captureImage(_that);case ProcessOcr() when processOcr != null:
return processOcr(_that);case ClassifyTransaction() when classifyTransaction != null:
return classifyTransaction(_that);case UpdateOcrField() when updateField != null:
return updateField(_that);case ToggleRememberPattern() when toggleRememberPattern != null:
return toggleRememberPattern(_that);case SaveAsDraft() when saveAsDraft != null:
return saveAsDraft(_that);case RetryCapture() when retryCapture != null:
return retryCapture(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CaptureImage value)  captureImage,required TResult Function( ProcessOcr value)  processOcr,required TResult Function( ClassifyTransaction value)  classifyTransaction,required TResult Function( UpdateOcrField value)  updateField,required TResult Function( ToggleRememberPattern value)  toggleRememberPattern,required TResult Function( SaveAsDraft value)  saveAsDraft,required TResult Function( RetryCapture value)  retryCapture,}){
final _that = this;
switch (_that) {
case CaptureImage():
return captureImage(_that);case ProcessOcr():
return processOcr(_that);case ClassifyTransaction():
return classifyTransaction(_that);case UpdateOcrField():
return updateField(_that);case ToggleRememberPattern():
return toggleRememberPattern(_that);case SaveAsDraft():
return saveAsDraft(_that);case RetryCapture():
return retryCapture(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CaptureImage value)?  captureImage,TResult? Function( ProcessOcr value)?  processOcr,TResult? Function( ClassifyTransaction value)?  classifyTransaction,TResult? Function( UpdateOcrField value)?  updateField,TResult? Function( ToggleRememberPattern value)?  toggleRememberPattern,TResult? Function( SaveAsDraft value)?  saveAsDraft,TResult? Function( RetryCapture value)?  retryCapture,}){
final _that = this;
switch (_that) {
case CaptureImage() when captureImage != null:
return captureImage(_that);case ProcessOcr() when processOcr != null:
return processOcr(_that);case ClassifyTransaction() when classifyTransaction != null:
return classifyTransaction(_that);case UpdateOcrField() when updateField != null:
return updateField(_that);case ToggleRememberPattern() when toggleRememberPattern != null:
return toggleRememberPattern(_that);case SaveAsDraft() when saveAsDraft != null:
return saveAsDraft(_that);case RetryCapture() when retryCapture != null:
return retryCapture(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( File image)?  captureImage,TResult Function( String rawText)?  processOcr,TResult Function( ParsedOcrData parsed)?  classifyTransaction,TResult Function( DateTime? date,  int? amount,  String? merchantName,  String? description,  AccountId? accountId)?  updateField,TResult Function( bool remember)?  toggleRememberPattern,TResult Function()?  saveAsDraft,TResult Function()?  retryCapture,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CaptureImage() when captureImage != null:
return captureImage(_that.image);case ProcessOcr() when processOcr != null:
return processOcr(_that.rawText);case ClassifyTransaction() when classifyTransaction != null:
return classifyTransaction(_that.parsed);case UpdateOcrField() when updateField != null:
return updateField(_that.date,_that.amount,_that.merchantName,_that.description,_that.accountId);case ToggleRememberPattern() when toggleRememberPattern != null:
return toggleRememberPattern(_that.remember);case SaveAsDraft() when saveAsDraft != null:
return saveAsDraft();case RetryCapture() when retryCapture != null:
return retryCapture();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( File image)  captureImage,required TResult Function( String rawText)  processOcr,required TResult Function( ParsedOcrData parsed)  classifyTransaction,required TResult Function( DateTime? date,  int? amount,  String? merchantName,  String? description,  AccountId? accountId)  updateField,required TResult Function( bool remember)  toggleRememberPattern,required TResult Function()  saveAsDraft,required TResult Function()  retryCapture,}) {final _that = this;
switch (_that) {
case CaptureImage():
return captureImage(_that.image);case ProcessOcr():
return processOcr(_that.rawText);case ClassifyTransaction():
return classifyTransaction(_that.parsed);case UpdateOcrField():
return updateField(_that.date,_that.amount,_that.merchantName,_that.description,_that.accountId);case ToggleRememberPattern():
return toggleRememberPattern(_that.remember);case SaveAsDraft():
return saveAsDraft();case RetryCapture():
return retryCapture();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( File image)?  captureImage,TResult? Function( String rawText)?  processOcr,TResult? Function( ParsedOcrData parsed)?  classifyTransaction,TResult? Function( DateTime? date,  int? amount,  String? merchantName,  String? description,  AccountId? accountId)?  updateField,TResult? Function( bool remember)?  toggleRememberPattern,TResult? Function()?  saveAsDraft,TResult? Function()?  retryCapture,}) {final _that = this;
switch (_that) {
case CaptureImage() when captureImage != null:
return captureImage(_that.image);case ProcessOcr() when processOcr != null:
return processOcr(_that.rawText);case ClassifyTransaction() when classifyTransaction != null:
return classifyTransaction(_that.parsed);case UpdateOcrField() when updateField != null:
return updateField(_that.date,_that.amount,_that.merchantName,_that.description,_that.accountId);case ToggleRememberPattern() when toggleRememberPattern != null:
return toggleRememberPattern(_that.remember);case SaveAsDraft() when saveAsDraft != null:
return saveAsDraft();case RetryCapture() when retryCapture != null:
return retryCapture();case _:
  return null;

}
}

}

/// @nodoc


class CaptureImage implements OcrEvent {
  const CaptureImage({required this.image});
  

 final  File image;

/// Create a copy of OcrEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CaptureImageCopyWith<CaptureImage> get copyWith => _$CaptureImageCopyWithImpl<CaptureImage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CaptureImage&&(identical(other.image, image) || other.image == image));
}


@override
int get hashCode => Object.hash(runtimeType,image);

@override
String toString() {
  return 'OcrEvent.captureImage(image: $image)';
}


}

/// @nodoc
abstract mixin class $CaptureImageCopyWith<$Res> implements $OcrEventCopyWith<$Res> {
  factory $CaptureImageCopyWith(CaptureImage value, $Res Function(CaptureImage) _then) = _$CaptureImageCopyWithImpl;
@useResult
$Res call({
 File image
});




}
/// @nodoc
class _$CaptureImageCopyWithImpl<$Res>
    implements $CaptureImageCopyWith<$Res> {
  _$CaptureImageCopyWithImpl(this._self, this._then);

  final CaptureImage _self;
  final $Res Function(CaptureImage) _then;

/// Create a copy of OcrEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? image = null,}) {
  return _then(CaptureImage(
image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as File,
  ));
}


}

/// @nodoc


class ProcessOcr implements OcrEvent {
  const ProcessOcr({required this.rawText});
  

 final  String rawText;

/// Create a copy of OcrEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProcessOcrCopyWith<ProcessOcr> get copyWith => _$ProcessOcrCopyWithImpl<ProcessOcr>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProcessOcr&&(identical(other.rawText, rawText) || other.rawText == rawText));
}


@override
int get hashCode => Object.hash(runtimeType,rawText);

@override
String toString() {
  return 'OcrEvent.processOcr(rawText: $rawText)';
}


}

/// @nodoc
abstract mixin class $ProcessOcrCopyWith<$Res> implements $OcrEventCopyWith<$Res> {
  factory $ProcessOcrCopyWith(ProcessOcr value, $Res Function(ProcessOcr) _then) = _$ProcessOcrCopyWithImpl;
@useResult
$Res call({
 String rawText
});




}
/// @nodoc
class _$ProcessOcrCopyWithImpl<$Res>
    implements $ProcessOcrCopyWith<$Res> {
  _$ProcessOcrCopyWithImpl(this._self, this._then);

  final ProcessOcr _self;
  final $Res Function(ProcessOcr) _then;

/// Create a copy of OcrEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? rawText = null,}) {
  return _then(ProcessOcr(
rawText: null == rawText ? _self.rawText : rawText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ClassifyTransaction implements OcrEvent {
  const ClassifyTransaction({required this.parsed});
  

 final  ParsedOcrData parsed;

/// Create a copy of OcrEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClassifyTransactionCopyWith<ClassifyTransaction> get copyWith => _$ClassifyTransactionCopyWithImpl<ClassifyTransaction>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClassifyTransaction&&(identical(other.parsed, parsed) || other.parsed == parsed));
}


@override
int get hashCode => Object.hash(runtimeType,parsed);

@override
String toString() {
  return 'OcrEvent.classifyTransaction(parsed: $parsed)';
}


}

/// @nodoc
abstract mixin class $ClassifyTransactionCopyWith<$Res> implements $OcrEventCopyWith<$Res> {
  factory $ClassifyTransactionCopyWith(ClassifyTransaction value, $Res Function(ClassifyTransaction) _then) = _$ClassifyTransactionCopyWithImpl;
@useResult
$Res call({
 ParsedOcrData parsed
});




}
/// @nodoc
class _$ClassifyTransactionCopyWithImpl<$Res>
    implements $ClassifyTransactionCopyWith<$Res> {
  _$ClassifyTransactionCopyWithImpl(this._self, this._then);

  final ClassifyTransaction _self;
  final $Res Function(ClassifyTransaction) _then;

/// Create a copy of OcrEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? parsed = null,}) {
  return _then(ClassifyTransaction(
parsed: null == parsed ? _self.parsed : parsed // ignore: cast_nullable_to_non_nullable
as ParsedOcrData,
  ));
}


}

/// @nodoc


class UpdateOcrField implements OcrEvent {
  const UpdateOcrField({this.date, this.amount, this.merchantName, this.description, this.accountId});
  

 final  DateTime? date;
 final  int? amount;
 final  String? merchantName;
 final  String? description;
 final  AccountId? accountId;

/// Create a copy of OcrEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateOcrFieldCopyWith<UpdateOcrField> get copyWith => _$UpdateOcrFieldCopyWithImpl<UpdateOcrField>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateOcrField&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.merchantName, merchantName) || other.merchantName == merchantName)&&(identical(other.description, description) || other.description == description)&&(identical(other.accountId, accountId) || other.accountId == accountId));
}


@override
int get hashCode => Object.hash(runtimeType,date,amount,merchantName,description,accountId);

@override
String toString() {
  return 'OcrEvent.updateField(date: $date, amount: $amount, merchantName: $merchantName, description: $description, accountId: $accountId)';
}


}

/// @nodoc
abstract mixin class $UpdateOcrFieldCopyWith<$Res> implements $OcrEventCopyWith<$Res> {
  factory $UpdateOcrFieldCopyWith(UpdateOcrField value, $Res Function(UpdateOcrField) _then) = _$UpdateOcrFieldCopyWithImpl;
@useResult
$Res call({
 DateTime? date, int? amount, String? merchantName, String? description, AccountId? accountId
});




}
/// @nodoc
class _$UpdateOcrFieldCopyWithImpl<$Res>
    implements $UpdateOcrFieldCopyWith<$Res> {
  _$UpdateOcrFieldCopyWithImpl(this._self, this._then);

  final UpdateOcrField _self;
  final $Res Function(UpdateOcrField) _then;

/// Create a copy of OcrEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? date = freezed,Object? amount = freezed,Object? merchantName = freezed,Object? description = freezed,Object? accountId = freezed,}) {
  return _then(UpdateOcrField(
date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int?,merchantName: freezed == merchantName ? _self.merchantName : merchantName // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as AccountId?,
  ));
}


}

/// @nodoc


class ToggleRememberPattern implements OcrEvent {
  const ToggleRememberPattern({required this.remember});
  

 final  bool remember;

/// Create a copy of OcrEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ToggleRememberPatternCopyWith<ToggleRememberPattern> get copyWith => _$ToggleRememberPatternCopyWithImpl<ToggleRememberPattern>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ToggleRememberPattern&&(identical(other.remember, remember) || other.remember == remember));
}


@override
int get hashCode => Object.hash(runtimeType,remember);

@override
String toString() {
  return 'OcrEvent.toggleRememberPattern(remember: $remember)';
}


}

/// @nodoc
abstract mixin class $ToggleRememberPatternCopyWith<$Res> implements $OcrEventCopyWith<$Res> {
  factory $ToggleRememberPatternCopyWith(ToggleRememberPattern value, $Res Function(ToggleRememberPattern) _then) = _$ToggleRememberPatternCopyWithImpl;
@useResult
$Res call({
 bool remember
});




}
/// @nodoc
class _$ToggleRememberPatternCopyWithImpl<$Res>
    implements $ToggleRememberPatternCopyWith<$Res> {
  _$ToggleRememberPatternCopyWithImpl(this._self, this._then);

  final ToggleRememberPattern _self;
  final $Res Function(ToggleRememberPattern) _then;

/// Create a copy of OcrEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? remember = null,}) {
  return _then(ToggleRememberPattern(
remember: null == remember ? _self.remember : remember // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class SaveAsDraft implements OcrEvent {
  const SaveAsDraft();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaveAsDraft);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OcrEvent.saveAsDraft()';
}


}




/// @nodoc


class RetryCapture implements OcrEvent {
  const RetryCapture();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RetryCapture);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OcrEvent.retryCapture()';
}


}




/// @nodoc
mixin _$OcrState {

 OcrPhase get phase;/// OCR 파싱 결과
 ParsedOcrData? get parsed;/// 분류 엔진 결과
 ClassificationResult? get classified;/// 분류 신뢰도 (0.0 ~ 1.0)
 double get confidence;/// "이 패턴 기억하기" 체크 여부
 bool get rememberPattern;/// 사용자가 수동 수정한 accountId (분류 결과 override)
 AccountId? get overriddenAccountId;/// 최종 저장된 Draft
 Transaction? get savedDraft;/// 오류 메시지
 String? get errorMessage;
/// Create a copy of OcrState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OcrStateCopyWith<OcrState> get copyWith => _$OcrStateCopyWithImpl<OcrState>(this as OcrState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OcrState&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.parsed, parsed) || other.parsed == parsed)&&(identical(other.classified, classified) || other.classified == classified)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.rememberPattern, rememberPattern) || other.rememberPattern == rememberPattern)&&(identical(other.overriddenAccountId, overriddenAccountId) || other.overriddenAccountId == overriddenAccountId)&&(identical(other.savedDraft, savedDraft) || other.savedDraft == savedDraft)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,phase,parsed,classified,confidence,rememberPattern,overriddenAccountId,savedDraft,errorMessage);

@override
String toString() {
  return 'OcrState(phase: $phase, parsed: $parsed, classified: $classified, confidence: $confidence, rememberPattern: $rememberPattern, overriddenAccountId: $overriddenAccountId, savedDraft: $savedDraft, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $OcrStateCopyWith<$Res>  {
  factory $OcrStateCopyWith(OcrState value, $Res Function(OcrState) _then) = _$OcrStateCopyWithImpl;
@useResult
$Res call({
 OcrPhase phase, ParsedOcrData? parsed, ClassificationResult? classified, double confidence, bool rememberPattern, AccountId? overriddenAccountId, Transaction? savedDraft, String? errorMessage
});


$TransactionCopyWith<$Res>? get savedDraft;

}
/// @nodoc
class _$OcrStateCopyWithImpl<$Res>
    implements $OcrStateCopyWith<$Res> {
  _$OcrStateCopyWithImpl(this._self, this._then);

  final OcrState _self;
  final $Res Function(OcrState) _then;

/// Create a copy of OcrState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phase = null,Object? parsed = freezed,Object? classified = freezed,Object? confidence = null,Object? rememberPattern = null,Object? overriddenAccountId = freezed,Object? savedDraft = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as OcrPhase,parsed: freezed == parsed ? _self.parsed : parsed // ignore: cast_nullable_to_non_nullable
as ParsedOcrData?,classified: freezed == classified ? _self.classified : classified // ignore: cast_nullable_to_non_nullable
as ClassificationResult?,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,rememberPattern: null == rememberPattern ? _self.rememberPattern : rememberPattern // ignore: cast_nullable_to_non_nullable
as bool,overriddenAccountId: freezed == overriddenAccountId ? _self.overriddenAccountId : overriddenAccountId // ignore: cast_nullable_to_non_nullable
as AccountId?,savedDraft: freezed == savedDraft ? _self.savedDraft : savedDraft // ignore: cast_nullable_to_non_nullable
as Transaction?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of OcrState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionCopyWith<$Res>? get savedDraft {
    if (_self.savedDraft == null) {
    return null;
  }

  return $TransactionCopyWith<$Res>(_self.savedDraft!, (value) {
    return _then(_self.copyWith(savedDraft: value));
  });
}
}


/// Adds pattern-matching-related methods to [OcrState].
extension OcrStatePatterns on OcrState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OcrState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OcrState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OcrState value)  $default,){
final _that = this;
switch (_that) {
case _OcrState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OcrState value)?  $default,){
final _that = this;
switch (_that) {
case _OcrState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( OcrPhase phase,  ParsedOcrData? parsed,  ClassificationResult? classified,  double confidence,  bool rememberPattern,  AccountId? overriddenAccountId,  Transaction? savedDraft,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OcrState() when $default != null:
return $default(_that.phase,_that.parsed,_that.classified,_that.confidence,_that.rememberPattern,_that.overriddenAccountId,_that.savedDraft,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( OcrPhase phase,  ParsedOcrData? parsed,  ClassificationResult? classified,  double confidence,  bool rememberPattern,  AccountId? overriddenAccountId,  Transaction? savedDraft,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _OcrState():
return $default(_that.phase,_that.parsed,_that.classified,_that.confidence,_that.rememberPattern,_that.overriddenAccountId,_that.savedDraft,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( OcrPhase phase,  ParsedOcrData? parsed,  ClassificationResult? classified,  double confidence,  bool rememberPattern,  AccountId? overriddenAccountId,  Transaction? savedDraft,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _OcrState() when $default != null:
return $default(_that.phase,_that.parsed,_that.classified,_that.confidence,_that.rememberPattern,_that.overriddenAccountId,_that.savedDraft,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _OcrState implements OcrState {
  const _OcrState({this.phase = OcrPhase.idle, this.parsed, this.classified, this.confidence = 0.0, this.rememberPattern = false, this.overriddenAccountId, this.savedDraft, this.errorMessage});
  

@override@JsonKey() final  OcrPhase phase;
/// OCR 파싱 결과
@override final  ParsedOcrData? parsed;
/// 분류 엔진 결과
@override final  ClassificationResult? classified;
/// 분류 신뢰도 (0.0 ~ 1.0)
@override@JsonKey() final  double confidence;
/// "이 패턴 기억하기" 체크 여부
@override@JsonKey() final  bool rememberPattern;
/// 사용자가 수동 수정한 accountId (분류 결과 override)
@override final  AccountId? overriddenAccountId;
/// 최종 저장된 Draft
@override final  Transaction? savedDraft;
/// 오류 메시지
@override final  String? errorMessage;

/// Create a copy of OcrState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OcrStateCopyWith<_OcrState> get copyWith => __$OcrStateCopyWithImpl<_OcrState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OcrState&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.parsed, parsed) || other.parsed == parsed)&&(identical(other.classified, classified) || other.classified == classified)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.rememberPattern, rememberPattern) || other.rememberPattern == rememberPattern)&&(identical(other.overriddenAccountId, overriddenAccountId) || other.overriddenAccountId == overriddenAccountId)&&(identical(other.savedDraft, savedDraft) || other.savedDraft == savedDraft)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,phase,parsed,classified,confidence,rememberPattern,overriddenAccountId,savedDraft,errorMessage);

@override
String toString() {
  return 'OcrState(phase: $phase, parsed: $parsed, classified: $classified, confidence: $confidence, rememberPattern: $rememberPattern, overriddenAccountId: $overriddenAccountId, savedDraft: $savedDraft, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$OcrStateCopyWith<$Res> implements $OcrStateCopyWith<$Res> {
  factory _$OcrStateCopyWith(_OcrState value, $Res Function(_OcrState) _then) = __$OcrStateCopyWithImpl;
@override @useResult
$Res call({
 OcrPhase phase, ParsedOcrData? parsed, ClassificationResult? classified, double confidence, bool rememberPattern, AccountId? overriddenAccountId, Transaction? savedDraft, String? errorMessage
});


@override $TransactionCopyWith<$Res>? get savedDraft;

}
/// @nodoc
class __$OcrStateCopyWithImpl<$Res>
    implements _$OcrStateCopyWith<$Res> {
  __$OcrStateCopyWithImpl(this._self, this._then);

  final _OcrState _self;
  final $Res Function(_OcrState) _then;

/// Create a copy of OcrState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phase = null,Object? parsed = freezed,Object? classified = freezed,Object? confidence = null,Object? rememberPattern = null,Object? overriddenAccountId = freezed,Object? savedDraft = freezed,Object? errorMessage = freezed,}) {
  return _then(_OcrState(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as OcrPhase,parsed: freezed == parsed ? _self.parsed : parsed // ignore: cast_nullable_to_non_nullable
as ParsedOcrData?,classified: freezed == classified ? _self.classified : classified // ignore: cast_nullable_to_non_nullable
as ClassificationResult?,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,rememberPattern: null == rememberPattern ? _self.rememberPattern : rememberPattern // ignore: cast_nullable_to_non_nullable
as bool,overriddenAccountId: freezed == overriddenAccountId ? _self.overriddenAccountId : overriddenAccountId // ignore: cast_nullable_to_non_nullable
as AccountId?,savedDraft: freezed == savedDraft ? _self.savedDraft : savedDraft // ignore: cast_nullable_to_non_nullable
as Transaction?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of OcrState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionCopyWith<$Res>? get savedDraft {
    if (_self.savedDraft == null) {
    return null;
  }

  return $TransactionCopyWith<$Res>(_self.savedDraft!, (value) {
    return _then(_self.copyWith(savedDraft: value));
  });
}
}

// dart format on
