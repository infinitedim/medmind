import 'package:medmind/core/enum/enum_collection.dart';
import 'package:medmind/domain/entities/lifestyle_factor.dart';
import 'package:medmind/domain/entities/medication.dart';
import 'package:medmind/domain/entities/sleep_record.dart';
import 'package:medmind/domain/entities/symptom.dart';

class JournalEntry {
  final String id;
  final DateTime date;
  final Mood? mood;
  final int? moodIntensity;
  final List<SymptomLog> symptoms;
  final List<MedicationLog> medications;
  final SleepRecord? sleepRecord;
  final List<LifestyleFactorLog> lifestyleFactors;
  final String? freeText;
  final List<ExtractedSymptom>? extractedSymptoms;
  final ActivityLevel? activityLevel;
  final DateTime createdAt;
  final DateTime updatedAt;

  JournalEntry({
    required this.id,
    required this.date,
    this.mood,
    this.moodIntensity,
    this.symptoms = const [],
    this.medications = const [],
    this.sleepRecord,
    this.lifestyleFactors = const [],
    this.freeText,
    this.extractedSymptoms,
    this.activityLevel,
    required this.createdAt,
    required this.updatedAt,
  });
}
