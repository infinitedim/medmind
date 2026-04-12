// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'anomaly_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AnomalyResult {

 double get reconstructionError; bool get isAnomaly; String get severity;
/// Create a copy of AnomalyResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnomalyResultCopyWith<AnomalyResult> get copyWith => _$AnomalyResultCopyWithImpl<AnomalyResult>(this as AnomalyResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnomalyResult&&(identical(other.reconstructionError, reconstructionError) || other.reconstructionError == reconstructionError)&&(identical(other.isAnomaly, isAnomaly) || other.isAnomaly == isAnomaly)&&(identical(other.severity, severity) || other.severity == severity));
}


@override
int get hashCode => Object.hash(runtimeType,reconstructionError,isAnomaly,severity);

@override
String toString() {
  return 'AnomalyResult(reconstructionError: $reconstructionError, isAnomaly: $isAnomaly, severity: $severity)';
}


}

/// @nodoc
abstract mixin class $AnomalyResultCopyWith<$Res>  {
  factory $AnomalyResultCopyWith(AnomalyResult value, $Res Function(AnomalyResult) _then) = _$AnomalyResultCopyWithImpl;
@useResult
$Res call({
 double reconstructionError, bool isAnomaly, String severity
});




}
/// @nodoc
class _$AnomalyResultCopyWithImpl<$Res>
    implements $AnomalyResultCopyWith<$Res> {
  _$AnomalyResultCopyWithImpl(this._self, this._then);

  final AnomalyResult _self;
  final $Res Function(AnomalyResult) _then;

/// Create a copy of AnomalyResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reconstructionError = null,Object? isAnomaly = null,Object? severity = null,}) {
  return _then(_self.copyWith(
reconstructionError: null == reconstructionError ? _self.reconstructionError : reconstructionError // ignore: cast_nullable_to_non_nullable
as double,isAnomaly: null == isAnomaly ? _self.isAnomaly : isAnomaly // ignore: cast_nullable_to_non_nullable
as bool,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AnomalyResult].
extension AnomalyResultPatterns on AnomalyResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnomalyResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnomalyResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnomalyResult value)  $default,){
final _that = this;
switch (_that) {
case _AnomalyResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnomalyResult value)?  $default,){
final _that = this;
switch (_that) {
case _AnomalyResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double reconstructionError,  bool isAnomaly,  String severity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnomalyResult() when $default != null:
return $default(_that.reconstructionError,_that.isAnomaly,_that.severity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double reconstructionError,  bool isAnomaly,  String severity)  $default,) {final _that = this;
switch (_that) {
case _AnomalyResult():
return $default(_that.reconstructionError,_that.isAnomaly,_that.severity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double reconstructionError,  bool isAnomaly,  String severity)?  $default,) {final _that = this;
switch (_that) {
case _AnomalyResult() when $default != null:
return $default(_that.reconstructionError,_that.isAnomaly,_that.severity);case _:
  return null;

}
}

}

/// @nodoc


class _AnomalyResult implements AnomalyResult {
  const _AnomalyResult({required this.reconstructionError, required this.isAnomaly, required this.severity});
  

@override final  double reconstructionError;
@override final  bool isAnomaly;
@override final  String severity;

/// Create a copy of AnomalyResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnomalyResultCopyWith<_AnomalyResult> get copyWith => __$AnomalyResultCopyWithImpl<_AnomalyResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnomalyResult&&(identical(other.reconstructionError, reconstructionError) || other.reconstructionError == reconstructionError)&&(identical(other.isAnomaly, isAnomaly) || other.isAnomaly == isAnomaly)&&(identical(other.severity, severity) || other.severity == severity));
}


@override
int get hashCode => Object.hash(runtimeType,reconstructionError,isAnomaly,severity);

@override
String toString() {
  return 'AnomalyResult(reconstructionError: $reconstructionError, isAnomaly: $isAnomaly, severity: $severity)';
}


}

/// @nodoc
abstract mixin class _$AnomalyResultCopyWith<$Res> implements $AnomalyResultCopyWith<$Res> {
  factory _$AnomalyResultCopyWith(_AnomalyResult value, $Res Function(_AnomalyResult) _then) = __$AnomalyResultCopyWithImpl;
@override @useResult
$Res call({
 double reconstructionError, bool isAnomaly, String severity
});




}
/// @nodoc
class __$AnomalyResultCopyWithImpl<$Res>
    implements _$AnomalyResultCopyWith<$Res> {
  __$AnomalyResultCopyWithImpl(this._self, this._then);

  final _AnomalyResult _self;
  final $Res Function(_AnomalyResult) _then;

/// Create a copy of AnomalyResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reconstructionError = null,Object? isAnomaly = null,Object? severity = null,}) {
  return _then(_AnomalyResult(
reconstructionError: null == reconstructionError ? _self.reconstructionError : reconstructionError // ignore: cast_nullable_to_non_nullable
as double,isAnomaly: null == isAnomaly ? _self.isAnomaly : isAnomaly // ignore: cast_nullable_to_non_nullable
as bool,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
