import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medmind/core/enum/enum_collection.dart';

part 'health_score.freezed.dart';

@freezed
abstract class HealthScore with _$HealthScore {
  const factory HealthScore({
    required DateTime date,
    required double overallScore, // 0-100
    required Map<String, double> components, // breakdown per category
    required ScoreTrend trend,
  }) = _HealthScore;
}
