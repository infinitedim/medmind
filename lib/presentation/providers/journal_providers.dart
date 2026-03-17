import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medmind/core/enum/enum_collection.dart';
import 'package:medmind/domain/entities/journal_entry.dart';
import 'package:medmind/domain/entities/lifestyle_factor.dart';
import 'package:medmind/domain/entities/medication.dart';
import 'package:medmind/domain/entities/sleep_record.dart';
import 'package:medmind/domain/entities/symptom.dart';
import 'package:medmind/domain/usecases/journal/create_journal_entry.dart';
import 'package:medmind/domain/usecases/journal/delete_journal_entry.dart';
import 'package:medmind/domain/entities/vital_record.dart';
import 'package:medmind/domain/usecases/journal/get_journal_entries.dart';
import 'package:medmind/domain/usecases/journal/search_journal_entries.dart';
import 'package:medmind/domain/usecases/journal/update_journal_entry.dart';
import 'package:medmind/presentation/providers/core_providers.dart';

class JournalFormState {
  final String? entryId;
  final DateTime date;
  final Mood? mood;
  final int? moodIntensity;
  final List<SymptomLog> symptoms;
  final List<MedicationLog> medications;
  final SleepRecord? sleepRecord;
  final List<LifestyleFactorLog> lifestyleFactors;
  final String? freeText;
  final ActivityLevel? activityLevel;
  final VitalRecord? vitalRecord;
  final bool isSaving;

  const JournalFormState({
    this.entryId,
    required this.date,
    this.mood,
    this.moodIntensity,
    this.symptoms = const [],
    this.medications = const [],
    this.sleepRecord,
    this.lifestyleFactors = const [],
    this.freeText,
    this.activityLevel,
    this.vitalRecord,
    this.isSaving = false,
  });

  factory JournalFormState.fromEntry(JournalEntry entry) {
    return JournalFormState(
      entryId: entry.id,
      date: entry.date,
      mood: entry.mood,
      moodIntensity: entry.moodIntensity,
      symptoms: entry.symptoms,
      medications: entry.medications,
      sleepRecord: entry.sleepRecord,
      lifestyleFactors: entry.lifestyleFactors,
      freeText: entry.freeText,
      activityLevel: entry.activityLevel,
      vitalRecord: entry.vitalRecord,
    );
  }

  JournalEntry toEntry() {
    final now = DateTime.now();
    final id = entryId ?? now.millisecondsSinceEpoch.toString();
    return JournalEntry(
      id: id,
      date: date,
      mood: mood,
      moodIntensity: moodIntensity,
      symptoms: symptoms,
      medications: medications,
      sleepRecord: sleepRecord,
      lifestyleFactors: lifestyleFactors,
      freeText: freeText,
      activityLevel: activityLevel,
      vitalRecord: vitalRecord,
      createdAt: now,
      updatedAt: now,
    );
  }

