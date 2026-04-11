import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:medmind/core/errors/exceptions.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/data/datasources/ml/symptom_classifier.dart';
import 'package:medmind/domain/entities/correlation_result.dart';
import 'package:medmind/domain/entities/symptom.dart';
import 'package:medmind/domain/repositories/ml_repository.dart';
import 'package:medmind/domain/services/correlation_engine.dart';

@LazySingleton(as: MlRepository)
class MlRepositoryImpl implements MlRepository {
  const MlRepositoryImpl(this._symptomExtractor);

  final RuleBasedSymptomExtractor _symptomExtractor;

  @override
  Future<Either<Failure, List<ExtractedSymptom>>> extractSymptomsFromText(
    String text,
  ) async {
    try {
      final extracted = _symptomExtractor.extractFromText(text);
      return Right(extracted);
    } on MlInferenceException catch (e) {
      return Left(MLFailure(e.message));
    } catch (e) {
      return Left(MLFailure('Failed to extract symptoms: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> predictAnomaly(List<double> features) async {
    // Statistical fallback: Detect anomaly if any feature is > 2.5 standard deviations from baseline.
    // NOTE: This is a simplified logic since we're skipping actual TFLite inference.
    // Real logic would require a baseline feature distribution for the user.
    try {
      // Dummy baseline means/std-devs (normally this would be cached per user)
      const baselines = [50.0, 5.0, 7.0, 8.0, 0.0, 2.0];
      const deviations = [20.0, 2.0, 2.0, 2.0, 3.0, 5.0];

      for (var i = 0; i < features.length && i < baselines.length; i++) {
        if (features[i] == -1.0) continue; // Skip missing data
        final zScore = (features[i] - baselines[i]).abs() / deviations[i];
        if (zScore > 2.5) return const Right(true);
      }
      return const Right(false);
    } catch (e) {
      return Left(MLFailure('Anomaly detection failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<CorrelationResult>>> computeCorrelations(
    List<List<double>> timeSeriesData,
    List<String> variableNames,
  ) async {
    try {
      final results = CorrelationEngine.computeSignificantCorrelations(
        data: timeSeriesData,
        variableNames: variableNames,
      );
      return Right(results);
    } catch (e) {
      return Left(MLFailure('Failed to compute correlations: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> initializeModels() async {
    // Rule-based extraction and statistical correlations don't require ML model initialization
    return const Right(null);
  }
}
