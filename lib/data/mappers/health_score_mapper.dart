import 'package:medmind/core/enum/enum_collection.dart';
import 'package:medmind/domain/entities/health_score.dart';

extension HealthScoreMapper on HealthScore {
  Map<String, dynamic> toMap() => {
    'date': date.toIso8601String(),
    'overallScore': overallScore,
    'components': components,
    'trend': trend.name,
  };
}

extension HealthScoreFromMap on Map<String, dynamic> {
  HealthScore toHealthScore() => HealthScore(
    date: DateTime.parse(this['date'] as String),
    overallScore: (this['overallScore'] as num).toDouble(),
    components: (this['components'] as Map<String, dynamic>).map(
      (k, v) => MapEntry(k, (v as num).toDouble()),
    ),
    trend: ScoreTrend.values.byName(this['trend'] as String),
  );
}
