import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/entities/journal_entry.dart';
import 'package:medmind/domain/entities/sleep_record.dart';
import 'package:medmind/domain/repositories/health_connect_repository.dart';
import 'package:medmind/platform/health_connect_channel.dart';

@LazySingleton(as: HealthConnectRepository)
class HealthConnectRepositoryImpl implements HealthConnectRepository {
  const HealthConnectRepositoryImpl(this._channel);

  final HealthConnectChannel _channel;

  @override
  Future<Either<Failure, bool>> checkAvailability() async {
    try {
      final result = await _channel.isAvailable();
      return Right(result);
    } on HealthConnectException catch (e) {
      return Left(HealthConnectFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> requestPermissions() async {
    try {
      final result = await _channel.requestPermissions();
      return Right(result);
    } on HealthConnectException catch (e) {
      return Left(HealthConnectFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<SleepRecord>>> importSleepData({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final now = DateTime.now();
      final sessions = await _channel.readSleepSessions(
        startTime: startDate ?? now.subtract(const Duration(days: 30)),
        endTime: endDate ?? now,
      );
      return Right(sessions.map(_sessionToRecord).toList());
    } on HealthConnectException catch (e) {
      return Left(HealthConnectFailure(e.message));
    }
  }

  SleepRecord _sessionToRecord(SleepSession session) {
    final totalMinutes = session.endTime
        .difference(session.startTime)
        .inMinutes;
    final deepMinutes = session.stages
        .where((s) => s.type == 5)
        .fold<int>(0, (sum, s) => sum + s.duration.inMinutes);
    final disturbances =
        session.stages.where((s) => s.type == 1).length;
    final quality = totalMinutes > 0
        ? (deepMinutes / totalMinutes * 10).round().clamp(1, 10)
        : 1;
    return SleepRecord(
      bedTime: session.startTime,
      wakeTime: session.endTime,
      quality: quality,
      disturbances: disturbances,
    );
  }

  @override
  Future<Either<Failure, Map<DateTime, int>>> importStepData({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final now = DateTime.now();
      final from = startDate ?? now.subtract(const Duration(days: 30));
      final to = endDate ?? now;
      final result = <DateTime, int>{};
      var cursor = DateTime(from.year, from.month, from.day);
      while (!cursor.isAfter(to)) {
        final dayEnd = cursor.add(const Duration(days: 1));
        final steps = await _channel.readSteps(
          startTime: cursor,
          endTime: dayEnd,
        );
        result[cursor] = steps;
        cursor = dayEnd;
      }
      return Right(result);
    } on HealthConnectException catch (e) {
      return Left(HealthConnectFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> exportSymptomData(
    List<JournalEntry> entries,
  ) async =>
      const Right(null);
}
