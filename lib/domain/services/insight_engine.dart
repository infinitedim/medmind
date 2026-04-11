import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/entities/correlation_result.dart';
import 'package:medmind/domain/entities/health_score.dart';
import 'package:medmind/domain/entities/insight.dart';
import 'package:medmind/domain/repositories/journal_repository.dart';
import 'package:medmind/domain/usecases/insight/detect_anomalies.dart';
import 'package:medmind/domain/usecases/insight/generate_correlations.dart';
import 'package:medmind/domain/usecases/insight/generate_health_score.dart';

@lazySingleton
class InsightEngine {
  final GenerateCorrelations _generateCorrelations;
  final DetectAnomalies _detectAnomalies;
  final GenerateHealthScore _generateHealthScore;
  final JournalRepository _journalRepository;

  const InsightEngine(
    this._generateCorrelations,
    this._detectAnomalies,
    this._generateHealthScore,
    this._journalRepository,
  );

  /// Run a full health analysis suite.
  /// Typically called after new journal entries are added or periodically.
  Future<Either<Failure, InsightReport>> analyzeHealthData({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // 1. Fetch entries for the period
    final entriesResult = await _journalRepository.getEntries(
      startDate: startDate,
      endDate: endDate,
    );

    return entriesResult.fold(
      (failure) => Left(failure),
      (entries) async {
        if (entries.isEmpty) {
          return const Left(NotFoundFailure('No data to analyze'));
        }

        // 2. Generate Correlations
        final correlationsResult = await _generateCorrelations(
          GenerateCorrelationsParams(startDate: startDate, endDate: endDate),
        );

        // 3. Detect Anomalies
        final anomaliesResult = await _detectAnomalies(entries);

        // 4. Generate Current Health Score
        final scoreResult = await _generateHealthScore(
          GenerateHealthScoreParams(date: endDate),
        );

        return Right(
          InsightReport(
            correlations: correlationsResult.getOrElse(() => []),
            anomalies: anomaliesResult.getOrElse(() => []),
            currentScore: scoreResult.fold((_) => null, (r) => r),
            periodStart: startDate,
            periodEnd: endDate,
          ),
        );
      },
    );
  }
}

class InsightReport {
  final List<CorrelationResult> correlations;
  final List<Insight> anomalies;
  final HealthScore? currentScore;
  final DateTime periodStart;
  final DateTime periodEnd;

  const InsightReport({
    required this.correlations,
    required this.anomalies,
    this.currentScore,
    required this.periodStart,
    required this.periodEnd,
  });
}
