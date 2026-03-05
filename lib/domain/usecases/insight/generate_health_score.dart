import 'package:dartz/dartz.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/core/enum/enum_collection.dart';
import 'package:medmind/domain/entities/health_score.dart';
import 'package:medmind/domain/entities/journal_entry.dart';
import 'package:medmind/domain/repositories/insight_repository.dart';
import 'package:medmind/domain/repositories/journal_repository.dart';

class GenerateHealthScoreParams {
  final DateTime date;

  const GenerateHealthScoreParams({required this.date});
}

class GenerateHealthScore {
  final JournalRepository _journalRepository;
  final InsightRepository _insightRepository;

  const GenerateHealthScore(this._journalRepository, this._insightRepository);

  Future<Either<Failure, HealthScore>> call(
    GenerateHealthScoreParams params,
  ) async {
    final cached = await _insightRepository.getHealthScore(params.date);
    final cachedScore = cached.getOrElse(() => null);
    if (cachedScore != null) return Right(cachedScore);

    final dayStart = DateTime(
      params.date.year,
      params.date.month,
      params.date.day,
    );
    final dayEnd = dayStart.add(const Duration(hours: 23, minutes: 59));

    final entriesResult = await _journalRepository.getEntries(
      startDate: dayStart,
      endDate: dayEnd,
      limit: 1,
    );

    return entriesResult.fold(Left.new, (entries) async {
      if (entries.isEmpty) {
        return Left(
          NotFoundFailure('No journal entry found for ${params.date}'),
        );
      }
      final score = _computeScore(entries.first, params.date);
      await _insightRepository.saveHealthScore(score);
      return Right(score);
    });
  }

  HealthScore _computeScore(JournalEntry entry, DateTime date) {
    final mood = _moodScore(entry.mood, entry.moodIntensity);
    final sleep = _sleepScore(entry.sleepRecord?.quality);
    final symptom = _symptomScore(entry.symptoms);

    final overall = (mood * 0.35 + sleep * 0.35 + symptom * 0.30).clamp(
      0.0,
      100.0,
    );

    return HealthScore(
      date: date,
      overallScore: overall,
      components: {'mood': mood, 'sleep': sleep, 'symptoms': symptom},
      trend: ScoreTrend.stable,
    );
  }

  double _moodScore(Mood? mood, int? intensity) {
    if (mood == null) return 50.0;
    final base = [100.0, 75.0, 50.0, 25.0, 0.0][mood.index];
    if (intensity == null) return base;
    return (base + (intensity - 1) / 9.0 * 100.0) / 2.0;
  }

  double _sleepScore(int? quality) {
    if (quality == null) return 50.0;
    return (quality / 10.0) * 100.0;
  }

  double _symptomScore(List symptoms) {
    if (symptoms.isEmpty) return 100.0;
    final totalSeverity = symptoms.fold<int>(
      0,
      (acc, s) => acc + (s.severity as int),
    );
    return (100.0 - totalSeverity * 2).clamp(0.0, 100.0);
  }
}
