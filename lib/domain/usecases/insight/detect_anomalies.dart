import 'package:dartz/dartz.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/entities/insight.dart';
import 'package:medmind/domain/entities/journal_entry.dart';
import 'package:medmind/core/enum/enum_collection.dart';
import 'package:medmind/domain/repositories/insight_repository.dart';
import 'package:medmind/domain/repositories/ml_repository.dart';

class DetectAnomalies {
  final MlRepository _mlRepository;
  final InsightRepository _insightRepository;

  const DetectAnomalies(this._mlRepository, this._insightRepository);

  Future<Either<Failure, List<Insight>>> call(
    List<JournalEntry> entries,
  ) async {
    final anomalies = <Insight>[];

    for (final entry in entries) {
      final features = _toFeatureVector(entry);
      final result = await _mlRepository.predictAnomaly(features);

      final insight = result.fold(
        (_) => null,
        (isAnomaly) => isAnomaly ? _buildInsight(entry) : null,
      );

      if (insight != null) {
        await _insightRepository.saveInsight(insight);
        anomalies.add(insight);
      }
    }

    return Right(anomalies);
  }

  List<double> _toFeatureVector(JournalEntry entry) {
    final sleepDurationHours = entry.sleepRecord != null
        ? entry.sleepRecord!.duration.inMinutes / 60.0
        : 0.0;
    return [
      entry.mood?.index.toDouble() ?? -1.0,
      entry.moodIntensity?.toDouble() ?? -1.0,
      entry.sleepRecord?.quality.toDouble() ?? -1.0,
      sleepDurationHours,
      entry.symptoms.length.toDouble(),
      entry.symptoms.isEmpty
          ? 0.0
          : entry.symptoms
                    .map((s) => s.severity)
                    .reduce((a, b) => a + b)
                    .toDouble() /
                entry.symptoms.length,
    ];
  }

  Insight _buildInsight(JournalEntry entry) {
    return Insight(
      id: 'anomaly_${entry.id}',
      type: InsightType.anomaly,
      title: 'Unusual health pattern detected',
      description:
          'Your health data on ${entry.date.toString().split(' ').first} '
          'shows an unusual pattern compared to your baseline.',
      confidence: 0.8,
      relatedVariables: const ['mood', 'symptoms', 'sleep'],
      generatedAt: DateTime.now(),
    );
  }
}
