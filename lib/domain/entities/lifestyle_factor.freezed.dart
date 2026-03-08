// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lifestyle_factor.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LifestyleFactor {

 String get id; String get name; FactorType get type; String? get unit;
/// Create a copy of LifestyleFactor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LifestyleFactorCopyWith<LifestyleFactor> get copyWith => _$LifestyleFactorCopyWithImpl<LifestyleFactor>(this as LifestyleFactor, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LifestyleFactor&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.unit, unit) || other.unit == unit));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,type,unit);

@override
String toString() {
  return 'LifestyleFactor(id: $id, name: $name, type: $type, unit: $unit)';
}


}

/// @nodoc
abstract mixin class $LifestyleFactorCopyWith<$Res>  {
  factory $LifestyleFactorCopyWith(LifestyleFactor value, $Res Function(LifestyleFactor) _then) = _$LifestyleFactorCopyWithImpl;
@useResult
$Res call({
 String id, String name, FactorType type, String? unit
});




}
/// @nodoc
class _$LifestyleFactorCopyWithImpl<$Res>
    implements $LifestyleFactorCopyWith<$Res> {
  _$LifestyleFactorCopyWithImpl(this._self, this._then);

  final LifestyleFactor _self;
  final $Res Function(LifestyleFactor) _then;

/// Create a copy of LifestyleFactor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,Object? unit = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as FactorType,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LifestyleFactor].
extension LifestyleFactorPatterns on LifestyleFactor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LifestyleFactor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LifestyleFactor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LifestyleFactor value)  $default,){
final _that = this;
switch (_that) {
case _LifestyleFactor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LifestyleFactor value)?  $default,){
final _that = this;
switch (_that) {
case _LifestyleFactor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  FactorType type,  String? unit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LifestyleFactor() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.unit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  FactorType type,  String? unit)  $default,) {final _that = this;
switch (_that) {
case _LifestyleFactor():
return $default(_that.id,_that.name,_that.type,_that.unit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  FactorType type,  String? unit)?  $default,) {final _that = this;
switch (_that) {
case _LifestyleFactor() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.unit);case _:
  return null;

}
}

}

/// @nodoc


class _LifestyleFactor implements LifestyleFactor {
  const _LifestyleFactor({required this.id, required this.name, required this.type, this.unit});
  

@override final  String id;
@override final  String name;
@override final  FactorType type;
@override final  String? unit;

/// Create a copy of LifestyleFactor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LifestyleFactorCopyWith<_LifestyleFactor> get copyWith => __$LifestyleFactorCopyWithImpl<_LifestyleFactor>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LifestyleFactor&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.unit, unit) || other.unit == unit));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,type,unit);

@override
String toString() {
  return 'LifestyleFactor(id: $id, name: $name, type: $type, unit: $unit)';
}


}

