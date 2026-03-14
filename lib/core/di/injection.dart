// lib/core/di/injection.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:medmind/data/datasources/local/isar_database.dart';
import 'package:medmind/platform/keystore_channel.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

/// Inisialisasi DI container.
///
/// Dipanggil dari [main.dart] sebelum [runApp]:
/// ```dart
/// await configureDependencies();
/// ```
@InjectableInit()
Future<void> configureDependencies() async => getIt.init();

// ─── App Module ─────────────────────────────────────────────────────────────

/// Module yang mendaftarkan dependensi eksternal / platform ke GetIt.
@module
abstract class AppModule {
  /// FlutterSecureStorage — enkripsi custom cipher (default 10.x).
  /// encryptedSharedPreferences dihapus di 10.x karena Jetpack Security
  /// deprecated oleh Google; data lama dimigrasikan otomatis saat first access.
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  /// Membuka dan mengembalikan instance [Isar] yang sudah di-encrypt.
  ///
  /// [KeystoreChannel] harus sudah terdaftar (via @lazySingleton) sebelum
  /// metode ini dipanggil. Injectable menangani urutan resolusi secara otomatis.
  ///
  // ignore: unintended_html_in_doc_comment
  /// [preResolve] memastikan Future<Isar> di-await saat [getIt.init()],
  /// sehingga semua datasource yang depend ke [Isar] mendapat instance siap pakai.
  @preResolve
  @lazySingleton
  Future<Isar> isar(KeystoreChannel keystore) => IsarDatabase.open(keystore);
}
