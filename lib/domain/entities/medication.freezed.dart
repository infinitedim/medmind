// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medication.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Medication {

 String get id; String get name; String? get dosage; String? get frequency;
/// Create a copy of Medication
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationCopyWith<Medication> get copyWith => _$MedicationCopyWithImpl<Medication>(this as Medication, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Medication&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.dosage, dosage) || other.dosage == dosage)&&(identical(other.frequency, frequency) || other.frequency == frequency));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,dosage,frequency);

@override
String toString() {
  return 'Medication(id: $id, name: $name, dosage: $dosage, frequency: $frequency)';
}


}

/// @nodoc
abstract mixin class $MedicationCopyWith<$Res>  {
  factory $MedicationCopyWith(Medication value, $Res Function(Medication) _then) = _$MedicationCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? dosage, String? frequency
});




}
/// @nodoc
class _$MedicationCopyWithImpl<$Res>
    implements $MedicationCopyWith<$Res> {
  _$MedicationCopyWithImpl(this._self, this._then);

  final Medication _self;
  final $Res Function(Medication) _then;

/// Create a copy of Medication
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? dosage = freezed,Object? frequency = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dosage: freezed == dosage ? _self.dosage : dosage // ignore: cast_nullable_to_non_nullable
as String?,frequency: freezed == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Medication].
extension MedicationPatterns on Medication {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Medication value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Medication() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Medication value)  $default,){
final _that = this;
switch (_that) {
case _Medication():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Medication value)?  $default,){
final _that = this;
switch (_that) {
case _Medication() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? dosage,  String? frequency)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Medication() when $default != null:
return $default(_that.id,_that.name,_that.dosage,_that.frequency);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? dosage,  String? frequency)  $default,) {final _that = this;
switch (_that) {
case _Medication():
return $default(_that.id,_that.name,_that.dosage,_that.frequency);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? dosage,  String? frequency)?  $default,) {final _that = this;
switch (_that) {
case _Medication() when $default != null:
return $default(_that.id,_that.name,_that.dosage,_that.frequency);case _:
  return null;

}
}

}

/// @nodoc


class _Medication implements Medication {
  const _Medication({required this.id, required this.name, this.dosage, this.frequency});
  

@override final  String id;
@override final  String name;
@override final  String? dosage;
@override final  String? frequency;

/// Create a copy of Medication
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicationCopyWith<_Medication> get copyWith => __$MedicationCopyWithImpl<_Medication>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Medication&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.dosage, dosage) || other.dosage == dosage)&&(identical(other.frequency, frequency) || other.frequency == frequency));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,dosage,frequency);

@override
String toString() {
  return 'Medication(id: $id, name: $name, dosage: $dosage, frequency: $frequency)';
}


}

