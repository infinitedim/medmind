// lib/core/errors/exceptions.dart

/// Base class untuk semua custom exception di MedMind.
abstract class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

// ─── Database Exceptions ─────────────────────────────────────────────────────

class DatabaseException extends AppException {
  const DatabaseException(super.message);
}

class RecordNotFoundException extends AppException {
  const RecordNotFoundException(String collection, String id)
    : super('Record "$id" tidak ditemukan di collection $collection');
}

// ─── Keystore / Encryption Exceptions ────────────────────────────────────────

class KeystoreException extends AppException {
  const KeystoreException(super.message);
}

// ─── ML / Inference Exceptions ───────────────────────────────────────────────

class MlInferenceException extends AppException {
  const MlInferenceException(super.message);
}

class ModelLoadException extends AppException {
  const ModelLoadException(String modelPath)
    : super('Gagal memuat model TFLite: $modelPath');
}

// ─── Health Connect Exceptions ────────────────────────────────────────────────

class HealthConnectUnavailableException extends AppException {
  const HealthConnectUnavailableException()
    : super('Health Connect tidak tersedia di perangkat ini');
}

class HealthConnectPermissionException extends AppException {
  const HealthConnectPermissionException(String permission)
    : super('Izin Health Connect ditolak: $permission');
}

// ─── Network / Remote Exceptions ─────────────────────────────────────────────

class NetworkException extends AppException {
  const NetworkException(super.message);
}

class ServerException extends AppException {
  const ServerException(super.message);
}

// ─── Cache Exceptions ────────────────────────────────────────────────────────

class CacheException extends AppException {
  const CacheException(super.message);
}
