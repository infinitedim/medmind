// test/unit/domain/usecases/health_connect/import_sleep_data_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/entities/sleep_record.dart';
import 'package:medmind/domain/usecases/health_connect/import_sleep_data.dart';

import '../../../../helpers/mock_repositories.dart';

void main() {
  late MockHealthConnectRepository repo;
  late ImportSleepData useCase;
  const params = ImportDataParams();

  setUp(() {
    registerFallbackValues();
    repo = MockHealthConnectRepository();
    useCase = ImportSleepData(repo);
  });

  group('ImportSleepData', () {
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
      verifyNever(() =>
          repo.importSleepData(startDate: any(named: 'startDate'), endDate: any(named: 'endDate')));
    });

    test('returns sleep records on success', () async {
      final records = [
        SleepRecord(
          bedTime: DateTime(2026, 3, 1, 22),
          wakeTime: DateTime(2026, 3, 2, 6),
          quality: 7,
        ),
      ];
      when(() => repo.checkAvailability())
          .thenAnswer((_) async => const Right(true));
      when(() => repo.requestPermissions())
          .thenAnswer((_) async => const Right(true));
      when(() => repo.importSleepData(
                startDate: any(named: 'startDate'),
                endDate: any(named: 'endDate'),
              ))
          .thenAnswer((_) async => Right(records));

      final result = await useCase(params);

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('Expected Right'), (r) => expect(r, records));
    });

    test('propagates DatabaseFailure from checkAvailability', () async {
      when(() => repo.checkAvailability())
          .thenAnswer((_) async => const Left(DatabaseFailure('db error')));

      final result = await useCase(params);

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<DatabaseFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('forwards date range params to importSleepData', () async {
      final start = DateTime(2026, 1, 1);
      final end = DateTime(2026, 3, 1);
      final rangeParams = ImportDataParams(startDate: start, endDate: end);
      when(() => repo.checkAvailability())
          .thenAnswer((_) async => const Right(true));
      when(() => repo.requestPermissions())
          .thenAnswer((_) async => const Right(true));
      when(() => repo.importSleepData(
                startDate: any(named: 'startDate'),
                endDate: any(named: 'endDate'),
              ))
          .thenAnswer((_) async => const Right([]));

      await useCase(rangeParams);

      final captured = verify(
        () => repo.importSleepData(
          startDate: captureAny(named: 'startDate'),
          endDate: captureAny(named: 'endDate'),
        ),
      ).captured;
      expect(captured[0], start);
      expect(captured[1], end);
    });
  });
}
