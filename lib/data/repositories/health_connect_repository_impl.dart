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
      return Right(await _channel.isAvailable());
    } on HealthConnectException catch (e) {
      return Left(HealthConnectFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> requestPermissions() async {
    try {
      return Right(await _channel.requestPermissions());
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

  @override
  Future<Either<Failure, Map<DateTime, int>>> importStepData({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final now = DateTime.now();
      final from = DateTime(
        (startDate ?? now.subtract(const Duration(days: 30))).year,
        (startDate ?? now.subtract(const Duration(days: 30))).month,
        (startDate ?? now.subtract(const Duration(days: 30))).day,
      );
      final to = DateTime(now.year, now.month, now.day);
      final result = <DateTime, int>{};
      var cursor = from;
      while (!cursor.isAfter(endDate ?? to)) {
        final dayEnd = cursor.add(const Duration(days: 1));
        final steps = await _channel.readSteps(
          startTime: cursor,
          endTime: dayEnd,
        );
        if (steps > 0) result[cursor] = steps;
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
  ) async => const Right(null);

  // ─── Private helpers ─────────────────────────────────────────────────────

  SleepRecord _sessionToRecord(SleepSession session) {
    final totalMinutes = session.endTime
        .difference(session.startTime)
        .inMinutes
        .clamp(1, 1440);
    final deepMinutes = session.stages
        .where((s) => s.type == 5)
        .fold(0, (sum, s) => sum + s.duration.inMinutes);
    final quality = ((deepMinutes / totalMinutes) * 10).round().clamp(1, 10);
    final disturbances = session.stages.where((s) => s.type == 1).length;
    return SleepRecord(
      bedTime: session.startTime,
      wakeTime: session.endTime,
      quality: quality,
      disturbances: disturbances,
    );
  }
}
