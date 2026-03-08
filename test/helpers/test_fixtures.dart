// test/helpers/test_fixtures.dart
// Shared fixtures (fake data) digunakan di semua test layer.

import 'package:medmind/core/enum/enum_collection.dart';
import 'package:medmind/domain/entities/journal_entry.dart';
import 'package:medmind/domain/entities/symptom.dart';
import 'package:medmind/domain/entities/sleep_record.dart';
import 'package:medmind/domain/entities/medication.dart';
import 'package:medmind/domain/entities/lifestyle_factor.dart';

/// Entry id yang digunakan secara konsisten di semua test.
const kTestEntryId = 'test-entry-id-123';
const kTestEntryId2 = 'test-entry-id-456';

final kNow = DateTime(2026, 3, 8, 10, 0);

/// Minimal valid [JournalEntry] tanpa data opsional.
JournalEntry makeMinimalEntry({
  String id = kTestEntryId,
  DateTime? date,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final ts = date ?? kNow;
  return JournalEntry(
    id: id,
    date: ts,
    createdAt: createdAt ?? ts,
    updatedAt: updatedAt ?? ts,
  );
}

/// [JournalEntry] lengkap dengan semua field terisi.
JournalEntry makeFullEntry({String id = kTestEntryId, DateTime? date}) {
  final ts = date ?? kNow;
  return JournalEntry(
    id: id,
    date: ts,
    mood: Mood.good,
    moodIntensity: 7,
    symptoms: [
      SymptomLog(
        symptomId: 'symptom-headache',
        severity: 4,
        notes: 'After lunch',
      ),
    ],
    medications: [
      MedicationLog(
        medicationId: 'med-paracetamol',
        dosage: '500mg',
        // takenAt: ts,
        taken: true,
      ),
    ],
    sleepRecord: SleepRecord(
      bedTime: ts.subtract(const Duration(hours: 8)),
      wakeTime: ts,
      // durationMinutes: 480,
      disturbances: 480,
      quality: 3,
    ),
    lifestyleFactors: [
      LifestyleFactorLog(factorId: 'factor-exercise', numericValue: 30),
    ],
    freeText: 'Felt okay today, mild headache after lunch.',
    activityLevel: ActivityLevel.moderate,
    createdAt: ts,
    updatedAt: ts,
  );
}

/// List minimal entries untuk test yang butuh koleksi.
List<JournalEntry> makeEntryList({int count = 3}) {
  return List.generate(
    count,
    (i) => makeMinimalEntry(
      id: 'test-entry-id-$i',
      date: kNow.subtract(Duration(days: i)),
    ),
  );
}
