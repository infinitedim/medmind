import 'package:dartz/dartz.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/entities/correlation_result.dart';
import 'package:medmind/domain/entities/symptom.dart';

abstract class MlRepository {
  Future<Either<Failure, List<ExtractedSymptom>>> extractSymptomsFromText(
    String text,
  );

  Future<Either<Failure, bool>> predictAnomaly(List<double> features);

  Future<Either<Failure, List<CorrelationResult>>> computeCorrelations(
    List<List<double>> timeSeriesData,
    List<String> variableNames,
  );

  Future<Either<Failure, void>> initializeModels();
}
