// test/unit/core/errors/failures_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:medmind/core/errors/failures.dart';

void main() {
  group('Failures', () {
    group('DatabaseFailure', () {
      test('menyimpan message dengan benar', () {
        const failure = DatabaseFailure('Database error');
        expect(failure.message, 'Database error');
      });

      test('adalah subtype dari Failure', () {
        const failure = DatabaseFailure('error');
        expect(failure, isA<Failure>());
      });
    });

    group('MLFailure', () {
      test('menyimpan message dengan benar', () {
        const failure = MLFailure('Model not found');
        expect(failure.message, 'Model not found');
      });
    });

    group('EncryptionFailure', () {
      test('menyimpan message dengan benar', () {
        const failure = EncryptionFailure('Key invalid');
        expect(failure.message, 'Key invalid');
      });
    });

    group('ValidationFailure', () {
      test('menyimpan message dengan benar', () {
        const failure = ValidationFailure('Field required');
        expect(failure.message, 'Field required');
      });
    });

    group('NotFoundFailure', () {
      test('menyimpan message dengan benar', () {
        const failure = NotFoundFailure('Entry not found');
        expect(failure.message, 'Entry not found');
      });
    });

    group('HealthConnectFailure', () {
      test('menyimpan message dengan benar', () {
        const failure = HealthConnectFailure('Permission denied');
        expect(failure.message, 'Permission denied');
      });
    });

    group('ExportFailure', () {
      test('menyimpan message dengan benar', () {
        const failure = ExportFailure('Export gagal');
        expect(failure.message, 'Export gagal');
      });
    });

    group('NetworkFailure', () {
      test('menyimpan message dengan benar', () {
        const failure = NetworkFailure('No connection');
        expect(failure.message, 'No connection');
      });
    });

    test('setiap Failure bertipe berbeda (sealed class)', () {
      const failures = <Failure>[
        DatabaseFailure('db'),
        MLFailure('ml'),
        EncryptionFailure('enc'),
        ValidationFailure('val'),
        NotFoundFailure('nf'),
        HealthConnectFailure('hc'),
        ExportFailure('exp'),
        NetworkFailure('net'),
      ];

      final types = failures.map((f) => f.runtimeType).toSet();
      expect(types.length, failures.length);
    });
  });
}
