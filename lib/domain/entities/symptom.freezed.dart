// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'symptom.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Symptom {

 String get id; String get name; SymptomCategory get category; String get icon; bool get isCustom;
/// Create a copy of Symptom
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SymptomCopyWith<Symptom> get copyWith => _$SymptomCopyWithImpl<Symptom>(this as Symptom, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Symptom&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.isCustom, isCustom) || other.isCustom == isCustom));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,category,icon,isCustom);

@override
String toString() {
  return 'Symptom(id: $id, name: $name, category: $category, icon: $icon, isCustom: $isCustom)';
}


}

/// @nodoc
abstract mixin class $SymptomCopyWith<$Res>  {
  factory $SymptomCopyWith(Symptom value, $Res Function(Symptom) _then) = _$SymptomCopyWithImpl;
@useResult
$Res call({
 String id, String name, SymptomCategory category, String icon, bool isCustom
});




}
/// @nodoc
class _$SymptomCopyWithImpl<$Res>
    implements $SymptomCopyWith<$Res> {
  _$SymptomCopyWithImpl(this._self, this._then);

  final Symptom _self;
  final $Res Function(Symptom) _then;

/// Create a copy of Symptom
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? category = null,Object? icon = null,Object? isCustom = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as SymptomCategory,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,isCustom: null == isCustom ? _self.isCustom : isCustom // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Symptom].
extension SymptomPatterns on Symptom {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Symptom value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Symptom() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Symptom value)  $default,){
final _that = this;
switch (_that) {
case _Symptom():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Symptom value)?  $default,){
final _that = this;
switch (_that) {
case _Symptom() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  SymptomCategory category,  String icon,  bool isCustom)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Symptom() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.icon,_that.isCustom);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  SymptomCategory category,  String icon,  bool isCustom)  $default,) {final _that = this;
switch (_that) {
case _Symptom():
return $default(_that.id,_that.name,_that.category,_that.icon,_that.isCustom);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  SymptomCategory category,  String icon,  bool isCustom)?  $default,) {final _that = this;
switch (_that) {
case _Symptom() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.icon,_that.isCustom);case _:
  return null;

}
}

}

/// @nodoc


class _Symptom implements Symptom {
  const _Symptom({required this.id, required this.name, required this.category, required this.icon, this.isCustom = false});
  

@override final  String id;
@override final  String name;
@override final  SymptomCategory category;
@override final  String icon;
@override@JsonKey() final  bool isCustom;

/// Create a copy of Symptom
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SymptomCopyWith<_Symptom> get copyWith => __$SymptomCopyWithImpl<_Symptom>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Symptom&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.isCustom, isCustom) || other.isCustom == isCustom));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,category,icon,isCustom);

@override
String toString() {
  return 'Symptom(id: $id, name: $name, category: $category, icon: $icon, isCustom: $isCustom)';
}


}

