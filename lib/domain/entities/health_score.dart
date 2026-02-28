import 'package:medmind/core/enum/enum_collection.dart';

class HealthScore {
  final DateTime date;
  final double overallScore; // 0-100
  final Map<String, double> components; // breakdown per category
  final ScoreTrend trend;

  HealthScore({
    required this.date,
    required this.overallScore,
    required this.components,
    required this.trend,
  });
}
