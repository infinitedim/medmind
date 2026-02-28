import 'package:flutter/material.dart';
import 'package:medmind/core/enum/enum_collection.dart';

class Symptom {
  final String id;
  final String name;
  final SymptomCategory category;
  final String icon;
  final bool isCustom;

  Symptom({
    required this.id,
    required this.name,
    required this.category,
    required this.icon,
    this.isCustom = false,
  });
}

class SymptomLog {
  final String symptomId;
  final int severity; // 1-10
  final TimeOfDay? onset; // kapan mulai
  final Duration? duration; // berapa lama
  final String? notes;

  SymptomLog({
    required this.symptomId,
    required this.severity,
    this.onset,
    this.duration,
    this.notes,
  });
}

class ExtractedSymptom {
  final String symptomName;
  final String? severity; // mild, moderate, severe
  final double confidence; // 0.0 - 1.0
  final String sourceText; // potongan teks yang di-extract
  final bool? isConfirmedByUser;

  ExtractedSymptom({
    required this.symptomName,
    this.severity,
    required this.confidence,
    required this.sourceText,
    this.isConfirmedByUser,
  });
}