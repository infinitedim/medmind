import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:medmind/core/enum/enum_collection.dart';
import 'package:medmind/core/errors/exceptions.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/data/datasources/local/insight_cache_datasource.dart';
import 'package:medmind/data/models/insight_model.dart';
import 'package:medmind/domain/entities/correlation_result.dart';
import 'package:medmind/domain/entities/health_score.dart';
import 'package:medmind/domain/entities/insight.dart';
import 'package:medmind/domain/repositories/insight_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton(as: InsightRepository)
class InsightRepositoryImpl implements InsightRepository {
  const InsightRepositoryImpl(this._cache, this._prefs);

  final InsightCacheDataSource _cache;
  final SharedPreferences _prefs;

  static const _correlationsKey = 'cached_correlations';
  static const _healthScoresKey = 'cached_health_scores';

  @override
  Future<Either<Failure, List<Insight>>> getInsights({
    bool unreadOnly = false,
  }) async {
    try {
      final models = unreadOnly
          ? await _cache.getUnread()
          : await _cache.getAll();
      return Right(models.map(_modelToInsight).toList());
    } on CacheException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> saveInsight(Insight insight) async {
    try {
      await _cache.save(_insightToModel(insight));
      return const Right(null);
    } on CacheException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Insight>> markAsRead(String id) async {
    try {
      await _cache.markAsRead(id);
      final model = await _cache.getByUid(id);
      return Right(_modelToInsight(model));
    } on RecordNotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on CacheException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Insight>> toggleSaved(String id) async {
    try {
      await _cache.toggleSaved(id);
      final model = await _cache.getByUid(id);
      return Right(_modelToInsight(model));
    } on RecordNotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on CacheException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> saveCorrelations(
    List<CorrelationResult> correlations,
  ) async {
    final list = correlations.map(_correlationToMap).toList();
    await _prefs.setString(_correlationsKey, jsonEncode(list));
    return const Right(null);
  }

  @override
  Future<Either<Failure, List<CorrelationResult>>> getCorrelations({
    DateTime? since,
  }) async {
    final raw = _prefs.getString(_correlationsKey);
    if (raw == null) return const Right([]);
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    return Right(list.map(_correlationFromMap).toList());
  }

  @override
  Future<Either<Failure, HealthScore?>> getHealthScore(DateTime date) async {
    final raw = _prefs.getString(_healthScoresKey);
    if (raw == null) return const Right(null);
    final map = jsonDecode(raw) as Map<String, dynamic>;
    final key = date.toIso8601String().substring(0, 10);
    final entry = map[key] as Map<String, dynamic>?;
    if (entry == null) return const Right(null);
    return Right(_healthScoreFromMap(entry));
  }

  @override
  Future<Either<Failure, void>> saveHealthScore(HealthScore score) async {
    final raw = _prefs.getString(_healthScoresKey);
    final map = raw != null
        ? (jsonDecode(raw) as Map<String, dynamic>)
        : <String, dynamic>{};
    final key = score.date.toIso8601String().substring(0, 10);
    map[key] = _healthScoreToMap(score);
    await _prefs.setString(_healthScoresKey, jsonEncode(map));
    return const Right(null);
  }

  @override
  Stream<List<Insight>> watchInsights() {
    return _cache.watchAll().map((models) => models.map(_modelToInsight).toList());
  }

  Insight _modelToInsight(InsightModel model) {
    final vars = (jsonDecode(model.relatedVariablesJson) as List).cast<String>();
    return Insight(
      id: model.uid,
      type: model.type,
      title: model.title,
      description: model.description,
      confidence: model.confidence,
      relatedVariables: vars,
      generatedAt: model.generatedAt,
      isRead: model.isRead,
      isSaved: model.isSaved,
    );
  }

  InsightModel _insightToModel(Insight insight) {
    return InsightModel()
      ..uid = insight.id
      ..type = insight.type
      ..title = insight.title
      ..description = insight.description
      ..confidence = insight.confidence
      ..relatedVariablesJson = jsonEncode(insight.relatedVariables)
      ..generatedAt = insight.generatedAt
      ..isRead = insight.isRead
      ..isSaved = insight.isSaved;
  }

  Map<String, dynamic> _correlationToMap(CorrelationResult c) => {
    'variableA': c.variableA,
    'variableB': c.variableB,
    'correlationCoefficient': c.correlationCoefficient,
    'pValue': c.pValue,
    'sampleSize': c.sampleSize,
    'lag': c.lag,
    'isSignificant': c.isSignificant,
  };

  CorrelationResult _correlationFromMap(Map<String, dynamic> m) =>
      CorrelationResult(
        variableA: m['variableA'] as String,
        variableB: m['variableB'] as String,
        correlationCoefficient: (m['correlationCoefficient'] as num).toDouble(),
        pValue: (m['pValue'] as num).toDouble(),
        sampleSize: m['sampleSize'] as int,
        lag: m['lag'] as int,
        isSignificant: m['isSignificant'] as bool,
      );

  Map<String, dynamic> _healthScoreToMap(HealthScore s) => {
    'date': s.date.toIso8601String(),
    'overallScore': s.overallScore,
    'components': s.components,
    'trend': s.trend.name,
  };

  HealthScore _healthScoreFromMap(Map<String, dynamic> m) => HealthScore(
    date: DateTime.parse(m['date'] as String),
    overallScore: (m['overallScore'] as num).toDouble(),
    components: (m['components'] as Map<String, dynamic>).map(
      (k, v) => MapEntry(k, (v as num).toDouble()),
    ),
    trend: ScoreTrend.values.byName(m['trend'] as String),
  );
}
