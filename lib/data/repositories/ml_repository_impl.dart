import 'dart:math';

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
    // TODO: Implement anomaly detection using TFLite model
    // For now, return false (no anomaly) as placeholder
    return const Right(false);
  }

  @override
  Future<Either<Failure, List<CorrelationResult>>> computeCorrelations(
    List<List<double>> timeSeriesData,
    List<String> variableNames,
  ) async {
    try {
      final results = <CorrelationResult>[];

      for (int i = 0; i < timeSeriesData.length; i++) {
        for (int j = i + 1; j < timeSeriesData.length; j++) {
          final series1 = timeSeriesData[i];
          final series2 = timeSeriesData[j];

          if (series1.length != series2.length || series1.isEmpty) continue;

          final correlation = _computePearsonCorrelation(series1, series2);
          final pValue = CorrelationEngine.pValue(
            correlation.t,
            series1.length - 2,
          );

          results.add(
            CorrelationResult(
              variableA: variableNames[i],
              variableB: variableNames[j],
              correlationCoefficient: correlation.r,
              pValue: pValue,
              sampleSize: series1.length,
              lag: 0, // No lag for simple correlation
              isSignificant: pValue < 0.05,
            ),
          );
        }
      }

      return Right(results);
    } catch (e) {
      return Left(MLFailure('Failed to compute correlations: ${e.toString()}'));
    }
  }

  /// Computes Pearson correlation coefficient and t-statistic.
  ({double r, double t}) _computePearsonCorrelation(
    List<double> x,
    List<double> y,
  ) {
    final n = x.length;
    final sumX = x.reduce((a, b) => a + b);
    final sumY = y.reduce((a, b) => a + b);
    final sumXY = List.generate(n, (i) => x[i] * y[i]).reduce((a, b) => a + b);
    final sumX2 = x.map((v) => v * v).reduce((a, b) => a + b);
    final sumY2 = y.map((v) => v * v).reduce((a, b) => a + b);

    final numerator = n * sumXY - sumX * sumY;
    final denominator = sqrt(
      (n * sumX2 - sumX * sumX) * (n * sumY2 - sumY * sumY),
    );

    final r = denominator == 0 ? 0.0 : numerator / denominator;
    final t = r * sqrt((n - 2) / (1 - r * r));

    return (r: r, t: t);
  }

  @override
  Future<Either<Failure, void>> initializeModels() async {
    // Rule-based extraction doesn't require model initialization
    // TODO: Initialize TFLite models when available
    return const Right(null);
  }
}