  JournalFormState copyWith({
    String? entryId,
    DateTime? date,
    Mood? mood,
    int? moodIntensity,
    List<SymptomLog>? symptoms,
    List<MedicationLog>? medications,
    SleepRecord? sleepRecord,
    List<LifestyleFactorLog>? lifestyleFactors,
    String? freeText,
    ActivityLevel? activityLevel,
    VitalRecord? vitalRecord,
    bool? isSaving,
    bool clearMood = false,
    bool clearMoodIntensity = false,
    bool clearSleepRecord = false,
    bool clearFreeText = false,
    bool clearActivityLevel = false,
    bool clearVitalRecord = false,
  }) {
    return JournalFormState(
      entryId: entryId ?? this.entryId,
      date: date ?? this.date,
      mood: clearMood ? null : mood ?? this.mood,
      moodIntensity: clearMoodIntensity
          ? null
          : moodIntensity ?? this.moodIntensity,
      symptoms: symptoms ?? this.symptoms,
      medications: medications ?? this.medications,
      sleepRecord: clearSleepRecord ? null : sleepRecord ?? this.sleepRecord,
      lifestyleFactors: lifestyleFactors ?? this.lifestyleFactors,
      freeText: clearFreeText ? null : freeText ?? this.freeText,
      activityLevel: clearActivityLevel
          ? null
          : activityLevel ?? this.activityLevel,
      vitalRecord: clearVitalRecord ? null : vitalRecord ?? this.vitalRecord,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

final journalEntriesProvider =
    StreamProvider.family<List<JournalEntry>, (DateTime?, DateTime?)>((
      ref,
      dates,
    ) {
      final repo = ref.watch(journalRepositoryProvider);
      return repo.watchEntries(startDate: dates.$1, endDate: dates.$2);
    });

final journalEntryProvider = FutureProvider.family<JournalEntry?, String>((
  ref,
  id,
) async {
  final repo = ref.watch(journalRepositoryProvider);
  final result = await repo.getEntryById(id);
  return result.fold((_) => null, (v) => v);
});

final journalSearchProvider = FutureProvider.family<List<JournalEntry>, String>(
  (ref, query) async {
    if (query.isEmpty) return [];
    final repo = ref.watch(journalRepositoryProvider);
    final useCase = SearchJournalEntries(repo);
    final result = await useCase(query);
    return result.fold((_) => [], (v) => v);
  },
);

final journalFormProvider =
    AsyncNotifierProvider.family<
      JournalFormNotifier,
      JournalFormState,
      String?
    >((entryId) => JournalFormNotifier(entryId));

class JournalFormNotifier extends AsyncNotifier<JournalFormState> {
  final String? _entryId;

  JournalFormNotifier(this._entryId);

  @override
  Future<JournalFormState> build() async {
    if (_entryId == null) {
      return JournalFormState(date: DateTime.now());
    }
    final repo = ref.read(journalRepositoryProvider);
    final result = await repo.getEntryById(_entryId);
    return result.fold(
      (_) => JournalFormState(date: DateTime.now()),
      JournalFormState.fromEntry,
    );
  }

  void setMood(Mood mood) {
    state = AsyncData(state.requireValue.copyWith(mood: mood));
  }

  void setMoodIntensity(int intensity) {
    state = AsyncData(state.requireValue.copyWith(moodIntensity: intensity));
  }

  void setSleepRecord(SleepRecord? record) {
    if (record == null) {
      state = AsyncData(state.requireValue.copyWith(clearSleepRecord: true));
    } else {
      state = AsyncData(state.requireValue.copyWith(sleepRecord: record));
    }
  }

  void setActivityLevel(ActivityLevel level) {
    state = AsyncData(state.requireValue.copyWith(activityLevel: level));
  }

  void setDate(DateTime date) {
    state = AsyncData(state.requireValue.copyWith(date: date));
  }

  void setFreeText(String text) {
    state = AsyncData(
      state.requireValue.copyWith(
        freeText: text.isEmpty ? null : text,
        clearFreeText: text.isEmpty,
      ),
    );
  }

  void addSymptomLog(SymptomLog log) {
    final current = state.requireValue;
    final updated =
        current.symptoms.where((s) => s.symptomId != log.symptomId).toList()
          ..add(log);
    state = AsyncData(current.copyWith(symptoms: updated));
  }

  void removeSymptomLog(String symptomId) {
    final current = state.requireValue;
    state = AsyncData(
      current.copyWith(
        symptoms: current.symptoms
            .where((s) => s.symptomId != symptomId)
            .toList(),
      ),
    );
  }

  void addMedicationLog(MedicationLog log) {
    final current = state.requireValue;
    final updated =
        current.medications
            .where((m) => m.medicationId != log.medicationId)
            .toList()
          ..add(log);
    state = AsyncData(current.copyWith(medications: updated));
  }

  void addLifestyleFactorLog(LifestyleFactorLog log) {
    final current = state.requireValue;
    final updated =
        current.lifestyleFactors
            .where((l) => l.factorId != log.factorId)
            .toList()
          ..add(log);
    state = AsyncData(current.copyWith(lifestyleFactors: updated));
  }

  void updateVitals(VitalRecord? record) {
    if (record == null) {
      state = AsyncData(state.requireValue.copyWith(clearVitalRecord: true));
    } else {
      state = AsyncData(state.requireValue.copyWith(vitalRecord: record));
    }
  }

  Future<bool> submit() async {
    final current = state.requireValue;
    state = AsyncData(current.copyWith(isSaving: true));
    final entry = current.toEntry();
    final repo = ref.read(journalRepositoryProvider);
    if (current.entryId == null) {
      final result = await CreateJournalEntry(repo)(entry);
      return result.fold((_) {
        state = AsyncData(current.copyWith(isSaving: false));
        return false;
      }, (_) => true);
    } else {
      final result = await UpdateJournalEntry(repo)(entry);
      return result.fold((_) {
        state = AsyncData(current.copyWith(isSaving: false));
        return false;
      }, (_) => true);
    }
  }

  Future<bool> delete() async {
    final current = state.requireValue;
    if (current.entryId == null) return false;
    state = AsyncData(current.copyWith(isSaving: true));
    final repo = ref.read(journalRepositoryProvider);
    final useCase = DeleteJournalEntry(repo);
    final result = await useCase(current.entryId!);
    return result.fold((_) {
      state = AsyncData(current.copyWith(isSaving: false));
      return false;
    }, (_) => true);
  }
}

final journalPageEntriesProvider =
    FutureProvider.family<List<JournalEntry>, GetJournalEntriesParams>((
      ref,
      params,
    ) async {
      final repo = ref.watch(journalRepositoryProvider);
      final useCase = GetJournalEntries(repo);
      final result = await useCase(params);
      return result.fold((_) => [], (v) => v);
    });

final userMedicationsProvider = FutureProvider<List<Medication>>((_) async {
  return const [];
});

final todayJournalEntryProvider = Provider<JournalEntry?>((ref) {
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, now.day);
  final end = start.add(const Duration(days: 1));
  final list = ref.watch(journalEntriesProvider((start, end))).asData?.value;
  return list?.firstOrNull;
});

final journalEntriesCountProvider = Provider<int>((ref) {
  return ref.watch(journalEntriesProvider((null, null))).asData?.value.length ??
      0;
});

final journalStreakProvider = Provider<int>((ref) {
  final entries = ref.watch(journalEntriesProvider((null, null))).asData?.value;
  if (entries == null || entries.isEmpty) return 0;
  final dates =
      entries
          .map((e) => DateTime(e.date.year, e.date.month, e.date.day))
          .toSet()
          .toList()
        ..sort((a, b) => b.compareTo(a));
  final today = DateTime.now();
  final todayDate = DateTime(today.year, today.month, today.day);
  if (dates.first != todayDate &&
      dates.first != todayDate.subtract(const Duration(days: 1))) {
    return 0;
  }
  int streak = 1;
  for (int i = 1; i < dates.length; i++) {
    if (dates[i] == dates[i - 1].subtract(const Duration(days: 1))) {
      streak++;
    } else {
      break;
    }
  }
  return streak;
});
