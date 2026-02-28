# MedMind — Rencana Pengembangan Detail

> Dokumen ini adalah panduan langkah-demi-langkah untuk membangun MedMind dari nol sampai siap rilis di Play Store.
> Ditulis untuk developer yang akan mengerjakan sendiri (solo dev).

---

## Daftar Isi

1. [Gambaran Arsitektur & Struktur Folder](#1-gambaran-arsitektur--struktur-folder)
2. [Phase 1: Foundation (Minggu 1–2)](#phase-1-foundation-minggu-12)
3. [Phase 2: Smart Journaling (Minggu 3–4)](#phase-2-smart-journaling-minggu-34)
4. [Phase 3: Statistical Engine (Minggu 5–6)](#phase-3-statistical-engine-minggu-56)
5. [Phase 4: ML Integration (Minggu 7–9)](#phase-4-ml-integration-minggu-79)
6. [Phase 5: Visualization & Polish (Minggu 10–11)](#phase-5-visualization--polish-minggu-1011)
7. [Phase 6: Production (Minggu 12)](#phase-6-production-minggu-12)
8. [Daftar Risiko & Mitigasi](#daftar-risiko--mitigasi)
9. [Definisi "Selesai" (Definition of Done)](#definisi-selesai-definition-of-done)

---

## 1. Gambaran Arsitektur & Struktur Folder

### 1.1 Prinsip Arsitektur

Kita pakai **Clean Architecture** dengan 3 layer utama:

| Layer            | Tanggung Jawab                                                                     | Aturan Dependency                                                                   |
| ---------------- | ---------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------- |
| **Presentation** | Widget, Provider (Riverpod), navigasi, animasi                                     | Boleh depend ke Domain. TIDAK BOLEH depend ke Data.                                 |
| **Domain**       | Entity, Use Case, Repository Interface, Domain Service (Insight Engine)            | TIDAK BOLEH depend ke package manapun kecuali Dart core. Ini layer paling "bersih". |
| **Data**         | Repository Implementation, Data Source (Isar, TFLite, Sensor, Firebase), Model/DTO | Boleh depend ke Domain (implement interface). Boleh pakai package eksternal.        |

**Kenapa ini penting?** Kalau suatu hari kamu mau ganti Isar ke Drift, atau ganti TFLite ke ONNX Runtime, kamu cuma ubah Data layer. Domain dan Presentation tidak tersentuh.

### 1.2 Struktur Folder yang Direkomendasikan

```
lib/
├── app/
│   ├── app.dart                          # MaterialApp, tema, GoRouter setup
│   ├── theme/
│   │   ├── app_theme.dart                # ThemeData Material 3
│   │   ├── app_colors.dart               # Color tokens
│   │   └── app_typography.dart           # TextStyle tokens
│   └── routes/
│       ├── app_router.dart               # GoRouter configuration
│       └── route_names.dart              # Konstanta nama route
│
├── core/
│   ├── constants/                        # App-wide constants
│   ├── errors/
│   │   ├── failures.dart                 # Failure sealed class
│   │   └── exceptions.dart               # Custom exceptions
│   ├── extensions/                       # Extension methods (DateTime, String, dll)
│   ├── utils/
│   │   ├── date_utils.dart
│   │   └── logger.dart
│   └── di/
│       └── injection.dart                # GetIt + Injectable setup
│
├── domain/
│   ├── entities/
│   │   ├── journal_entry.dart            # JournalEntry entity (freezed)
│   │   ├── symptom.dart                  # Symptom entity
│   │   ├── medication.dart               # Medication entity
│   │   ├── mood.dart                     # Mood entity
│   │   ├── sleep_record.dart             # SleepRecord entity
│   │   ├── lifestyle_factor.dart         # LifestyleFactor entity
│   │   ├── insight.dart                  # Insight entity (hasil analisis)
│   │   ├── health_score.dart             # HealthScore value object
│   │   └── correlation_result.dart       # CorrelationResult value object
│   │
│   ├── repositories/
│   │   ├── journal_repository.dart       # Abstract interface
│   │   ├── symptom_repository.dart
│   │   ├── insight_repository.dart
│   │   ├── ml_repository.dart            # Abstract ML inference interface
│   │   ├── health_connect_repository.dart
│   │   └── user_preferences_repository.dart
│   │
│   ├── usecases/
│   │   ├── journal/
│   │   │   ├── create_journal_entry.dart
│   │   │   ├── get_journal_entries.dart
│   │   │   ├── update_journal_entry.dart
│   │   │   ├── delete_journal_entry.dart
│   │   │   └── search_journal_entries.dart
│   │   ├── insight/
│   │   │   ├── generate_correlations.dart
│   │   │   ├── detect_anomalies.dart
│   │   │   ├── get_insights.dart
│   │   │   └── generate_health_score.dart
│   │   ├── ml/
│   │   │   ├── extract_symptoms_from_text.dart
│   │   │   └── predict_anomaly.dart
│   │   ├── health_connect/
│   │   │   ├── import_sleep_data.dart
│   │   │   ├── import_step_data.dart
│   │   │   └── export_symptom_data.dart
│   │   └── export/
│   │       ├── export_to_pdf.dart
│   │       └── export_to_csv.dart
│   │
│   └── services/
│       └── insight_engine.dart           # Domain Service — orchestrator untuk
│                                         # correlation analysis, pattern mining,
│                                         # anomaly detection. PURE DART.
│
├── data/
│   ├── models/                           # DTO / data models (json_serializable)
│   │   ├── journal_entry_model.dart
│   │   ├── symptom_model.dart
│   │   ├── medication_model.dart
│   │   └── ...
│   │
│   ├── datasources/
│   │   ├── local/
│   │   │   ├── isar_database.dart        # Isar instance setup + schema
│   │   │   ├── journal_local_datasource.dart
│   │   │   ├── symptom_local_datasource.dart
│   │   │   └── insight_cache_datasource.dart
│   │   ├── ml/
│   │   │   ├── tflite_engine.dart        # TFLite interpreter wrapper
│   │   │   ├── isolate_pool_manager.dart # Isolate pool untuk ML inference
│   │   │   ├── symptom_classifier.dart   # Model: NLP symptom extraction
│   │   │   ├── correlation_model.dart    # Model: correlation detection
│   │   │   └── anomaly_model.dart        # Model: anomaly detection
│   │   ├── sensor/
│   │   │   └── activity_sensor_datasource.dart
│   │   └── remote/
│   │       └── firebase_auth_datasource.dart
│   │
│   ├── repositories/                     # Implementasi dari domain interfaces
│   │   ├── journal_repository_impl.dart
│   │   ├── symptom_repository_impl.dart
│   │   ├── insight_repository_impl.dart
│   │   ├── ml_repository_impl.dart
│   │   ├── health_connect_repository_impl.dart
│   │   └── user_preferences_repository_impl.dart
│   │
│   └── mappers/                          # Entity ↔ Model converters
│       ├── journal_entry_mapper.dart
│       └── symptom_mapper.dart
│
├── presentation/
│   ├── providers/                        # Riverpod providers (global)
│   │   ├── journal_providers.dart
│   │   ├── insight_providers.dart
│   │   ├── ml_providers.dart
│   │   ├── auth_providers.dart
│   │   └── theme_providers.dart
│   │
│   ├── pages/
│   │   ├── home/
│   │   │   ├── home_page.dart
│   │   │   └── widgets/
│   │   │       ├── daily_summary_card.dart
│   │   │       ├── quick_log_buttons.dart
│   │   │       └── health_score_ring.dart
│   │   │
│   │   ├── journal/
│   │   │   ├── journal_list_page.dart
│   │   │   ├── journal_entry_page.dart   # Form untuk buat/edit entry
│   │   │   └── widgets/
│   │   │       ├── symptom_selector.dart
│   │   │       ├── mood_picker.dart
│   │   │       ├── sleep_input.dart
│   │   │       ├── medication_input.dart
│   │   │       └── free_text_input.dart
│   │   │
│   │   ├── insights/
│   │   │   ├── insights_page.dart
│   │   │   └── widgets/
│   │   │       ├── correlation_heatmap.dart    # CustomPainter
│   │   │       ├── symptom_timeline.dart       # CustomPainter
│   │   │       ├── insight_card.dart
│   │   │       └── trend_chart.dart
│   │   │
│   │   ├── settings/
│   │   │   ├── settings_page.dart
│   │   │   ├── reminder_settings_page.dart
│   │   │   ├── health_connect_settings_page.dart
│   │   │   ├── security_settings_page.dart
│   │   │   └── export_page.dart
│   │   │
│   │   └── onboarding/
│   │       ├── onboarding_page.dart
│   │       └── symptom_setup_page.dart   # User pilih gejala yg mau di-track
│   │
│   └── shared/                           # Reusable widgets
│       ├── app_bottom_nav.dart
│       ├── loading_indicator.dart
│       └── error_widget.dart
│
├── platform/                             # Platform channel code (Dart side)
│   ├── health_connect_channel.dart       # MethodChannel ke Android Health Connect
│   └── keystore_channel.dart             # MethodChannel ke Android Keystore
│
└── main.dart                             # Entry point

android/
├── app/src/main/kotlin/.../
│   ├── health_connect/
│   │   └── HealthConnectPlugin.kt        # Native Health Connect bridge
│   └── keystore/
│       └── KeystorePlugin.kt             # Native Android Keystore bridge

test/
├── domain/
│   ├── services/
│   │   └── insight_engine_test.dart      # Property-based tests
│   └── usecases/
│       └── ...
├── data/
│   ├── datasources/
│   │   └── ml/
│   │       └── tflite_engine_test.dart   # ML integration tests
│   └── repositories/
│       └── ...
├── presentation/
│   ├── pages/
│   │   └── ...
│   └── golden/                           # Golden test files
│       └── ...
└── fixtures/                             # Test data (JSON, mock health datasets)
    └── ...

ml/                                       # BUKAN bagian dari Flutter project
├── notebooks/                            # Jupyter notebooks untuk training
│   ├── symptom_correlation_training.ipynb
│   ├── anomaly_detection_training.ipynb
│   └── nlp_symptom_extraction_training.ipynb
├── data/                                 # Training data (anonymized)
├── models/                               # Exported TFLite models
│   ├── symptom_correlation_v1.tflite
│   ├── anomaly_detection_v1.tflite
│   └── nlp_symptom_v1.tflite
└── requirements.txt                      # Python dependencies
```

### 1.3 Konvensi Penamaan

| Jenis             | Konvensi                           | Contoh                                 |
| ----------------- | ---------------------------------- | -------------------------------------- |
| File              | `snake_case.dart`                  | `journal_entry.dart`                   |
| Class             | `PascalCase`                       | `JournalEntry`                         |
| Variable/function | `camelCase`                        | `getJournalEntries()`                  |
| Konstanta         | `camelCase` atau `SCREAMING_SNAKE` | `maxRetryCount` atau `MAX_RETRY_COUNT` |
| Provider          | `camelCase` + `Provider` suffix    | `journalEntriesProvider`               |
| Freezed entity    | `PascalCase` + `@freezed`          | `@freezed class Symptom`               |
| Isar Collection   | `PascalCase` + `Collection` suffix | `JournalEntryCollection`               |
| Test file         | `<nama_file>_test.dart`            | `insight_engine_test.dart`             |

### 1.4 Git Branch Strategy

```
main ← production-ready code
  └── develop ← integration branch (semua feature merge ke sini)
        ├── feature/foundation-setup
        ├── feature/journal-crud
        ├── feature/insight-engine
        ├── feature/tflite-integration
        ├── feature/health-connect
        ├── feature/custom-visualizations
        └── fix/some-bug-description
```

**Aturan:**

- Setiap feature = 1 branch dari `develop`
- Sebelum merge, pastikan semua test pass
- Commit message pakai format: `feat:`, `fix:`, `refactor:`, `test:`, `docs:`, `chore:`
- Contoh: `feat: implement correlation heatmap with CustomPainter`

---

## Phase 1: Foundation (Minggu 1–2)

> **Tujuan:** Setup project, arsitektur, database, enkripsi, DI, CI pipeline, dan core model.
> Setelah phase ini selesai, kamu punya "kerangka kosong" yang arsitekturnya sudah benar dan siap diisi fitur.

### Minggu 1: Project Setup & Arsitektur

#### Hari 1–2: Inisialisasi Project

**Yang dikerjakan:**

1. **Buat Flutter project baru**

   ```bash
   flutter create --org com.yourblooo --project-name medmind --platforms android medmind
   ```

2. **Setup dependencies di `pubspec.yaml`**

   Tambahkan semua package sesuai tech stack. Tapi JANGAN tambahkan sekaligus — tambahkan per-phase sesuai kebutuhan. Untuk Phase 1, yang dibutuhkan:

   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     # State management
     flutter_riverpod: ^2.5.x
     riverpod_annotation: ^2.3.x

     # Database
     isar: ^3.1.x
     isar_flutter_libs: ^3.1.x

     # Models
     freezed_annotation: ^2.4.x
     json_annotation: ^4.9.x

     # DI
     get_it: ^7.7.x
     injectable: ^2.4.x

     # Navigation
     go_router: ^14.x.x

     # Security
     flutter_secure_storage: ^9.2.x
     encrypt: ^5.0.x

     # Utils
     path_provider: ^2.1.x
     intl: ^0.19.x
     logger: ^2.4.x

   dev_dependencies:
     flutter_test:
       sdk: flutter
     very_good_analysis: ^6.0.x
     build_runner: ^2.4.x
     freezed: ^2.5.x
     json_serializable: ^6.8.x
     riverpod_generator: ^2.4.x
     isar_generator: ^3.1.x
     injectable_generator: ^2.6.x
     mockito: ^5.4.x
     build_verify: ^3.1.x
   ```

3. **Setup analysis_options.yaml**

   ```yaml
   include: package:very_good_analysis/analysis_options.yaml

   linter:
     rules:
       public_member_api_docs: false # Terlalu ketat untuk solo dev
   ```

4. **Buat seluruh folder structure** seperti di atas (kosong, tapi folder-nya sudah ada)

   Tip: buat file `.gitkeep` di folder kosong supaya Git track folder-nya.

5. **Init Git repo**

   ```bash
   git init
   git add .
   git commit -m "chore: initial project setup with clean architecture folder structure"
   ```

**Deliverable:** Project Flutter baru yang bisa `flutter run` tanpa error, folder structure Clean Architecture sudah ada.

#### Hari 2–3: Domain Entities (Freezed Models)

**Yang dikerjakan:**

Buat semua entity di `lib/domain/entities/`. Ini adalah "bahasa" dari aplikasi kamu — semua layer akan bicara pakai entity ini.

**Entity yang perlu dibuat:**

1. **`JournalEntry`** — satu entri jurnal harian

   ```
   Fields:
   - id: String (UUIDv4)
   - date: DateTime
   - mood: Mood? (enum: great, good, okay, bad, terrible)
   - moodIntensity: int? (1-10)
   - symptoms: List<SymptomLog>
   - medications: List<MedicationLog>
   - sleepRecord: SleepRecord?
   - lifestyleFactors: List<LifestyleFactorLog>
   - freeText: String? (catatan bebas)
   - extractedSymptoms: List<ExtractedSymptom>? (hasil NLP, nullable karena async)
   - activityLevel: ActivityLevel? (enum: sedentary, light, moderate, active)
   - createdAt: DateTime
   - updatedAt: DateTime
   ```

2. **`Symptom`** — definisi gejala (master data)

   ```
   Fields:
   - id: String
   - name: String
   - category: SymptomCategory (enum: neurological, digestive, respiratory, musculoskeletal, psychological, skin, general)
   - icon: String (emoji atau icon name)
   - isCustom: bool (user bisa buat gejala sendiri)
   ```

3. **`SymptomLog`** — log gejala dalam satu journal entry

   ```
   Fields:
   - symptomId: String
   - severity: int (1-10)
   - onset: TimeOfDay? (kapan mulai)
   - duration: Duration? (berapa lama)
   - notes: String?
   ```

4. **`Medication`** — definisi obat (master data)

   ```
   Fields:
   - id: String
   - name: String
   - dosage: String? (contoh: "500mg")
   - frequency: String? (contoh: "2x sehari")
   ```

5. **`MedicationLog`** — log minum obat

   ```
   Fields:
   - medicationId: String
   - taken: bool
   - time: TimeOfDay?
   - dosage: String?
   ```

6. **`SleepRecord`**

   ```
   Fields:
   - bedTime: DateTime
   - wakeTime: DateTime
   - quality: int (1-10)
   - disturbances: int? (berapa kali terbangun)
   - get duration => wakeTime.difference(bedTime)
   ```

7. **`LifestyleFactor`** — faktor gaya hidup (master data)

   ```
   Fields:
   - id: String
   - name: String (contoh: "Caffeine", "Alcohol", "Exercise", "Water Intake", "Screen Time")
   - type: FactorType (enum: boolean, numeric, scale)
   - unit: String? (contoh: "cups", "glasses", "minutes")
   ```

8. **`LifestyleFactorLog`**

   ```
   Fields:
   - factorId: String
   - boolValue: bool? (untuk tipe boolean: "Consumed caffeine?")
   - numericValue: double? (untuk tipe numeric: "3 cups")
   - scaleValue: int? (untuk tipe scale: 1-10)
   ```

9. **`Insight`** — hasil analisis dari Insight Engine

   ```
   Fields:
   - id: String
   - type: InsightType (enum: correlation, anomaly, trend, recommendation)
   - title: String (judul singkat, contoh: "Migraine & Sleep Connection")
   - description: String (penjelasan, contoh: "Kamu 2.8x lebih mungkin mengalami migraine setelah tidur < 6 jam")
   - confidence: double (0.0 - 1.0)
   - relatedVariables: List<String> (variable IDs yang terlibat)
   - generatedAt: DateTime
   - isRead: bool
   - isSaved: bool (user bisa bookmark insight)
   ```

10. **`CorrelationResult`** — hasil korelasi statistik mentah

    ```
    Fields:
    - variableA: String
    - variableB: String
    - correlationCoefficient: double (-1.0 to 1.0)
    - pValue: double
    - sampleSize: int
    - lag: int (0 = same day, 1 = next day, dst)
    - isSignificant: bool (p < 0.05 setelah Bonferroni correction)
    ```

11. **`HealthScore`** — skor kesehatan harian

    ```
    Fields:
    - date: DateTime
    - overallScore: double (0-100)
    - components: Map<String, double> (breakdown per kategori)
    - trend: ScoreTrend (enum: improving, stable, declining)
    ```

12. **`ExtractedSymptom`** — hasil NLP extraction dari free text

    ```
    Fields:
    - symptomName: String
    - severity: String? (mild, moderate, severe)
    - confidence: double (0.0 - 1.0)
    - sourceText: String (potongan teks yang di-extract)
    - isConfirmedByUser: bool?
    ```

**Cara buat tiap entity:**

Pakai `@freezed`:

```dart
// lib/domain/entities/journal_entry.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'journal_entry.freezed.dart';

@freezed
class JournalEntry with _$JournalEntry {
  const factory JournalEntry({
    required String id,
    required DateTime date,
    Mood? mood,
    int? moodIntensity,
    @Default([]) List<SymptomLog> symptoms,
    @Default([]) List<MedicationLog> medications,
    SleepRecord? sleepRecord,
    @Default([]) List<LifestyleFactorLog> lifestyleFactors,
    String? freeText,
    List<ExtractedSymptom>? extractedSymptoms,
    ActivityLevel? activityLevel,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _JournalEntry;
}
```

Setelah semua entity dibuat, jalankan:

```bash
dart run build_runner build --delete-conflicting-outputs
```

**Deliverable:** Semua domain entity ter-generate tanpa error. `dart analyze` bersih.

#### Hari 3–4: Repository Interfaces & Use Cases

**Yang dikerjakan:**

1. **Buat repository interfaces** di `lib/domain/repositories/`

   Setiap interface mendefinisikan kontrak data tanpa peduli implementasi:

   ```dart
   // lib/domain/repositories/journal_repository.dart
   abstract class JournalRepository {
     Future<Either<Failure, JournalEntry>> createEntry(JournalEntry entry);
     Future<Either<Failure, List<JournalEntry>>> getEntries({
       DateTime? startDate,
       DateTime? endDate,
       int? limit,
       int? offset,
     });
     Future<Either<Failure, JournalEntry>> getEntryById(String id);
     Future<Either<Failure, JournalEntry>> updateEntry(JournalEntry entry);
     Future<Either<Failure, void>> deleteEntry(String id);
     Future<Either<Failure, List<JournalEntry>>> searchEntries(String query);
     Stream<List<JournalEntry>> watchEntries({DateTime? startDate, DateTime? endDate});
   }
   ```

   **Catatan tentang `Either<Failure, T>`:**
   Kamu bisa pakai package `dartz` atau `fpdart` untuk tipe `Either`, ATAU buat sendiri yang sederhana:

   ```dart
   // lib/core/errors/failures.dart
   sealed class Failure {
     final String message;
     const Failure(this.message);
   }

   class DatabaseFailure extends Failure {
     const DatabaseFailure(super.message);
   }

   class MLFailure extends Failure {
     const MLFailure(super.message);
   }

   class EncryptionFailure extends Failure {
     const EncryptionFailure(super.message);
   }
   ```

   Kalau mau simpel tanpa `Either`, bisa pakai:
   - Return `T` langsung, throw custom exception untuk error → tangkap di use case / provider
   - Atau buat `Result<T>` sealed class sendiri:

   ```dart
   sealed class Result<T> {
     const Result();
   }
   class Success<T> extends Result<T> {
     final T data;
     const Success(this.data);
   }
   class Error<T> extends Result<T> {
     final Failure failure;
     const Error(this.failure);
   }
   ```

   **Pilih salah satu pendekatan dan KONSISTEN di seluruh project.**

2. **Buat use cases** di `lib/domain/usecases/`

   Setiap use case = 1 aksi bisnis. Pattern yang dipakai:

   ```dart
   // lib/domain/usecases/journal/create_journal_entry.dart
   class CreateJournalEntry {
     final JournalRepository _repository;

     CreateJournalEntry(this._repository);

     Future<Result<JournalEntry>> call(JournalEntry entry) {
       // Validasi bisnis bisa ditaruh di sini
       // contoh: pastikan date tidak di masa depan
       return _repository.createEntry(entry);
     }
   }
   ```

   **Use cases yang perlu dibuat di Phase 1 (CRUD saja):**
   - `CreateJournalEntry`
   - `GetJournalEntries` (dengan filter tanggal)
   - `GetJournalEntryById`
   - `UpdateJournalEntry`
   - `DeleteJournalEntry`
   - `SearchJournalEntries`

**Deliverable:** Semua repository interface dan CRUD use cases terdefinisi. Masih belum ada implementasi (itu di step selanjutnya).

#### Hari 4–5: Isar Database Setup + Enkripsi

**Yang dikerjakan:**

1. **Buat Isar schema / collection models** di `lib/data/models/`

   Isar butuh `@Collection` annotation dan `Id` field. Ini BERBEDA dari domain entity — ini adalah "representasi database":

   ```dart
   // lib/data/models/journal_entry_model.dart
   import 'package:isar/isar.dart';

   part 'journal_entry_model.g.dart';

   @Collection()
   class JournalEntryModel {
     Id id = Isar.autoIncrement;

     @Index(unique: true)
     late String uid;  // UUID dari domain entity

     @Index()
     late DateTime date;

     @Enumerated(EnumType.name)
     MoodModel? mood;

     int? moodIntensity;

     late List<SymptomLogEmbed> symptoms;
     late List<MedicationLogEmbed> medications;
     SleepRecordEmbed? sleepRecord;
     late List<LifestyleFactorLogEmbed> lifestyleFactors;

     String? freeText;
     List<ExtractedSymptomEmbed>? extractedSymptoms;

     @Enumerated(EnumType.name)
     ActivityLevelModel? activityLevel;

     late DateTime createdAt;
     late DateTime updatedAt;
   }

   @Embedded()
   class SymptomLogEmbed {
     late String symptomId;
     late int severity;
     // ... dll
   }
   ```

   **Penting:** Buat mapper untuk konversi antara `JournalEntryModel` (data layer) ↔ `JournalEntry` (domain entity).

   ```dart
   // lib/data/mappers/journal_entry_mapper.dart
   class JournalEntryMapper {
     static JournalEntry toDomain(JournalEntryModel model) {
       return JournalEntry(
         id: model.uid,
         date: model.date,
         mood: _mapMood(model.mood),
         // ... map semua field
       );
     }

     static JournalEntryModel toModel(JournalEntry entity) {
       return JournalEntryModel()
         ..uid = entity.id
         ..date = entity.date
         ..mood = _mapMoodModel(entity.mood)
         // ... map semua field
         ;
     }
   }
   ```

2. **Setup Isar instance dengan enkripsi**

   ```dart
   // lib/data/datasources/local/isar_database.dart
   class IsarDatabase {
     static Future<Isar> initialize(String encryptionKey) async {
       final dir = await getApplicationDocumentsDirectory();
       return Isar.open(
         [JournalEntryModelSchema, SymptomModelSchema, /* ... */],
         directory: dir.path,
         encryptionKey: encryptionKey,  // AES-256
       );
     }
   }
   ```

3. **Setup enkripsi key management**

   ```dart
   // lib/data/datasources/local/encryption_key_manager.dart
   class EncryptionKeyManager {
     final FlutterSecureStorage _secureStorage;
     static const _keyName = 'isar_encryption_key';

     EncryptionKeyManager(this._secureStorage);

     Future<String> getOrCreateKey() async {
       var key = await _secureStorage.read(key: _keyName);
       if (key == null) {
         // Generate random 32-byte key, encode as base64
         final random = Random.secure();
         final bytes = List<int>.generate(32, (_) => random.nextInt(256));
         key = base64Encode(bytes);
         await _secureStorage.write(key: _keyName, value: key);
       }
       return key;
     }

     Future<void> destroyKey() async {
       await _secureStorage.delete(key: _keyName);
     }
   }
   ```

   **Catatan keamanan:**
   - `FlutterSecureStorage` di Android menyimpan data di `EncryptedSharedPreferences` yang di-backup oleh Android Keystore
   - Kalau device punya hardware security module (HSM), key akan dilindungi hardware
   - Method `destroyKey()` dipanggil saat user delete account — ini membuat semua data Isar tidak bisa didekripsi lagi (cryptographic erasure)

4. **Jalankan build_runner** untuk generate Isar schema:

   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

5. **Buat unit test** untuk:
   - Mapper: `JournalEntry` → `JournalEntryModel` → `JournalEntry` (round-trip test)
   - Encryption key manager: generate → read → destroy → read returns null

**Deliverable:** Isar database bisa di-initialize dengan enkripsi. Mapper bekerja dengan benar (dibuktikan oleh test).

#### Hari 5: Dependency Injection Setup

**Yang dikerjakan:**

Setup GetIt + Injectable. Ini memungkinkan swap implementasi untuk testing.

```dart
// lib/core/di/injection.dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();
```

Annotate semua class yang perlu di-inject:

```dart
// lib/data/repositories/journal_repository_impl.dart
@LazySingleton(as: JournalRepository)  // <-- bind ke interface
class JournalRepositoryImpl implements JournalRepository {
  final JournalLocalDataSource _localDataSource;

  JournalRepositoryImpl(this._localDataSource);

  // ... implementasi
}
```

**Setup Riverpod bridge:**

```dart
// lib/presentation/providers/journal_providers.dart
final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  return getIt<JournalRepository>();
});

final journalEntriesProvider = FutureProvider.family<List<JournalEntry>, DateRange?>((ref, dateRange) async {
  final repo = ref.watch(journalRepositoryProvider);
  final result = await repo.getEntries(
    startDate: dateRange?.start,
    endDate: dateRange?.end,
  );
  return result.when(
    success: (entries) => entries,
    error: (failure) => throw failure,
  );
});
```

**Deliverable:** DI container terkonfigurasi. Riverpod provider bisa resolve use case dari GetIt.

### Minggu 2: Repository Implementation, CI/CD, Navigasi

#### Hari 6–7: Repository Implementation

**Yang dikerjakan:**

Implementasi `JournalLocalDataSource` dan `JournalRepositoryImpl`.

```dart
// lib/data/datasources/local/journal_local_datasource.dart
class JournalLocalDataSource {
  final Isar _isar;

  JournalLocalDataSource(this._isar);

  Future<JournalEntryModel> create(JournalEntryModel model) async {
    await _isar.writeTxn(() async {
      await _isar.journalEntryModels.put(model);
    });
    return model;
  }

  Future<List<JournalEntryModel>> query({
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  }) async {
    var query = _isar.journalEntryModels.where();

    if (startDate != null && endDate != null) {
      query = query.dateBetween(startDate, endDate);
    }

    return query
        .sortByDateDesc()
        .offset(offset ?? 0)
        .limit(limit ?? 50)
        .findAll();
  }

  Stream<List<JournalEntryModel>> watch({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    // Isar reactive query
    return _isar.journalEntryModels
        .where()
        .sortByDateDesc()
        .watch(fireImmediately: true);
  }

  // ... CRUD operations lainnya
}
```

**Buat integration test** yang menguji full CRUD cycle:

1. Create entry → verify tersimpan
2. Read entry → verify field sesuai
3. Update entry → verify perubahan
4. Delete entry → verify hilang
5. Search → verify hasil pencarian
6. Watch stream → verify reactive updates

**Deliverable:** CRUD journal entry bekerja end-to-end dengan database lokal. Dibuktikan dengan integration test.

#### Hari 7–8: Navigasi (GoRouter) & Shell UI

**Yang dikerjakan:**

1. **Setup GoRouter** dengan bottom navigation shell:

   ```dart
   // lib/app/routes/app_router.dart
   final routerProvider = Provider<GoRouter>((ref) {
     return GoRouter(
       initialLocation: '/home',
       routes: [
         StatefulShellRoute.indexedStack(
           builder: (context, state, child) => MainShell(child: child),
           branches: [
             StatefulShellBranch(routes: [
               GoRoute(path: '/home', builder: (_, __) => const HomePage()),
             ]),
             StatefulShellBranch(routes: [
               GoRoute(path: '/journal', builder: (_, __) => const JournalListPage()),
               GoRoute(path: '/journal/new', builder: (_, __) => const JournalEntryPage()),
               GoRoute(path: '/journal/:id', builder: (_, state) => JournalEntryPage(
                 entryId: state.pathParameters['id'],
               )),
             ]),
             StatefulShellBranch(routes: [
               GoRoute(path: '/insights', builder: (_, __) => const InsightsPage()),
             ]),
             StatefulShellBranch(routes: [
               GoRoute(path: '/settings', builder: (_, __) => const SettingsPage()),
             ]),
           ],
         ),
       ],
     );
   });
   ```

2. **Buat shell UI** — bottom navigation dengan 4 tab:
   - Home (daily summary)
   - Journal (list + entry)
   - Insights (correlation & trends)
   - Settings

3. **Buat placeholder pages** untuk setiap tab — cukup `Scaffold` dengan `AppBar` dan teks "Coming soon".

4. **Setup tema Material 3:**

   ```dart
   // lib/app/theme/app_theme.dart
   class AppTheme {
     static ThemeData light() {
       final colorScheme = ColorScheme.fromSeed(
         seedColor: const Color(0xFF6750A4),  // Ungu menenangkan, cocok untuk health app
         brightness: Brightness.light,
       );
       return ThemeData(
         useMaterial3: true,
         colorScheme: colorScheme,
         // ... customize component themes
       );
     }

     static ThemeData dark() {
       // ... dark theme
     }
   }
   ```

**Deliverable:** Aplikasi bisa dijalankan, navigasi 4 tab bekerja, tema Material 3 terpasang.

#### Hari 8–9: CI/CD Pipeline (GitHub Actions)

**Yang dikerjakan:**

Buat `.github/workflows/ci.yml`:

```yaml
name: CI

on:
  push:
    branches: [develop, main]
  pull_request:
    branches: [develop, main]

jobs:
  analyze-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: "3.27.x" # Pin versi Flutter
          channel: "stable"
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Generate code
        run: dart run build_runner build --delete-conflicting-outputs

      - name: Analyze
        run: flutter analyze --fatal-infos

      - name: Run tests
        run: flutter test --coverage

      - name: Check coverage
        run: |
          # Install lcov
          sudo apt-get install -y lcov
          # Generate coverage report
          genhtml coverage/lcov.info -o coverage/html
          # Check minimum coverage (Phase 1: 60%, akan dinaikkan bertahap)
          COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep "lines" | awk '{print $2}' | tr -d '%')
          echo "Coverage: $COVERAGE%"
          # Uncomment saat sudah siap enforce:
          # if (( $(echo "$COVERAGE < 60" | bc -l) )); then exit 1; fi

  build-android:
    runs-on: ubuntu-latest
    needs: analyze-and-test
    if: github.ref == 'refs/heads/develop' || github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: "3.27.x"
          channel: "stable"
          cache: true

      - uses: actions/setup-java@v4
        with:
          distribution: "temurin"
          java-version: "17"

      - name: Generate code
        run: dart run build_runner build --delete-conflicting-outputs

      - name: Build APK
        run: flutter build apk --release

      - name: Upload APK
        uses: actions/upload-artifact@v4
        with:
          name: medmind-apk
          path: build/app/outputs/flutter-apk/app-release.apk
```

**Deliverable:** Setiap push ke `develop` atau `main` otomatis di-analyze, di-test, dan di-build.

#### Hari 9–10: Onboarding Flow + Biometric Lock

**Yang dikerjakan:**

1. **Onboarding flow** (3-4 screen):
   - Screen 1: Welcome + value proposition ("Journal kesehatanmu, insight otomatis, privasi terjaga")
   - Screen 2: Pilih gejala yang mau di-track (checklist dari master data symptoms)
   - Screen 3: Pilih lifestyle factors yang mau di-track
   - Screen 4: Setup keamanan (biometric lock on/off)

   Data onboarding disimpan di `UserPreferences` (pakai SharedPreferences atau Isar).

2. **Biometric lock** (opsional, bisa di-skip dan diaktifkan nanti di Settings):

   Pakai `local_auth` package (tambahkan di pubspec). Flow:
   - App launch → cek apakah biometric enabled
   - Kalau enabled → tampilkan biometric prompt sebelum masuk app
   - Kalau gagal 3x → tampilkan PIN fallback (simpel 4-digit)

   **Catatan:** Belum ditambahkan ke pubspec di Phase 1 dependencies di atas. Tambahkan:

   ```yaml
   local_auth: ^2.3.x
   shared_preferences: ^2.3.x
   ```

3. **First launch detection:**

   ```dart
   final isFirstLaunchProvider = FutureProvider<bool>((ref) async {
     final prefs = await SharedPreferences.getInstance();
     return prefs.getBool('onboarding_completed') != true;
   });
   ```

**Deliverable:** User baru disambut onboarding. Biometric lock bisa diaktifkan.

---

### Checklist Akhir Phase 1

- [ ] Project Flutter bisa `flutter run` tanpa error
- [ ] Folder structure Clean Architecture lengkap
- [ ] Semua domain entity (12 entity) ter-generate dengan Freezed
- [ ] Repository interfaces terdefinisi
- [ ] CRUD use cases terdefinisi
- [ ] Isar database setup dengan enkripsi AES-256
- [ ] Encryption key management via Android Keystore
- [ ] DI container (GetIt + Injectable) terkonfigurasi
- [ ] Riverpod providers bridge ke use cases
- [ ] GoRouter setup dengan 4 tab navigation
- [ ] Material 3 tema (light + dark)
- [ ] Repository implementation + integration tests
- [ ] Onboarding flow (3-4 screen)
- [ ] Biometric lock (opsional)
- [ ] CI/CD pipeline (GitHub Actions)
- [ ] Minimum 5 unit tests + 2 integration tests passing
- [ ] `flutter analyze` 0 warnings
- [ ] Git: branch `feature/foundation-setup` merged ke `develop`

---

## Phase 2: Smart Journaling (Minggu 3–4)

> **Tujuan:** Bangun fitur journaling inti — form entry yang lengkap, intuitif, dan cepat. Plus reminder system dan Health Connect bridge.
> Setelah phase ini, user bisa log data kesehatan harian dengan lancar.

### Minggu 3: Journal Entry Form

#### Hari 11–12: Symptom Selector & Mood Picker

**Yang dikerjakan:**

1. **Mood Picker widget**
   - 5 mood levels dengan emoji/ikon: 😊 🙂 😐 😟 😰
   - Tap untuk pilih → slider muncul untuk intensity (1-10)
   - Animasi transisi antar mood (pakai `flutter_animate`)
   - State dikelola oleh Riverpod `StateProvider` lokal di form

2. **Symptom Selector widget**
   - Grid/chip display dari gejala yang dipilih user saat onboarding
   - Tap chip → expand mini-form: severity slider (1-10) + optional notes
   - Tombol "+" untuk tambah gejala baru (custom symptom)
   - Search/filter kalau daftar panjang
   - Multi-select: bisa log beberapa gejala sekaligus

   **UX Consideration:** User yang sedang sakit tidak mau mengisi form yang ribet. Buat semua input bisa diselesaikan dengan 2-3 tap. Severity default = 5, auto-suggest based on history.

3. **Buat `JournalFormState`** — Riverpod `StateNotifier` yang mengelola semua field form secara terpusat:

   ```dart
   @riverpod
   class JournalFormNotifier extends _$JournalFormNotifier {
     @override
     JournalFormState build({String? entryId}) {
       // Kalau entryId != null, load existing entry (edit mode)
       // Kalau null, return empty form state
       return JournalFormState.empty(date: DateTime.now());
     }

     void updateMood(Mood mood, int intensity) { ... }
     void addSymptom(SymptomLog log) { ... }
     void removeSymptom(String symptomId) { ... }
     void updateSleep(SleepRecord record) { ... }
     // ... semua form mutation methods

     Future<Result<JournalEntry>> submit() async {
       // Validasi → buat entity → panggil use case → return result
     }
   }
   ```

**Deliverable:** Mood picker dan symptom selector bekerja dan terintegrasi ke form state.

#### Hari 12–13: Sleep, Medication, & Lifestyle Inputs

**Yang dikerjakan:**

1. **Sleep Input widget**
   - Bedtime picker (jam:menit) + wake time picker
   - Sleep quality slider (1-10)
   - Disturbance counter (+/- stepper)
   - Auto-calculate duration dan tampilkan "7h 30m"
   - Swipeable card UX — swipe up untuk expand detail

2. **Medication Logger widget**
   - Daftar obat dari user setup (profil obat)
   - Quick toggle: taken ✅ / not taken ❌
   - Tap untuk detail: waktu minum, dosis alternatif
   - Reminder badge: "Kamu belum log obat hari ini"

3. **Lifestyle Factor Logger widget**
   - Render dinamis berdasarkan factor type:
     - **Boolean**: simple toggle ("Consumed caffeine? Yes/No")
     - **Numeric**: number input + unit ("Water: \_\_\_ glasses")
     - **Scale**: slider 1-10 ("Stress level")
   - Grouped by category (food, activity, mood triggers)

4. **Free Text Input**
   - Multi-line text field untuk catatan bebas
   - Placeholder: "How are you feeling today? Any triggers you noticed?"
   - Word count indicator
   - Nanti di Phase 4, text ini akan diproses NLP

**Deliverable:** Form entry lengkap. User bisa log semua aspek kesehatan.

#### Hari 13–14: Journal Entry Page Assembly & Save Flow

**Yang dikerjakan:**

1. **Assemble `JournalEntryPage`**
   - Tab atau accordion layout:
     - Tab 1: Mood + Symptoms (paling penting, default tab)
     - Tab 2: Sleep + Medications
     - Tab 3: Lifestyle + Notes
   - **Auto-save draft**: setiap 30 detik, simpan draft ke Isar (status: draft)
   - **Submit tombol**: validasi → save ke Isar (status: completed) → navigate kembali ke list
   - **Unsaved changes guard**: kalau user back tanpa save, tampilkan dialog "Simpan sebagai draft?"

2. **Journal List Page**
   - List journal entries diurutkan tanggal terbaru
   - Card UI: tanggal, mood emoji, severity badges, snippet dari free text
   - Infinite scroll / lazy loading (dari Riverpod `AsyncNotifier` dengan pagination)
   - Swipe to delete dengan undo snackbar
   - Tap card → navigate ke detail/edit

3. **Home Page - Daily Summary**
   - Kalau hari ini sudah ada entry: tampilkan summary card
   - Kalau belum: tampilkan CTA "Log hari ini" dengan quick-log buttons (mood-only quick log)
   - Streak counter: "Kamu sudah journaling 7 hari berturut-turut! 🔥"

**Deliverable:** Full journaling flow bekerja: create → view → edit → delete. Draft auto-save.

### Minggu 4: Adaptive Reminders & Health Connect

#### Hari 15–16: Adaptive Reminder System

**Yang dikerjakan:**

1. **Basic reminder** dulu (MVP):
   - User set waktu reminder di Settings (default: 21:00)
   - Pakai `flutter_local_notifications` untuk schedule daily reminder
   - Notification text: "Sudah waktunya journaling! Bagaimana harimu?"
   - Tap notification → deep link ke `JournalEntryPage` (buat entry baru)

2. **Adaptive behavior tracking:**

   Buat `ReminderAnalytics` class yang track:

   ```dart
   class ReminderAnalytics {
     // Log setiap kali user buka journal entry page
     Future<void> logJournalOpened({
       required DateTime timestamp,
       required bool fromNotification,  // dari notif atau buka manual?
     }) async { ... }

     // Hitung compliance rate per jam
     // Contoh: jam 21:00 → 80% open rate, jam 08:00 → 20% open rate
     Future<Map<int, double>> getHourlyComplianceRates({
       required Duration window,  // 2 minggu terakhir
     }) async { ... }

     // Rekomendasikan waktu optimal
     Future<TimeOfDay> getOptimalReminderTime() async { ... }
   }
   ```

3. **Dynamic rescheduling** (setelah 2 minggu data terkumpul):
   - Setiap minggu, hitung compliance rate per jam
   - Kalau compliance di jam sekarang < 40%, suggest waktu baru ke user
   - "Sepertinya kamu lebih konsisten journaling jam 22:00. Mau pindah reminder ke jam segitu?"

4. **Contextual prompt** (setelah 1 minggu data):
   - Cek apa yang belum di-log hari ini
   - Notification body disesuaikan: "Kamu belum log obat hari ini — sudah diminum?"

**Package tambahan untuk Phase 2:**

```yaml
flutter_local_notifications: ^17.x.x
awesome_notifications: ^0.9.x # Untuk notification scheduling yang lebih advanced
workmanager: ^0.5.x # Untuk background scheduling
```

**Deliverable:** Reminder system bekerja dengan scheduling persisten. Foundation untuk adaptive behavior tracking sudah ada.

#### Hari 16–18: Health Connect Integration (Platform Channel)

**Ini bagian yang teknis berat.** Health Connect adalah API Android native — tidak ada package Flutter yang mature dan stabil. Jadi kita buat sendiri via platform channel.

**Yang dikerjakan:**

1. **Setup Android manifest permissions:**

   ```xml
   <!-- android/app/src/main/AndroidManifest.xml -->
   <uses-permission android:name="android.permission.health.READ_SLEEP" />
   <uses-permission android:name="android.permission.health.READ_STEPS" />
   <uses-permission android:name="android.permission.health.READ_HEART_RATE" />
   <uses-permission android:name="android.permission.health.WRITE_HEALTH_CONNECT" />
   ```

2. **Buat Kotlin plugin** di `android/app/src/main/kotlin/.../health_connect/`:

   ```kotlin
   // HealthConnectPlugin.kt
   class HealthConnectPlugin(private val activity: Activity) : MethodCallHandler {
       private val healthConnectClient by lazy {
           HealthConnectClient.getOrCreate(activity)
       }

       override fun onMethodCall(call: MethodCall, result: Result) {
           when (call.method) {
               "isAvailable" -> checkAvailability(result)
               "requestPermissions" -> requestPermissions(result)
               "readSleepSessions" -> readSleepData(call, result)
               "readSteps" -> readStepData(call, result)
               "readHeartRate" -> readHeartRateData(call, result)
               else -> result.notImplemented()
           }
       }

       private fun readSleepData(call: MethodCall, result: Result) {
           val startTime = Instant.parse(call.argument<String>("startTime")!!)
           val endTime = Instant.parse(call.argument<String>("endTime")!!)

           scope.launch {
               try {
                   val response = healthConnectClient.readRecords(
                       ReadRecordsRequest(
                           recordType = SleepSessionRecord::class,
                           timeRangeFilter = TimeRangeFilter.between(startTime, endTime)
                       )
                   )
                   val sleepData = response.records.map { record ->
                       mapOf(
                           "startTime" to record.startTime.toString(),
                           "endTime" to record.endTime.toString(),
                           "stages" to record.stages.map { stage ->
                               mapOf("type" to stage.stage, "start" to stage.startTime.toString(), "end" to stage.endTime.toString())
                           }
                       )
                   }
                   result.success(sleepData)
               } catch (e: Exception) {
                   result.error("HEALTH_CONNECT_ERROR", e.message, null)
               }
           }
       }
   }
   ```

3. **Buat Dart side platform channel:**

   ```dart
   // lib/platform/health_connect_channel.dart
   class HealthConnectChannel {
     static const _channel = MethodChannel('com.yourblooo.medmind/health_connect');

     Future<bool> isAvailable() async {
       return await _channel.invokeMethod<bool>('isAvailable') ?? false;
     }

     Future<bool> requestPermissions() async {
       return await _channel.invokeMethod<bool>('requestPermissions') ?? false;
     }

     Future<List<SleepSession>> readSleepSessions({
       required DateTime startTime,
       required DateTime endTime,
     }) async {
       final result = await _channel.invokeMethod<List>('readSleepSessions', {
         'startTime': startTime.toIso8601String(),
         'endTime': endTime.toIso8601String(),
       });
       return (result ?? []).map((e) => SleepSession.fromMap(e as Map)).toList();
     }

     // ... readSteps, readHeartRate
   }
   ```

4. **Buat `HealthConnectRepository`** yang wrap channel dengan error handling:
   - Cek availability → kalau tidak ada, return gracefully
   - Request permissions → handle denial
   - Auto-import saat user buka journal entry baru: pre-fill sleep data dari Health Connect jika tersedia
   - User bisa override imported data (Health Connect data sebagai suggestion, bukan final)

5. **Settings page untuk Health Connect:**
   - Toggle on/off
   - Tampilkan status koneksi
   - List data types yang di-sync
   - "Last synced: 5 menit yang lalu"

**Deliverable:** Health Connect data (sleep, steps) bisa di-import ke journal entry. Graceful degradation kalau Health Connect tidak tersedia.

#### Hari 18–20: Testing & Polish Phase 2

**Yang dikerjakan:**

1. **Widget tests** untuk semua input widgets:
   - Mood picker: tap → verify state change
   - Symptom selector: add/remove → verify list
   - Sleep input: set times → verify duration calculation
   - Form submit → verify use case dipanggil dengan data benar

2. **Integration test: full journal flow**
   - Launch app → navigate ke journal → create entry → fill all fields → save → verify di list → tap → verify detail → edit → save → verify update → delete → verify gone

3. **UX polish:**
   - Animasi transisi antar tab dalam form (pakai `flutter_animate`)
   - Haptic feedback saat save berhasil
   - Loading states dan error states yang informatif
   - Empty state di journal list: "Belum ada entri. Mulai journaling hari ini!"

---

### Checklist Akhir Phase 2

- [ ] Mood picker dengan intensity slider
- [ ] Symptom selector dengan severity + multi-select
- [ ] Sleep input (bedtime, wake time, quality, disturbances)
- [ ] Medication logger (quick toggle + detail)
- [ ] Lifestyle factor logger (boolean/numeric/scale)
- [ ] Free text input
- [ ] Auto-save draft (30 detik interval)
- [ ] Journal list dengan lazy loading + search
- [ ] Home page daily summary + streak counter
- [ ] Basic reminder notification system
- [ ] Adaptive reminder analytics foundation
- [ ] Health Connect platform channel (Kotlin + Dart)
- [ ] Health Connect settings page
- [ ] Widget tests untuk semua input components
- [ ] Integration test: full journal CRUD flow
- [ ] Git: branch `feature/journal-crud` + `feature/health-connect` merged ke `develop`

---

## Phase 3: Statistical Engine (Minggu 5–6)

> **Tujuan:** Bangun Insight Engine — pure Dart statistical analysis engine yang mengolah data journal menjadi insights yang bisa dipahami manusia.
> Ini adalah "otak" MedMind dan bagian yang paling menunjukkan senior-level thinking.

### Minggu 5: Correlation Engine

#### Hari 21–23: Data Preparation Pipeline

**Yang dikerjakan:**

Sebelum bisa hitung korelasi, kita perlu transformasi data journal entries menjadi time-series tabular. Ini adalah ETL (Extract-Transform-Load) pipeline mini.

1. **Buat `DataPreparationService`** (domain layer):

   ```dart
   // lib/domain/services/data_preparation_service.dart
   class DataPreparationService {
     /// Transformasi journal entries menjadi time-series matrix
     /// Setiap row = 1 hari, setiap kolom = 1 variabel
     ///
     /// Contoh output:
     /// date     | sleep_hours | sleep_quality | caffeine | migraine_severity | mood | ...
     /// 2026-01-15 | 6.5        | 7             | true     | 8                 | 3    | ...
     /// 2026-01-16 | 8.0        | 9             | false    | 0                 | 7    | ...
     TimeSeriesMatrix prepareMatrix(List<JournalEntry> entries) {
       // 1. Sort by date
       // 2. Fill missing dates with null rows (explicit gaps)
       // 3. Extract each variable into a column
       // 4. Normalize: boolean → 0/1, severity → 0-10, etc.
       // 5. Return structured matrix
     }

     /// Identifikasi pasangan variabel yang layak dikorelasikan
     /// (skip kalau salah satu variabel terlalu sedikit data points)
     List<VariablePair> identifyCorrelationCandidates(
       TimeSeriesMatrix matrix, {
       int minimumDataPoints = 14,  // minimal 2 minggu data
     }) { ... }
   }
   ```

2. **Buat `TimeSeriesMatrix`** (value object):

   ```dart
   class TimeSeriesMatrix {
     final List<DateTime> dates;
     final Map<String, List<double?>> columns;  // variable_name → values (nullable untuk missing)
     final Map<String, VariableType> variableTypes;

     int get rowCount => dates.length;
     int get columnCount => columns.length;

     List<double?> getColumn(String name) => columns[name] ?? [];
     List<double?> getLaggedColumn(String name, int lag) {
       // Shift column by `lag` days
       // Digunakan untuk cek: "Apakah tidur hari Senin mempengaruhi migraine hari Selasa?"
     }
   }
   ```

3. **Variable extraction logic** — cara extract setiap jenis data:

   | Sumber Data         | Variabel                  | Tipe              | Normalisasi                          |
   | ------------------- | ------------------------- | ----------------- | ------------------------------------ |
   | Mood                | `mood_score`              | Continuous (1-5)  | Map enum ke angka                    |
   | Mood                | `mood_intensity`          | Continuous (1-10) | Langsung                             |
   | Symptom             | `symptom_{name}_severity` | Continuous (0-10) | 0 kalau gejala tidak di-log hari itu |
   | Symptom             | `symptom_{name}_present`  | Binary (0/1)      | 1 kalau severity > 0                 |
   | Sleep               | `sleep_hours`             | Continuous        | Hitung dari bedtime/waketime         |
   | Sleep               | `sleep_quality`           | Continuous (1-10) | Langsung                             |
   | Sleep               | `sleep_disturbances`      | Count             | Langsung                             |
   | Medication          | `med_{name}_taken`        | Binary (0/1)      | Langsung                             |
   | Lifestyle (boolean) | `factor_{name}`           | Binary (0/1)      | Langsung                             |
   | Lifestyle (numeric) | `factor_{name}`           | Continuous        | Langsung                             |
   | Lifestyle (scale)   | `factor_{name}`           | Continuous (1-10) | Langsung                             |
   | Health Connect      | `steps`                   | Continuous        | Langsung                             |
   | Health Connect      | `heart_rate_avg`          | Continuous        | Daily average                        |

**Deliverable:** Data preparation pipeline yang bisa transformasi raw journal data ke structured matrix. Unit-tested dengan fixture data.

#### Hari 23–25: Correlation Calculation Engine

**Yang dikerjakan:**

Implementasi statistik korelasi di pure Dart. INI HARUS 100% UNIT TESTED karena kesalahan statistik bisa menghasilkan insight yang menyesatkan.

1. **Buat `CorrelationEngine`** (domain service):

   ```dart
   // lib/domain/services/correlation_engine.dart
   class CorrelationEngine {

     /// Pearson correlation coefficient
     /// Digunakan untuk pasangan variabel continuous × continuous
     /// Return: -1.0 (inverse) to 1.0 (perfect positive)
     CorrelationResult pearsonCorrelation(
       List<double> x,
       List<double> y,
     ) {
       // Implementasi:
       // 1. Hitung mean x dan y
       // 2. Hitung covariance
       // 3. Hitung standard deviation x dan y
       // 4. r = covariance / (sd_x * sd_y)
       // 5. Hitung p-value dari t-distribution:
       //    t = r * sqrt((n-2) / (1-r²))
       //    df = n - 2
       //    p = 2 * (1 - CDF_t(|t|, df))
     }

     /// Spearman rank correlation
     /// Digunakan untuk data ordinal atau non-linear relationships
     CorrelationResult spearmanCorrelation(
       List<double> x,
       List<double> y,
     ) {
       // 1. Assign ranks ke kedua variabel
       // 2. Jalankan Pearson pada ranks
     }

     /// Point-biserial correlation
     /// Digunakan untuk binary × continuous (contoh: caffeine consumed × migraine severity)
     CorrelationResult pointBiserialCorrelation(
       List<double> binary,  // hanya 0 dan 1
       List<double> continuous,
     ) { ... }

     /// Chi-square test of independence
     /// Digunakan untuk binary × binary (contoh: caffeine consumed × migraine present)
     ChiSquareResult chiSquareTest(
       List<double> x,  // binary
       List<double> y,  // binary
     ) {
       // 1. Buat contingency table 2x2
       // 2. Hitung expected frequencies
       // 3. χ² = Σ (observed - expected)² / expected
       // 4. p-value dari chi-square distribution (df=1)
     }

     /// Risk ratio (relative risk)
     /// "Kamu 2.8x lebih mungkin mengalami migraine saat tidur < 6 jam"
     RiskRatioResult calculateRiskRatio(
       List<double> exposure,  // binary: tidur < 6 jam? (1/0)
       List<double> outcome,   // binary: migraine? (1/0)
     ) {
       // RR = P(outcome | exposed) / P(outcome | not exposed)
       // Example:
       //   8 dari 10 hari kurang tidur → migraine  (P = 0.8)
       //   2 dari 20 hari cukup tidur → migraine  (P = 0.1)
       //   RR = 0.8 / 0.1 = 8.0
     }

     /// Bonferroni correction
     /// Kalau kita test 20 pasangan variabel, risk false positive naik
     /// Bonferroni: threshold = 0.05 / jumlah_tests
     double bonferroniThreshold(int numberOfTests) {
       return 0.05 / numberOfTests;
     }
   }
   ```

2. **P-value calculation tanpa library statistik:**

   Ini agak tricky karena butuh t-distribution CDF. Opsi:
   - **Opsi A (Rekomendasi):** Implementasi approx t-distribution CDF pakai algoritma dari Applied Statistics (journals). Cari algoritma AS 63 atau gunakan normal approximation untuk df > 30.
   - **Opsi B:** Precompute lookup table untuk common df values dan interpolasi.
   - **Opsi C:** Bundled pre-calculated critical values table. Kurang presisi tapi cukup untuk aplikasi health journal.

   **Yang paling pragmatis:** Untuk n > 30 (yang hampir pasti kita punya setelah 1 bulan journaling), t-distribution ≈ normal distribution. Jadi cukup implementasi standard normal CDF:

   ```dart
   /// Standard normal CDF menggunakan Abramowitz & Stegun approximation
   /// Error < 7.5e-8
   double normalCdf(double z) {
     // Implementasi polynomial approximation
   }
   ```

3. **Bangun test suite yang ketat:**

   ```dart
   // test/domain/services/correlation_engine_test.dart

   // Test dengan data yang PASTI diketahui hasilnya:
   // - Perfect positive correlation (r=1): x = [1,2,3,4,5], y = [2,4,6,8,10]
   // - Perfect negative correlation (r=-1): x = [1,2,3,4,5], y = [10,8,6,4,2]
   // - No correlation (r≈0): x = [1,2,3,4,5], y = [3,1,4,1,5]
   // - Known result from statistics textbook

   // Property-based tests:
   // - |r| selalu antara 0 dan 1
   // - pearson(x, x) == 1.0
   // - pearson(x, -x) == -1.0
   // - pearson(x, y) == pearson(y, x) (symmetry)
   // - p-value selalu antara 0 dan 1
   // - Lebih banyak data points → p-value lebih rendah (untuk same r)
   ```

**Deliverable:** Correlation engine dengan 4 metode korelasi + p-value calculation. 100% unit tested. Ini HARUS reliable — salah hitung = insight menyesesatkan.

#### Hari 25–26: Lagged Correlation & Multi-Variable Analysis

**Yang dikerjakan:**

1. **Lagged correlation analysis:**

   Ini fitur yang membuat MedMind berbeda dari app lain. Banyak penyebab kesehatan punya **delayed effect**:
   - Alkohol hari Sabtu → tidur buruk hari Minggu → migraine hari Senin (lag 2)
   - Kurang tidur hari ini → mood buruk besok (lag 1)
   - Olahraga hari ini → tidur lebih baik malam ini (lag 0-1)

   ```dart
   // Dalam InsightEngine
   List<CorrelationResult> analyzeLaggedCorrelations(
     TimeSeriesMatrix matrix, {
     int maxLag = 3,  // cek sampai 3 hari ke belakang
   }) {
     final results = <CorrelationResult>[];
     final candidates = dataPrep.identifyCorrelationCandidates(matrix);

     for (final pair in candidates) {
       for (var lag = 0; lag <= maxLag; lag++) {
         final x = matrix.getColumn(pair.variableA);
         final y = matrix.getLaggedColumn(pair.variableB, lag);

         // Remove pairs where either is null (missing data)
         final (cleanX, cleanY) = removePairwiseNulls(x, y);

         if (cleanX.length < 14) continue;  // minimal 2 minggu data

         final result = correlationEngine.calculate(
           cleanX, cleanY,
           method: selectMethod(pair),
         );

         results.add(result.copyWith(
           variableA: pair.variableA,
           variableB: pair.variableB,
           lag: lag,
         ));
       }
     }

     // Apply Bonferroni correction
     final threshold = correlationEngine.bonferroniThreshold(results.length);
     return results.where((r) => r.pValue < threshold).toList()
       ..sort((a, b) => a.pValue.compareTo(b.pValue));  // urutkan by significance
   }
   ```

2. **Method selection logic:**

   ```dart
   CorrelationMethod selectMethod(VariablePair pair) {
     if (pair.typeA == VariableType.binary && pair.typeB == VariableType.binary) {
       return CorrelationMethod.chiSquare;
     } else if (pair.typeA == VariableType.binary || pair.typeB == VariableType.binary) {
       return CorrelationMethod.pointBiserial;
     } else {
       return CorrelationMethod.spearman;  // default Spearman (lebih robust untuk health data yang mungkin non-linear)
     }
   }
   ```

**Deliverable:** Lagged correlation analysis bekerja dan menemukan cross-day patterns.

### Minggu 6: Insight Generation & Anomaly Detection

#### Hari 27–28: Natural Language Insight Generator

**Yang dikerjakan:**

Ubah hasil statistik kering menjadi kalimat yang bisa dipahami orang awam.

```dart
// lib/domain/services/insight_generator.dart
class InsightGenerator {
  /// Konversi CorrelationResult → Insight yang human-readable
  Insight generateCorrelationInsight(CorrelationResult result) {
    final direction = result.coefficient > 0 ? 'positif' : 'negatif';
    final strength = _strengthLabel(result.coefficient.abs());

    // Template-based NLG
    if (result.lag == 0) {
      return Insight(
        type: InsightType.correlation,
        title: _generateTitle(result),
        description: _generateSameDayDescription(result),
        confidence: _confidenceFromPValue(result.pValue),
        relatedVariables: [result.variableA, result.variableB],
      );
    } else {
      return Insight(
        type: InsightType.correlation,
        title: _generateTitle(result),
        description: _generateLaggedDescription(result),
        confidence: _confidenceFromPValue(result.pValue),
        relatedVariables: [result.variableA, result.variableB],
      );
    }
  }

  String _generateSameDayDescription(CorrelationResult r) {
    // Contoh template:
    // Binary × Continuous:
    //   "Pada hari-hari kamu mengonsumsi kafein, tingkat kecemasan rata-rata 6.8/10.
    //    Pada hari tanpa kafein, rata-rata 3.2/10. (Berdasarkan data {n} hari)"
    //
    // Risk ratio:
    //   "Kamu {rr}x lebih mungkin mengalami {symptom} pada hari {factor}."
    //   "Pola ini muncul di {count} dari {total} kejadian."
    //
    // Continuous × Continuous:
    //   "Ada hubungan {strength} antara {varA} dan {varB}."
    //   "Semakin {tinggi/rendah} {varA}, semakin {tinggi/rendah} {varB}."
  }

  String _generateLaggedDescription(CorrelationResult r) {
    // Contoh:
    //   "Kurang tidur hari ini berkaitan dengan migraine besok."
    //   "{VarA} pada hari N tampak mempengaruhi {VarB} pada hari N+{lag}."
    //   "Contoh terakhir: {VarA} = {value} pada {date}, {VarB} = {value} pada {date+lag}"
  }

  // Human-readable variable names
  String _humanName(String variableId) {
    // 'symptom_migraine_severity' → 'tingkat keparahan migraine'
    // 'sleep_hours' → 'durasi tidur'
    // 'factor_caffeine' → 'konsumsi kafein'
    // Bisa pakai lookup table
  }
}
```

**Template library — buat banyak variasi supaya tidak terasa robotik:**

```dart
final _sameDayTemplates = [
  'Pada hari kamu {exposure}, {outcome} cenderung {direction}.',
  'Ada pola: saat {exposure}, kamu {ratio}x lebih mungkin mengalami {outcome}.',
  'Data {n} hari menunjukkan hubungan antara {varA} dan {varB}.',
];

final _laggedTemplates = [
  '{VarA} hari ini tampak mempengaruhi {VarB} {lag_description} kemudian.',
  'Perhatikan: {VarA} pada hari N → {VarB} terpengaruh pada hari N+{lag}.',
];

String _lagDescription(int lag) => switch (lag) {
  1 => '1 hari',
  2 => '2 hari',
  3 => '3 hari',
  _ => '$lag hari',
};
```

**Deliverable:** Insights terbentuk dalam bahasa manusia. Tested dengan berbagai skenario korelasi.

#### Hari 28–29: Anomaly Detection (Pure Dart)

**Yang dikerjakan:**

Deteksi hari-hari yang "tidak biasa" berdasarkan baseline user. Ini bisa jadi peringatan dini.

```dart
// lib/domain/services/anomaly_detector.dart
class AnomalyDetector {
  /// Z-score based anomaly detection
  /// Cocok untuk data yang roughly normal distribution
  List<AnomalyResult> detectZScoreAnomalies(
    TimeSeriesMatrix matrix, {
    double threshold = 2.0,  // hari yang >2 standard deviations dari mean
    int baselineWindow = 30,  // gunakan 30 hari terakhir sebagai baseline
  }) {
    final anomalies = <AnomalyResult>[];

    for (final variable in matrix.columns.keys) {
      final values = matrix.getColumn(variable).whereType<double>().toList();
      if (values.length < baselineWindow) continue;

      final baseline = values.sublist(0, values.length - 1);
      final latest = values.last;

      final mean = _mean(baseline);
      final stdDev = _standardDeviation(baseline);

      if (stdDev == 0) continue;  // no variation

      final zScore = (latest - mean) / stdDev;

      if (zScore.abs() > threshold) {
        anomalies.add(AnomalyResult(
          variable: variable,
          date: matrix.dates.last,
          value: latest,
          baselineMean: mean,
          baselineStdDev: stdDev,
          zScore: zScore,
          direction: zScore > 0 ? AnomalyDirection.above : AnomalyDirection.below,
        ));
      }
    }

    return anomalies;
  }

  /// Moving average anomaly detection
  /// Lebih robust untuk data yang tidak normal distribution
  List<AnomalyResult> detectMovingAverageAnomalies(
    TimeSeriesMatrix matrix, {
    int window = 7,        // 7-day moving average
    double threshold = 1.5, // multiplier dari MAD (median absolute deviation)
  }) { ... }
}
```

**Contoh insight dari anomaly:**

- "Tidur kamu semalam (4 jam) jauh di bawah rata-rata 2 minggu terakhir (7.2 jam). Ini bisa mempengaruhi gejala besok."
- "Tingkat kecemasan hari ini (9/10) unusually tinggi. Apa ada yang terjadi?"

**Deliverable:** Anomaly detector yang bisa flag hari-hari unusual.

#### Hari 29–30: Insight Engine Orchestrator + Health Score

**Yang dikerjakan:**

1. **`InsightEngine`** — domain service yang menyatukan semuanya:

   ```dart
   // lib/domain/services/insight_engine.dart
   class InsightEngine {
     final DataPreparationService _dataPrep;
     final CorrelationEngine _correlationEngine;
     final AnomalyDetector _anomalyDetector;
     final InsightGenerator _insightGenerator;

     InsightEngine({
       required DataPreparationService dataPrep,
       required CorrelationEngine correlationEngine,
       required AnomalyDetector anomalyDetector,
       required InsightGenerator insightGenerator,
     }) : _dataPrep = dataPrep,
          _correlationEngine = correlationEngine,
          _anomalyDetector = anomalyDetector,
          _insightGenerator = insightGenerator;

     /// Main analysis pipeline
     /// Dipanggil saat user buka Insights tab atau saat background refresh
     Future<InsightReport> analyzeAll(List<JournalEntry> entries) async {
       // Step 1: Prepare data matrix
       final matrix = _dataPrep.prepareMatrix(entries);

       // Step 2: Run correlation analysis (termasuk lagged)
       final correlations = _correlationEngine.analyzeLaggedCorrelations(matrix);

       // Step 3: Run anomaly detection
       final anomalies = _anomalyDetector.detectZScoreAnomalies(matrix);

       // Step 4: Generate human-readable insights
       final correlationInsights = correlations
           .map(_insightGenerator.generateCorrelationInsight)
           .toList();
       final anomalyInsights = anomalies
           .map(_insightGenerator.generateAnomalyInsight)
           .toList();

       // Step 5: Deduplicate & rank
       final allInsights = [...correlationInsights, ...anomalyInsights]
           ..sort((a, b) => b.confidence.compareTo(a.confidence));

       // Step 6: Calculate health score
       final healthScore = _calculateHealthScore(matrix, anomalies);

       return InsightReport(
         insights: allInsights,
         healthScore: healthScore,
         correlationMatrix: correlations,
         anomalies: anomalies,
         analyzedAt: DateTime.now(),
         dataPointCount: matrix.rowCount,
       );
     }

     HealthScore _calculateHealthScore(TimeSeriesMatrix matrix, List<AnomalyResult> anomalies) {
       // Composite score berdasarkan:
       // - Mood trend (improving/declining)
       // - Symptom frequency (fewer = better)
       // - Sleep quality trend
       // - Anomaly count (fewer = better)
       // - Medication compliance
       // Weighted average → normalize ke 0-100
     }
   }
   ```

2. **`InsightReport`** — value object untuk hasil analisis:

   ```dart
   @freezed
   class InsightReport with _$InsightReport {
     const factory InsightReport({
       required List<Insight> insights,
       required HealthScore healthScore,
       required List<CorrelationResult> correlationMatrix,
       required List<AnomalyResult> anomalies,
       required DateTime analyzedAt,
       required int dataPointCount,
     }) = _InsightReport;
   }
   ```

3. **Insight caching:**
   - Insight report di-cache di Isar
   - Re-analyze hanya kalau ada entry baru sejak terakhir analyze
   - TTL: 24 jam (force re-analyze setelah 24 jam walaupun tidak ada entry baru)

4. **Background analysis:**
   - WorkManager task yang re-analyze setiap malam (atau setelah entry baru disimpan)
   - Hasil di-cache → siap tampil saat user buka Insights tab

**Deliverable:** InsightEngine bekerja end-to-end. Bisa input journal entries → output ranked insights + health score.

---

### Checklist Akhir Phase 3

- [ ] DataPreparationService: journal entries → time series matrix
- [ ] CorrelationEngine: 4 metode (Pearson, Spearman, point-biserial, chi-square)
- [ ] P-value calculation
- [ ] Bonferroni correction
- [ ] Lagged correlation analysis (lag 0–3)
- [ ] AnomalyDetector: Z-score + moving average
- [ ] InsightGenerator: template-based NLG (Bahasa Indonesia + English)
- [ ] InsightEngine orchestrator
- [ ] HealthScore calculator
- [ ] Insight caching di Isar
- [ ] 100% unit test coverage untuk semua domain services
- [ ] Property-based tests untuk statistical correctness
- [ ] Git: branch `feature/insight-engine` merged ke `develop`

---

## Phase 4: ML Integration (Minggu 7–9)

> **Tujuan:** Integrasi TensorFlow Lite untuk NLP symptom extraction dan anomaly detection ML model. Bangun isolate-based inference pipeline yang tidak mengganggu UI.

### Minggu 7: ML Model Preparation & TFLite Setup

#### Hari 31–33: Model Training (Python Side)

**Yang dikerjakan:**

Ini di luar Flutter project, tapi essential. Kita perlu prepare model sebelum bisa integrasi.

1. **Symptom NLP Extraction Model:**

   **Opsi realistis untuk solo dev:**
   - **Opsi A (Rekomendasi): Rule-based NLP + small classifier**
     - Buat dictionary symptom keywords (Bahasa Indonesia + English)
     - Keyword matching + simple TF-IDF classifier untuk severity
     - Konversi ke TFLite model (~500KB)
     - **Pro:** cepat develop, predictable behavior
     - **Kontra:** tidak sefleksibel BERT
   - **Opsi B: Fine-tuned MobileBERT**
     - Fine-tune MobileBERT pada medical symptom extraction task
     - Butuh labeled dataset (bisa pakai public NER health datasets)
     - Convert ke TFLite (~20MB)
     - **Pro:** lebih akurat untuk bahasa alami
     - **Kontra:** butuh GPU untuk training, model lebih besar

   **Rekomendasi:** Mulai dengan Opsi A, upgrade ke Opsi B kalau punya waktu.

   ```python
   # ml/notebooks/symptom_extraction_training.ipynb

   # 1. Prepare symptom dictionary
   symptom_dict = {
       'headache': ['headache', 'sakit kepala', 'pusing', 'migraine', 'migrain'],
       'nausea': ['nausea', 'mual', 'nauseous', 'enek'],
       'fatigue': ['fatigue', 'lelah', 'capek', 'tired', 'exhausted', 'lemas'],
       # ... 50+ symptoms
   }

   # 2. Train simple text classifier
   # Input: sentence → Output: list of symptom tags + severity

   # 3. Export ke TFLite
   converter = tf.lite.TFLiteConverter.from_saved_model(saved_model_dir)
   converter.optimizations = [tf.lite.Optimize.DEFAULT]
   tflite_model = converter.convert()

   with open('models/nlp_symptom_v1.tflite', 'wb') as f:
       f.write(tflite_model)
   ```

2. **Anomaly Detection Model (Complementing Dart-native):**
   - Isolation Forest trained on synthetic health data
   - Input: daily feature vector (sleep, mood, symptom count, etc.)
   - Output: anomaly score (0-1)
   - Convert ke TFLite (~1MB)

3. **Correlation Enhancement Model:**

   Sebenarnya untuk correlation, pure Dart statistical methods (Phase 3) sudah cukup. ML model di sini bersifat **optional enhancement** — bisa detect non-linear relationships yang missed oleh Pearson/Spearman. Skip ini kalau waktu terbatas, fokus ke NLP dan anomaly.

4. **Taruh model files di Flutter assets:**

   ```yaml
   # pubspec.yaml
   flutter:
     assets:
       - assets/ml/nlp_symptom_v1.tflite
       - assets/ml/anomaly_detection_v1.tflite
       - assets/ml/symptom_labels.json # label mapping
   ```

**Deliverable:** Minimal 2 TFLite model siap di-bundle ke app. Documented input/output spec.

#### Hari 33–35: TFLite Engine & Isolate Pool

**Yang dikerjakan:**

Package tambahan untuk Phase 4:

```yaml
tflite_flutter: ^0.10.x
```

1. **TFLite Engine wrapper:**

   ```dart
   // lib/data/datasources/ml/tflite_engine.dart
   class TFLiteEngine {
     Interpreter? _interpreter;
     final String _modelPath;

     TFLiteEngine(this._modelPath);

     Future<void> loadModel() async {
       _interpreter = await Interpreter.fromAsset(_modelPath);
     }

     List<double> runInference(List<double> input) {
       if (_interpreter == null) throw MLFailure('Model not loaded');

       final inputBuffer = [input];  // batch size 1
       final outputBuffer = List.filled(1, List.filled(_outputSize, 0.0));

       _interpreter!.run(inputBuffer, outputBuffer);

       return outputBuffer[0];
     }

     void dispose() {
       _interpreter?.close();
       _interpreter = null;
     }
   }
   ```

2. **Isolate Pool Manager:**

   TFLite inference HARUS di isolate terpisah supaya tidak block UI thread.

   ```dart
   // lib/data/datasources/ml/isolate_pool_manager.dart
   class IsolatePoolManager {
     final int _poolSize;
     final List<Isolate> _isolates = [];
     final List<SendPort> _sendPorts = [];
     final Queue<Completer<dynamic>> _taskQueue = Queue();
     final List<bool> _busy;

     IsolatePoolManager({int poolSize = 2})
       : _poolSize = poolSize,
         _busy = List.filled(poolSize, false);

     Future<void> initialize(String modelAssetPath) async {
       for (var i = 0; i < _poolSize; i++) {
         final receivePort = ReceivePort();
         final isolate = await Isolate.spawn(
           _isolateEntryPoint,
           _IsolateConfig(
             sendPort: receivePort.sendPort,
             modelPath: modelAssetPath,
           ),
         );
         _isolates.add(isolate);

         // Wait for isolate to send back its SendPort
         final sendPort = await receivePort.first as SendPort;
         _sendPorts.add(sendPort);
       }
     }

     Future<List<double>> runInference(List<double> input) async {
       // Find available isolate or queue the task
       final freeIndex = _busy.indexOf(false);
       if (freeIndex == -1) {
         // All busy — queue and wait
         final completer = Completer<List<double>>();
         _taskQueue.add(completer);
         return completer.future;
       }

       _busy[freeIndex] = true;
       try {
         return await _sendInferenceRequest(_sendPorts[freeIndex], input);
       } finally {
         _busy[freeIndex] = false;
         _processQueue();
       }
     }

     static void _isolateEntryPoint(_IsolateConfig config) {
       // Ini jalan di isolate terpisah
       final receivePort = ReceivePort();
       config.sendPort.send(receivePort.sendPort);

       // Load model di isolate ini
       final engine = TFLiteEngine(config.modelPath);
       engine.loadModel();

       receivePort.listen((message) {
         final request = message as _InferenceRequest;
         final result = engine.runInference(request.input);
         request.replyPort.send(result);
       });
     }

     void dispose() {
       for (final isolate in _isolates) {
         isolate.kill();
       }
     }
   }
   ```

   **Catatan penting:**
   - `tflite_flutter` mungkin tidak bisa dipakai langsung di isolate karena menggunakan FFI yang tied ke main isolate. Kalau ini terjadi, alternative approach:
     - Gunakan `compute()` function saja (single isolate per inference) — lebih sederhana
     - Atau gunakan approach `RootIsolateToken` yang tersedia di Flutter 3.7+
   - **Test di device asli**, bukan emulator — performance berbeda signifikan

3. **Model lifecycle management:**

   ```dart
   // lib/data/datasources/ml/ml_model_manager.dart
   class MLModelManager with WidgetsBindingObserver {
     final Map<String, IsolatePoolManager> _pools = {};

     @override
     void didChangeAppLifecycleState(AppLifecycleState state) {
       if (state == AppLifecycleState.paused) {
         // App background → dispose non-essential models to free RAM
         _pools['anomaly']?.dispose();
       }
       if (state == AppLifecycleState.resumed) {
         // App foreground → re-load if needed (lazy, on next inference request)
       }
     }

     Future<IsolatePoolManager> getPool(String modelName) async {
       if (!_pools.containsKey(modelName)) {
         final pool = IsolatePoolManager();
         await pool.initialize('assets/ml/${modelName}.tflite');
         _pools[modelName] = pool;
       }
       return _pools[modelName]!;
     }
   }
   ```

**Deliverable:** TFLite models loadable in Flutter isolates. Inference returns correct results. Memory managed properly.

### Minggu 8–9: NLP Integration & ML Repository

#### Hari 36–38: Symptom Extraction Pipeline

**Yang dikerjakan:**

1. **`SymptomExtractor`** class yang wrap TFLite NLP model:

   ```dart
   // lib/data/datasources/ml/symptom_extractor.dart
   class SymptomExtractor {
     final IsolatePoolManager _pool;
     final Map<int, String> _labelMap;  // index → symptom name

     Future<List<ExtractedSymptom>> extractFromText(String text) async {
       // 1. Tokenize text
       final tokens = _tokenize(text);

       // 2. Convert to input tensor
       final inputVector = _tokensToVector(tokens);

       // 3. Run inference
       final output = await _pool.runInference(inputVector);

       // 4. Post-process: map output indices to symptom names
       final symptoms = <ExtractedSymptom>[];
       for (var i = 0; i < output.length; i++) {
         if (output[i] > 0.5) {  // confidence threshold
           symptoms.add(ExtractedSymptom(
             symptomName: _labelMap[i] ?? 'unknown',
             confidence: output[i],
             sourceText: text,
             isConfirmedByUser: null,  // pending confirmation
           ));
         }
       }

       return symptoms..sort((a, b) => b.confidence.compareTo(a.confidence));
     }

     List<String> _tokenize(String text) {
       // Simple whitespace + punctuation tokenizer
       // Lowercase, remove special chars, split
       return text.toLowerCase()
           .replaceAll(RegExp(r'[^\w\s]'), ' ')
           .split(RegExp(r'\s+'))
           .where((t) => t.isNotEmpty)
           .toList();
     }
   }
   ```

2. **Rule-based fallback** (pakai kalau model confidence rendah):

   ```dart
   class RuleBasedSymptomExtractor {
     final Map<String, List<String>> _symptomKeywords;

     List<ExtractedSymptom> extractFromText(String text) {
       final lowerText = text.toLowerCase();
       final found = <ExtractedSymptom>[];

       for (final entry in _symptomKeywords.entries) {
         for (final keyword in entry.value) {
           if (lowerText.contains(keyword)) {
             found.add(ExtractedSymptom(
               symptomName: entry.key,
               confidence: 0.6,  // lower confidence than ML model
               sourceText: _extractContext(text, keyword),
               severity: _detectSeverity(text, keyword),
             ));
             break;  // satu keyword cukup per symptom
           }
         }
       }

       return found;
     }

     String? _detectSeverity(String text, String keyword) {
       // Cek kata-kata sekitar keyword:
       // "sangat sakit kepala" → severe
       // "sedikit pusing" → mild
       // "sakit kepala parah" → severe
       final severityPatterns = {
         'severe': ['sangat', 'parah', 'severe', 'splitting', 'terrible', 'banget'],
         'moderate': ['cukup', 'moderate', 'lumayan'],
         'mild': ['sedikit', 'mild', 'slight', 'ringan', 'dikit'],
       };
       // ... pattern matching logic
     }
   }
   ```

3. **Integration into journal save flow:**
   - User save journal entry dengan free text
   - Background: NLP pipeline processes text
   - Jika confidence > 0.85: auto-add extracted symptoms ke entry
   - Jika confidence 0.5-0.85: show suggestion dialog "Kami mendeteksi kamu menyebut [gejala]. Tambahkan ke log?"
   - Jika confidence < 0.5: skip (tapi log untuk future training data)

#### Hari 38–40: ML Repository Implementation

**Yang dikerjakan:**

```dart
// lib/data/repositories/ml_repository_impl.dart
@LazySingleton(as: MLRepository)
class MLRepositoryImpl implements MLRepository {
  final MLModelManager _modelManager;
  final SymptomExtractor _symptomExtractor;
  final RuleBasedSymptomExtractor _ruleBasedExtractor;

  @override
  Future<List<ExtractedSymptom>> extractSymptomsFromText(String text) async {
    try {
      // Try ML model first
      final mlResults = await _symptomExtractor.extractFromText(text);

      if (mlResults.isEmpty || mlResults.every((r) => r.confidence < 0.5)) {
        // Fallback to rule-based
        return _ruleBasedExtractor.extractFromText(text);
      }

      return mlResults;
    } catch (e) {
      // ML model failed (OOM, corrupted model, etc.)
      // Graceful degradation: use rule-based
      return _ruleBasedExtractor.extractFromText(text);
    }
  }

  @override
  Future<double> predictAnomalyScore(List<double> dailyFeatures) async {
    try {
      final pool = await _modelManager.getPool('anomaly_detection_v1');
      final output = await pool.runInference(dailyFeatures);
      return output[0];  // anomaly score 0-1
    } catch (e) {
      return -1;  // indicates ML unavailable, fallback to statistical method
    }
  }
}
```

#### Hari 41–43: Wiring ML ke Insight Engine + Testing

**Yang dikerjakan:**

1. Update `InsightEngine` untuk include ML-based insights alongside statistical insights
2. ML anomaly score sebagai additional signal (bukan replacement) untuk statistical anomaly detector
3. NLP extraction results feed into correlation engine (extracted symptoms → symptom logs → correlation data)

**Testing:**

```dart
// test/data/datasources/ml/symptom_extractor_test.dart
group('SymptomExtractor', () {
  test('extracts headache from English text', () async {
    final result = await extractor.extractFromText(
      'Had a terrible headache all morning'
    );
    expect(result, contains(
      predicate<ExtractedSymptom>((s) => s.symptomName == 'headache')
    ));
  });

  test('extracts symptoms from Bahasa Indonesia', () async {
    final result = await extractor.extractFromText(
      'Sangat mual setelah makan siang, sakit kepala juga'
    );
    expect(result.length, greaterThanOrEqualTo(2));
  });

  test('low confidence triggers fallback', () async {
    // Test with ambiguous text
    final result = await extractor.extractFromText('Had a long day');
    expect(result, isEmpty);  // should not hallucinate symptoms
  });

  test('graceful degradation when model fails', () async {
    // Simulate model load failure
    // Should fall back to rule-based without throwing
  });
});
```

---

### Checklist Akhir Phase 4

- [ ] Minimal 2 TFLite models bundled (NLP + anomaly)
- [ ] TFLite inference bekerja di isolate (tidak block UI)
- [ ] IsolatePoolManager: load, run, dispose
- [ ] MLModelManager: lifecycle management dengan AppLifecycleState
- [ ] SymptomExtractor: ML-based extraction
- [ ] RuleBasedSymptomExtractor: keyword-based fallback
- [ ] Graceful degradation: ML failure → fallback → still works
- [ ] NLP results terintegrasi ke journal save flow
- [ ] ML anomaly score terintegrasi ke Insight Engine
- [ ] Suggestion dialog untuk medium-confidence extractions
- [ ] ML integration tests (known input → expected output)
- [ ] Performance test: inference < 500ms on mid-range device
- [ ] Git: branch `feature/tflite-integration` merged ke `develop`

---

## Phase 5: Visualization & Polish (Minggu 10–11)

> **Tujuan:** Bangun custom visualisasi yang impressive (heatmap, timeline, health score ring), polish UX, dan comprehensive testing.

### Minggu 10: Custom Paint Visualizations

#### Hari 44–46: Correlation Heatmap (CustomPainter)

**Yang dikerjakan:**

Ini widget paling impressive secara visual. Heatmap menunjukkan korelasi antar variabel.

```dart
// lib/presentation/pages/insights/widgets/correlation_heatmap.dart

class CorrelationHeatmapPainter extends CustomPainter {
  final List<String> labels;          // variable names
  final List<List<double>> matrix;    // correlation matrix NxN
  final double? selectedRow;
  final double? selectedCol;

  @override
  void paint(Canvas canvas, Size size) {
    final cellSize = size.width / (labels.length + 1);  // +1 for labels

    for (var i = 0; i < labels.length; i++) {
      for (var j = 0; j < labels.length; j++) {
        final value = matrix[i][j];
        final color = _correlationColor(value);

        // Draw cell
        final rect = Rect.fromLTWH(
          (j + 1) * cellSize,
          (i + 1) * cellSize,
          cellSize,
          cellSize,
        );
        canvas.drawRect(rect, Paint()..color = color);

        // Draw value text
        _drawText(canvas, value.toStringAsFixed(2), rect.center);
      }

      // Draw row/column labels
      _drawText(canvas, _shortLabel(labels[i]),
        Offset(0, (i + 1.5) * cellSize));
      _drawText(canvas, _shortLabel(labels[i]),
        Offset((i + 1.5) * cellSize, 0));
    }
  }

  Color _correlationColor(double value) {
    // -1 (strong negative) → red
    //  0 (no correlation) → white/gray
    // +1 (strong positive) → blue/green
    if (value > 0) {
      return Color.lerp(Colors.white, Colors.blue.shade700, value)!;
    } else {
      return Color.lerp(Colors.white, Colors.red.shade700, -value)!;
    }
  }
}
```

**Interaktivitas:**

- Tap sebuah cell → tampilkan detail insight untuk pasangan variabel tersebut
- Pinch to zoom kalau banyak variabel
- Long press → highlight row dan column

**GestureDetector wrapper:**

```dart
class InteractiveHeatmap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        // Hitung cell mana yang di-tap berdasarkan position
        final cell = _hitTestCell(details.localPosition);
        if (cell != null) {
          // Navigate ke detail insight
        }
      },
      child: CustomPaint(
        painter: CorrelationHeatmapPainter(...),
        size: Size(width, height),
      ),
    );
  }
}
```

#### Hari 46–48: Symptom Timeline (CustomPainter)

**Yang dikerjakan:**

Timeline horizontal yang menampilkan layered tracks:

```
Date:     Jan 1    Jan 2    Jan 3    Jan 4    Jan 5
          ───────────────────────────────────────────
Sleep:    ████████ ████     ██████████ ████████ ███████
          7.5h     4h       8h         7h       6.5h
          ───────────────────────────────────────────
Migraine: ·        ●●●●     ●●         ·        ·
          -        8/10     3/10       -        -
          ───────────────────────────────────────────
Mood:     😊       😟       😐         🙂       😊
          ───────────────────────────────────────────
Caffeine: ☕☕      ☕☕☕     ☕          ☕☕      ☕
```

**Implementasi kunci:**

- Horizontal scroll menggunakan `GestureDetector` + `ScrollController`
- Setiap track = satu horizontal lane yang di-paint `CustomPainter`
- `RepaintBoundary` per track untuk isolasi repaint
- Vertical layout: stack of tracks, collapsible
- Performance: hanya paint data yang visible (viewport culling berdasarkan scroll offset)

```dart
class SymptomTimelinePainter extends CustomPainter {
  final List<JournalEntry> entries;
  final double scrollOffset;
  final double dayWidth;  // pixels per day
  final List<TrackConfig> tracks;

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Calculate visible date range from scrollOffset
    final visibleStart = scrollOffset ~/ dayWidth;
    final visibleEnd = (scrollOffset + size.width) ~/ dayWidth + 1;

    // 2. Only iterate entries in visible range
    for (var i = visibleStart; i <= visibleEnd && i < entries.length; i++) {
      final entry = entries[i];
      final x = i * dayWidth - scrollOffset;

      // 3. Paint each track
      var y = 0.0;
      for (final track in tracks) {
        _paintTrack(canvas, track, entry, x, y, dayWidth);
        y += track.height;
      }
    }
  }

  @override
  bool shouldRepaint(SymptomTimelinePainter old) {
    return old.scrollOffset != scrollOffset || old.entries != entries;
  }
}
```

#### Hari 48–49: Health Score Ring Animation

**Yang dikerjakan:**

Animated circular progress indicator dengan gradient, smooth animation, dan particle effects.

```dart
class HealthScoreRing extends StatefulWidget {
  final double score;  // 0-100
  final ScoreTrend trend;

  @override
  State<HealthScoreRing> createState() => _HealthScoreRingState();
}

class _HealthScoreRingState extends State<HealthScoreRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scoreAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scoreAnimation = Tween<double>(begin: 0, end: widget.score)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scoreAnimation,
      builder: (context, child) {
        return CustomPaint(
          painter: HealthScoreRingPainter(
            score: _scoreAnimation.value,
            trend: widget.trend,
          ),
          child: Center(
            child: Text(
              '${_scoreAnimation.value.round()}',
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
        );
      },
    );
  }
}

class HealthScoreRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Background circle (gray track)
    // 2. Gradient arc (progress based on score)
    //    - 0-30: red gradient
    //    - 30-60: yellow gradient
    //    - 60-100: green gradient
    // 3. Glow effect at the end of the arc
    // 4. Optional: particle effects along the arc
  }
}
```

### Minggu 11: Insights Page Assembly, Export, & Comprehensive Testing

#### Hari 50–51: Insights Page

**Yang dikerjakan:**

1. **Insights Page layout:**
   - Top: Health Score Ring (animated, prominent)
   - Below: horizontal date selector (scroll to change analysis period)
   - Tab bar: "Insights" | "Heatmap" | "Timeline"
   - Insight cards: ranked list from InsightEngine, dengan read/unread indicator
   - Each card expandable: tap untuk lihat detail + chart pendukung
   - "Not enough data" state: kalau < 14 hari data, tampilkan progress bar "Journal X hari lagi untuk insight pertamamu!"

2. **Riverpod integration:**

   ```dart
   @riverpod
   Future<InsightReport> insightReport(InsightReportRef ref) async {
     final entries = await ref.watch(journalEntriesProvider(null).future);
     final engine = ref.watch(insightEngineProvider);
     return engine.analyzeAll(entries);
   }
   ```

3. **Handling async ML inference:**
   - Tampilkan shimmer loading saat analysis berjalan
   - Progressive loading: statistical insights appear first (fast), ML insights appear later (slower)
   - Error state: kalau analysis fail, tampilkan "Ada masalah saat analisis. Coba lagi?"

#### Hari 52–53: Export Pipeline

**Yang dikerjakan:**

1. **PDF Report Generator:**

   Tambahkan package:

   ```yaml
   pdf: ^3.10.x
   printing: ^5.12.x
   ```

   ```dart
   class HealthReportGenerator {
     Future<Uint8List> generatePdf({
       required DateRange period,
       required List<JournalEntry> entries,
       required InsightReport insights,
     }) async {
       final pdf = pw.Document();

       pdf.addPage(pw.MultiPage(
         header: (context) => _buildHeader(period),
         build: (context) => [
           _buildSummarySection(entries, insights),
           _buildSymptomFrequencyTable(entries),
           _buildMedicationCompliance(entries),
           _buildSleepAnalysis(entries),
           _buildTopInsights(insights),
           _buildCorrelationTable(insights.correlationMatrix),
         ],
       ));

       return pdf.save();
     }
   }
   ```

2. **CSV Export:**

   ```dart
   class CsvExporter {
     String exportEntries(List<JournalEntry> entries) {
       // Header row
       // Each entry becomes a row
       // Columns: date, mood, mood_intensity, symptom_1_severity, ..., sleep_hours, etc.
     }
   }
   ```

3. **Export page UI:**
   - Pilih period (last 30 days, last 90 days, custom range)
   - Pilih format (PDF, CSV)
   - Optional: password protect PDF
   - Share via `share_plus`

#### Hari 54–57: Comprehensive Testing & Polish

**Yang dikerjakan:**

1. **Golden tests** (minimal 5 golden test files):
   - `health_score_ring_golden_test.dart` — ring di berbagai score (0, 25, 50, 75, 100)
   - `correlation_heatmap_golden_test.dart` — 5x5 matrix dengan known values
   - `symptom_timeline_golden_test.dart` — 7 hari data dengan berbagai symptoms
   - `mood_picker_golden_test.dart` — semua mood states
   - `journal_entry_card_golden_test.dart` — card dengan full data vs minimal data

   ```dart
   testWidgets('health score ring renders correctly at 75%', (tester) async {
     await tester.pumpWidget(
       MaterialApp(
         home: Scaffold(
           body: Center(
             child: SizedBox(
               width: 200,
               height: 200,
               child: CustomPaint(
                 painter: HealthScoreRingPainter(score: 75, trend: ScoreTrend.improving),
               ),
             ),
           ),
         ),
       ),
     );

     await expectLater(
       find.byType(CustomPaint),
       matchesGoldenFile('goldens/health_score_ring_75.png'),
     );
   });
   ```

2. **End-to-end flow test:**
   - Create 30 journal entries (programmatically)
   - Run InsightEngine analysis
   - Navigate to Insights page
   - Verify insights displayed
   - Export PDF
   - Verify PDF generated

3. **Performance profiling:**
   - Profile Insights page load time dengan 100+ entries
   - Profile custom paint FPS saat scrolling timeline
   - Profile ML inference time
   - Set benchmark targets: insight generation < 3s, timeline scroll 60fps, ML inference < 500ms

4. **UX Polish:**
   - Micro-animations (card reveals, tab transitions)
   - Proper error messages (not generic "Something went wrong")
   - Accessibility: semantic labels untuk custom paint widgets
   - Dark mode review: semua custom paint respects theme

---

### Checklist Akhir Phase 5

- [ ] Correlation heatmap (CustomPainter) dengan tap interactivity
- [ ] Symptom timeline (CustomPainter) dengan scroll + viewport culling
- [ ] Health score ring animation (animated, gradient, glow)
- [ ] Insights page: score + tabs + insight cards + empty state
- [ ] PDF report generator
- [ ] CSV export
- [ ] Export page UI with share
- [ ] 5 golden tests
- [ ] E2E integration test (30 entries → insights → export)
- [ ] Performance profiling documented
- [ ] Dark mode review
- [ ] Accessibility audit (semantic labels)
- [ ] Git: branches `feature/custom-visualizations` + `feature/export` merged ke `develop`

---

## Phase 6: Production (Minggu 12)

> **Tujuan:** Finalisasi untuk Play Store release. Error monitoring, performance optimization, store listing.

### Hari 58–59: Error Monitoring (Sentry)

**Yang dikerjakan:**

Tambahkan package:

```yaml
sentry_flutter: ^8.x.x
```

Setup dengan PII scrubbing:

```dart
// lib/main.dart
Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn = 'YOUR_SENTRY_DSN';
      options.tracesSampleRate = 0.3;  // 30% performance tracing
      options.beforeSend = (event, hint) {
        // AGGRESSIVE PII SCRUBBING
        // Jangan pernah kirim health data ke Sentry
        return _scrubPii(event);
      };
      options.beforeBreadcrumb = (breadcrumb, hint) {
        // Hapus breadcrumb yang mengandung health data
        if (breadcrumb?.category == 'journal' ||
            breadcrumb?.category == 'symptom') {
          return null;  // discard
        }
        return breadcrumb;
      };
    },
    appRunner: () => runApp(
      ProviderScope(child: const MedMindApp()),
    ),
  );
}

