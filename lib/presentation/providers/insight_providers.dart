import 'package:medmind/presentation/providers/core_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medmind/domain/entities/insight.dart';
import 'package:medmind/domain/services/insight_engine.dart';

part 'insight_providers.g.dart';

@riverpod
class InsightsNotifier extends _$InsightsNotifier {
  @override
  Stream<List<Insight>> build() {
    final repository = ref.watch(insightRepositoryProvider);
    return repository.watchInsights();
  }

  Future<void> runAnalysis() async {
    final engine = ref.read(insightEngineProvider);
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 30));
    
    await engine.analyzeHealthData(startDate: start, endDate: now);
  }
}

@riverpod
Future<InsightReport?> latestInsightReport(Ref ref) async {
  final engine = ref.watch(insightEngineProvider);
  final now = DateTime.now();
  final start = now.subtract(const Duration(days: 30));
  
  final result = await engine.analyzeHealthData(startDate: start, endDate: now);
  return result.fold((_) => null, (report) => report);
}

@riverpod
InsightEngine insightEngine(Ref ref) {
  return InsightEngine(
    ref.watch(generateCorrelationsProvider),
    ref.watch(detectAnomaliesProvider),
    ref.watch(generateHealthScoreProvider),
    ref.watch(journalRepositoryProvider),
  );
}

