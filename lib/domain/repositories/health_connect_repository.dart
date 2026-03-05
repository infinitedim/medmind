import 'package:dartz/dartz.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/entities/journal_entry.dart';
import 'package:medmind/domain/entities/sleep_record.dart';

abstract class HealthConnectRepository {
  Future<Either<Failure, bool>> checkAvailability();
  Future<Either<Failure, bool>> requestPermissions();

  Future<Either<Failure, List<SleepRecord>>> importSleepData({
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<Either<Failure, Map<DateTime, int>>> importStepData({
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<Either<Failure, void>> exportSymptomData(List<JournalEntry> entries);
}
