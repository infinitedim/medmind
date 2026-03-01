// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journal_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JournalEntry {

 String get id; DateTime get date; Mood? get mood; int? get moodIntensity; List<SymptomLog> get symptoms; List<MedicationLog> get medications; SleepRecord? get sleepRecord; List<LifestyleFactorLog> get lifestyleFactors; String? get freeText; List<ExtractedSymptom>? get extractedSymptoms; ActivityLevel? get activityLevel; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of JournalEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JournalEntryCopyWith<JournalEntry> get copyWith => _$JournalEntryCopyWithImpl<JournalEntry>(this as JournalEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JournalEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.mood, mood) || other.mood == mood)&&(identical(other.moodIntensity, moodIntensity) || other.moodIntensity == moodIntensity)&&const DeepCollectionEquality().equals(other.symptoms, symptoms)&&const DeepCollectionEquality().equals(other.medications, medications)&&(identical(other.sleepRecord, sleepRecord) || other.sleepRecord == sleepRecord)&&const DeepCollectionEquality().equals(other.lifestyleFactors, lifestyleFactors)&&(identical(other.freeText, freeText) || other.freeText == freeText)&&const DeepCollectionEquality().equals(other.extractedSymptoms, extractedSymptoms)&&(identical(other.activityLevel, activityLevel) || other.activityLevel == activityLevel)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,date,mood,moodIntensity,const DeepCollectionEquality().hash(symptoms),const DeepCollectionEquality().hash(medications),sleepRecord,const DeepCollectionEquality().hash(lifestyleFactors),freeText,const DeepCollectionEquality().hash(extractedSymptoms),activityLevel,createdAt,updatedAt);

@override
String toString() {
  return 'JournalEntry(id: $id, date: $date, mood: $mood, moodIntensity: $moodIntensity, symptoms: $symptoms, medications: $medications, sleepRecord: $sleepRecord, lifestyleFactors: $lifestyleFactors, freeText: $freeText, extractedSymptoms: $extractedSymptoms, activityLevel: $activityLevel, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $JournalEntryCopyWith<$Res>  {
  factory $JournalEntryCopyWith(JournalEntry value, $Res Function(JournalEntry) _then) = _$JournalEntryCopyWithImpl;
@useResult
$Res call({
 String id, DateTime date, Mood? mood, int? moodIntensity, List<SymptomLog> symptoms, List<MedicationLog> medications, SleepRecord? sleepRecord, List<LifestyleFactorLog> lifestyleFactors, String? freeText, List<ExtractedSymptom>? extractedSymptoms, ActivityLevel? activityLevel, DateTime createdAt, DateTime updatedAt
});


$SleepRecordCopyWith<$Res>? get sleepRecord;

}
/// @nodoc
class _$JournalEntryCopyWithImpl<$Res>
    implements $JournalEntryCopyWith<$Res> {
  _$JournalEntryCopyWithImpl(this._self, this._then);

  final JournalEntry _self;
  final $Res Function(JournalEntry) _then;

/// Create a copy of JournalEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? date = null,Object? mood = freezed,Object? moodIntensity = freezed,Object? symptoms = null,Object? medications = null,Object? sleepRecord = freezed,Object? lifestyleFactors = null,Object? freeText = freezed,Object? extractedSymptoms = freezed,Object? activityLevel = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,mood: freezed == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as Mood?,moodIntensity: freezed == moodIntensity ? _self.moodIntensity : moodIntensity // ignore: cast_nullable_to_non_nullable
as int?,symptoms: null == symptoms ? _self.symptoms : symptoms // ignore: cast_nullable_to_non_nullable
as List<SymptomLog>,medications: null == medications ? _self.medications : medications // ignore: cast_nullable_to_non_nullable
as List<MedicationLog>,sleepRecord: freezed == sleepRecord ? _self.sleepRecord : sleepRecord // ignore: cast_nullable_to_non_nullable
as SleepRecord?,lifestyleFactors: null == lifestyleFactors ? _self.lifestyleFactors : lifestyleFactors // ignore: cast_nullable_to_non_nullable
as List<LifestyleFactorLog>,freeText: freezed == freeText ? _self.freeText : freeText // ignore: cast_nullable_to_non_nullable
as String?,extractedSymptoms: freezed == extractedSymptoms ? _self.extractedSymptoms : extractedSymptoms // ignore: cast_nullable_to_non_nullable
as List<ExtractedSymptom>?,activityLevel: freezed == activityLevel ? _self.activityLevel : activityLevel // ignore: cast_nullable_to_non_nullable
as ActivityLevel?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of JournalEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SleepRecordCopyWith<$Res>? get sleepRecord {
    if (_self.sleepRecord == null) {
    return null;
  }

  return $SleepRecordCopyWith<$Res>(_self.sleepRecord!, (value) {
    return _then(_self.copyWith(sleepRecord: value));
  });
}
}


