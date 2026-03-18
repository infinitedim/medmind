// test/unit/domain/usecases/health_connect/import_step_data_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/usecases/health_connect/import_sleep_data.dart';
import 'package:medmind/domain/usecases/health_connect/import_step_data.dart';

import '../../../../helpers/mock_repositories.dart';

void main() {
  late MockHealthConnectRepository repo;
  late ImportStepData useCase;
  const params = ImportDataParams();

  setUp(() {
    registerFallbackValues();
    repo = MockHealthConnectRepository();
    useCase = ImportStepData(repo);
  });

  group('ImportStepData', () {
    test('returns HealthConnectFailure when device not available', () async {
      when(() => repo.checkAvailability())
          .thenAnswer((_) async => const Right(false));

      final result = await useCase(params);

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<HealthConnectFailure>()),
        (_) => fail('Expected Left'),
      );
      verifyNever(() => repo.requestPermissions());
    });

    test('returns HealthConnectFailure when permissions denied', () async {
      when(() => repo.checkAvailability())
          .thenAnswer((_) async => const Right(true));
      when(() => repo.requestPermissions())
          .thenAnswer((_) async => const Right(false));

      final result = await useCase(params);

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<HealthConnectFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('returns step data map on success', () async {
      final stepData = {DateTime(2026, 3, 1): 8500};
      when(() => repo.checkAvailability())
          .thenAnswer((_) async => const Right(true));
      when(() => repo.requestPermissions())
          .thenAnswer((_) async => const Right(true));
      when(() => repo.importStepData(
                startDate: any(named: 'startDate'),
                endDate: any(named: 'endDate'),
              ))
          .thenAnswer((_) async => Right(stepData));

      final result = await useCase(params);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (data) => expect(data, stepData),
      );
    });

    test('propagates Failure from checkAvailability', () async {
      when(() => repo.checkAvailability())
          .thenAnswer((_) async =>
              const Left(HealthConnectFailure('channel error')));

      final result = await useCase(params);

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<HealthConnectFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('does not call importStepData if not available', () async {
      when(() => repo.checkAvailability())
          .thenAnswer((_) async => const Right(false));

      await useCase(params);

      verifyNever(() => repo.importStepData(
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
          ));
    });
  });
}
