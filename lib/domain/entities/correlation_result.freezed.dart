// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'correlation_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CorrelationResult {

 String get variableA; String get variableB; double get correlationCoefficient; double get pValue; int get sampleSize; int get lag; bool get isSignificant;
/// Create a copy of CorrelationResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CorrelationResultCopyWith<CorrelationResult> get copyWith => _$CorrelationResultCopyWithImpl<CorrelationResult>(this as CorrelationResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CorrelationResult&&(identical(other.variableA, variableA) || other.variableA == variableA)&&(identical(other.variableB, variableB) || other.variableB == variableB)&&(identical(other.correlationCoefficient, correlationCoefficient) || other.correlationCoefficient == correlationCoefficient)&&(identical(other.pValue, pValue) || other.pValue == pValue)&&(identical(other.sampleSize, sampleSize) || other.sampleSize == sampleSize)&&(identical(other.lag, lag) || other.lag == lag)&&(identical(other.isSignificant, isSignificant) || other.isSignificant == isSignificant));
}


@override
int get hashCode => Object.hash(runtimeType,variableA,variableB,correlationCoefficient,pValue,sampleSize,lag,isSignificant);

@override
String toString() {
  return 'CorrelationResult(variableA: $variableA, variableB: $variableB, correlationCoefficient: $correlationCoefficient, pValue: $pValue, sampleSize: $sampleSize, lag: $lag, isSignificant: $isSignificant)';
}


}

/// @nodoc
abstract mixin class $CorrelationResultCopyWith<$Res>  {
  factory $CorrelationResultCopyWith(CorrelationResult value, $Res Function(CorrelationResult) _then) = _$CorrelationResultCopyWithImpl;
@useResult
$Res call({
 String variableA, String variableB, double correlationCoefficient, double pValue, int sampleSize, int lag, bool isSignificant
});




}
/// @nodoc
class _$CorrelationResultCopyWithImpl<$Res>
    implements $CorrelationResultCopyWith<$Res> {
  _$CorrelationResultCopyWithImpl(this._self, this._then);

  final CorrelationResult _self;
  final $Res Function(CorrelationResult) _then;

/// Create a copy of CorrelationResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? variableA = null,Object? variableB = null,Object? correlationCoefficient = null,Object? pValue = null,Object? sampleSize = null,Object? lag = null,Object? isSignificant = null,}) {
  return _then(_self.copyWith(
variableA: null == variableA ? _self.variableA : variableA // ignore: cast_nullable_to_non_nullable
as String,variableB: null == variableB ? _self.variableB : variableB // ignore: cast_nullable_to_non_nullable
as String,correlationCoefficient: null == correlationCoefficient ? _self.correlationCoefficient : correlationCoefficient // ignore: cast_nullable_to_non_nullable
as double,pValue: null == pValue ? _self.pValue : pValue // ignore: cast_nullable_to_non_nullable
as double,sampleSize: null == sampleSize ? _self.sampleSize : sampleSize // ignore: cast_nullable_to_non_nullable
as int,lag: null == lag ? _self.lag : lag // ignore: cast_nullable_to_non_nullable
as int,isSignificant: null == isSignificant ? _self.isSignificant : isSignificant // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CorrelationResult].
extension CorrelationResultPatterns on CorrelationResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CorrelationResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CorrelationResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CorrelationResult value)  $default,){
final _that = this;
switch (_that) {
case _CorrelationResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CorrelationResult value)?  $default,){
final _that = this;
switch (_that) {
case _CorrelationResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String variableA,  String variableB,  double correlationCoefficient,  double pValue,  int sampleSize,  int lag,  bool isSignificant)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CorrelationResult() when $default != null:
return $default(_that.variableA,_that.variableB,_that.correlationCoefficient,_that.pValue,_that.sampleSize,_that.lag,_that.isSignificant);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String variableA,  String variableB,  double correlationCoefficient,  double pValue,  int sampleSize,  int lag,  bool isSignificant)  $default,) {final _that = this;
switch (_that) {
case _CorrelationResult():
return $default(_that.variableA,_that.variableB,_that.correlationCoefficient,_that.pValue,_that.sampleSize,_that.lag,_that.isSignificant);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String variableA,  String variableB,  double correlationCoefficient,  double pValue,  int sampleSize,  int lag,  bool isSignificant)?  $default,) {final _that = this;
switch (_that) {
case _CorrelationResult() when $default != null:
return $default(_that.variableA,_that.variableB,_that.correlationCoefficient,_that.pValue,_that.sampleSize,_that.lag,_that.isSignificant);case _:
  return null;

}
}

}