/// Adds pattern-matching-related methods to [JournalEntry].
extension JournalEntryPatterns on JournalEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JournalEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JournalEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JournalEntry value)  $default,){
final _that = this;
switch (_that) {
case _JournalEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JournalEntry value)?  $default,){
final _that = this;
switch (_that) {
case _JournalEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime date,  Mood? mood,  int? moodIntensity,  List<SymptomLog> symptoms,  List<MedicationLog> medications,  SleepRecord? sleepRecord,  List<LifestyleFactorLog> lifestyleFactors,  String? freeText,  List<ExtractedSymptom>? extractedSymptoms,  ActivityLevel? activityLevel,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JournalEntry() when $default != null:
return $default(_that.id,_that.date,_that.mood,_that.moodIntensity,_that.symptoms,_that.medications,_that.sleepRecord,_that.lifestyleFactors,_that.freeText,_that.extractedSymptoms,_that.activityLevel,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime date,  Mood? mood,  int? moodIntensity,  List<SymptomLog> symptoms,  List<MedicationLog> medications,  SleepRecord? sleepRecord,  List<LifestyleFactorLog> lifestyleFactors,  String? freeText,  List<ExtractedSymptom>? extractedSymptoms,  ActivityLevel? activityLevel,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _JournalEntry():
return $default(_that.id,_that.date,_that.mood,_that.moodIntensity,_that.symptoms,_that.medications,_that.sleepRecord,_that.lifestyleFactors,_that.freeText,_that.extractedSymptoms,_that.activityLevel,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime date,  Mood? mood,  int? moodIntensity,  List<SymptomLog> symptoms,  List<MedicationLog> medications,  SleepRecord? sleepRecord,  List<LifestyleFactorLog> lifestyleFactors,  String? freeText,  List<ExtractedSymptom>? extractedSymptoms,  ActivityLevel? activityLevel,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _JournalEntry() when $default != null:
return $default(_that.id,_that.date,_that.mood,_that.moodIntensity,_that.symptoms,_that.medications,_that.sleepRecord,_that.lifestyleFactors,_that.freeText,_that.extractedSymptoms,_that.activityLevel,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _JournalEntry implements JournalEntry {
  const _JournalEntry({required this.id, required this.date, this.mood, this.moodIntensity, final  List<SymptomLog> symptoms = const [], final  List<MedicationLog> medications = const [], this.sleepRecord, final  List<LifestyleFactorLog> lifestyleFactors = const [], this.freeText, final  List<ExtractedSymptom>? extractedSymptoms, this.activityLevel, required this.createdAt, required this.updatedAt}): _symptoms = symptoms,_medications = medications,_lifestyleFactors = lifestyleFactors,_extractedSymptoms = extractedSymptoms;
  

@override final  String id;
@override final  DateTime date;
@override final  Mood? mood;
@override final  int? moodIntensity;
 final  List<SymptomLog> _symptoms;
@override@JsonKey() List<SymptomLog> get symptoms {
  if (_symptoms is EqualUnmodifiableListView) return _symptoms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_symptoms);
}

 final  List<MedicationLog> _medications;
@override@JsonKey() List<MedicationLog> get medications {
  if (_medications is EqualUnmodifiableListView) return _medications;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_medications);
}

@override final  SleepRecord? sleepRecord;
 final  List<LifestyleFactorLog> _lifestyleFactors;
@override@JsonKey() List<LifestyleFactorLog> get lifestyleFactors {
  if (_lifestyleFactors is EqualUnmodifiableListView) return _lifestyleFactors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lifestyleFactors);
}

@override final  String? freeText;
 final  List<ExtractedSymptom>? _extractedSymptoms;
@override List<ExtractedSymptom>? get extractedSymptoms {
  final value = _extractedSymptoms;
  if (value == null) return null;
  if (_extractedSymptoms is EqualUnmodifiableListView) return _extractedSymptoms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  ActivityLevel? activityLevel;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of JournalEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JournalEntryCopyWith<_JournalEntry> get copyWith => __$JournalEntryCopyWithImpl<_JournalEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JournalEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.mood, mood) || other.mood == mood)&&(identical(other.moodIntensity, moodIntensity) || other.moodIntensity == moodIntensity)&&const DeepCollectionEquality().equals(other._symptoms, _symptoms)&&const DeepCollectionEquality().equals(other._medications, _medications)&&(identical(other.sleepRecord, sleepRecord) || other.sleepRecord == sleepRecord)&&const DeepCollectionEquality().equals(other._lifestyleFactors, _lifestyleFactors)&&(identical(other.freeText, freeText) || other.freeText == freeText)&&const DeepCollectionEquality().equals(other._extractedSymptoms, _extractedSymptoms)&&(identical(other.activityLevel, activityLevel) || other.activityLevel == activityLevel)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,date,mood,moodIntensity,const DeepCollectionEquality().hash(_symptoms),const DeepCollectionEquality().hash(_medications),sleepRecord,const DeepCollectionEquality().hash(_lifestyleFactors),freeText,const DeepCollectionEquality().hash(_extractedSymptoms),activityLevel,createdAt,updatedAt);

@override
String toString() {
  return 'JournalEntry(id: $id, date: $date, mood: $mood, moodIntensity: $moodIntensity, symptoms: $symptoms, medications: $medications, sleepRecord: $sleepRecord, lifestyleFactors: $lifestyleFactors, freeText: $freeText, extractedSymptoms: $extractedSymptoms, activityLevel: $activityLevel, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$JournalEntryCopyWith<$Res> implements $JournalEntryCopyWith<$Res> {
  factory _$JournalEntryCopyWith(_JournalEntry value, $Res Function(_JournalEntry) _then) = __$JournalEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime date, Mood? mood, int? moodIntensity, List<SymptomLog> symptoms, List<MedicationLog> medications, SleepRecord? sleepRecord, List<LifestyleFactorLog> lifestyleFactors, String? freeText, List<ExtractedSymptom>? extractedSymptoms, ActivityLevel? activityLevel, DateTime createdAt, DateTime updatedAt
});


