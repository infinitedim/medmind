// test/unit/domain/usecases/health_connect/export_symptom_data_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/usecases/health_connect/export_symtom_data.dart';

import '../../../../helpers/mock_repositories.dart';
import '../../../../helpers/test_fixtures.dart';

void main() {
  late MockHealthConnectRepository repo;
  late ExportSymptomData useCase;

  setUp(() {
    registerFallbackValues();
    repo = MockHealthConnectRepository();
    useCase = ExportSymptomData(repo);
  });

  group('ExportSymptomData', () {
    test('returns Right(null) without calling repo when entries is empty',
        () async {
      final result = await useCase(const []);

      expect(result.isRight(), isTrue);
      verifyZeroInteractions(repo);
    });

    test('returns HealthConnectFailure when device not available', () async {
      when(() => repo.checkAvailability())
          .thenAnswer((_) async => const Right(false));

      final result = await useCase([makeMinimalEntry()]);

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

      final result = await useCase([makeMinimalEntry()]);

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<HealthConnectFailure>()),
        (_) => fail('Expected Left'),
      );
      verifyNever(() => repo.exportSymptomData(any()));
    });

    test('calls exportSymptomData on success and returns Right', () async {
      final entries = makeEntryList(count: 2);
      when(() => repo.checkAvailability())
          .thenAnswer((_) async => const Right(true));
      when(() => repo.requestPermissions())
          .thenAnswer((_) async => const Right(true));
      when(() => repo.exportSymptomData(any()))
          .thenAnswer((_) async => const Right(null));

      final result = await useCase(entries);

      expect(result.isRight(), isTrue);
      verify(() => repo.exportSymptomData(any())).called(1);
    });

    test('propagates HealthConnectFailure from exportSymptomData', () async {
      when(() => repo.checkAvailability())
          .thenAnswer((_) async => const Right(true));
      when(() => repo.requestPermissions())
          .thenAnswer((_) async => const Right(true));
      when(() => repo.exportSymptomData(any()))
          .thenAnswer(
              (_) async => const Left(HealthConnectFailure('write error')));

      final result = await useCase([makeMinimalEntry()]);

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) {
          expect(f, isA<HealthConnectFailure>());
          expect(f.message, 'write error');
        },
        (_) => fail('Expected Left'),
      );
    });
  });
}
