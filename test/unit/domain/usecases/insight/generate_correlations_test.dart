// test/unit/domain/usecases/insight/generate_correlations_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/entities/correlation_result.dart';
import 'package:medmind/domain/usecases/insight/generate_correlations.dart';

import '../../../../helpers/mock_repositories.dart';
import '../../../../helpers/test_fixtures.dart';

void main() {
  late MockJournalRepository journalRepo;
  late MockMlRepository mlRepo;
  late MockInsightRepository insightRepo;
  late GenerateCorrelations useCase;

  final start = DateTime(2026, 2, 1);
  final end = DateTime(2026, 3, 8);

  final params = GenerateCorrelationsParams(startDate: start, endDate: end);

  const correlations = [
    CorrelationResult(
      variableA: 'mood',
      variableB: 'sleepQuality',
      correlationCoefficient: 0.72,
      pValue: 0.01,
      sampleSize: 14,
      lag: 0,
      isSignificant: true,
    ),
  ];

  setUp(() {
    registerFallbackValues();
    journalRepo = MockJournalRepository();
    mlRepo = MockMlRepository();
    insightRepo = MockInsightRepository();
    useCase = GenerateCorrelations(journalRepo, mlRepo, insightRepo);
  });

  group('GenerateCorrelations', () {
    test('forwards journalRepo failure without calling ML', () async {
      when(
        () => journalRepo.getEntries(
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      ).thenAnswer((_) async => const Left(DatabaseFailure('db error')));

      final result = await useCase(params);

      expect(result.isLeft(), isTrue);
      result.fold((f) => expect(f, isA<DatabaseFailure>()), (_) => fail(''));
      verifyZeroInteractions(mlRepo);
    });

    test('returns Right([]) when no entries exist', () async {
      when(
        () => journalRepo.getEntries(
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      ).thenAnswer((_) async => const Right([]));

      final result = await useCase(params);

      expect(result, const Right(<CorrelationResult>[]));
      verifyZeroInteractions(mlRepo);
    });

    test('calls mlRepo.computeCorrelations with entries matrix', () async {
      final entries = makeEntryList(count: 3);
      when(
        () => journalRepo.getEntries(
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      ).thenAnswer((_) async => Right(entries));
      when(
        () => mlRepo.computeCorrelations(any(), any()),
      ).thenAnswer((_) async => const Right(correlations));
      when(
        () => insightRepo.saveCorrelations(any()),
      ).thenAnswer((_) async => const Right(null));

      await useCase(params);

      verify(() => mlRepo.computeCorrelations(any(), any())).called(1);
    });

    test('forwards mlRepo failure without calling insightRepo', () async {
      final entries = makeEntryList(count: 3);
      when(
        () => journalRepo.getEntries(
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      ).thenAnswer((_) async => Right(entries));
      when(
        () => mlRepo.computeCorrelations(any(), any()),
      ).thenAnswer((_) async => const Left(MLFailure('ml error')));

      final result = await useCase(params);

      expect(result.isLeft(), isTrue);
      result.fold((f) => expect(f, isA<MLFailure>()), (_) => fail(''));
      verifyZeroInteractions(insightRepo);
    });

    test('saves correlations and returns them on success', () async {
      final entries = makeEntryList(count: 3);
      when(
        () => journalRepo.getEntries(
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      ).thenAnswer((_) async => Right(entries));
      when(
        () => mlRepo.computeCorrelations(any(), any()),
      ).thenAnswer((_) async => const Right(correlations));
      when(
        () => insightRepo.saveCorrelations(any()),
      ).thenAnswer((_) async => const Right(null));

      final result = await useCase(params);

      verify(() => insightRepo.saveCorrelations(any())).called(1);
      expect(result.isRight(), isTrue);
      result.fold((_) => fail(''), (c) => expect(c, correlations));
    });

    test('forwards insightRepo.saveCorrelations failure', () async {
      final entries = makeEntryList(count: 3);
      when(
        () => journalRepo.getEntries(
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      ).thenAnswer((_) async => Right(entries));
      when(
        () => mlRepo.computeCorrelations(any(), any()),
      ).thenAnswer((_) async => const Right(correlations));
      when(
        () => insightRepo.saveCorrelations(any()),
      ).thenAnswer((_) async => const Left(DatabaseFailure('save error')));

      final result = await useCase(params);

      expect(result.isLeft(), isTrue);
      result.fold((f) => expect(f, isA<DatabaseFailure>()), (_) => fail(''));
    });
  });
}
