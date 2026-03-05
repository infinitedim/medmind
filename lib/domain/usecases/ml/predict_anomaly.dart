import 'package:dartz/dartz.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/repositories/ml_repository.dart';

class PredictAnomaly {
  final MlRepository _repository;

  const PredictAnomaly(this._repository);

  Future<Either<Failure, bool>> call(List<double> features) {
    return _repository.predictAnomaly(features);
  }
}