SentryEvent _scrubPii(SentryEvent event) {
  // Remove any extra data that might contain health info
  return event.copyWith(
    extra: {},  // clear all extra data
    tags: event.tags?..removeWhere(
      (key, value) => ['symptom', 'mood', 'medication', 'sleep'].contains(key)
    ),
  );
}
```

### Hari 59–60: Performance Optimization

**Checklist:**

- [ ] **App size audit**: `flutter build apk --analyze-size`. Target: < 30MB APK (termasuk TFLite models)
- [ ] **Startup time**: profiling cold start. Target: < 3 detik di device mid-range
  - Deferred loading: TFLite models loaded lazily (bukan startup)
  - Deferred Isar collection opening
- [ ] **Memory usage**: profiling heap. Target: < 150MB peak
  - Dispose TFLite models saat app background
  - Image cache limits
- [ ] **Jank audit**: record performance overlay saat scrolling. Target: 0 jank frames
  - Pastikan isolate-based inference bekerja
  - Pastikan custom paint `shouldRepaint` di-implement benar
- [ ] **Battery**: verifikasi WorkManager schedule tidak terlalu agresif
- [ ] **Proguard/R8 rules**: pastikan TFLite native libs tidak di-strip

```yaml
# android/app/proguard-rules.pro
-keep class org.tensorflow.lite.** { *; }
-keepclassmembers class org.tensorflow.lite.** { *; }
```

### Hari 60–61: Play Store Preparation

**Yang dikerjakan:**

1. **App signing:**
   - Generate upload keystore
   - Setup `key.properties` (JANGAN commit ke Git!)
   - Configure signing di `build.gradle`

2. **App icon & splash screen:**

   ```yaml
   # Tambahkan di pubspec
   flutter_launcher_icons: ^0.14.x
   flutter_native_splash: ^2.4.x
   ```

3. **Store listing preparation:**
   - App name: "MedMind - Health Journal"
   - Short description (80 char): "Privately track symptoms, find health patterns with on-device AI"
   - Full description: penjelasan fitur, privacy commitment, how it works
   - Screenshots: 5-8 screenshot (home, journal, insights, heatmap, timeline, export, settings, onboarding)
   - Feature graphic: 1024x500
   - Privacy policy: WAJIB untuk health app. Tekan bahwa data di-local, enkripsi, dll.

4. **Release build:**

   ```bash
   flutter build appbundle --release
   ```

5. **Internal testing track:**
   - Upload ke Play Store internal testing
   - Test di minimal 3 device berbeda (low-end, mid-range, flagship)
   - Fix crash atau issue yang ditemukan

### Hari 62: Final Review & Release

**Yang dikerjakan:**

1. **Final code review** — review semua code sendiri:
   - Apakah ada hardcoded strings?
   - Apakah semua error di-handle?
   - Apakah ada TODO yang tertinggal?
   - Apakah lint 100% clean?

2. **Merge `develop` → `main`**

3. **Tag release:**

   ```bash
   git tag -a v1.0.0 -m "Initial release"
   git push origin v1.0.0
   ```

4. **Publish ke Play Store** (closed/open testing atau production)

---

### Checklist Akhir Phase 6

- [ ] Sentry error monitoring terpasang dengan PII scrubbing
- [ ] App size < 30MB
- [ ] Cold start < 3 detik
- [ ] 0 jank frames di scrolling
- [ ] App signing configured
- [ ] App icon & splash screen
- [ ] Store listing (screenshots, description, privacy policy)
- [ ] Release build berhasil
- [ ] Tested di 3+ device berbeda
- [ ] All tests pass di CI (tinggal lihat berapa test count)
- [ ] Code coverage >= 80%
- [ ] `develop` merged ke `main`
- [ ] Tagged v1.0.0
- [ ] Published ke Play Store

---

## Daftar Risiko & Mitigasi

| #   | Risiko                                  | Dampak                                   | Probabilitas                                        | Mitigasi                                                                                                        |
| --- | --------------------------------------- | ---------------------------------------- | --------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| 1   | **Isar deprecated/unmaintained**        | Tinggi — database adalah core            | Sedang (Isar development memang melambat)           | Monitor Isar GitHub. Siap migrate ke Drift kalau perlu. Clean Architecture memudahkan swap.                     |
| 2   | **TFLite Flutter binding tidak stabil** | Sedang — ML fitur terganggu              | Sedang                                              | Rule-based fallback selalu tersedia. ML adalah enhancement, bukan hard dependency.                              |
| 3   | **Health Connect API berubah**          | Rendah — fitur tambahan                  | Rendah                                              | Platform channel isolasi perubahan. Graceful degradation sudah built-in.                                        |
| 4   | **Model ML akurasi rendah**             | Sedang — insight menyesatkan             | Tinggi (untuk solo dev tanpa massive training data) | Confidence threshold ketat. User confirmation untuk medium confidence. Statistical engine selalu jadi fallback. |
| 5   | **Burnout karena scope terlalu besar**  | Tinggi — project tidak selesai           | Tinggi                                              | Prioritaskan: Phase 1-3 = MVP. Phase 4-5 = enhancement. Ship Phase 3 dulu, iterate.                             |
| 6   | **Android permission changes**          | Sedang — location/sensor fitur terganggu | Rendah                                              | Minimal permission usage. Graceful degradation untuk semua permission-gated features.                           |

### Strategi Jika Waktu Kurang

Kalau 12 minggu terasa terlalu ketat, ini urutan prioritas:

1. **HARUS SELESAI (Phase 1-3):** Foundation + Journaling + Statistical Engine = **sudah cukup untuk portfolio**
2. **SANGAT DIREKOMENDASIKAN (Phase 5 parsial):** Minimal 1 custom paint visualization (heatmap ATAU health score ring)
3. **NICE TO HAVE (Phase 4):** TFLite integration — bisa di-add setelah launch
4. **NICE TO HAVE (Phase 2 parsial):** Health Connect — bisa di-add setelah launch

**MVP yang worth untuk portfolio = Phase 1 + 2 + 3 + Export + 1 Custom Paint = ~8 minggu**

---

## Definisi "Selesai" (Definition of Done)

Sebuah fitur dianggap "selesai" kalau:

1. **Fungsional**: fitur bekerja sesuai spesifikasi
2. **Tested**: unit test untuk domain logic, widget test untuk UI, integration test untuk flow kritis
3. **Reviewed**: kamu sudah review kode sendiri, tidak ada TODO yang tertinggal
4. **Clean**: `flutter analyze` 0 warning, formatting konsisten (`dart format`)
5. **Documented**: kode yang complex punya komentar yang menjelaskan "kenapa" (bukan "apa")
6. **Committed**: branch sudah merged ke `develop` dengan descriptive commit messages
7. **CI Green**: semua GitHub Actions checks pass

---

_Dokumen ini adalah living document. Update sesuai progress aktual. Jangan takut adjust timeline — yang penting progress konsisten dan arsitektur tetap bersih._
