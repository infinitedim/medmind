import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medmind/core/di/injection.dart';
import 'package:medmind/domain/repositories/health_connect_repository.dart';
import 'package:medmind/domain/repositories/insight_repository.dart';
import 'package:medmind/domain/repositories/journal_repository.dart';
import 'package:medmind/domain/repositories/ml_repository.dart';
import 'package:medmind/domain/repositories/symptom_repository.dart';
import 'package:medmind/domain/repositories/user_preferences_repository.dart';

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
