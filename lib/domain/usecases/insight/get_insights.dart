import 'package:dartz/dartz.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/entities/insight.dart';
import 'package:medmind/domain/repositories/insight_repository.dart';

class GetInsightsParams {
  final bool unreadOnly;

  const GetInsightsParams({this.unreadOnly = false});
}

class GetInsights {
  final InsightRepository _repository;

  const GetInsights(this._repository);

  Future<Either<Failure, List<Insight>>> call(GetInsightsParams params) {
    return _repository.getInsights(unreadOnly: params.unreadOnly);
  }

  Stream<List<Insight>> watch() => _repository.watchInsights();
}