/// @nodoc


class _CorrelationResult implements CorrelationResult {
  const _CorrelationResult({required this.variableA, required this.variableB, required this.correlationCoefficient, required this.pValue, required this.sampleSize, required this.lag, required this.isSignificant});
  

@override final  String variableA;
@override final  String variableB;
@override final  double correlationCoefficient;
@override final  double pValue;
@override final  int sampleSize;
@override final  int lag;
@override final  bool isSignificant;

/// Create a copy of CorrelationResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CorrelationResultCopyWith<_CorrelationResult> get copyWith => __$CorrelationResultCopyWithImpl<_CorrelationResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CorrelationResult&&(identical(other.variableA, variableA) || other.variableA == variableA)&&(identical(other.variableB, variableB) || other.variableB == variableB)&&(identical(other.correlationCoefficient, correlationCoefficient) || other.correlationCoefficient == correlationCoefficient)&&(identical(other.pValue, pValue) || other.pValue == pValue)&&(identical(other.sampleSize, sampleSize) || other.sampleSize == sampleSize)&&(identical(other.lag, lag) || other.lag == lag)&&(identical(other.isSignificant, isSignificant) || other.isSignificant == isSignificant));
}


@override
int get hashCode => Object.hash(runtimeType,variableA,variableB,correlationCoefficient,pValue,sampleSize,lag,isSignificant);

@override
String toString() {
  return 'CorrelationResult(variableA: $variableA, variableB: $variableB, correlationCoefficient: $correlationCoefficient, pValue: $pValue, sampleSize: $sampleSize, lag: $lag, isSignificant: $isSignificant)';
}


}

/// @nodoc
abstract mixin class _$CorrelationResultCopyWith<$Res> implements $CorrelationResultCopyWith<$Res> {
  factory _$CorrelationResultCopyWith(_CorrelationResult value, $Res Function(_CorrelationResult) _then) = __$CorrelationResultCopyWithImpl;
@override @useResult
$Res call({
 String variableA, String variableB, double correlationCoefficient, double pValue, int sampleSize, int lag, bool isSignificant
});




}
/// @nodoc
class __$CorrelationResultCopyWithImpl<$Res>
    implements _$CorrelationResultCopyWith<$Res> {
  __$CorrelationResultCopyWithImpl(this._self, this._then);

  final _CorrelationResult _self;
  final $Res Function(_CorrelationResult) _then;

/// Create a copy of CorrelationResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? variableA = null,Object? variableB = null,Object? correlationCoefficient = null,Object? pValue = null,Object? sampleSize = null,Object? lag = null,Object? isSignificant = null,}) {
  return _then(_CorrelationResult(
variableA: null == variableA ? _self.variableA : variableA // ignore: cast_nullable_to_non_nullable
as String,variableB: null == variableB ? _self.variableB : variableB // ignore: cast_nullable_to_non_nullable
as String,correlationCoefficient: null == correlationCoefficient ? _self.correlationCoefficient : correlationCoefficient // ignore: cast_nullable_to_non_nullable
as double,pValue: null == pValue ? _self.pValue : pValue // ignore: cast_nullable_to_non_nullable
as double,sampleSize: null == sampleSize ? _self.sampleSize : sampleSize // ignore: cast_nullable_to_non_nullable
as int,lag: null == lag ? _self.lag : lag // ignore: cast_nullable_to_non_nullable
as int,isSignificant: null == isSignificant ? _self.isSignificant : isSignificant // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
