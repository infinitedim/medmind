import 'package:flutter/material.dart';

class Medication {
  final String id;
  final String name;
  final String? dosage;
  final String? frequency;

  Medication({
    required this.id,
    required this.name,
    this.dosage,
    this.frequency,
  });
}

class MedicationLog {
  final String medicationId;
  final bool taken;
  final TimeOfDay? time;
  final String? dosage;

  MedicationLog({
    required this.medicationId,
    required this.taken,
    this.time,
    this.dosage,
  });
}
