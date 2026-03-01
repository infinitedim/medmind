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
    required int severity, // 1-10
    TimeOfDay? onset, // kapan mulai
    Duration? duration, // berapa lama
    String? notes,
  }) = _SymptomLog;
}

@freezed
abstract class ExtractedSymptom with _$ExtractedSymptom {
  const factory ExtractedSymptom({
    required String symptomName,
    String? severity, // mild, moderate, severe
    required double confidence, // 0.0 - 1.0
    required String sourceText, // potongan teks yang di-extract
    bool? isConfirmedByUser,
  }) = _ExtractedSymptom;
}
