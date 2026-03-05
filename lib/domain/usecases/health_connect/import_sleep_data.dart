import 'package:dartz/dartz.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/entities/sleep_record.dart';
import 'package:medmind/domain/repositories/health_connect_repository.dart';

class ImportDataParams {
  final DateTime? startDate;
  final DateTime? endDate;

  const ImportDataParams({this.startDate, this.endDate});
}

class ImportSleepData {
  final HealthConnectRepository _repository;

  const ImportSleepData(this._repository);

  Future<Either<Failure, List<SleepRecord>>> call(
    ImportDataParams params,
  ) async {
    final available = await _repository.checkAvailability();
    return available.fold(Left.new, (isAvailable) async {
      if (!isAvailable) {
        return const Left(
          HealthConnectFailure(
            'Health Connect is not available on this device',
          ),
        );
      }
      final permissions = await _repository.requestPermissions();
      return permissions.fold(Left.new, (granted) async {
        if (!granted) {
          return const Left(
            HealthConnectFailure('Health Connect permissions were denied'),
          );
        }
        return _repository.importSleepData(
          startDate: params.startDate,
          endDate: params.endDate,
        );
      });
    });
  }
}
