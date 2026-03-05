import 'package:dartz/dartz.dart';
import 'package:medmind/core/errors/failures.dart';
import 'package:medmind/domain/entities/correlation_result.dart';
import 'package:medmind/domain/entities/journal_entry.dart';
import 'package:medmind/domain/repositories/insight_repository.dart';
import 'package:medmind/domain/repositories/journal_repository.dart';
import 'package:medmind/domain/repositories/ml_repository.dart';

class GenerateCorrelationsParams {
  final DateTime startDate;
  final DateTime endDate;

  const GenerateCorrelationsParams({
    required this.startDate,
    required this.endDate,
  });
}

class GenerateCorrelations {
  final JournalRepository _journalRepository;
  final MlRepository _mlRepository;
  final InsightRepository _insightRepository;

  const GenerateCorrelations(
    this._journalRepository,
    this._mlRepository,
    this._insightRepository,
  );

  Future<Either<Failure, List<CorrelationResult>>> call(
    GenerateCorrelationsParams params,
  ) async {
    final entriesResult = await _journalRepository.getEntries(
      startDate: params.startDate,
      endDate: params.endDate,
    );

    return entriesResult.fold(Left.new, (entries) => _compute(entries));
  }

  Future<Either<Failure, List<CorrelationResult>>> _compute(
    List<JournalEntry> entries,
  ) async {
    final matrix = _buildTimeSeriesMatrix(entries);
    if (matrix.isEmpty) return const Right([]);

    final correlationsResult = await _mlRepository.computeCorrelations(
      matrix.rows,
      matrix.variableNames,
    );

    return correlationsResult.fold(Left.new, (correlations) async {
      final saveResult = await _insightRepository.saveCorrelations(
        correlations,
      );
      return saveResult.fold(Left.new, (_) => Right(correlations));
    });
  }

  _TimeSeriesMatrix _buildTimeSeriesMatrix(List<JournalEntry> entries) {
    final sorted = [...entries]..sort((a, b) => a.date.compareTo(b.date));

    const variables = [
      'mood',
      'moodIntensity',
      'sleepQuality',
      'sleepDuration',
      'symptomCount',
    ];

    final rows = sorted.map((e) {
      final sleepDurationHours = e.sleepRecord != null
          ? e.sleepRecord!.duration.inMinutes / 60.0
          : 0.0;
      return [
        e.mood != null ? e.mood!.index.toDouble() : -1.0,
        e.moodIntensity?.toDouble() ?? -1.0,
        e.sleepRecord?.quality.toDouble() ?? -1.0,
        sleepDurationHours,
        e.symptoms.length.toDouble(),
      ];
    }).toList();

    return _TimeSeriesMatrix(rows: rows, variableNames: variables);
  }
}

class _TimeSeriesMatrix {
  final List<List<double>> rows;
  final List<String> variableNames;

  const _TimeSeriesMatrix({required this.rows, required this.variableNames});

  bool get isEmpty => rows.isEmpty;
}
