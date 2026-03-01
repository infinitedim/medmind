import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medmind/core/enum/enum_collection.dart';
import 'package:medmind/domain/entities/lifestyle_factor.dart';
import 'package:medmind/domain/entities/medication.dart';
import 'package:medmind/domain/entities/sleep_record.dart';
import 'package:medmind/domain/entities/symptom.dart';

part 'journal_entry.freezed.dart';

@freezed
abstract class JournalEntry with _$JournalEntry {
  const factory JournalEntry({
    required String id,
    required DateTime date,
    Mood? mood,
    int? moodIntensity,
    @Default([]) List<SymptomLog> symptoms,
    @Default([]) List<MedicationLog> medications,
    SleepRecord? sleepRecord,
    @Default([]) List<LifestyleFactorLog> lifestyleFactors,
    String? freeText,
    List<ExtractedSymptom>? extractedSymptoms,
    ActivityLevel? activityLevel,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _JournalEntry;
}
