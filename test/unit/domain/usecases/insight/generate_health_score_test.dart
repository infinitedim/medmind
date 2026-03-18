// test/unit/domain/usecases/insight/generate_health_score_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:medmind/core/enum/enum_collection.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/entities/health_score.dart';
import 'package:medmind/domain/entities/journal_entry.dart';
import 'package:medmind/domain/entities/sleep_record.dart';
import 'package:medmind/domain/entities/symptom.dart';
import 'package:medmind/domain/usecases/insight/generate_health_score.dart';

import '../../../../helpers/mock_repositories.dart';
import '../../../../helpers/test_fixtures.dart';

void main() {
  late MockJournalRepository journalRepo;
  late MockInsightRepository insightRepo;
  late GenerateHealthScore useCase;

  final testDate = DateTime(2026, 3, 8);

  setUp(() {
    registerFallbackValues();
    journalRepo = MockJournalRepository();
    insightRepo = MockInsightRepository();
    useCase = GenerateHealthScore(journalRepo, insightRepo);
  });

  group('GenerateHealthScore', () {
    test(
      'returns cached score on cache hit without querying journal',
      () async {
        final cached = HealthScore(
          date: testDate,
          overallScore: 75.0,
          components: const {'mood': 75.0, 'sleep': 75.0, 'symptoms': 75.0},
          trend: ScoreTrend.stable,
        );
        when(
          () => insightRepo.getHealthScore(testDate),
        ).thenAnswer((_) async => Right(cached));

        final result = await useCase(GenerateHealthScoreParams(date: testDate));

        expect(result.isRight(), isTrue);
        result.fold((_) => fail('Expected Right'), (s) => expect(s, cached));
        verifyZeroInteractions(journalRepo);
      },
    );

    test('returns NotFoundFailure when no entry exists for date', () async {
      when(
        () => insightRepo.getHealthScore(any()),
      ).thenAnswer((_) async => const Right(null));
      when(
        () => journalRepo.getEntries(
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => const Right([]));

      final result = await useCase(GenerateHealthScoreParams(date: testDate));

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<NotFoundFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test(
      'computes high score for good mood, good sleep, no symptoms',
      () async {
        final entry = JournalEntry(
          id: 'e1',
          date: testDate,
          mood: Mood.great, // base = 100
          moodIntensity: 10, // (100 + 100) / 2 = 100
          sleepRecord: SleepRecord(
            bedTime: testDate.subtract(const Duration(hours: 8)),
            wakeTime: testDate,
            quality: 10, // 100
          ),
          symptoms: const [],
          createdAt: testDate,
          updatedAt: testDate,
        );
        when(
          () => insightRepo.getHealthScore(any()),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => journalRepo.getEntries(
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => Right([entry]));
        when(
          () => insightRepo.saveHealthScore(any()),
        ).thenAnswer((_) async => const Right(null));

        final result = await useCase(GenerateHealthScoreParams(date: testDate));

        expect(result.isRight(), isTrue);
        result.fold((_) => fail('Expected Right'), (s) {
          expect(s.overallScore, closeTo(100.0, 0.01));
          expect(s.components['mood'], closeTo(100.0, 0.01));
          expect(s.components['sleep'], closeTo(100.0, 0.01));
          expect(s.components['symptoms'], closeTo(100.0, 0.01));
        });
      },
    );

    test(
      'computes low score for terrible mood, poor sleep, many symptoms',
      () async {
        final entry = JournalEntry(
          id: 'e2',
          date: testDate,
          mood: Mood.terrible, // base = 0
          sleepRecord: SleepRecord(
            bedTime: testDate.subtract(const Duration(hours: 4)),
            wakeTime: testDate,
            quality: 2, // 20
          ),
          symptoms: List.generate(
            5,
            (i) => SymptomLog(symptomId: 'sym-$i', severity: 8),
          ),
          createdAt: testDate,
          updatedAt: testDate,
        );
        when(
          () => insightRepo.getHealthScore(any()),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => journalRepo.getEntries(
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => Right([entry]));
        when(
          () => insightRepo.saveHealthScore(any()),
        ).thenAnswer((_) async => const Right(null));

        final result = await useCase(GenerateHealthScoreParams(date: testDate));

        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Expected Right'),
          (s) => expect(s.overallScore, lessThan(30.0)),
        );
      },
    );

    test('score uses weights mood×0.35, sleep×0.35, symptoms×0.30', () async {
      // mood=50, sleep=50, symptoms=100 → 50*0.35 + 50*0.35 + 100*0.30 = 17.5+17.5+30 = 65
      final entry = JournalEntry(
        id: 'e3',
        date: testDate,
        mood: Mood.okay, // base=50, no intensity
        sleepRecord: SleepRecord(
          bedTime: testDate.subtract(const Duration(hours: 8)),
          wakeTime: testDate,
          quality: 5, // 50
        ),
        symptoms: const [],
        createdAt: testDate,
        updatedAt: testDate,
      );
      when(
        () => insightRepo.getHealthScore(any()),
      ).thenAnswer((_) async => const Right(null));
      when(
        () => journalRepo.getEntries(
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => Right([entry]));
      when(
        () => insightRepo.saveHealthScore(any()),
      ).thenAnswer((_) async => const Right(null));

      final result = await useCase(GenerateHealthScoreParams(date: testDate));

      result.fold(
        (_) => fail('Expected Right'),
        (s) => expect(s.overallScore, closeTo(65.0, 0.1)),
      );
    });

    test('saves computed score to insightRepo', () async {
      final entry = makeMinimalEntry(date: testDate);
      when(
        () => insightRepo.getHealthScore(any()),
      ).thenAnswer((_) async => const Right(null));
      when(
        () => journalRepo.getEntries(
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => Right([entry]));
      when(
        () => insightRepo.saveHealthScore(any()),
      ).thenAnswer((_) async => const Right(null));

      await useCase(GenerateHealthScoreParams(date: testDate));

      verify(() => insightRepo.saveHealthScore(any())).called(1);
    });
  });
}
