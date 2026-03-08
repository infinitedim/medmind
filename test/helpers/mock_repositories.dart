// test/helpers/mock_repositories.dart
// Semua mock class menggunakan mocktail — tidak perlu code generation.

import 'package:mocktail/mocktail.dart';
import 'package:medmind/domain/repositories/journal_repository.dart';
import 'package:medmind/domain/repositories/symptom_repository.dart';
import 'package:medmind/domain/repositories/insight_repository.dart';
import 'package:medmind/domain/repositories/ml_repository.dart';
import 'package:medmind/domain/repositories/health_connect_repository.dart';
import 'package:medmind/domain/repositories/user_preferences_repository.dart';
import 'package:medmind/domain/entities/journal_entry.dart';

// ─── Repository Mocks ───────────────────────────────────────────────────────

class MockJournalRepository extends Mock implements JournalRepository {}

class MockSymptomRepository extends Mock implements SymptomRepository {}

class MockInsightRepository extends Mock implements InsightRepository {}

class MockMlRepository extends Mock implements MlRepository {}

class MockHealthConnectRepository extends Mock
    implements HealthConnectRepository {}

class MockUserPreferencesRepository extends Mock
    implements UserPreferencesRepository {}

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
}