@override $SleepRecordCopyWith<$Res>? get sleepRecord;

}
/// @nodoc
class __$JournalEntryCopyWithImpl<$Res>
    implements _$JournalEntryCopyWith<$Res> {
  __$JournalEntryCopyWithImpl(this._self, this._then);

  final _JournalEntry _self;
  final $Res Function(_JournalEntry) _then;

/// Create a copy of JournalEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = null,Object? mood = freezed,Object? moodIntensity = freezed,Object? symptoms = null,Object? medications = null,Object? sleepRecord = freezed,Object? lifestyleFactors = null,Object? freeText = freezed,Object? extractedSymptoms = freezed,Object? activityLevel = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_JournalEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,mood: freezed == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as Mood?,moodIntensity: freezed == moodIntensity ? _self.moodIntensity : moodIntensity // ignore: cast_nullable_to_non_nullable
as int?,symptoms: null == symptoms ? _self._symptoms : symptoms // ignore: cast_nullable_to_non_nullable
as List<SymptomLog>,medications: null == medications ? _self._medications : medications // ignore: cast_nullable_to_non_nullable
as List<MedicationLog>,sleepRecord: freezed == sleepRecord ? _self.sleepRecord : sleepRecord // ignore: cast_nullable_to_non_nullable
as SleepRecord?,lifestyleFactors: null == lifestyleFactors ? _self._lifestyleFactors : lifestyleFactors // ignore: cast_nullable_to_non_nullable
as List<LifestyleFactorLog>,freeText: freezed == freeText ? _self.freeText : freeText // ignore: cast_nullable_to_non_nullable
as String?,extractedSymptoms: freezed == extractedSymptoms ? _self._extractedSymptoms : extractedSymptoms // ignore: cast_nullable_to_non_nullable
as List<ExtractedSymptom>?,activityLevel: freezed == activityLevel ? _self.activityLevel : activityLevel // ignore: cast_nullable_to_non_nullable
as ActivityLevel?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of JournalEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SleepRecordCopyWith<$Res>? get sleepRecord {
    if (_self.sleepRecord == null) {
    return null;
  }

  return $SleepRecordCopyWith<$Res>(_self.sleepRecord!, (value) {
    return _then(_self.copyWith(sleepRecord: value));
  });
}
}

// dart format on