/// @nodoc
abstract mixin class _$MedicationCopyWith<$Res> implements $MedicationCopyWith<$Res> {
  factory _$MedicationCopyWith(_Medication value, $Res Function(_Medication) _then) = __$MedicationCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? dosage, String? frequency
});




}
/// @nodoc
class __$MedicationCopyWithImpl<$Res>
    implements _$MedicationCopyWith<$Res> {
  __$MedicationCopyWithImpl(this._self, this._then);

  final _Medication _self;
  final $Res Function(_Medication) _then;

/// Create a copy of Medication
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? dosage = freezed,Object? frequency = freezed,}) {
  return _then(_Medication(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dosage: freezed == dosage ? _self.dosage : dosage // ignore: cast_nullable_to_non_nullable
as String?,frequency: freezed == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$MedicationLog {

 String get medicationId; bool get taken; TimeOfDay? get time; String? get dosage;
/// Create a copy of MedicationLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationLogCopyWith<MedicationLog> get copyWith => _$MedicationLogCopyWithImpl<MedicationLog>(this as MedicationLog, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicationLog&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.taken, taken) || other.taken == taken)&&(identical(other.time, time) || other.time == time)&&(identical(other.dosage, dosage) || other.dosage == dosage));
}


@override
int get hashCode => Object.hash(runtimeType,medicationId,taken,time,dosage);

@override
String toString() {
  return 'MedicationLog(medicationId: $medicationId, taken: $taken, time: $time, dosage: $dosage)';
}


}

/// @nodoc
abstract mixin class $MedicationLogCopyWith<$Res>  {
  factory $MedicationLogCopyWith(MedicationLog value, $Res Function(MedicationLog) _then) = _$MedicationLogCopyWithImpl;
@useResult
$Res call({
 String medicationId, bool taken, TimeOfDay? time, String? dosage
});




}
/// @nodoc
class _$MedicationLogCopyWithImpl<$Res>
    implements $MedicationLogCopyWith<$Res> {
  _$MedicationLogCopyWithImpl(this._self, this._then);

  final MedicationLog _self;
  final $Res Function(MedicationLog) _then;

/// Create a copy of MedicationLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? medicationId = null,Object? taken = null,Object? time = freezed,Object? dosage = freezed,}) {
  return _then(_self.copyWith(
medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,taken: null == taken ? _self.taken : taken // ignore: cast_nullable_to_non_nullable
as bool,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as TimeOfDay?,dosage: freezed == dosage ? _self.dosage : dosage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MedicationLog].
extension MedicationLogPatterns on MedicationLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicationLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicationLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicationLog value)  $default,){
final _that = this;
switch (_that) {
case _MedicationLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicationLog value)?  $default,){
final _that = this;
switch (_that) {
case _MedicationLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String medicationId,  bool taken,  TimeOfDay? time,  String? dosage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicationLog() when $default != null:
return $default(_that.medicationId,_that.taken,_that.time,_that.dosage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String medicationId,  bool taken,  TimeOfDay? time,  String? dosage)  $default,) {final _that = this;
switch (_that) {
case _MedicationLog():
return $default(_that.medicationId,_that.taken,_that.time,_that.dosage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String medicationId,  bool taken,  TimeOfDay? time,  String? dosage)?  $default,) {final _that = this;
switch (_that) {
case _MedicationLog() when $default != null:
return $default(_that.medicationId,_that.taken,_that.time,_that.dosage);case _:
  return null;

}
}

}

/// @nodoc


class _MedicationLog implements MedicationLog {
  const _MedicationLog({required this.medicationId, required this.taken, this.time, this.dosage});
  

@override final  String medicationId;
@override final  bool taken;
@override final  TimeOfDay? time;
@override final  String? dosage;

/// Create a copy of MedicationLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicationLogCopyWith<_MedicationLog> get copyWith => __$MedicationLogCopyWithImpl<_MedicationLog>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicationLog&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.taken, taken) || other.taken == taken)&&(identical(other.time, time) || other.time == time)&&(identical(other.dosage, dosage) || other.dosage == dosage));
}


@override
int get hashCode => Object.hash(runtimeType,medicationId,taken,time,dosage);

@override
String toString() {
  return 'MedicationLog(medicationId: $medicationId, taken: $taken, time: $time, dosage: $dosage)';
}


}

/// @nodoc
abstract mixin class _$MedicationLogCopyWith<$Res> implements $MedicationLogCopyWith<$Res> {
  factory _$MedicationLogCopyWith(_MedicationLog value, $Res Function(_MedicationLog) _then) = __$MedicationLogCopyWithImpl;
@override @useResult
$Res call({
 String medicationId, bool taken, TimeOfDay? time, String? dosage
});




}
/// @nodoc
class __$MedicationLogCopyWithImpl<$Res>
    implements _$MedicationLogCopyWith<$Res> {
  __$MedicationLogCopyWithImpl(this._self, this._then);

  final _MedicationLog _self;
  final $Res Function(_MedicationLog) _then;

/// Create a copy of MedicationLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? medicationId = null,Object? taken = null,Object? time = freezed,Object? dosage = freezed,}) {
  return _then(_MedicationLog(
medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,taken: null == taken ? _self.taken : taken // ignore: cast_nullable_to_non_nullable
as bool,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as TimeOfDay?,dosage: freezed == dosage ? _self.dosage : dosage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
