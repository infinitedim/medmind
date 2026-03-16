import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/entities/correlation_result.dart';
import 'package:medmind/domain/entities/symptom.dart';
import 'package:medmind/domain/repositories/ml_repository.dart';

@LazySingleton(as: MlRepository)
class MlRepositoryImpl implements MlRepository {
  const MlRepositoryImpl();

  static const _notReady = MLFailure('ML models not yet initialized');

  @override
  Future<Either<Failure, List<ExtractedSymptom>>> extractSymptomsFromText(
    String text,
  ) async => const Left(_notReady);

  @override
  Future<Either<Failure, bool>> predictAnomaly(List<double> features) async =>
      const Left(_notReady);

  @override
  Future<Either<Failure, List<CorrelationResult>>> computeCorrelations(
    List<List<double>> timeSeriesData,
    List<String> variableNames,
  ) async => const Left(_notReady);

  @override
  Future<Either<Failure, void>> initializeModels() async =>
      const Left(_notReady);
}
