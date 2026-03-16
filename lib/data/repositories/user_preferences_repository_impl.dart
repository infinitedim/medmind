import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/repositories/user_preferences_repository.dart';

@LazySingleton(as: UserPreferencesRepository)
class UserPreferencesRepositoryImpl implements UserPreferencesRepository {
  const UserPreferencesRepositoryImpl(this._prefs);

  final SharedPreferences _prefs;

  static const _biometricKey = 'biometric_lock_enabled';
  static const _onboardingKey = 'onboarding_complete';
  static const _reminderKey = 'reminder_time';
  static const _themeKey = 'theme_mode';
  static const _trackedSymptomsKey = 'tracked_symptom_ids';

  @override
  Future<Either<Failure, bool>> isBiometricEnabled() async =>
      Right(_prefs.getBool(_biometricKey) ?? false);

  @override
  Future<Either<Failure, void>> setBiometricEnabled({
    required bool enabled,
  }) async {
    try {
      await _prefs.setBool(_biometricKey, enabled);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Gagal menyimpan biometric setting: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> isOnboardingComplete() async =>
      Right(_prefs.getBool(_onboardingKey) ?? false);

  @override
  Future<Either<Failure, void>> completeOnboarding() async {
    try {
      await _prefs.setBool(_onboardingKey, true);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Gagal menyimpan onboarding status: $e'));
    }
  }

  @override
  Future<Either<Failure, String?>> getReminderTime() async =>
      Right(_prefs.getString(_reminderKey));

  @override
  Future<Either<Failure, void>> setReminderTime(String time) async {
    try {
      await _prefs.setString(_reminderKey, time);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Gagal menyimpan reminder time: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> getThemeMode() async =>
      Right(_prefs.getString(_themeKey) ?? 'system');

  @override
  Future<Either<Failure, void>> setThemeMode(String mode) async {
    try {
      await _prefs.setString(_themeKey, mode);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Gagal menyimpan theme mode: $e'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getTrackedSymptomIds() async =>
      Right(_prefs.getStringList(_trackedSymptomsKey) ?? const []);

  @override
  Future<Either<Failure, void>> setTrackedSymptomIds(List<String> ids) async {
    try {
      await _prefs.setStringList(_trackedSymptomsKey, ids);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Gagal menyimpan tracked symptoms: $e'));
    }
  }
}
