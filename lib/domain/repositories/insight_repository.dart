import 'package:dartz/dartz.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/entities/correlation_result.dart';
import 'package:medmind/domain/entities/health_score.dart';
import 'package:medmind/domain/entities/insight.dart';

abstract class InsightRepository {
  Future<Either<Failure, List<Insight>>> getInsights({bool unreadOnly = false});
  Future<Either<Failure, void>> saveInsight(Insight insight);
  Future<Either<Failure, Insight>> markAsRead(String id);
  Future<Either<Failure, Insight>> toggleSaved(String id);

  Future<Either<Failure, void>> saveCorrelations(
    List<CorrelationResult> correlations,
  );

  Future<Either<Failure, List<CorrelationResult>>> getCorrelations({
    DateTime? since,
  });

  Future<Either<Failure, HealthScore?>> getHealthScore(DateTime date);

  Future<Either<Failure, void>> saveHealthScore(HealthScore score);

  Stream<List<Insight>> watchInsights();
}
