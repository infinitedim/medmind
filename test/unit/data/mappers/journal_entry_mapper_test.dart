// test/unit/data/mappers/journal_entry_mapper_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medmind/core/enum/enum_collection.dart';
import 'package:medmind/data/mappers/journal_entry_mapper.dart';
import 'package:medmind/data/models/journal_entry_model.dart';
import 'package:medmind/domain/entities/journal_entry.dart';
import 'package:medmind/domain/entities/lifestyle_factor.dart';
import 'package:medmind/domain/entities/medication.dart';
import 'package:medmind/domain/entities/sleep_record.dart';
import 'package:medmind/domain/entities/symptom.dart';

void main() {
  // ─── SymptomLog ────────────────────────────────────────────────────────────

  group('SymptomLogEmbed.toDomain()', () {
    test('maps all fields including optional onset, duration, notes', () {
      final embed = SymptomLogEmbed()
        ..symptomId = 'headache'
        ..severity = 5
        ..onsetHour = 10
        ..onsetMinute = 30
        ..durationMinutes = 45
        ..notes = 'after lunch';

      final domain = embed.toDomain();

      expect(domain.symptomId, 'headache');
      expect(domain.severity, 5);
      expect(domain.onset, const TimeOfDay(hour: 10, minute: 30));
      expect(domain.duration, const Duration(minutes: 45));
      expect(domain.notes, 'after lunch');
    });

    test('onset is null when onsetHour/Minute are null', () {
      final embed = SymptomLogEmbed()
        ..symptomId = 'nausea'
        ..severity = 3;

      final domain = embed.toDomain();

      expect(domain.onset, isNull);
      expect(domain.duration, isNull);
      expect(domain.notes, isNull);
    });
  });

  group('SymptomLog.toModel()', () {
    test('maps all fields including optional onset, duration, notes', () {
      const log = SymptomLog(
        symptomId: 'headache',
        severity: 5,
        onset: TimeOfDay(hour: 10, minute: 30),
        duration: Duration(minutes: 45),
        notes: 'after lunch',
      );

      final model = log.toModel();

      expect(model.symptomId, 'headache');
      expect(model.severity, 5);
      expect(model.onsetHour, 10);
      expect(model.onsetMinute, 30);
      expect(model.durationMinutes, 45);
      expect(model.notes, 'after lunch');
    });

    test('optional fields are null when not provided', () {
      const log = SymptomLog(symptomId: 'nausea', severity: 3);

      final model = log.toModel();

      expect(model.onsetHour, isNull);
      expect(model.onsetMinute, isNull);
      expect(model.durationMinutes, isNull);
      expect(model.notes, isNull);
    });
  });

  group('SymptomLog round-trip', () {
    test('domain → model → domain preserves all fields', () {
      const original = SymptomLog(
        symptomId: 'dizziness',
        severity: 7,
        onset: TimeOfDay(hour: 15, minute: 45),
        duration: Duration(minutes: 30),
        notes: 'before dinner',
      );

      final restored = original.toModel().toDomain();

      expect(restored.symptomId, original.symptomId);
      expect(restored.severity, original.severity);
      expect(restored.onset, original.onset);
      expect(restored.duration, original.duration);
      expect(restored.notes, original.notes);
    });
  });

  // ─── MedicationLog ──────────────────────────────────────────────────────────

  group('MedicationLogEmbed.toDomain()', () {
    test('maps all fields including optional time and dosage', () {
      final embed = MedicationLogEmbed()
        ..medicationId = 'paracetamol'
        ..taken = true
        ..timeHour = 8
        ..timeMinute = 0
        ..dosage = '500mg';

      final domain = embed.toDomain();

      expect(domain.medicationId, 'paracetamol');
      expect(domain.taken, isTrue);
      expect(domain.time, const TimeOfDay(hour: 8, minute: 0));
      expect(domain.dosage, '500mg');
    });

    test('time is null when timeHour/Minute are null', () {
      final embed = MedicationLogEmbed()
        ..medicationId = 'ibuprofen'
        ..taken = false;

      final domain = embed.toDomain();

      expect(domain.time, isNull);
      expect(domain.dosage, isNull);
    });
  });

  group('MedicationLog.toModel()', () {
    test('maps all fields correctly', () {
      const log = MedicationLog(
        medicationId: 'paracetamol',
        taken: true,
        time: TimeOfDay(hour: 8, minute: 0),
        dosage: '500mg',
      );

      final model = log.toModel();

      expect(model.medicationId, 'paracetamol');
      expect(model.taken, isTrue);
      expect(model.timeHour, 8);
      expect(model.timeMinute, 0);
      expect(model.dosage, '500mg');
    });
  });

  // ─── SleepRecord ───────────────────────────────────────────────────────────

  group('SleepRecordEmbed.toDomain()', () {
    test('converts millisecond timestamps to DateTime and maps quality', () {
      final bedTime = DateTime(2026, 3, 7, 22, 30);
      final wakeTime = DateTime(2026, 3, 8, 6, 30);
      final embed = SleepRecordEmbed()
        ..bedTimeMs = bedTime.millisecondsSinceEpoch
        ..wakeTimeMs = wakeTime.millisecondsSinceEpoch
        ..quality = 8
        ..disturbances = 2;

      final domain = embed.toDomain();

      expect(
        domain.bedTime.millisecondsSinceEpoch,
        bedTime.millisecondsSinceEpoch,
      );
      expect(
        domain.wakeTime.millisecondsSinceEpoch,
        wakeTime.millisecondsSinceEpoch,
      );
      expect(domain.quality, 8);
      expect(domain.disturbances, 2);
    });

    test('disturbances is null when not set', () {
      final embed = SleepRecordEmbed()
        ..bedTimeMs = DateTime(2026, 3, 7, 23, 0).millisecondsSinceEpoch
        ..wakeTimeMs = DateTime(2026, 3, 8, 7, 0).millisecondsSinceEpoch
        ..quality = 6;

      final domain = embed.toDomain();

      expect(domain.disturbances, isNull);
    });
  });

  group('SleepRecord.toModel()', () {
    test('converts DateTime to millisecond timestamps', () {
      final bedTime = DateTime(2026, 3, 7, 22, 30);
      final wakeTime = DateTime(2026, 3, 8, 6, 30);
      final record = SleepRecord(
        bedTime: bedTime,
        wakeTime: wakeTime,
        quality: 8,
        disturbances: 2,
      );

      final model = record.toModel();

      expect(model.bedTimeMs, bedTime.millisecondsSinceEpoch);
      expect(model.wakeTimeMs, wakeTime.millisecondsSinceEpoch);
      expect(model.quality, 8);
      expect(model.disturbances, 2);
    });
  });

  group('SleepRecord round-trip', () {
    test('domain → model → domain preserves millisecond precision', () {
      final bedTime = DateTime(2026, 3, 7, 22, 0);
      final wakeTime = DateTime(2026, 3, 8, 6, 0);
      final original = SleepRecord(
        bedTime: bedTime,
        wakeTime: wakeTime,
        quality: 7,
      );

      final restored = original.toModel().toDomain();

      expect(
        restored.bedTime.millisecondsSinceEpoch,
        original.bedTime.millisecondsSinceEpoch,
      );
      expect(
        restored.wakeTime.millisecondsSinceEpoch,
        original.wakeTime.millisecondsSinceEpoch,
      );
      expect(restored.quality, original.quality);
    });
  });

  // ─── LifestyleFactorLog ────────────────────────────────────────────────────

  group('LifestyleFactorLogEmbed.toDomain()', () {
    test('maps boolValue factor', () {
      final embed = LifestyleFactorLogEmbed()
        ..factorId = 'exercise'
        ..boolValue = true;

      final domain = embed.toDomain();

      expect(domain.factorId, 'exercise');
      expect(domain.boolValue, isTrue);
      expect(domain.numericValue, isNull);
      expect(domain.scaleValue, isNull);
    });

    test('maps numericValue factor', () {
      final embed = LifestyleFactorLogEmbed()
        ..factorId = 'steps'
        ..numericValue = 8500.0;

      final domain = embed.toDomain();

      expect(domain.numericValue, 8500.0);
    });

    test('maps scaleValue factor', () {
      final embed = LifestyleFactorLogEmbed()
        ..factorId = 'stress'
        ..scaleValue = 7;

      final domain = embed.toDomain();

      expect(domain.scaleValue, 7);
    });
  });

  group('LifestyleFactorLog.toModel()', () {
    test('maps all optional fields', () {
      const log = LifestyleFactorLog(factorId: 'water', numericValue: 2.5);

      final model = log.toModel();

      expect(model.factorId, 'water');
      expect(model.numericValue, 2.5);
      expect(model.boolValue, isNull);
      expect(model.scaleValue, isNull);
    });
  });

  // ─── ExtractedSymptom ──────────────────────────────────────────────────────

  group('ExtractedSymptomEmbed.toDomain()', () {
    test('maps all fields including optional ones', () {
      final embed = ExtractedSymptomEmbed()
        ..symptomName = 'headache'
        ..severity = 'moderate'
        ..confidence = 0.85
        ..sourceText = 'I have a headache'
        ..isConfirmedByUser = true;

      final domain = embed.toDomain();

      expect(domain.symptomName, 'headache');
      expect(domain.severity, 'moderate');
      expect(domain.confidence, 0.85);
      expect(domain.sourceText, 'I have a headache');
      expect(domain.isConfirmedByUser, isTrue);
    });

    test('optional fields can be null', () {
      final embed = ExtractedSymptomEmbed()
        ..symptomName = 'fatigue'
        ..confidence = 0.7
        ..sourceText = 'feeling tired';

      final domain = embed.toDomain();

      expect(domain.severity, isNull);
      expect(domain.isConfirmedByUser, isNull);
    });
  });

  group('ExtractedSymptom round-trip', () {
    test('domain → model → domain preserves all fields', () {
      const original = ExtractedSymptom(
        symptomName: 'nausea',
        severity: 'severe',
        confidence: 0.95,
        sourceText: 'severe nausea after eating',
        isConfirmedByUser: false,
      );

      final restored = original.toModel().toDomain();

      expect(restored.symptomName, original.symptomName);
      expect(restored.severity, original.severity);
      expect(restored.confidence, original.confidence);
      expect(restored.sourceText, original.sourceText);
      expect(restored.isConfirmedByUser, original.isConfirmedByUser);
    });
  });

  // ─── JournalEntry full round-trip ─────────────────────────────────────────

  group('JournalEntry full round-trip', () {
    test('domain entry → model → domain preserves all fields', () {
      final ts = DateTime(2026, 3, 8, 10, 0);
      final original = JournalEntry(
        id: 'entry-round-trip',
        date: ts,
        mood: Mood.good,
        moodIntensity: 7,
        symptoms: const [SymptomLog(symptomId: 'headache', severity: 4)],
        medications: const [
          MedicationLog(medicationId: 'paracetamol', taken: true),
        ],
        sleepRecord: SleepRecord(
          bedTime: ts.subtract(const Duration(hours: 8)),
          wakeTime: ts,
          quality: 7,
        ),
        lifestyleFactors: const [
          LifestyleFactorLog(factorId: 'exercise', boolValue: true),
        ],
        freeText: 'Feeling okay today.',
        activityLevel: ActivityLevel.moderate,
        createdAt: ts,
        updatedAt: ts,
      );

      final model = original.toModel();
      final restored = model.toDomain();

      expect(restored.id, original.id);
      expect(restored.date, original.date);
      expect(restored.mood, original.mood);
      expect(restored.moodIntensity, original.moodIntensity);
      expect(restored.freeText, original.freeText);
      expect(restored.activityLevel, original.activityLevel);
      expect(restored.createdAt, original.createdAt);
      expect(restored.updatedAt, original.updatedAt);

      // Symptoms
      expect(restored.symptoms.length, 1);
      expect(restored.symptoms.first.symptomId, 'headache');
      expect(restored.symptoms.first.severity, 4);

      // Medications
      expect(restored.medications.length, 1);
      expect(restored.medications.first.medicationId, 'paracetamol');
      expect(restored.medications.first.taken, isTrue);

      // Sleep
      expect(restored.sleepRecord, isNotNull);
      expect(restored.sleepRecord!.quality, 7);

      // Lifestyle
      expect(restored.lifestyleFactors.length, 1);
      expect(restored.lifestyleFactors.first.factorId, 'exercise');
    });

    test('minimal entry with no optional fields round-trips cleanly', () {
      final ts = DateTime(2026, 3, 8);
      final original = JournalEntry(
        id: 'minimal',
        date: ts,
        createdAt: ts,
        updatedAt: ts,
      );

      final restored = original.toModel().toDomain();

      expect(restored.id, original.id);
      expect(restored.mood, isNull);
      expect(restored.sleepRecord, isNull);
      expect(restored.freeText, isNull);
      expect(restored.symptoms, isEmpty);
      expect(restored.medications, isEmpty);
      expect(restored.lifestyleFactors, isEmpty);
    });
  });
}
