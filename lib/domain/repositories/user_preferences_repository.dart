import 'package:dartz/dartz.dart';
import 'package:medmind/core/errors/failures.dart';

abstract class UserPreferencesRepository {
  Future<Either<Failure, bool>> isBiometricEnabled();
  Future<Either<Failure, void>> setBiometricEnabled({required bool enabled});

  Future<Either<Failure, bool>> isOnboardingComplete();
  Future<Either<Failure, void>> completeOnboarding();

  Future<Either<Failure, String?>> getReminderTime();
  Future<Either<Failure, void>> setReminderTime(String time);

  Future<Either<Failure, String>> getThemeMode();
  Future<Either<Failure, void>> setThemeMode(String mode);

  Future<Either<Failure, List<String>>> getTrackedSymptomIds();
  Future<Either<Failure, void>> setTrackedSymptomIds(List<String> ids);

  Future<Either<Failure, List<String>>> getTrackedLifestyleFactorIds();
  Future<Either<Failure, void>> setTrackedLifestyleFactorIds(List<String> ids);
}