/// @nodoc
abstract mixin class _$SymptomCopyWith<$Res> implements $SymptomCopyWith<$Res> {
  factory _$SymptomCopyWith(_Symptom value, $Res Function(_Symptom) _then) = __$SymptomCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, SymptomCategory category, String icon, bool isCustom
});




}
/// @nodoc
class __$SymptomCopyWithImpl<$Res>
    implements _$SymptomCopyWith<$Res> {
  __$SymptomCopyWithImpl(this._self, this._then);

  final _Symptom _self;
  final $Res Function(_Symptom) _then;

/// Create a copy of Symptom
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? category = null,Object? icon = null,Object? isCustom = null,}) {
  return _then(_Symptom(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as SymptomCategory,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,isCustom: null == isCustom ? _self.isCustom : isCustom // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$SymptomLog {

 String get symptomId; int get severity;// 1-10
 TimeOfDay? get onset;// kapan mulai
 Duration? get duration;// berapa lama
 String? get notes;
/// Create a copy of SymptomLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SymptomLogCopyWith<SymptomLog> get copyWith => _$SymptomLogCopyWithImpl<SymptomLog>(this as SymptomLog, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SymptomLog&&(identical(other.symptomId, symptomId) || other.symptomId == symptomId)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.onset, onset) || other.onset == onset)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.notes, notes) || other.notes == notes));
}


@override
int get hashCode => Object.hash(runtimeType,symptomId,severity,onset,duration,notes);

@override
String toString() {
  return 'SymptomLog(symptomId: $symptomId, severity: $severity, onset: $onset, duration: $duration, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $SymptomLogCopyWith<$Res>  {
  factory $SymptomLogCopyWith(SymptomLog value, $Res Function(SymptomLog) _then) = _$SymptomLogCopyWithImpl;
@useResult
$Res call({
 String symptomId, int severity, TimeOfDay? onset, Duration? duration, String? notes
});




}
/// @nodoc
class _$SymptomLogCopyWithImpl<$Res>
    implements $SymptomLogCopyWith<$Res> {
  _$SymptomLogCopyWithImpl(this._self, this._then);

  final SymptomLog _self;
  final $Res Function(SymptomLog) _then;

/// Create a copy of SymptomLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? symptomId = null,Object? severity = null,Object? onset = freezed,Object? duration = freezed,Object? notes = freezed,}) {
  return _then(_self.copyWith(
symptomId: null == symptomId ? _self.symptomId : symptomId // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as int,onset: freezed == onset ? _self.onset : onset // ignore: cast_nullable_to_non_nullable
as TimeOfDay?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SymptomLog].
extension SymptomLogPatterns on SymptomLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SymptomLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SymptomLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SymptomLog value)  $default,){
final _that = this;
switch (_that) {
case _SymptomLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SymptomLog value)?  $default,){
final _that = this;
switch (_that) {
case _SymptomLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String symptomId,  int severity,  TimeOfDay? onset,  Duration? duration,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SymptomLog() when $default != null:
return $default(_that.symptomId,_that.severity,_that.onset,_that.duration,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String symptomId,  int severity,  TimeOfDay? onset,  Duration? duration,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _SymptomLog():
return $default(_that.symptomId,_that.severity,_that.onset,_that.duration,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String symptomId,  int severity,  TimeOfDay? onset,  Duration? duration,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _SymptomLog() when $default != null:
return $default(_that.symptomId,_that.severity,_that.onset,_that.duration,_that.notes);case _:
  return null;

}
}

}

/// @nodoc


class _SymptomLog implements SymptomLog {
  const _SymptomLog({required this.symptomId, required this.severity, this.onset, this.duration, this.notes});
  

@override final  String symptomId;
@override final  int severity;
// 1-10
@override final  TimeOfDay? onset;
// kapan mulai
@override final  Duration? duration;
// berapa lama
@override final  String? notes;

/// Create a copy of SymptomLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SymptomLogCopyWith<_SymptomLog> get copyWith => __$SymptomLogCopyWithImpl<_SymptomLog>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SymptomLog&&(identical(other.symptomId, symptomId) || other.symptomId == symptomId)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.onset, onset) || other.onset == onset)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.notes, notes) || other.notes == notes));
}


@override
int get hashCode => Object.hash(runtimeType,symptomId,severity,onset,duration,notes);

@override
String toString() {
  return 'SymptomLog(symptomId: $symptomId, severity: $severity, onset: $onset, duration: $duration, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$SymptomLogCopyWith<$Res> implements $SymptomLogCopyWith<$Res> {
  factory _$SymptomLogCopyWith(_SymptomLog value, $Res Function(_SymptomLog) _then) = __$SymptomLogCopyWithImpl;
@override @useResult
$Res call({
 String symptomId, int severity, TimeOfDay? onset, Duration? duration, String? notes
});




}
/// @nodoc
class __$SymptomLogCopyWithImpl<$Res>
    implements _$SymptomLogCopyWith<$Res> {
  __$SymptomLogCopyWithImpl(this._self, this._then);

  final _SymptomLog _self;
  final $Res Function(_SymptomLog) _then;

/// Create a copy of SymptomLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? symptomId = null,Object? severity = null,Object? onset = freezed,Object? duration = freezed,Object? notes = freezed,}) {
  return _then(_SymptomLog(
symptomId: null == symptomId ? _self.symptomId : symptomId // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as int,onset: freezed == onset ? _self.onset : onset // ignore: cast_nullable_to_non_nullable
as TimeOfDay?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$ExtractedSymptom {

 String get symptomName; String? get severity;// mild, moderate, severe
 double get confidence;// 0.0 - 1.0
 String get sourceText;// potongan teks yang di-extract
 bool? get isConfirmedByUser;
/// Create a copy of ExtractedSymptom
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExtractedSymptomCopyWith<ExtractedSymptom> get copyWith => _$ExtractedSymptomCopyWithImpl<ExtractedSymptom>(this as ExtractedSymptom, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExtractedSymptom&&(identical(other.symptomName, symptomName) || other.symptomName == symptomName)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.sourceText, sourceText) || other.sourceText == sourceText)&&(identical(other.isConfirmedByUser, isConfirmedByUser) || other.isConfirmedByUser == isConfirmedByUser));
}


@override
int get hashCode => Object.hash(runtimeType,symptomName,severity,confidence,sourceText,isConfirmedByUser);

@override
String toString() {
  return 'ExtractedSymptom(symptomName: $symptomName, severity: $severity, confidence: $confidence, sourceText: $sourceText, isConfirmedByUser: $isConfirmedByUser)';
}


}

/// @nodoc
abstract mixin class $ExtractedSymptomCopyWith<$Res>  {
  factory $ExtractedSymptomCopyWith(ExtractedSymptom value, $Res Function(ExtractedSymptom) _then) = _$ExtractedSymptomCopyWithImpl;
@useResult
$Res call({
 String symptomName, String? severity, double confidence, String sourceText, bool? isConfirmedByUser
});




}
/// @nodoc
class _$ExtractedSymptomCopyWithImpl<$Res>
    implements $ExtractedSymptomCopyWith<$Res> {
  _$ExtractedSymptomCopyWithImpl(this._self, this._then);

  final ExtractedSymptom _self;
  final $Res Function(ExtractedSymptom) _then;

/// Create a copy of ExtractedSymptom
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? symptomName = null,Object? severity = freezed,Object? confidence = null,Object? sourceText = null,Object? isConfirmedByUser = freezed,}) {
  return _then(_self.copyWith(
symptomName: null == symptomName ? _self.symptomName : symptomName // ignore: cast_nullable_to_non_nullable
as String,severity: freezed == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String?,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,sourceText: null == sourceText ? _self.sourceText : sourceText // ignore: cast_nullable_to_non_nullable
as String,isConfirmedByUser: freezed == isConfirmedByUser ? _self.isConfirmedByUser : isConfirmedByUser // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExtractedSymptom].
extension ExtractedSymptomPatterns on ExtractedSymptom {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExtractedSymptom value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExtractedSymptom() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExtractedSymptom value)  $default,){
final _that = this;
switch (_that) {
case _ExtractedSymptom():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExtractedSymptom value)?  $default,){
final _that = this;
switch (_that) {
case _ExtractedSymptom() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String symptomName,  String? severity,  double confidence,  String sourceText,  bool? isConfirmedByUser)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExtractedSymptom() when $default != null:
return $default(_that.symptomName,_that.severity,_that.confidence,_that.sourceText,_that.isConfirmedByUser);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String symptomName,  String? severity,  double confidence,  String sourceText,  bool? isConfirmedByUser)  $default,) {final _that = this;
switch (_that) {
case _ExtractedSymptom():
return $default(_that.symptomName,_that.severity,_that.confidence,_that.sourceText,_that.isConfirmedByUser);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String symptomName,  String? severity,  double confidence,  String sourceText,  bool? isConfirmedByUser)?  $default,) {final _that = this;
switch (_that) {
case _ExtractedSymptom() when $default != null:
return $default(_that.symptomName,_that.severity,_that.confidence,_that.sourceText,_that.isConfirmedByUser);case _:
  return null;

}
}

}

/// @nodoc


class _ExtractedSymptom implements ExtractedSymptom {
  const _ExtractedSymptom({required this.symptomName, this.severity, required this.confidence, required this.sourceText, this.isConfirmedByUser});
  

@override final  String symptomName;
@override final  String? severity;
// mild, moderate, severe
@override final  double confidence;
// 0.0 - 1.0
@override final  String sourceText;
// potongan teks yang di-extract
@override final  bool? isConfirmedByUser;

/// Create a copy of ExtractedSymptom
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExtractedSymptomCopyWith<_ExtractedSymptom> get copyWith => __$ExtractedSymptomCopyWithImpl<_ExtractedSymptom>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExtractedSymptom&&(identical(other.symptomName, symptomName) || other.symptomName == symptomName)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.sourceText, sourceText) || other.sourceText == sourceText)&&(identical(other.isConfirmedByUser, isConfirmedByUser) || other.isConfirmedByUser == isConfirmedByUser));
}


