// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_score.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HealthScore {

 DateTime get date; double get overallScore; Map<String, double> get components; ScoreTrend get trend;
/// Create a copy of HealthScore
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthScoreCopyWith<HealthScore> get copyWith => _$HealthScoreCopyWithImpl<HealthScore>(this as HealthScore, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthScore&&(identical(other.date, date) || other.date == date)&&(identical(other.overallScore, overallScore) || other.overallScore == overallScore)&&const DeepCollectionEquality().equals(other.components, components)&&(identical(other.trend, trend) || other.trend == trend));
}


@override
int get hashCode => Object.hash(runtimeType,date,overallScore,const DeepCollectionEquality().hash(components),trend);

@override
String toString() {
  return 'HealthScore(date: $date, overallScore: $overallScore, components: $components, trend: $trend)';
}


}

/// @nodoc
abstract mixin class $HealthScoreCopyWith<$Res>  {
  factory $HealthScoreCopyWith(HealthScore value, $Res Function(HealthScore) _then) = _$HealthScoreCopyWithImpl;
@useResult
$Res call({
 DateTime date, double overallScore, Map<String, double> components, ScoreTrend trend
});




}
/// @nodoc
class _$HealthScoreCopyWithImpl<$Res>
    implements $HealthScoreCopyWith<$Res> {
  _$HealthScoreCopyWithImpl(this._self, this._then);

  final HealthScore _self;
  final $Res Function(HealthScore) _then;

/// Create a copy of HealthScore
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? overallScore = null,Object? components = null,Object? trend = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,overallScore: null == overallScore ? _self.overallScore : overallScore // ignore: cast_nullable_to_non_nullable
as double,components: null == components ? _self.components : components // ignore: cast_nullable_to_non_nullable
as Map<String, double>,trend: null == trend ? _self.trend : trend // ignore: cast_nullable_to_non_nullable
as ScoreTrend,
  ));
}

}


/// Adds pattern-matching-related methods to [HealthScore].
extension HealthScorePatterns on HealthScore {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthScore value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthScore() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthScore value)  $default,){
final _that = this;
switch (_that) {
case _HealthScore():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthScore value)?  $default,){
final _that = this;
switch (_that) {
case _HealthScore() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  double overallScore,  Map<String, double> components,  ScoreTrend trend)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthScore() when $default != null:
return $default(_that.date,_that.overallScore,_that.components,_that.trend);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  double overallScore,  Map<String, double> components,  ScoreTrend trend)  $default,) {final _that = this;
switch (_that) {
case _HealthScore():
return $default(_that.date,_that.overallScore,_that.components,_that.trend);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  double overallScore,  Map<String, double> components,  ScoreTrend trend)?  $default,) {final _that = this;
switch (_that) {
case _HealthScore() when $default != null:
return $default(_that.date,_that.overallScore,_that.components,_that.trend);case _:
  return null;

}
}

}

/// @nodoc


class _HealthScore implements HealthScore {
  const _HealthScore({required this.date, required this.overallScore, required final  Map<String, double> components, required this.trend}): _components = components;
  

@override final  DateTime date;
@override final  double overallScore;
 final  Map<String, double> _components;
@override Map<String, double> get components {
  if (_components is EqualUnmodifiableMapView) return _components;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_components);
}

@override final  ScoreTrend trend;

/// Create a copy of HealthScore
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthScoreCopyWith<_HealthScore> get copyWith => __$HealthScoreCopyWithImpl<_HealthScore>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthScore&&(identical(other.date, date) || other.date == date)&&(identical(other.overallScore, overallScore) || other.overallScore == overallScore)&&const DeepCollectionEquality().equals(other._components, _components)&&(identical(other.trend, trend) || other.trend == trend));
}


@override
int get hashCode => Object.hash(runtimeType,date,overallScore,const DeepCollectionEquality().hash(_components),trend);

@override
String toString() {
  return 'HealthScore(date: $date, overallScore: $overallScore, components: $components, trend: $trend)';
}


}

/// @nodoc
abstract mixin class _$HealthScoreCopyWith<$Res> implements $HealthScoreCopyWith<$Res> {
  factory _$HealthScoreCopyWith(_HealthScore value, $Res Function(_HealthScore) _then) = __$HealthScoreCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, double overallScore, Map<String, double> components, ScoreTrend trend
});




}
/// @nodoc
class __$HealthScoreCopyWithImpl<$Res>
    implements _$HealthScoreCopyWith<$Res> {
  __$HealthScoreCopyWithImpl(this._self, this._then);

  final _HealthScore _self;
  final $Res Function(_HealthScore) _then;

/// Create a copy of HealthScore
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? overallScore = null,Object? components = null,Object? trend = null,}) {
  return _then(_HealthScore(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,overallScore: null == overallScore ? _self.overallScore : overallScore // ignore: cast_nullable_to_non_nullable
as double,components: null == components ? _self._components : components // ignore: cast_nullable_to_non_nullable
as Map<String, double>,trend: null == trend ? _self.trend : trend // ignore: cast_nullable_to_non_nullable
as ScoreTrend,
  ));
}


}

// dart format on
