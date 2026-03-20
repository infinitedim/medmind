// test/unit/presentation/providers/journal_form_notifier_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:medmind/core/enum/enum_collection.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/entities/sleep_record.dart';
import 'package:medmind/domain/entities/symptom.dart';
import 'package:medmind/presentation/providers/core_providers.dart';
import 'package:medmind/presentation/providers/journal_providers.dart';

import '../../../helpers/mock_repositories.dart';
import '../../../helpers/test_fixtures.dart';

void main() {
  late MockJournalRepository mockRepo;

  setUp(() {
    registerFallbackValues();
    mockRepo = MockJournalRepository();
  });

  ProviderContainer makeContainer({String? entryId}) {
    return ProviderContainer(
      overrides: [journalRepositoryProvider.overrideWithValue(mockRepo)],
    );
  }

  // ─── JournalFormState unit tests ──────────────────────────────────────────

  group('JournalFormState', () {
    test('fromEntry populates all fields from JournalEntry', () {
      final entry = makeFullEntry();
      final state = JournalFormState.fromEntry(entry);

      expect(state.entryId, entry.id);
      expect(state.date, entry.date);
      expect(state.mood, entry.mood);
      expect(state.moodIntensity, entry.moodIntensity);
      expect(state.symptoms, entry.symptoms);
      expect(state.medications, entry.medications);
      expect(state.sleepRecord, entry.sleepRecord);
      expect(state.freeText, entry.freeText);
      expect(state.activityLevel, entry.activityLevel);
    });

    test('toEntry uses entryId as id when set', () {
      final state = JournalFormState(
        entryId: 'existing-id',
        date: kNow,
        mood: Mood.good,
      );

      final entry = state.toEntry();

      expect(entry.id, 'existing-id');
      expect(entry.mood, Mood.good);
      expect(entry.date, kNow);
    });

    test('toEntry generates id from timestamp when entryId is null', () {
      final state = JournalFormState(date: kNow);

      final entry = state.toEntry();

      expect(entry.id, isNotEmpty);
    });

    test('copyWith clearMood sets mood to null', () {
      final state = JournalFormState(date: kNow, mood: Mood.great);

      final updated = state.copyWith(clearMood: true);

      expect(updated.mood, isNull);
    });

    test('copyWith clearSleepRecord sets sleepRecord to null', () {
      final state = JournalFormState(
        date: kNow,
        sleepRecord: SleepRecord(
          bedTime: kNow.subtract(const Duration(hours: 8)),
          wakeTime: kNow,
          quality: 7,
        ),
      );

      final updated = state.copyWith(clearSleepRecord: true);

      expect(updated.sleepRecord, isNull);
    });

    test('copyWith preserves existing field when no new value provided', () {
      final state = JournalFormState(date: kNow, mood: Mood.good);

      final updated = state.copyWith(moodIntensity: 8);

      expect(updated.mood, Mood.good);
      expect(updated.moodIntensity, 8);
    });
  });

  // ─── JournalFormNotifier tests ────────────────────────────────────────────

  group('JournalFormNotifier — new entry (entryId = null)', () {
    test('build returns initial state with null entryId', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      final state = await container.read(journalFormProvider(null).future);

      expect(state.entryId, isNull);
      expect(state.mood, isNull);
      expect(state.symptoms, isEmpty);
    });

    test('setMood updates mood in state', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(journalFormProvider(null).future);
      container.read(journalFormProvider(null).notifier).setMood(Mood.great);

      final state = container.read(journalFormProvider(null)).requireValue;
      expect(state.mood, Mood.great);
    });

    test('setMoodIntensity updates moodIntensity in state', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(journalFormProvider(null).future);
      container.read(journalFormProvider(null).notifier).setMoodIntensity(8);

      final state = container.read(journalFormProvider(null)).requireValue;
      expect(state.moodIntensity, 8);
    });

    test('addSymptomLog adds new symptom', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(journalFormProvider(null).future);
      container
          .read(journalFormProvider(null).notifier)
          .addSymptomLog(const SymptomLog(symptomId: 'headache', severity: 5));

      final state = container.read(journalFormProvider(null)).requireValue;
      expect(state.symptoms.length, 1);
      expect(state.symptoms.first.symptomId, 'headache');
    });

    test('addSymptomLog replaces existing log with same symptomId', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(journalFormProvider(null).future);
      final notifier = container.read(journalFormProvider(null).notifier);
      notifier.addSymptomLog(
        const SymptomLog(symptomId: 'headache', severity: 3),
      );
      notifier.addSymptomLog(
        const SymptomLog(symptomId: 'headache', severity: 7),
      );

      final state = container.read(journalFormProvider(null)).requireValue;
      expect(state.symptoms.length, 1);
      expect(state.symptoms.first.severity, 7);
    });

    test('removeSymptomLog removes symptom by id', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(journalFormProvider(null).future);
      final notifier = container.read(journalFormProvider(null).notifier);
      notifier.addSymptomLog(
        const SymptomLog(symptomId: 'headache', severity: 5),
      );
      notifier.addSymptomLog(
        const SymptomLog(symptomId: 'nausea', severity: 3),
      );
      notifier.removeSymptomLog('headache');

      final state = container.read(journalFormProvider(null)).requireValue;
      expect(state.symptoms.length, 1);
      expect(state.symptoms.first.symptomId, 'nausea');
    });

    test('submit() calls createEntry and returns true on success', () async {
      final newEntry = makeMinimalEntry();
      when(
        () => mockRepo.createEntry(any()),
      ).thenAnswer((_) async => Right(newEntry));

      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(journalFormProvider(null).future);
      final result = await container
          .read(journalFormProvider(null).notifier)
          .submit();

      expect(result, isTrue);
      verify(() => mockRepo.createEntry(any())).called(1);
    });

    test('submit() returns false when createEntry fails', () async {
      when(
        () => mockRepo.createEntry(any()),
      ).thenAnswer((_) async => const Left(DatabaseFailure('write error')));

      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(journalFormProvider(null).future);
      final result = await container
          .read(journalFormProvider(null).notifier)
          .submit();

      expect(result, isFalse);
    });

    test(
      'delete() with null entryId returns false without calling repo',
      () async {
        final container = makeContainer();
        addTearDown(container.dispose);

        await container.read(journalFormProvider(null).future);
        final result = await container
            .read(journalFormProvider(null).notifier)
            .delete();

        expect(result, isFalse);
        verifyNever(() => mockRepo.deleteEntry(any()));
      },
    );
  });

  group('JournalFormNotifier — existing entry', () {
    test('build loads entry from repo when entryId is provided', () async {
      final existingEntry = makeFullEntry();
      when(
        () => mockRepo.getEntryById(kTestEntryId),
      ).thenAnswer((_) async => Right(existingEntry));

      final container = makeContainer(entryId: kTestEntryId);
      addTearDown(container.dispose);

      final state = await container.read(
        journalFormProvider(kTestEntryId).future,
      );

      expect(state.entryId, kTestEntryId);
      expect(state.mood, existingEntry.mood);
      verify(() => mockRepo.getEntryById(kTestEntryId)).called(1);
    });

    test('build falls back to empty state when getEntryById fails', () async {
      when(
        () => mockRepo.getEntryById(any()),
      ).thenAnswer((_) async => const Left(NotFoundFailure('not found')));

      final container = makeContainer(entryId: 'missing-id');
      addTearDown(container.dispose);

      final state = await container.read(
        journalFormProvider('missing-id').future,
      );

      expect(state.entryId, isNull);
    });

    test('submit() calls updateEntry for existing entry', () async {
      final existingEntry = makeFullEntry();
      when(
        () => mockRepo.getEntryById(kTestEntryId),
      ).thenAnswer((_) async => Right(existingEntry));
      when(
        () => mockRepo.updateEntry(any()),
      ).thenAnswer((_) async => Right(existingEntry));

      final container = makeContainer(entryId: kTestEntryId);
      addTearDown(container.dispose);

      await container.read(journalFormProvider(kTestEntryId).future);
      final result = await container
          .read(journalFormProvider(kTestEntryId).notifier)
          .submit();

      expect(result, isTrue);
      verify(() => mockRepo.updateEntry(any())).called(1);
      verifyNever(() => mockRepo.createEntry(any()));
    });

    test('delete() calls deleteEntry and returns true on success', () async {
      final existingEntry = makeFullEntry();
      when(
        () => mockRepo.getEntryById(kTestEntryId),
      ).thenAnswer((_) async => Right(existingEntry));
      when(
        () => mockRepo.deleteEntry(kTestEntryId),
      ).thenAnswer((_) async => const Right(null));

      final container = makeContainer(entryId: kTestEntryId);
      addTearDown(container.dispose);

      await container.read(journalFormProvider(kTestEntryId).future);
      final result = await container
          .read(journalFormProvider(kTestEntryId).notifier)
          .delete();

      expect(result, isTrue);
      verify(() => mockRepo.deleteEntry(kTestEntryId)).called(1);
    });
  });

  // ─── journalStreakProvider tests ───────────────────────────────────────────

  group('journalStreakProvider', () {
    test('returns 0 when entry list is empty', () async {
      when(
        () => mockRepo.watchEntries(
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      ).thenAnswer((_) => Stream.value([]));

      final container = ProviderContainer(
        overrides: [journalRepositoryProvider.overrideWithValue(mockRepo)],
      );
      addTearDown(container.dispose);

      await container.read(journalEntriesProvider((null, null)).future);
      expect(container.read(journalStreakProvider), 0);
    });

    test('returns 1 for today only', () async {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final entries = [makeMinimalEntry(date: today)];
      when(
        () => mockRepo.watchEntries(
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      ).thenAnswer((_) => Stream.value(entries));

      final container = ProviderContainer(
        overrides: [journalRepositoryProvider.overrideWithValue(mockRepo)],
      );
      addTearDown(container.dispose);

      await container.read(journalEntriesProvider((null, null)).future);
      expect(container.read(journalStreakProvider), 1);
    });

    test('returns 1 for yesterday only (no entry today)', () async {
      final now = DateTime.now();
      final yesterday = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(const Duration(days: 1));
      final entries = [makeMinimalEntry(date: yesterday)];
      when(
        () => mockRepo.watchEntries(
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      ).thenAnswer((_) => Stream.value(entries));

      final container = ProviderContainer(
        overrides: [journalRepositoryProvider.overrideWithValue(mockRepo)],
      );
      addTearDown(container.dispose);

      await container.read(journalEntriesProvider((null, null)).future);
      expect(container.read(journalStreakProvider), 1);
    });

    test('counts consecutive days from today', () async {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final entries = List.generate(
        5,
        (i) => makeMinimalEntry(
          id: 'e$i',
          date: today.subtract(Duration(days: i)),
        ),
      );
      when(
        () => mockRepo.watchEntries(
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      ).thenAnswer((_) => Stream.value(entries));

      final container = ProviderContainer(
        overrides: [journalRepositoryProvider.overrideWithValue(mockRepo)],
      );
      addTearDown(container.dispose);

      await container.read(journalEntriesProvider((null, null)).future);
      expect(container.read(journalStreakProvider), 5);
    });

    test('streak breaks when there is a gap', () async {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      // today, day-1, gap (no day-2), day-3
      final entries = [
        makeMinimalEntry(id: 'e0', date: today),
        makeMinimalEntry(
          id: 'e1',
          date: today.subtract(const Duration(days: 1)),
        ),
        makeMinimalEntry(
          id: 'e3',
          date: today.subtract(const Duration(days: 3)),
        ),
      ];
      when(
        () => mockRepo.watchEntries(
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      ).thenAnswer((_) => Stream.value(entries));

      final container = ProviderContainer(
        overrides: [journalRepositoryProvider.overrideWithValue(mockRepo)],
      );
      addTearDown(container.dispose);

      await container.read(journalEntriesProvider((null, null)).future);
      expect(container.read(journalStreakProvider), 2);
    });

    test('returns 0 when most recent entry is 2+ days ago', () async {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final entries = List.generate(
        5,
        (i) => makeMinimalEntry(
          id: 'e$i',
          date: today.subtract(Duration(days: i + 2)),
        ),
      );
      when(
        () => mockRepo.watchEntries(
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      ).thenAnswer((_) => Stream.value(entries));

      final container = ProviderContainer(
        overrides: [journalRepositoryProvider.overrideWithValue(mockRepo)],
      );
      addTearDown(container.dispose);

      await container.read(journalEntriesProvider((null, null)).future);
      expect(container.read(journalStreakProvider), 0);
    });
  });
}
