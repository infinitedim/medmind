import 'package:dartz/dartz.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/entities/journal_entry.dart';
import 'package:medmind/domain/repositories/health_connect_repository.dart';

class ExportSymptomData {
  final HealthConnectRepository _repository;

  const ExportSymptomData(this._repository);

  Future<Either<Failure, void>> call(List<JournalEntry> entries) async {
    if (entries.isEmpty) return const Right(null);

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
        return _repository.exportSymptomData(entries);
      });
    });
  }
}
