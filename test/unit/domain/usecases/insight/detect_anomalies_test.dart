// test/unit/domain/usecases/insight/detect_anomalies_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:medmind/core/enum/enum_collection.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/usecases/insight/detect_anomalies.dart';

import '../../../../helpers/mock_repositories.dart';
import '../../../../helpers/test_fixtures.dart';

void main() {
  late MockMlRepository mlRepo;
  late MockInsightRepository insightRepo;
  late DetectAnomalies useCase;

  setUp(() {
    registerFallbackValues();
    mlRepo = MockMlRepository();
    insightRepo = MockInsightRepository();
    useCase = DetectAnomalies(mlRepo, insightRepo);
  });

  group('DetectAnomalies', () {
    test('returns Right([]) immediately for empty entries list', () async {
      final result = await useCase([]);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (list) => expect(list, isEmpty),
      );
      verifyZeroInteractions(mlRepo);
      verifyZeroInteractions(insightRepo);
    });

    test(
      'returns empty anomaly list when ML predicts false for all entries',
      () async {
        final entries = makeEntryList(count: 3);
        when(
          () => mlRepo.predictAnomaly(any()),
        ).thenAnswer((_) async => const Right(false));

        final result = await useCase(entries);

        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Expected Right'),
          (list) => expect(list, isEmpty),
        );
        verifyNever(() => insightRepo.saveInsight(any()));
      },
    );

    test('saves insight and returns it when ML detects anomaly', () async {
      final entry = makeFullEntry();
      when(
        () => mlRepo.predictAnomaly(any()),
      ).thenAnswer((_) async => const Right(true));
      when(
        () => insightRepo.saveInsight(any()),
      ).thenAnswer((_) async => const Right(null));

      final result = await useCase([entry]);

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('Expected Right'), (list) {
        expect(list, hasLength(1));
        expect(list.first.id, contains('anomaly_'));
        expect(list.first.type, InsightType.anomaly);
      });
      verify(() => insightRepo.saveInsight(any())).called(1);
    });

    test('ML failure for one entry does not affect other entries', () async {
      final entries = makeEntryList(count: 2);
      var callCount = 0;
      when(() => mlRepo.predictAnomaly(any())).thenAnswer((_) async {
        callCount++;
        if (callCount == 1) return const Left(MLFailure('model error'));
        return const Right(true);
      });
      when(
        () => insightRepo.saveInsight(any()),
      ).thenAnswer((_) async => const Right(null));

      final result = await useCase(entries);

      // First entry: ML failure → no insight. Second entry: anomaly → 1 insight.
      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (list) => expect(list, hasLength(1)),
      );
    });

    test('feature vector has 6 elements and uses correct field order', () async {
      final entry = makeFullEntry();
      List<double>? capturedFeatures;
      when(() => mlRepo.predictAnomaly(any())).thenAnswer((inv) async {
        capturedFeatures = inv.positionalArguments.first as List<double>;
        return const Right(false);
      });

      await useCase([entry]);

      expect(capturedFeatures, isNotNull);
      expect(capturedFeatures!, hasLength(6));
      // mood index (good = 1), moodIntensity 7, sleep quality 3, ~8h sleep, 1 symptom, severity 4
      expect(capturedFeatures![0], Mood.good.index.toDouble()); // mood
      expect(capturedFeatures![1], 7.0); // moodIntensity
      expect(capturedFeatures![2], 3.0); // sleep quality
      expect(capturedFeatures![4], 1.0); // symptom count
      expect(capturedFeatures![5], 4.0); // avg severity
    });
  });
}
