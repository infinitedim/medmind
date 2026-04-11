import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medmind/core/di/injection.dart';
import 'package:medmind/domain/repositories/health_connect_repository.dart';
import 'package:medmind/domain/repositories/insight_repository.dart';
import 'package:medmind/domain/repositories/journal_repository.dart';
import 'package:medmind/domain/repositories/ml_repository.dart';
import 'package:medmind/domain/repositories/symptom_repository.dart';
import 'package:medmind/domain/repositories/user_preferences_repository.dart';
import 'package:medmind/domain/usecases/insight/detect_anomalies.dart';
import 'package:medmind/domain/usecases/insight/generate_correlations.dart';
import 'package:medmind/domain/usecases/insight/generate_health_score.dart';


final journalRepositoryProvider = Provider<JournalRepository>(
  (ref) => getIt<JournalRepository>(),
);

final symptomRepositoryProvider = Provider<SymptomRepository>(
  (ref) => getIt<SymptomRepository>(),
);

final insightRepositoryProvider = Provider<InsightRepository>(
  (ref) => getIt<InsightRepository>(),
);

final userPreferencesRepositoryProvider = Provider<UserPreferencesRepository>(
  (ref) => getIt<UserPreferencesRepository>(),
);

final mlRepositoryProvider = Provider<MlRepository>(
  (ref) => getIt<MlRepository>(),
);

final healthConnectRepositoryProvider = Provider<HealthConnectRepository>(
  (ref) => getIt<HealthConnectRepository>(),
);

// Use Cases
final generateCorrelationsProvider = Provider<GenerateCorrelations>(
  (ref) => getIt<GenerateCorrelations>(),
);

final detectAnomaliesProvider = Provider<DetectAnomalies>(
  (ref) => getIt<DetectAnomalies>(),
);

final generateHealthScoreProvider = Provider<GenerateHealthScore>(
  (ref) => getIt<GenerateHealthScore>(),
);

final currentDateProvider = Provider<DateTime>((ref) => DateTime.now());


