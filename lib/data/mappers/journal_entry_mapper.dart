// lib/data/mappers/journal_entry_mapper.dart
import 'package:flutter/material.dart';
import 'package:medmind/data/models/journal_entry_model.dart';
import 'package:medmind/domain/entities/journal_entry.dart';
import 'package:medmind/domain/entities/lifestyle_factor.dart';
import 'package:medmind/domain/entities/medication.dart';
import 'package:medmind/domain/entities/sleep_record.dart';
import 'package:medmind/domain/entities/symptom.dart';

/// Konversi antara [JournalEntry] (domain) dan [JournalEntryModel] (data/Isar).
///
/// Model fields sudah menggunakan domain enums langsung (Mood, ActivityLevel),
/// sehingga tidak perlu konversi enum terpisah.
extension JournalEntryModelMapper on JournalEntryModel {
  JournalEntry toDomain() {
    return JournalEntry(
      id: uid,
      date: date,
      mood: mood,
      moodIntensity: moodIntensity,
      symptoms: symptoms.map((e) => e.toDomain()).toList(),
      medications: medications.map((e) => e.toDomain()).toList(),
      sleepRecord: sleepRecord?.toDomain(),
      lifestyleFactors: lifestyleFactors.map((e) => e.toDomain()).toList(),
      freeText: freeText,
      extractedSymptoms: extractedSymptoms?.map((e) => e.toDomain()).toList(),
      activityLevel: activityLevel,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension JournalEntryDomainMapper on JournalEntry {
  JournalEntryModel toModel() {
    return JournalEntryModel()
      ..uid = id
      ..date = date
      ..mood = mood
      ..moodIntensity = moodIntensity
      ..symptoms = symptoms.map((e) => e.toModel()).toList()
      ..medications = medications.map((e) => e.toModel()).toList()
      ..sleepRecord = sleepRecord?.toModel()
      ..lifestyleFactors = lifestyleFactors.map((e) => e.toModel()).toList()
      ..freeText = freeText
      ..extractedSymptoms = extractedSymptoms?.map((e) => e.toModel()).toList()
      ..activityLevel = activityLevel
      ..createdAt = createdAt
      ..updatedAt = updatedAt;
  }
}

// ─── SymptomLog ──────────────────────────────────────────────────────────────

extension SymptomLogEmbedMapper on SymptomLogEmbed {
  SymptomLog toDomain() {
    return SymptomLog(
      symptomId: symptomId,
      severity: severity,
      onset: onsetHour != null && onsetMinute != null
          ? TimeOfDay(hour: onsetHour!, minute: onsetMinute!)
          : null,
      duration: durationMinutes != null
          ? Duration(minutes: durationMinutes!)
          : null,
      notes: notes,
    );
  }
}

extension SymptomLogDomainMapper on SymptomLog {
  SymptomLogEmbed toModel() {
    return SymptomLogEmbed()
      ..symptomId = symptomId
      ..severity = severity
      ..onsetHour = onset?.hour
      ..onsetMinute = onset?.minute
      ..durationMinutes = duration?.inMinutes
      ..notes = notes;
  }
}

// ─── MedicationLog ──────────────────────────────────────────────────────────

extension MedicationLogEmbedMapper on MedicationLogEmbed {
  MedicationLog toDomain() {
    return MedicationLog(
      medicationId: medicationId,
      taken: taken,
      time: timeHour != null && timeMinute != null
          ? TimeOfDay(hour: timeHour!, minute: timeMinute!)
          : null,
      dosage: dosage,
    );
  }
}

extension MedicationLogDomainMapper on MedicationLog {
  MedicationLogEmbed toModel() {
    return MedicationLogEmbed()
      ..medicationId = medicationId
      ..taken = taken
      ..timeHour = time?.hour
      ..timeMinute = time?.minute
      ..dosage = dosage;
  }
}

// ─── SleepRecord ─────────────────────────────────────────────────────────────

extension SleepRecordEmbedMapper on SleepRecordEmbed {
  SleepRecord toDomain() {
    return SleepRecord(
      bedTime: DateTime.fromMillisecondsSinceEpoch(bedTimeMs),
      wakeTime: DateTime.fromMillisecondsSinceEpoch(wakeTimeMs),
      quality: quality,
      disturbances: disturbances,
    );
  }
}

extension SleepRecordDomainMapper on SleepRecord {
  SleepRecordEmbed toModel() {
    return SleepRecordEmbed()
      ..bedTimeMs = bedTime.millisecondsSinceEpoch
      ..wakeTimeMs = wakeTime.millisecondsSinceEpoch
      ..quality = quality
      ..disturbances = disturbances;
  }
}

// ─── LifestyleFactorLog ──────────────────────────────────────────────────────

extension LifestyleFactorLogEmbedMapper on LifestyleFactorLogEmbed {
  LifestyleFactorLog toDomain() {
    return LifestyleFactorLog(
      factorId: factorId,
      boolValue: boolValue,
      numericValue: numericValue,
      scaleValue: scaleValue,
    );
  }
}

extension LifestyleFactorLogDomainMapper on LifestyleFactorLog {
  LifestyleFactorLogEmbed toModel() {
    return LifestyleFactorLogEmbed()
      ..factorId = factorId
      ..boolValue = boolValue
      ..numericValue = numericValue
      ..scaleValue = scaleValue;
  }
}

// ─── ExtractedSymptom ────────────────────────────────────────────────────────

extension ExtractedSymptomEmbedMapper on ExtractedSymptomEmbed {
  ExtractedSymptom toDomain() {
    return ExtractedSymptom(
      symptomName: symptomName,
      severity: severity,
      confidence: confidence,
      sourceText: sourceText,
      isConfirmedByUser: isConfirmedByUser,
    );
  }
}

extension ExtractedSymptomDomainMapper on ExtractedSymptom {
  ExtractedSymptomEmbed toModel() {
    return ExtractedSymptomEmbed()
      ..symptomName = symptomName
      ..severity = severity
      ..confidence = confidence
      ..sourceText = sourceText
      ..isConfirmedByUser = isConfirmedByUser;
  }
}
