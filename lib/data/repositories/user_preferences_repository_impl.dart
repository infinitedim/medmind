import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/repositories/user_preferences_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton(as: UserPreferencesRepository)
class UserPreferencesRepositoryImpl implements UserPreferencesRepository {
  const UserPreferencesRepositoryImpl(this._prefs);

  final SharedPreferences _prefs;

  static const _biometricKey = 'biometric_lock_enabled';
  static const _onboardingKey = 'onboarding_complete';
  static const _reminderKey = 'reminder_time';
  static const _themeKey = 'theme_mode';
  static const _trackedKey = 'tracked_symptom_ids';

  @override
  Future<Either<Failure, bool>> isBiometricEnabled() async =>
      Right(_prefs.getBool(_biometricKey) ?? false);

  @override
  Future<Either<Failure, void>> setBiometricEnabled({
    required bool enabled,
  }) async {
    await _prefs.setBool(_biometricKey, enabled);
    return const Right(null);
  }

  @override
  Future<Either<Failure, bool>> isOnboardingComplete() async =>
      Right(_prefs.getBool(_onboardingKey) ?? false);

  @override
  Future<Either<Failure, void>> completeOnboarding() async {
    await _prefs.setBool(_onboardingKey, true);
    return const Right(null);
  }

  @override
  Future<Either<Failure, String?>> getReminderTime() async =>
      Right(_prefs.getString(_reminderKey));

  @override
  Future<Either<Failure, void>> setReminderTime(String time) async {
    await _prefs.setString(_reminderKey, time);
    return const Right(null);
  }

  @override
  Future<Either<Failure, String>> getThemeMode() async =>
      Right(_prefs.getString(_themeKey) ?? 'dark');

  @override
  Future<Either<Failure, void>> setThemeMode(String mode) async {
    await _prefs.setString(_themeKey, mode);
    return const Right(null);
  }

  @override
  Future<Either<Failure, List<String>>> getTrackedSymptomIds() async =>
      Right(_prefs.getStringList(_trackedKey) ?? []);

  @override
  Future<Either<Failure, void>> setTrackedSymptomIds(List<String> ids) async {
    await _prefs.setStringList(_trackedKey, ids);
    return const Right(null);
  }

  static const _trackedLifestyleKey = 'tracked_lifestyle_factor_ids';

  @override
  Future<Either<Failure, List<String>>> getTrackedLifestyleFactorIds() async =>
      Right(_prefs.getStringList(_trackedLifestyleKey) ?? []);

  @override
  Future<Either<Failure, void>> setTrackedLifestyleFactorIds(
    List<String> ids,
  ) async {
    await _prefs.setStringList(_trackedLifestyleKey, ids);
    return const Right(null);
  }
}
