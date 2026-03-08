// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:isar/isar.dart' as _i338;
import 'package:medmind/core/di/injection.dart' as _i649;
import 'package:medmind/data/datasources/local/insight_cache_datasource.dart'
    as _i361;
import 'package:medmind/data/datasources/local/journal_local_datasource.dart'
    as _i191;
import 'package:medmind/data/datasources/local/symptom_local_datasource.dart'
    as _i308;
import 'package:medmind/platform/health_connect_channel.dart' as _i756;
import 'package:medmind/platform/keystore_channel.dart' as _i966;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.lazySingleton<_i558.FlutterSecureStorage>(() => appModule.secureStorage);
    gh.lazySingleton<_i756.HealthConnectChannel>(
      () => _i756.HealthConnectChannel(),
    );
    gh.lazySingleton<_i966.KeystoreChannel>(
      () => _i966.KeystoreChannel(gh<_i558.FlutterSecureStorage>()),
    );
    await gh.lazySingletonAsync<_i338.Isar>(
      () => appModule.isar(gh<_i966.KeystoreChannel>()),
      preResolve: true,
    );
    gh.lazySingleton<_i361.InsightCacheDataSource>(
      () => _i361.InsightCacheDataSource(gh<_i338.Isar>()),
    );
    gh.lazySingleton<_i191.JournalLocalDataSource>(
      () => _i191.JournalLocalDataSource(gh<_i338.Isar>()),
    );
    gh.lazySingleton<_i308.SymptomLocalDataSource>(
      () => _i308.SymptomLocalDataSource(gh<_i338.Isar>()),
    );
    return this;
  }
}

class _$AppModule extends _i649.AppModule {}
