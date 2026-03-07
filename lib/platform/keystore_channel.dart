// keystore_channel.dart
import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

/// Dart-side bridge to the native Android Keystore plugin.
///
/// Architecture (two-layer key protection):
///
///   Layer 1 — Hardware-backed master key (KeystorePlugin.kt)
///     An AES-256-GCM secret key is generated inside the AndroidKeyStore
///     provider and never leaves secure hardware. It is used solely to
///     encrypt/decrypt the database key.
///
///   Layer 2 — Database encryption key (this class)
///     A random 32-byte key is generated on first launch and immediately
///     encrypted by the master key. The resulting ciphertext and GCM IV are
///     stored in FlutterSecureStorage (EncryptedSharedPreferences, also backed
///     by Android Keystore). The raw key bytes exist in memory only during the
///     lifetime of a single [getOrCreateKey] call.
///
/// Result: the Isar database can only be opened by an app instance running on
/// the exact device that created it — hardware extraction or backup restore
/// cannot yield the raw database key.
///
/// Channel: com.yourblooo.medmind/keystore
@lazySingleton
class KeystoreChannel {
  static const _channel = MethodChannel('com.yourblooo.medmind/keystore');

  // Keys used to persist the encrypted database key in FlutterSecureStorage.
  static const _ciphertextStorageKey = 'medmind_encrypted_db_key';
  static const _ivStorageKey = 'medmind_db_key_iv';

  final FlutterSecureStorage _secureStorage;

  const KeystoreChannel(this._secureStorage);

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Returns the 32-byte AES-256 encryption key that Isar uses to open the
  /// database.
  ///
  /// On first call:
  ///   1. Creates the hardware-backed master key in Android Keystore.
  ///   2. Generates a cryptographically random 32-byte database key.
  ///   3. Encrypts the database key with the master key (AES-256-GCM).
  ///   4. Stores the ciphertext + GCM IV in FlutterSecureStorage.
  ///   5. Returns the raw 32 bytes.
  ///
  /// On subsequent calls:
  ///   1. Ensures the master key still exists in Keystore.
  ///   2. Reads the stored ciphertext + IV from FlutterSecureStorage.
  ///   3. Decrypts via the master key and returns the raw 32 bytes.
  Future<Uint8List> getOrCreateKey() async {
    await _ensureMasterKey();

    final storedCiphertext = await _secureStorage.read(
      key: _ciphertextStorageKey,
    );
    final storedIv = await _secureStorage.read(key: _ivStorageKey);

    if (storedCiphertext != null && storedIv != null) {
      // Existing key — decrypt and return.
      return _decryptDbKey(
        ciphertext: _b64Decode(storedCiphertext),
        iv: _b64Decode(storedIv),
      );
    }

    // First launch — generate, encrypt, persist.
    final dbKey = _generateRandomBytes(32);
    final encrypted = await _encryptDbKey(dbKey);

    await Future.wait([
      _secureStorage.write(
        key: _ciphertextStorageKey,
        value: _b64Encode(encrypted.ciphertext),
      ),
      _secureStorage.write(key: _ivStorageKey, value: _b64Encode(encrypted.iv)),
    ]);

    return dbKey;
  }

  /// Permanently destroys the database encryption key.
  ///
  /// Deletes the hardware master key from AndroidKeyStore AND removes the
  /// encrypted ciphertext from FlutterSecureStorage. After this call the Isar
  /// database is permanently unreadable — use this for account deletion
  /// (cryptographic erasure).
  Future<void> destroyKey() async {
    await Future.wait([
      _channel.invokeMethod<void>('deleteKey'),
      _secureStorage.delete(key: _ciphertextStorageKey),
      _secureStorage.delete(key: _ivStorageKey),
    ]);
  }

  // ---------------------------------------------------------------------------
  // Internal helpers
  // ---------------------------------------------------------------------------

  /// Generates the hardware-backed master key if it does not yet exist.
  Future<void> _ensureMasterKey() async {
    final exists = await _channel.invokeMethod<bool>('isKeyAvailable') ?? false;
    if (!exists) {
      await _channel.invokeMethod<void>('generateKey');
    }
  }

  /// Calls the native `encryptKey` method and wraps the result.
  Future<({Uint8List ciphertext, Uint8List iv})> _encryptDbKey(
    Uint8List dbKey,
  ) async {
    final raw = await _channel.invokeMethod<Map<Object?, Object?>>(
      'encryptKey',
      {'data': dbKey},
    );

    if (raw == null) {
      throw const KeystoreException(
        'encryptKey returned null — AndroidKeyStore may be unavailable.',
      );
    }

    return (
      ciphertext: _toUint8List(raw['ciphertext']),
      iv: _toUint8List(raw['iv']),
    );
  }

  /// Calls the native `decryptKey` method and returns the plaintext bytes.
  Future<Uint8List> _decryptDbKey({
    required Uint8List ciphertext,
    required Uint8List iv,
  }) async {
    final raw = await _channel.invokeMethod<List<Object?>>('decryptKey', {
      'ciphertext': ciphertext,
      'iv': iv,
    });

    if (raw == null) {
      throw const KeystoreException(
        'decryptKey returned null — master key may have been deleted.',
      );
    }

    return Uint8List.fromList(raw.cast<int>());
  }

  // ---------------------------------------------------------------------------
  // Utility
  // ---------------------------------------------------------------------------

  Uint8List _generateRandomBytes(int length) {
    final rng = Random.secure();
    return Uint8List.fromList(
      List<int>.generate(length, (_) => rng.nextInt(256)),
    );
  }

  Uint8List _toUint8List(Object? value) {
    if (value is Uint8List) return value;
    if (value is List) return Uint8List.fromList(value.cast<int>());
    throw KeystoreException(
      'Unexpected type from native layer: ${value.runtimeType}',
    );
  }

  String _b64Encode(Uint8List bytes) => base64Encode(bytes);

  Uint8List _b64Decode(String encoded) => base64Decode(encoded);
}

// ---------------------------------------------------------------------------
// Exception type
// ---------------------------------------------------------------------------

/// Thrown when a Keystore operation fails unexpectedly.
class KeystoreException implements Exception {
  const KeystoreException(this.message);

  final String message;

  @override
  String toString() => 'KeystoreException: $message';
}
