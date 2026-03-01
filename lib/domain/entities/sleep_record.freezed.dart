// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sleep_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SleepRecord {

 DateTime get bedTime; DateTime get wakeTime; int get quality;// 1-10
 int? get disturbances;
/// Create a copy of SleepRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SleepRecordCopyWith<SleepRecord> get copyWith => _$SleepRecordCopyWithImpl<SleepRecord>(this as SleepRecord, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SleepRecord&&(identical(other.bedTime, bedTime) || other.bedTime == bedTime)&&(identical(other.wakeTime, wakeTime) || other.wakeTime == wakeTime)&&(identical(other.quality, quality) || other.quality == quality)&&(identical(other.disturbances, disturbances) || other.disturbances == disturbances));
}


@override
int get hashCode => Object.hash(runtimeType,bedTime,wakeTime,quality,disturbances);

@override
String toString() {
  return 'SleepRecord(bedTime: $bedTime, wakeTime: $wakeTime, quality: $quality, disturbances: $disturbances)';
}


}

/// @nodoc
abstract mixin class $SleepRecordCopyWith<$Res>  {
  factory $SleepRecordCopyWith(SleepRecord value, $Res Function(SleepRecord) _then) = _$SleepRecordCopyWithImpl;
@useResult
$Res call({
 DateTime bedTime, DateTime wakeTime, int quality, int? disturbances
});




}
/// @nodoc
class _$SleepRecordCopyWithImpl<$Res>
    implements $SleepRecordCopyWith<$Res> {
  _$SleepRecordCopyWithImpl(this._self, this._then);

  final SleepRecord _self;
  final $Res Function(SleepRecord) _then;

/// Create a copy of SleepRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bedTime = null,Object? wakeTime = null,Object? quality = null,Object? disturbances = freezed,}) {
  return _then(_self.copyWith(
bedTime: null == bedTime ? _self.bedTime : bedTime // ignore: cast_nullable_to_non_nullable
as DateTime,wakeTime: null == wakeTime ? _self.wakeTime : wakeTime // ignore: cast_nullable_to_non_nullable
as DateTime,quality: null == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as int,disturbances: freezed == disturbances ? _self.disturbances : disturbances // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [SleepRecord].
extension SleepRecordPatterns on SleepRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SleepRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SleepRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SleepRecord value)  $default,){
final _that = this;
switch (_that) {
case _SleepRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SleepRecord value)?  $default,){
final _that = this;
switch (_that) {
case _SleepRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime bedTime,  DateTime wakeTime,  int quality,  int? disturbances)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SleepRecord() when $default != null:
return $default(_that.bedTime,_that.wakeTime,_that.quality,_that.disturbances);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime bedTime,  DateTime wakeTime,  int quality,  int? disturbances)  $default,) {final _that = this;
switch (_that) {
case _SleepRecord():
return $default(_that.bedTime,_that.wakeTime,_that.quality,_that.disturbances);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime bedTime,  DateTime wakeTime,  int quality,  int? disturbances)?  $default,) {final _that = this;
switch (_that) {
case _SleepRecord() when $default != null:
return $default(_that.bedTime,_that.wakeTime,_that.quality,_that.disturbances);case _:
  return null;

}
}

}

/// @nodoc


class _SleepRecord extends SleepRecord {
  const _SleepRecord({required this.bedTime, required this.wakeTime, required this.quality, this.disturbances}): super._();
  

@override final  DateTime bedTime;
@override final  DateTime wakeTime;
@override final  int quality;
// 1-10
@override final  int? disturbances;

/// Create a copy of SleepRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SleepRecordCopyWith<_SleepRecord> get copyWith => __$SleepRecordCopyWithImpl<_SleepRecord>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SleepRecord&&(identical(other.bedTime, bedTime) || other.bedTime == bedTime)&&(identical(other.wakeTime, wakeTime) || other.wakeTime == wakeTime)&&(identical(other.quality, quality) || other.quality == quality)&&(identical(other.disturbances, disturbances) || other.disturbances == disturbances));
}


@override
int get hashCode => Object.hash(runtimeType,bedTime,wakeTime,quality,disturbances);

@override
String toString() {
  return 'SleepRecord(bedTime: $bedTime, wakeTime: $wakeTime, quality: $quality, disturbances: $disturbances)';
}


}

/// @nodoc
abstract mixin class _$SleepRecordCopyWith<$Res> implements $SleepRecordCopyWith<$Res> {
  factory _$SleepRecordCopyWith(_SleepRecord value, $Res Function(_SleepRecord) _then) = __$SleepRecordCopyWithImpl;
@override @useResult
$Res call({
 DateTime bedTime, DateTime wakeTime, int quality, int? disturbances
});




}
/// @nodoc
class __$SleepRecordCopyWithImpl<$Res>
    implements _$SleepRecordCopyWith<$Res> {
  __$SleepRecordCopyWithImpl(this._self, this._then);

  final _SleepRecord _self;
  final $Res Function(_SleepRecord) _then;

/// Create a copy of SleepRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bedTime = null,Object? wakeTime = null,Object? quality = null,Object? disturbances = freezed,}) {
  return _then(_SleepRecord(
bedTime: null == bedTime ? _self.bedTime : bedTime // ignore: cast_nullable_to_non_nullable
as DateTime,wakeTime: null == wakeTime ? _self.wakeTime : wakeTime // ignore: cast_nullable_to_non_nullable
as DateTime,quality: null == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as int,disturbances: freezed == disturbances ? _self.disturbances : disturbances // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