/// @nodoc
abstract mixin class _$LifestyleFactorCopyWith<$Res> implements $LifestyleFactorCopyWith<$Res> {
  factory _$LifestyleFactorCopyWith(_LifestyleFactor value, $Res Function(_LifestyleFactor) _then) = __$LifestyleFactorCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, FactorType type, String? unit
});




}
/// @nodoc
class __$LifestyleFactorCopyWithImpl<$Res>
    implements _$LifestyleFactorCopyWith<$Res> {
  __$LifestyleFactorCopyWithImpl(this._self, this._then);

  final _LifestyleFactor _self;
  final $Res Function(_LifestyleFactor) _then;

/// Create a copy of LifestyleFactor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,Object? unit = freezed,}) {
  return _then(_LifestyleFactor(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as FactorType,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$LifestyleFactorLog {

 String get factorId; bool? get boolValue; double? get numericValue; int? get scaleValue;
/// Create a copy of LifestyleFactorLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LifestyleFactorLogCopyWith<LifestyleFactorLog> get copyWith => _$LifestyleFactorLogCopyWithImpl<LifestyleFactorLog>(this as LifestyleFactorLog, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LifestyleFactorLog&&(identical(other.factorId, factorId) || other.factorId == factorId)&&(identical(other.boolValue, boolValue) || other.boolValue == boolValue)&&(identical(other.numericValue, numericValue) || other.numericValue == numericValue)&&(identical(other.scaleValue, scaleValue) || other.scaleValue == scaleValue));
}


@override
int get hashCode => Object.hash(runtimeType,factorId,boolValue,numericValue,scaleValue);

@override
String toString() {
  return 'LifestyleFactorLog(factorId: $factorId, boolValue: $boolValue, numericValue: $numericValue, scaleValue: $scaleValue)';
}


}

/// @nodoc
abstract mixin class $LifestyleFactorLogCopyWith<$Res>  {
  factory $LifestyleFactorLogCopyWith(LifestyleFactorLog value, $Res Function(LifestyleFactorLog) _then) = _$LifestyleFactorLogCopyWithImpl;
@useResult
$Res call({
 String factorId, bool? boolValue, double? numericValue, int? scaleValue
});




}
/// @nodoc
class _$LifestyleFactorLogCopyWithImpl<$Res>
    implements $LifestyleFactorLogCopyWith<$Res> {
  _$LifestyleFactorLogCopyWithImpl(this._self, this._then);

  final LifestyleFactorLog _self;
  final $Res Function(LifestyleFactorLog) _then;

/// Create a copy of LifestyleFactorLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? factorId = null,Object? boolValue = freezed,Object? numericValue = freezed,Object? scaleValue = freezed,}) {
  return _then(_self.copyWith(
factorId: null == factorId ? _self.factorId : factorId // ignore: cast_nullable_to_non_nullable
as String,boolValue: freezed == boolValue ? _self.boolValue : boolValue // ignore: cast_nullable_to_non_nullable
as bool?,numericValue: freezed == numericValue ? _self.numericValue : numericValue // ignore: cast_nullable_to_non_nullable
as double?,scaleValue: freezed == scaleValue ? _self.scaleValue : scaleValue // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [LifestyleFactorLog].
extension LifestyleFactorLogPatterns on LifestyleFactorLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LifestyleFactorLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LifestyleFactorLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LifestyleFactorLog value)  $default,){
final _that = this;
switch (_that) {
case _LifestyleFactorLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LifestyleFactorLog value)?  $default,){
final _that = this;
switch (_that) {
case _LifestyleFactorLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String factorId,  bool? boolValue,  double? numericValue,  int? scaleValue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LifestyleFactorLog() when $default != null:
return $default(_that.factorId,_that.boolValue,_that.numericValue,_that.scaleValue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String factorId,  bool? boolValue,  double? numericValue,  int? scaleValue)  $default,) {final _that = this;
switch (_that) {
case _LifestyleFactorLog():
return $default(_that.factorId,_that.boolValue,_that.numericValue,_that.scaleValue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String factorId,  bool? boolValue,  double? numericValue,  int? scaleValue)?  $default,) {final _that = this;
switch (_that) {
case _LifestyleFactorLog() when $default != null:
return $default(_that.factorId,_that.boolValue,_that.numericValue,_that.scaleValue);case _:
  return null;

}
}

}

/// @nodoc


class _LifestyleFactorLog implements LifestyleFactorLog {
  const _LifestyleFactorLog({required this.factorId, this.boolValue, this.numericValue, this.scaleValue});
  

@override final  String factorId;
@override final  bool? boolValue;
@override final  double? numericValue;
@override final  int? scaleValue;

/// Create a copy of LifestyleFactorLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LifestyleFactorLogCopyWith<_LifestyleFactorLog> get copyWith => __$LifestyleFactorLogCopyWithImpl<_LifestyleFactorLog>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LifestyleFactorLog&&(identical(other.factorId, factorId) || other.factorId == factorId)&&(identical(other.boolValue, boolValue) || other.boolValue == boolValue)&&(identical(other.numericValue, numericValue) || other.numericValue == numericValue)&&(identical(other.scaleValue, scaleValue) || other.scaleValue == scaleValue));
}


@override
int get hashCode => Object.hash(runtimeType,factorId,boolValue,numericValue,scaleValue);

@override
String toString() {
  return 'LifestyleFactorLog(factorId: $factorId, boolValue: $boolValue, numericValue: $numericValue, scaleValue: $scaleValue)';
}


}

/// @nodoc
abstract mixin class _$LifestyleFactorLogCopyWith<$Res> implements $LifestyleFactorLogCopyWith<$Res> {
  factory _$LifestyleFactorLogCopyWith(_LifestyleFactorLog value, $Res Function(_LifestyleFactorLog) _then) = __$LifestyleFactorLogCopyWithImpl;
@override @useResult
$Res call({
 String factorId, bool? boolValue, double? numericValue, int? scaleValue
});




}
/// @nodoc
class __$LifestyleFactorLogCopyWithImpl<$Res>
    implements _$LifestyleFactorLogCopyWith<$Res> {
  __$LifestyleFactorLogCopyWithImpl(this._self, this._then);

  final _LifestyleFactorLog _self;
  final $Res Function(_LifestyleFactorLog) _then;

/// Create a copy of LifestyleFactorLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? factorId = null,Object? boolValue = freezed,Object? numericValue = freezed,Object? scaleValue = freezed,}) {
  return _then(_LifestyleFactorLog(
factorId: null == factorId ? _self.factorId : factorId // ignore: cast_nullable_to_non_nullable
as String,boolValue: freezed == boolValue ? _self.boolValue : boolValue // ignore: cast_nullable_to_non_nullable
as bool?,numericValue: freezed == numericValue ? _self.numericValue : numericValue // ignore: cast_nullable_to_non_nullable
as double?,scaleValue: freezed == scaleValue ? _self.scaleValue : scaleValue // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
