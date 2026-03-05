import 'package:dartz/dartz.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/repositories/health_connect_repository.dart';
import 'package:medmind/domain/usecases/health_connect/import_sleep_data.dart';

class ImportStepData {
  final HealthConnectRepository _repository;

  const ImportStepData(this._repository);

  Future<Either<Failure, Map<DateTime, int>>> call(
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
        return _repository.importStepData(
          startDate: params.startDate,
          endDate: params.endDate,
        );
      });
    });
  }
}
