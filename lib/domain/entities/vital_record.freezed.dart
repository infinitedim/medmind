// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vital_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VitalRecord {

 int? get heartRate; int? get steps; double? get weight; double? get spO2; DateTime get date; VitalSource get source;
/// Create a copy of VitalRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VitalRecordCopyWith<VitalRecord> get copyWith => _$VitalRecordCopyWithImpl<VitalRecord>(this as VitalRecord, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VitalRecord&&(identical(other.heartRate, heartRate) || other.heartRate == heartRate)&&(identical(other.steps, steps) || other.steps == steps)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.spO2, spO2) || other.spO2 == spO2)&&(identical(other.date, date) || other.date == date)&&(identical(other.source, source) || other.source == source));
}


@override
int get hashCode => Object.hash(runtimeType,heartRate,steps,weight,spO2,date,source);

@override
String toString() {
  return 'VitalRecord(heartRate: $heartRate, steps: $steps, weight: $weight, spO2: $spO2, date: $date, source: $source)';
}


}

/// @nodoc
abstract mixin class $VitalRecordCopyWith<$Res>  {
  factory $VitalRecordCopyWith(VitalRecord value, $Res Function(VitalRecord) _then) = _$VitalRecordCopyWithImpl;
@useResult
$Res call({
 int? heartRate, int? steps, double? weight, double? spO2, DateTime date, VitalSource source
});




}
/// @nodoc
class _$VitalRecordCopyWithImpl<$Res>
    implements $VitalRecordCopyWith<$Res> {
  _$VitalRecordCopyWithImpl(this._self, this._then);

  final VitalRecord _self;
  final $Res Function(VitalRecord) _then;

/// Create a copy of VitalRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? heartRate = freezed,Object? steps = freezed,Object? weight = freezed,Object? spO2 = freezed,Object? date = null,Object? source = null,}) {
  return _then(_self.copyWith(
heartRate: freezed == heartRate ? _self.heartRate : heartRate // ignore: cast_nullable_to_non_nullable
as int?,steps: freezed == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as int?,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,spO2: freezed == spO2 ? _self.spO2 : spO2 // ignore: cast_nullable_to_non_nullable
as double?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as VitalSource,
  ));
}

}


/// Adds pattern-matching-related methods to [VitalRecord].
extension VitalRecordPatterns on VitalRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VitalRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VitalRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VitalRecord value)  $default,){
final _that = this;
switch (_that) {
case _VitalRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VitalRecord value)?  $default,){
final _that = this;
switch (_that) {
case _VitalRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? heartRate,  int? steps,  double? weight,  double? spO2,  DateTime date,  VitalSource source)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VitalRecord() when $default != null:
return $default(_that.heartRate,_that.steps,_that.weight,_that.spO2,_that.date,_that.source);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? heartRate,  int? steps,  double? weight,  double? spO2,  DateTime date,  VitalSource source)  $default,) {final _that = this;
switch (_that) {
case _VitalRecord():
return $default(_that.heartRate,_that.steps,_that.weight,_that.spO2,_that.date,_that.source);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? heartRate,  int? steps,  double? weight,  double? spO2,  DateTime date,  VitalSource source)?  $default,) {final _that = this;
switch (_that) {
case _VitalRecord() when $default != null:
return $default(_that.heartRate,_that.steps,_that.weight,_that.spO2,_that.date,_that.source);case _:
  return null;

}
}

}

/// @nodoc


class _VitalRecord implements VitalRecord {
  const _VitalRecord({this.heartRate, this.steps, this.weight, this.spO2, required this.date, required this.source});
  

@override final  int? heartRate;
@override final  int? steps;
@override final  double? weight;
@override final  double? spO2;
@override final  DateTime date;
@override final  VitalSource source;

/// Create a copy of VitalRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VitalRecordCopyWith<_VitalRecord> get copyWith => __$VitalRecordCopyWithImpl<_VitalRecord>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VitalRecord&&(identical(other.heartRate, heartRate) || other.heartRate == heartRate)&&(identical(other.steps, steps) || other.steps == steps)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.spO2, spO2) || other.spO2 == spO2)&&(identical(other.date, date) || other.date == date)&&(identical(other.source, source) || other.source == source));
}


@override
int get hashCode => Object.hash(runtimeType,heartRate,steps,weight,spO2,date,source);

@override
String toString() {
  return 'VitalRecord(heartRate: $heartRate, steps: $steps, weight: $weight, spO2: $spO2, date: $date, source: $source)';
}


}

/// @nodoc
abstract mixin class _$VitalRecordCopyWith<$Res> implements $VitalRecordCopyWith<$Res> {
  factory _$VitalRecordCopyWith(_VitalRecord value, $Res Function(_VitalRecord) _then) = __$VitalRecordCopyWithImpl;
@override @useResult
$Res call({
 int? heartRate, int? steps, double? weight, double? spO2, DateTime date, VitalSource source
});




}
/// @nodoc
class __$VitalRecordCopyWithImpl<$Res>
    implements _$VitalRecordCopyWith<$Res> {
  __$VitalRecordCopyWithImpl(this._self, this._then);

  final _VitalRecord _self;
  final $Res Function(_VitalRecord) _then;

/// Create a copy of VitalRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? heartRate = freezed,Object? steps = freezed,Object? weight = freezed,Object? spO2 = freezed,Object? date = null,Object? source = null,}) {
  return _then(_VitalRecord(
heartRate: freezed == heartRate ? _self.heartRate : heartRate // ignore: cast_nullable_to_non_nullable
as int?,steps: freezed == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as int?,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,spO2: freezed == spO2 ? _self.spO2 : spO2 // ignore: cast_nullable_to_non_nullable
as double?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as VitalSource,
  ));
}


}

// dart format on
