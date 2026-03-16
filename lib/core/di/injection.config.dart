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
import 'package:medmind/data/repositories/health_connect_repository_impl.dart'
    as _i21;
import 'package:medmind/data/repositories/insight_repository_impl.dart'
    as _i473;
import 'package:medmind/data/repositories/journal_repository_impl.dart'
    as _i1019;
import 'package:medmind/data/repositories/ml_repository_impl.dart' as _i156;
import 'package:medmind/data/repositories/symptom_repository_impl.dart'
    as _i758;
import 'package:medmind/data/repositories/user_preferences_repository_impl.dart'
    as _i634;
import 'package:medmind/domain/repositories/health_connect_repository.dart'
    as _i783;
import 'package:medmind/domain/repositories/insight_repository.dart' as _i271;
import 'package:medmind/domain/repositories/journal_repository.dart' as _i466;
import 'package:medmind/domain/repositories/ml_repository.dart' as _i921;
import 'package:medmind/domain/repositories/symptom_repository.dart' as _i201;
import 'package:medmind/domain/repositories/user_preferences_repository.dart'
    as _i153;
import 'package:medmind/platform/health_connect_channel.dart' as _i756;
import 'package:medmind/platform/keystore_channel.dart' as _i966;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.lazySingleton<_i558.FlutterSecureStorage>(() => appModule.secureStorage);
    await gh.lazySingletonAsync<_i460.SharedPreferences>(
      () => appModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i756.HealthConnectChannel>(
      () => _i756.HealthConnectChannel(),
    );
    gh.lazySingleton<_i783.HealthConnectRepository>(
      () => _i21.HealthConnectRepositoryImpl(gh<_i756.HealthConnectChannel>()),
    );
    gh.lazySingleton<_i921.MlRepository>(() => const _i156.MlRepositoryImpl());
    gh.lazySingleton<_i966.KeystoreChannel>(
      () => _i966.KeystoreChannel(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i153.UserPreferencesRepository>(
      () => _i634.UserPreferencesRepositoryImpl(gh<_i460.SharedPreferences>()),
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
    gh.lazySingleton<_i271.InsightRepository>(
      () => _i473.InsightRepositoryImpl(
        gh<_i361.InsightCacheDataSource>(),
        gh<_i460.SharedPreferences>(),
      ),
    );
    gh.lazySingleton<_i466.JournalRepository>(
      () => _i1019.JournalRepositoryImpl(gh<_i191.JournalLocalDataSource>()),
    );
    gh.lazySingleton<_i201.SymptomRepository>(
      () => _i758.SymptomRepositoryImpl(
        gh<_i308.SymptomLocalDataSource>(),
        gh<_i460.SharedPreferences>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i649.AppModule {}
