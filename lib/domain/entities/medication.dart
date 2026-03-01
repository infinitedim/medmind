import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'medication.freezed.dart';

@freezed
abstract class Medication with _$Medication {
  const factory Medication({
    required String id,
    required String name,
    String? dosage,
    String? frequency,
  }) = _Medication;
}

@freezed
abstract class MedicationLog with _$MedicationLog {
  const factory MedicationLog({
    required String medicationId,
    required bool taken,
    TimeOfDay? time,
    String? dosage,
  }) = _MedicationLog;
}
