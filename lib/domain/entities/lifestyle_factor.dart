import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medmind/core/enum/enum_collection.dart';

part 'lifestyle_factor.freezed.dart';

@freezed
abstract class LifestyleFactor with _$LifestyleFactor {
  const factory LifestyleFactor({
    required String id,
    required String name,
    required FactorType type,
    String? unit,
  }) = _LifestyleFactor;
}

@freezed
abstract class LifestyleFactorLog with _$LifestyleFactorLog {
  const factory LifestyleFactorLog({
    required String factorId,
    bool? boolValue,
    double? numericValue,
    int? scaleValue,
  }) = _LifestyleFactorLog;
}
