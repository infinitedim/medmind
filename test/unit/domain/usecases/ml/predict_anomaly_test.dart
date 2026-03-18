// test/unit/domain/usecases/ml/predict_anomaly_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/usecases/ml/predict_anomaly.dart';

import '../../../../helpers/mock_repositories.dart';

void main() {
  late MockMlRepository mlRepo;
  late PredictAnomaly useCase;

  setUp(() {
    registerFallbackValues();
    mlRepo = MockMlRepository();
    useCase = PredictAnomaly(mlRepo);
  });

  group('PredictAnomaly', () {
    test('returns Right(true) when repo indicates anomaly', () async {
      const features = [0.8, 0.1, 0.95, 0.3];
      when(
        () => mlRepo.predictAnomaly(any()),
      ).thenAnswer((_) async => const Right(true));

      final result = await useCase(features);

      expect(result, const Right(true));
    });

    test('returns Right(false) when repo indicates no anomaly', () async {
      const features = [0.3, 0.5, 0.4, 0.6];
      when(
        () => mlRepo.predictAnomaly(any()),
      ).thenAnswer((_) async => const Right(false));

      final result = await useCase(features);

      expect(result, const Right(false));
    });

    test('forwards MLFailure from repo', () async {
      const features = [0.5, 0.5, 0.5];
      when(
        () => mlRepo.predictAnomaly(any()),
      ).thenAnswer((_) async => const Left(MLFailure('model not loaded')));

      final result = await useCase(features);

      expect(result.isLeft(), isTrue);
      result.fold((f) => expect(f, isA<MLFailure>()), (_) => fail(''));
    });

    test('passes feature list directly to repo', () async {
      const features = [1.0, 2.0, 3.0, 4.0, 5.0];
      when(
        () => mlRepo.predictAnomaly(any()),
      ).thenAnswer((_) async => const Right(false));

      await useCase(features);

      final captured = verify(
        () => mlRepo.predictAnomaly(captureAny()),
      ).captured;
      expect(captured.single, features);
    });

    test('handles empty feature list', () async {
      when(
        () => mlRepo.predictAnomaly(any()),
      ).thenAnswer((_) async => const Right(false));

      final result = await useCase([]);

      expect(result.isRight(), isTrue);
      verify(() => mlRepo.predictAnomaly(<double>[])).called(1);
    });
  });
}