@override
int get hashCode => Object.hash(runtimeType,symptomName,severity,confidence,sourceText,isConfirmedByUser);

@override
String toString() {
  return 'ExtractedSymptom(symptomName: $symptomName, severity: $severity, confidence: $confidence, sourceText: $sourceText, isConfirmedByUser: $isConfirmedByUser)';
}


}

/// @nodoc
abstract mixin class _$ExtractedSymptomCopyWith<$Res> implements $ExtractedSymptomCopyWith<$Res> {
  factory _$ExtractedSymptomCopyWith(_ExtractedSymptom value, $Res Function(_ExtractedSymptom) _then) = __$ExtractedSymptomCopyWithImpl;
@override @useResult
$Res call({
 String symptomName, String? severity, double confidence, String sourceText, bool? isConfirmedByUser
});




}
/// @nodoc
class __$ExtractedSymptomCopyWithImpl<$Res>
    implements _$ExtractedSymptomCopyWith<$Res> {
  __$ExtractedSymptomCopyWithImpl(this._self, this._then);

  final _ExtractedSymptom _self;
  final $Res Function(_ExtractedSymptom) _then;

/// Create a copy of ExtractedSymptom
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? symptomName = null,Object? severity = freezed,Object? confidence = null,Object? sourceText = null,Object? isConfirmedByUser = freezed,}) {
  return _then(_ExtractedSymptom(
symptomName: null == symptomName ? _self.symptomName : symptomName // ignore: cast_nullable_to_non_nullable
as String,severity: freezed == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String?,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,sourceText: null == sourceText ? _self.sourceText : sourceText // ignore: cast_nullable_to_non_nullable
as String,isConfirmedByUser: freezed == isConfirmedByUser ? _self.isConfirmedByUser : isConfirmedByUser // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
