import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medmind/core/enum/enum_collection.dart';

part 'symptom.freezed.dart';

@freezed
abstract class Symptom with _$Symptom {
  const factory Symptom({
    required String id,
    required String name,
    required SymptomCategory category,
    required String icon,
    @Default(false) bool isCustom,
  }) = _Symptom;
}

@freezed
abstract class SymptomLog with _$SymptomLog {
  const factory SymptomLog({
    required String symptomId,
    required int severity,
    TimeOfDay? onset,
    Duration? duration,
    String? notes,
  }) = _SymptomLog;
}

@freezed
abstract class ExtractedSymptom with _$ExtractedSymptom {
  const factory ExtractedSymptom({
    required String symptomName,
    String? severity,
    required double confidence,
    required String sourceText,
    bool? isConfirmedByUser,
  }) = _ExtractedSymptom;
}
