// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'PeriodComparison.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PeriodComparison {

 int get currentValue; int get previousValue;/// 증감액 (current - previous)
 int get changeAmount;/// 계정 경로 레이블 (equityTypePath)
 String get label;/// 증감률 (배율 10000)
 int get changeRatio;/// 비교 유형
 String get comparisonType;
/// Create a copy of PeriodComparison
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PeriodComparisonCopyWith<PeriodComparison> get copyWith => _$PeriodComparisonCopyWithImpl<PeriodComparison>(this as PeriodComparison, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PeriodComparison&&(identical(other.currentValue, currentValue) || other.currentValue == currentValue)&&(identical(other.previousValue, previousValue) || other.previousValue == previousValue)&&(identical(other.changeAmount, changeAmount) || other.changeAmount == changeAmount)&&(identical(other.label, label) || other.label == label)&&(identical(other.changeRatio, changeRatio) || other.changeRatio == changeRatio)&&(identical(other.comparisonType, comparisonType) || other.comparisonType == comparisonType));
}


@override
int get hashCode => Object.hash(runtimeType,currentValue,previousValue,changeAmount,label,changeRatio,comparisonType);

@override
String toString() {
  return 'PeriodComparison(currentValue: $currentValue, previousValue: $previousValue, changeAmount: $changeAmount, label: $label, changeRatio: $changeRatio, comparisonType: $comparisonType)';
}


}

/// @nodoc
abstract mixin class $PeriodComparisonCopyWith<$Res>  {
  factory $PeriodComparisonCopyWith(PeriodComparison value, $Res Function(PeriodComparison) _then) = _$PeriodComparisonCopyWithImpl;
@useResult
$Res call({
 int currentValue, int previousValue, int changeAmount, String label, int changeRatio, String comparisonType
});




}
/// @nodoc
class _$PeriodComparisonCopyWithImpl<$Res>
    implements $PeriodComparisonCopyWith<$Res> {
  _$PeriodComparisonCopyWithImpl(this._self, this._then);

  final PeriodComparison _self;
  final $Res Function(PeriodComparison) _then;

/// Create a copy of PeriodComparison
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentValue = null,Object? previousValue = null,Object? changeAmount = null,Object? label = null,Object? changeRatio = null,Object? comparisonType = null,}) {
  return _then(_self.copyWith(
currentValue: null == currentValue ? _self.currentValue : currentValue // ignore: cast_nullable_to_non_nullable
as int,previousValue: null == previousValue ? _self.previousValue : previousValue // ignore: cast_nullable_to_non_nullable
as int,changeAmount: null == changeAmount ? _self.changeAmount : changeAmount // ignore: cast_nullable_to_non_nullable
as int,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,changeRatio: null == changeRatio ? _self.changeRatio : changeRatio // ignore: cast_nullable_to_non_nullable
as int,comparisonType: null == comparisonType ? _self.comparisonType : comparisonType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PeriodComparison].
extension PeriodComparisonPatterns on PeriodComparison {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PeriodComparison value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PeriodComparison() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PeriodComparison value)  $default,){
final _that = this;
switch (_that) {
case _PeriodComparison():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PeriodComparison value)?  $default,){
final _that = this;
switch (_that) {
case _PeriodComparison() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentValue,  int previousValue,  int changeAmount,  String label,  int changeRatio,  String comparisonType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PeriodComparison() when $default != null:
return $default(_that.currentValue,_that.previousValue,_that.changeAmount,_that.label,_that.changeRatio,_that.comparisonType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentValue,  int previousValue,  int changeAmount,  String label,  int changeRatio,  String comparisonType)  $default,) {final _that = this;
switch (_that) {
case _PeriodComparison():
return $default(_that.currentValue,_that.previousValue,_that.changeAmount,_that.label,_that.changeRatio,_that.comparisonType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentValue,  int previousValue,  int changeAmount,  String label,  int changeRatio,  String comparisonType)?  $default,) {final _that = this;
switch (_that) {
case _PeriodComparison() when $default != null:
return $default(_that.currentValue,_that.previousValue,_that.changeAmount,_that.label,_that.changeRatio,_that.comparisonType);case _:
  return null;

}
}

}

/// @nodoc


class _PeriodComparison implements PeriodComparison {
  const _PeriodComparison({required this.currentValue, required this.previousValue, required this.changeAmount, required this.label, required this.changeRatio, required this.comparisonType});
  

@override final  int currentValue;
@override final  int previousValue;
/// 증감액 (current - previous)
@override final  int changeAmount;
/// 계정 경로 레이블 (equityTypePath)
@override final  String label;
/// 증감률 (배율 10000)
@override final  int changeRatio;
/// 비교 유형
@override final  String comparisonType;

/// Create a copy of PeriodComparison
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PeriodComparisonCopyWith<_PeriodComparison> get copyWith => __$PeriodComparisonCopyWithImpl<_PeriodComparison>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PeriodComparison&&(identical(other.currentValue, currentValue) || other.currentValue == currentValue)&&(identical(other.previousValue, previousValue) || other.previousValue == previousValue)&&(identical(other.changeAmount, changeAmount) || other.changeAmount == changeAmount)&&(identical(other.label, label) || other.label == label)&&(identical(other.changeRatio, changeRatio) || other.changeRatio == changeRatio)&&(identical(other.comparisonType, comparisonType) || other.comparisonType == comparisonType));
}


@override
int get hashCode => Object.hash(runtimeType,currentValue,previousValue,changeAmount,label,changeRatio,comparisonType);

@override
String toString() {
  return 'PeriodComparison(currentValue: $currentValue, previousValue: $previousValue, changeAmount: $changeAmount, label: $label, changeRatio: $changeRatio, comparisonType: $comparisonType)';
}


}

/// @nodoc
abstract mixin class _$PeriodComparisonCopyWith<$Res> implements $PeriodComparisonCopyWith<$Res> {
  factory _$PeriodComparisonCopyWith(_PeriodComparison value, $Res Function(_PeriodComparison) _then) = __$PeriodComparisonCopyWithImpl;
@override @useResult
$Res call({
 int currentValue, int previousValue, int changeAmount, String label, int changeRatio, String comparisonType
});




}
/// @nodoc
class __$PeriodComparisonCopyWithImpl<$Res>
    implements _$PeriodComparisonCopyWith<$Res> {
  __$PeriodComparisonCopyWithImpl(this._self, this._then);

  final _PeriodComparison _self;
  final $Res Function(_PeriodComparison) _then;

/// Create a copy of PeriodComparison
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentValue = null,Object? previousValue = null,Object? changeAmount = null,Object? label = null,Object? changeRatio = null,Object? comparisonType = null,}) {
  return _then(_PeriodComparison(
currentValue: null == currentValue ? _self.currentValue : currentValue // ignore: cast_nullable_to_non_nullable
as int,previousValue: null == previousValue ? _self.previousValue : previousValue // ignore: cast_nullable_to_non_nullable
as int,changeAmount: null == changeAmount ? _self.changeAmount : changeAmount // ignore: cast_nullable_to_non_nullable
as int,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,changeRatio: null == changeRatio ? _self.changeRatio : changeRatio // ignore: cast_nullable_to_non_nullable
as int,comparisonType: null == comparisonType ? _self.comparisonType : comparisonType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
