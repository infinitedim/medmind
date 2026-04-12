import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:medmind/core/errors/exceptions.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/data/datasources/ml/symptom_classifier.dart';
import 'package:medmind/data/datasources/ml/anomaly_model.dart';
import 'package:medmind/data/datasources/ml/correlation_model.dart';
import 'package:medmind/domain/entities/correlation_result.dart';
import 'package:medmind/domain/entities/symptom.dart';
import 'package:medmind/domain/repositories/ml_repository.dart';
import 'package:medmind/domain/services/correlation_engine.dart';

@LazySingleton(as: MlRepository)
class MlRepositoryImpl implements MlRepository {
  const MlRepositoryImpl(
    this._symptomExtractor,
    this._anomalyModel,
    this._correlationModel,
  );

  final RuleBasedSymptomExtractor _symptomExtractor;
  final AnomalyTFLiteModel _anomalyModel;
  final CorrelationTFLiteModel _correlationModel;

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
    try {
      // If flattened window is provided (10 * 4 = 40), reshape and run TFLite model
      if (features.length == 40) {
        final window = List<List<double>>.generate(
          10,
          (i) => features.sublist(i * 4, i * 4 + 4),
        );
        final res = await _anomalyModel.detect(window);
        return Right(res.isAnomaly);
      }

      // Fallback: statistical heuristic
      const baselines = [50.0, 5.0, 7.0, 8.0, 0.0, 2.0];
      const deviations = [20.0, 2.0, 2.0, 2.0, 3.0, 5.0];
      for (var i = 0; i < features.length && i < baselines.length; i++) {
        if (features[i] == -1.0) continue;
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

      // Attempt to augment with ML-based suggestions
      try {
        final mlSuggestions = await _correlationModel.getCorrelated(
          variableNames,
        );
        final source = variableNames.isNotEmpty ? variableNames.first : 'input';
        for (var i = 0; i < mlSuggestions.length && i < 5; i++) {
          final s = mlSuggestions[i];
          results.add(
            CorrelationResult(
              variableA: source,
              variableB: s.key,
              correlationCoefficient: s.value,
              pValue: 1.0,
              sampleSize: 0,
              lag: 0,
              isSignificant: false,
            ),
          );
        }
      } catch (_) {
        // ignore ML augmentation failures
      }

      return Right(results);
    } catch (e) {
      return Left(MLFailure('Failed to compute correlations: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> initializeModels() async {
    try {
      await Future.wait([_anomalyModel.init(), _correlationModel.init()]);
      return const Right(null);
    } catch (e) {
      return Left(MLFailure('Failed to initialize ML models: ${e.toString()}'));
    }
  }
}
