// test/unit/core/errors/exceptions_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:medmind/core/errors/exceptions.dart';

void main() {
  group('DatabaseException', () {
    test('stores message', () {
      const e = DatabaseException('db failed');
      expect(e.message, 'db failed');
      expect(e, isA<AppException>());
    });

    test('toString includes runtimeType and message', () {
      const e = DatabaseException('connection error');
      expect(e.toString(), contains('DatabaseException'));
      expect(e.toString(), contains('connection error'));
    });
  });

  group('RecordNotFoundException', () {
    test('formats message with collection and id', () {
      const e = RecordNotFoundException('JournalEntry', 'abc-123');
      expect(e.message, contains('JournalEntry'));
      expect(e.message, contains('abc-123'));
      expect(e, isA<AppException>());
    });
  });

  group('KeystoreException', () {
    test('stores message', () {
      const e = KeystoreException('key not found');
      expect(e.message, 'key not found');
      expect(e, isA<AppException>());
    });
  });

  group('MlInferenceException', () {
    test('stores message', () {
      const e = MlInferenceException('inference failed');
      expect(e.message, 'inference failed');
      expect(e, isA<AppException>());
    });
  });

  group('ModelLoadException', () {
    test('formats message with model path', () {
      const e = ModelLoadException('assets/model.tflite');
      expect(e.message, contains('assets/model.tflite'));
      expect(e, isA<AppException>());
    });
  });

  group('HealthConnectUnavailableException', () {
    test('has descriptive message', () {
      const e = HealthConnectUnavailableException();
      expect(e.message, isNotEmpty);
      expect(e, isA<AppException>());
    });
  });

  group('HealthConnectPermissionException', () {
    test('includes permission name in message', () {
      const e = HealthConnectPermissionException('SLEEP');
      expect(e.message, contains('SLEEP'));
      expect(e, isA<AppException>());
    });
  });

  group('NetworkException', () {
    test('stores message', () {
      const e = NetworkException('timeout');
      expect(e.message, 'timeout');
      expect(e, isA<AppException>());
    });
  });

  group('ServerException', () {
    test('stores message', () {
      const e = ServerException('500 Internal Server Error');
      expect(e.message, '500 Internal Server Error');
      expect(e, isA<AppException>());
    });
  });

  group('CacheException', () {
    test('stores message', () {
      const e = CacheException('cache miss');
      expect(e.message, 'cache miss');
      expect(e, isA<AppException>());
    });
  });

  group('AppException hierarchy', () {
    test('all exceptions are AppException', () {
      final exceptions = <AppException>[
        const DatabaseException('db'),
        const RecordNotFoundException('col', 'id'),
        const KeystoreException('key'),
        const MlInferenceException('ml'),
        const ModelLoadException('path'),
        const HealthConnectUnavailableException(),
        const HealthConnectPermissionException('perm'),
        const NetworkException('net'),
        const ServerException('srv'),
        const CacheException('cache'),
      ];
      for (final e in exceptions) {
        expect(e, isA<AppException>(), reason: '$e should be AppException');
        expect(e, isA<Exception>(), reason: '$e should be Exception');
      }
    });

    test('all exceptions have distinct runtimeType', () {
      final types = [
        const DatabaseException('').runtimeType,
        const RecordNotFoundException('c', 'i').runtimeType,
        const KeystoreException('').runtimeType,
        const MlInferenceException('').runtimeType,
        const ModelLoadException('').runtimeType,
        const HealthConnectUnavailableException().runtimeType,
        const HealthConnectPermissionException('').runtimeType,
        const NetworkException('').runtimeType,
        const ServerException('').runtimeType,
        const CacheException('').runtimeType,
      ];
      expect(types.toSet().length, equals(types.length));
    });
  });
}
