// test/helpers/mock_repositories.dart
// Semua mock class menggunakan mocktail — tidak perlu code generation.

import 'package:mocktail/mocktail.dart';
import 'package:medmind/core/enum/enum_collection.dart';
import 'package:medmind/core/services/biometric_auth_service.dart';
import 'package:medmind/domain/entities/correlation_result.dart';
import 'package:medmind/domain/entities/health_score.dart';
import 'package:medmind/domain/entities/insight.dart';
import 'package:medmind/domain/entities/journal_entry.dart';
import 'package:medmind/domain/entities/sleep_record.dart';
import 'package:medmind/domain/repositories/health_connect_repository.dart';
import 'package:medmind/domain/repositories/insight_repository.dart';
import 'package:medmind/domain/repositories/journal_repository.dart';
import 'package:medmind/domain/repositories/ml_repository.dart';
import 'package:medmind/domain/repositories/symptom_repository.dart';
import 'package:medmind/domain/repositories/user_preferences_repository.dart';
import 'package:medmind/domain/usecases/export/export_to_csv.dart';
import 'package:medmind/domain/usecases/export/export_to_pdf.dart';

// ─── Repository Mocks ───────────────────────────────────────────────────────

class MockJournalRepository extends Mock implements JournalRepository {}

class MockSymptomRepository extends Mock implements SymptomRepository {}

class MockInsightRepository extends Mock implements InsightRepository {}

class MockMlRepository extends Mock implements MlRepository {}

class MockHealthConnectRepository extends Mock
    implements HealthConnectRepository {}

class MockUserPreferencesRepository extends Mock
    implements UserPreferencesRepository {}

// ─── Service Mocks ──────────────────────────────────────────────────────────

class MockBiometricAuthService extends Mock implements BiometricAuthService {}

// ─── DataSource Mocks ───────────────────────────────────────────────────────

class MockCsvExportDataSource extends Mock implements CsvExportDataSource {}

class MockPdfExportDataSource extends Mock implements PdfExportDataSource {}

// ─── Fallback Values ────────────────────────────────────────────────────────
// Wajib didaftarkan untuk tipe custom yang dipakai sebagai argumen di mock.

void registerFallbackValues() {
  registerFallbackValue(
    JournalEntry(
      id: 'fallback-id',
      date: DateTime(2026),
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    ),
  );
  registerFallbackValue(
    Insight(
      id: 'fallback-insight',
      type: InsightType.correlation,
      title: 'Fallback',
      description: 'Fallback',
      confidence: 0.5,
      relatedVariables: const [],
      generatedAt: DateTime(2026),
    ),
  );
  registerFallbackValue(
    HealthScore(
      date: DateTime(2026),
      overallScore: 50.0,
      components: const {'mood': 50.0, 'sleep': 50.0, 'symptoms': 50.0},
      trend: ScoreTrend.stable,
    ),
  );
  registerFallbackValue(
    const CorrelationResult(
      variableA: 'a',
      variableB: 'b',
      correlationCoefficient: 0.0,
      pValue: 0.5,
      sampleSize: 10,
      lag: 0,
      isSignificant: false,
    ),
  );
  registerFallbackValue(
    SleepRecord(
      bedTime: DateTime(2026),
      wakeTime: DateTime(2026).add(const Duration(hours: 8)),
      quality: 5,
    ),
  );
  registerFallbackValue(
    ExportParams(
      entries: [
        JournalEntry(
          id: 'fallback-export',
          date: DateTime(2026),
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
      ],
    ),
  );
}

