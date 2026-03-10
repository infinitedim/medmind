# MedMind — Rencana Pengembangan Detail

> Dokumen ini adalah panduan langkah-demi-langkah untuk membangun MedMind dari nol sampai siap rilis di Play Store.
> Ditulis untuk developer yang akan mengerjakan sendiri (solo dev).
>
> **Terakhir diperbarui:** 10 Maret 2026
> **Status Keseluruhan:** ~40% complete — Domain layer 100%, Data layer ~65% (foundation selesai, 6 repository implementations kosong), Presentation layer ~5% (routing/theming/shell selesai, semua page stub), Insight Engine 0%, ML Integration 0%, Testing ~15% (14 test files ada, unit tests jalan, widget tests basic).
>
> **Breakdown per layer:**
> | Layer | Progress | Detail |
> |-------|----------|--------|
> | Domain | 100% ✅ | 8 entities (Freezed), 6 repo interfaces, 16 use cases, 6 enums, failures, exceptions |
> | Data (Models/Sources) | 100% ✅ | Isar DB + AES-256-GCM, 4 @Collection + schemas, 3 datasources (511 LOC), 2 mappers |
> | Data (Repo Impls) | 0% ❌ | Semua 6 file kosong — **BLOCKER UTAMA** |
> | Presentation (Shell) | 100% ✅ | GoRouter, bottom nav, theme (360 LOC), typography, color tokens |
> | Presentation (Pages) | ~5% 🟡 | Hanya onboarding welcome selesai, sisanya stub |
> | Presentation (Providers) | 0% ❌ | Folder kosong, Riverpod belum dipakai |
> | Platform Channels | 100% ✅ | HealthConnectChannel (243 LOC), KeystoreChannel (193 LOC) |
> | Testing | ~15% 🟡 | 14 test files, 6 unit + 4 widget + 2 integration (smoke) |
> | DI Container | 95% 🟡 | Terkonfigurasi tapi `configureDependencies()` **belum dipanggil** di `main.dart` — BUG |
> | Insight Engine | 0% ❌ | `insight_engine.dart` kosong |
> | ML Integration | 0% ❌ | Semua file kosong, model `.tflite` 0 bytes |

---

## Daftar Isi

1. [Gambaran Arsitektur & Struktur Folder](#1-gambaran-arsitektur--struktur-folder)
2. [Phase 1: Foundation (Minggu 1–2)](#phase-1-foundation-minggu-12) — 🟡 ~80% selesai
3. [Phase 2: Smart Journaling (Minggu 3–4)](#phase-2-smart-journaling-minggu-34) — ❌ Belum dimulai
4. [Phase 3: Statistical Engine (Minggu 5–6)](#phase-3-statistical-engine-minggu-56) — ❌ Belum dimulai
5. [Phase 4: ML Integration (Minggu 7–9)](#phase-4-ml-integration-minggu-79) — ❌ Belum dimulai
6. [Phase 5: Visualization & Polish (Minggu 10–11)](#phase-5-visualization--polish-minggu-1011) — ❌ Belum dimulai
7. [Phase 6: Production (Minggu 12)](#phase-6-production-minggu-12) — ❌ Belum dimulai
8. [Daftar Risiko & Mitigasi](#daftar-risiko--mitigasi)
9. [Definisi "Selesai" (Definition of Done)](#definisi-selesai-definition-of-done)
10. [📍 LANGKAH SELANJUTNYA — Action Plan Detail](#-langkah-selanjutnya--action-plan-detail) — **MULAI DARI SINI**

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
│   │   │       ├── vitals_input.dart
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
   - vitalRecord: VitalRecord? (data vital harian — lihat entity #13)
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

13. **`VitalRecord`** — data vital harian (dari Health Connect atau input manual)

    ```
    Fields:
    - heartRate: int? (rata-rata bpm — derivasi dari readHeartRate() samples;
                       iterasi berikutnya bisa tambah heartRateMin + heartRateMax)
    - steps: int? (total langkah hari ini — dari readSteps() atau input manual)
    - weight: double? (berat badan dalam kg — manual input saja;
                       readWeight() belum ada di HealthConnectChannel)
    - spO2: double? (saturasi oksigen % — manual input saja;
                     readSpO2() belum ada di HealthConnectChannel)
    - date: DateTime (tanggal pencatatan vital)
    - source: VitalSource (enum: manual, healthConnect)
    ```

    Tambahkan `VitalSource` enum ke `lib/core/enum/enum_collection.dart`.
    Catatan: weight dan spO2 hanya bisa ditambahkan via manual input untuk saat ini.
    Semua fields nullable — entity tetap valid meski hanya sebagian fields terisi.

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
    branches: [development main]
  pull_request:
    branches: [development main]

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

- [x] Project Flutter bisa `flutter run` tanpa error ✅ _Selesai — project berjalan, SDK ^3.11.0, main.dart → ProviderScope → MedMindApp_
- [x] Folder structure Clean Architecture lengkap ✅ _Selesai — lib/app, core, domain, data, presentation, platform semua sudah ada_
- [ ] 🟡 Semua domain entity (13 entity) ter-generate dengan Freezed — _12 entity sudah selesai: JournalEntry, Symptom (+ SymptomLog + ExtractedSymptom), Medication (+ MedicationLog), SleepRecord, LifestyleFactor (+ LifestyleFactorLog), Insight, CorrelationResult, HealthScore. Semua `.freezed.dart` ter-generate. **Perlu ditambahkan:** `VitalRecord` entity (#13) + `VitalSource` enum + field `vitalRecord: VitalRecord?` di JournalEntry — sesuai perubahan Phase 2._
- [x] Repository interfaces terdefinisi ✅ _Selesai — 6 abstract class: JournalRepository, SymptomRepository, InsightRepository, MlRepository, HealthConnectRepository, UserPreferencesRepository_
- [x] CRUD use cases terdefinisi ✅ _Selesai — 16 use cases: 5 Journal, 4 Insight, 2 ML, 3 Health Connect, 2 Export_
- [x] Enum collections ✅ _Selesai — Mood, ActivityLevel, SymptomCategory, FactorType, InsightType, ScoreTrend di `enum_collection.dart`_
- [x] Error handling (Failure sealed class) ✅ _Selesai — 8 Failure types di `failures.dart`, pola `Either<Failure, T>` dari dartz dipakai konsisten_
- [x] GoRouter setup dengan 4 tab navigation ✅ _Selesai — ShellRoute + StatefulShellBranch untuk Home, Journal, Insights, Settings. Nested routes untuk journal/:id, settings sub-pages._
- [x] Route constants ✅ _Selesai — 12 route name constants di `route_names.dart`_
- [x] Material 3 tema (dark mode) ✅ _Selesai — Tema dark komprehensif (~200+ baris): ColorScheme, component themes (buttons, input, cards, dialogs, chips, sliders, tabs, dll.), app bar, bottom nav styling. Color tokens: Zinc, Teal, Cyan, Red, Amber, Emerald, dll._
- [x] Typography system ✅ _Selesai — Inter + JetBrains Mono via Google Fonts, skala: Display, H1-H3, Body, Small, Caption, Micro, Overline_
- [x] Bottom navigation shell ✅ _Selesai — Custom bottom nav 4 tab: Home, Journal, Insights, Settings, dengan teal highlight active state_
- [x] Onboarding page (screen 1) ✅ _Selesai — Brain icon, feature pills (On-device AI, 100% Private, Offline-first), CTA buttons. Desain profesional._
- [x] Android build config ✅ _Selesai — minSdk 26, Health Connect client 1.1.0-rc01, kotlinx-coroutines-android_
- [x] Dependencies di pubspec.yaml ✅ _Selesai — flutter_riverpod, isar, freezed, get_it, injectable, go_router, flutter_secure_storage, encrypt, dartz, google_fonts, lucide_icons, flutter_animate, dll._
- [x] ✅ Isar database setup dengan enkripsi AES-256-GCM field-level — _`isar_database.dart` (142 baris): `IsarDatabase.open(KeystoreChannel)` inisialisasi Isar dengan 4 schemas. `EncryptionHelper` wrap `encrypt` package — format `"<iv_base64>:<ciphertext_base64>"`. Catatan: enkripsi field-level (bukan `encryptionKey` Isar param — tidak tersedia di Isar 3.1.0+1)._
- [x] ✅ Isar schema generation tooling — _`tools/generate_isar_schemas.sh`: script isolated Flutter project untuk generate .g.dart tanpa konflik toolchain. Diperlukan karena `isar_generator` 3.x konflik dengan build_runner modern. Semua 4 `.g.dart` sudah di-commit. Regenerate setiap kali model fields berubah._
- [x] ✅ Encryption key management via Android Keystore — _`platform/keystore_channel.dart` fully implemented: two-layer key management (Android Keystore HSM + FlutterSecureStorage). Ter-register di DI container via `AppModule` (`@preResolve @lazySingleton Future<Isar> isar(KeystoreChannel)`)._
- [x] ✅ DI container (GetIt + Injectable) terkonfigurasi — _`injection.dart`: `@InjectableInit`, `configureDependencies()`, `AppModule` register `FlutterSecureStorage` + `Isar` (via `@preResolve`). `injection.config.dart` auto-generated: wires KeystoreChannel, FlutterSecureStorage, Isar, JournalLocalDataSource, SymptomLocalDataSource, InsightCacheDataSource, HealthConnectChannel._
- [ ] ❌ Riverpod providers bridge ke use cases — _`lib/presentation/providers/` directory ada tapi KOSONG. Riverpod hanya sebatas ProviderScope di main.dart. Ini blocker untuk Phase 2 UI._
- [x] ✅ Data Models (4 Isar @Collection + 4 generated schemas) — _`journal_entry_model.dart`: 5 `@Embedded` classes (SymptomLogEmbed, MedicationLogEmbed, SleepRecordEmbed, LifestyleFactorLogEmbed, ExtractedSymptomEmbed) + `@Collection JournalEntryModel`. `symptom_model.dart`, `medication_model.dart`, `insight_model.dart` semuanya implemented. Penting: model pakai domain enums langsung (`Mood`, `ActivityLevel`, `SymptomCategory`, `InsightType`) — tidak ada model-specific enum. Semua 4 `.g.dart` ter-generate via tools/generate_isar_schemas.sh._
- [x] ✅ Mappers (Entity ↔ Model) — _`journal_entry_mapper.dart`: bidirectional extensions JournalEntryModel↔JournalEntry + semua embedded object mappers. `symptom_mapper.dart`: bidirectional SymptomModel↔Symptom. Tidak ada enum conversion — karena model langsung pakai domain types, mapper assignment langsung (no boilerplate)._
- [ ] ❌ Repository implementation + integration tests — _Semua 6 file `_repository_impl.dart` KOSONG: journal, symptom, insight, ml, health_connect, user_preferences. Ini blocker langsung sebelum Riverpod providers bisa berfungsi._
- [x] ✅ Local data sources (3 datasources, total 511 baris) — _`journal_local_datasource.dart` (134 baris): full CRUD + watch stream + search + getByDateRange + count. `symptom_local_datasource.dart` (101 baris): CRUD + getByCategory(`SymptomCategory`) + getCustomSymptoms. `insight_cache_datasource.dart` (134 baris): CRUD + getUnread + getSaved + getByType(`InsightType`) + markAsRead + toggleSaved + evictOlderThan(days). Semua `@lazySingleton`._
- [x] ✅ Custom exceptions (9 tipe) — _`exceptions.dart`: `AppException` base + `DatabaseException`, `RecordNotFoundException`, `KeystoreException`, `MlInferenceException`, `ModelLoadException`, `HealthConnectUnavailableException`, `HealthConnectPermissionException`, `NetworkException`, `ServerException`, `CacheException`. Siap di-throw dari data layer dan di-catch di repository layer._
- [ ] ❌ Core utilities — _`date_utils.dart` dan `logger.dart` masih KOSONG. Ini dibutuhkan oleh data preparation service (Phase 3) dan journal list UI (Phase 2)._
- [ ] 🟡 Onboarding flow (3-4 screen) — _Hanya screen 1 (welcome) selesai. `SymptomSetupPage` parsial (progress "2 of 4", skeleton). Screen 3 & 4 belum ada._
- [ ] ❌ Biometric lock (opsional)
- [ ] ❌ CI/CD pipeline (GitHub Actions) — _Folder `.github/workflows/` belum ada._
- [x] 🟡 Test infrastructure + basic tests — _14 test files ada: 3 test helpers (`mock_repositories.dart` dengan 6 mocks via mocktail, `pump_app.dart` dengan ProviderScope helper, `test_fixtures.dart` dengan factory methods), 5 unit tests (failures_test + 4 journal use case tests — create, delete, get, search, update), 4 widget tests (app_bottom_nav, home_page, journal_entry_page, journal_list_page — basic structural tests), 2 integration test skeletons (smoke test aktif, full CRUD flow di-comment). **Belum tercapai target 5 unit + 2 integration yang fully passing—widget tests hanya verifikasi render, belum behavioral.**_
- [ ] ❌ `flutter analyze` 0 warnings — _Belum diverifikasi setelah semua perubahan._
- [ ] ❌ Git: branch `feature/foundation-setup` merged ke `develop`

> **Ringkasan Phase 1:** Domain layer (entities, repositories, use cases) 100% selesai. Arsitektur, routing, dan theming 100% selesai. Data layer foundation 100% selesai — Isar DB + AES-256-GCM enkripsi, 4 Isar @Collection models + 4 generated schemas, 3 local data sources (511 baris total), 2 mappers, 9 custom exceptions, DI container (GetIt + Injectable) semuanya sudah terimplementasi dan ter-wire. Test infrastructure sudah ada (14 file: unit tests + widget tests + integration stubs + helpers + fixtures). **Blocker sekarang:** 6 repository implementations (`_impl.dart`) masih kosong → Riverpod providers tidak bisa berfungsi → UI tidak bisa baca/tulis data. Plus: `configureDependencies()` BELUM dipanggil di `main.dart` (DI container ter-define tapi tidak diinisialisasi saat runtime — BUG); `date_utils.dart`, `logger.dart` kosong; onboarding screen 2-4 belum ada; biometric lock belum ada; tidak ada CI/CD pipeline.
>
> **⚠️ Architectural Decisions yang Berbeda dari Plan Awal:**
>
> | #   | Plan Awal                                                     | Implementasi Aktual                                                                        | Alasan                                                                    |
> | --- | ------------------------------------------------------------- | ------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------- |
> | 1   | Isar `encryptionKey` param untuk DB-level encryption          | Field-level AES-256-GCM via `encrypt` package (`EncryptionHelper` di `isar_database.dart`) | `encryptionKey` param tidak tersedia di Isar 3.1.0+1                      |
> | 2   | `isar_generator` via `build_runner` untuk generate schemas    | Isolated Flutter project via `tools/generate_isar_schemas.sh`                              | `isar_generator` 3.x konflik dengan `build_runner` modern                 |
> | 3   | Model-specific enums terpisah dari domain enums               | Model pakai domain enums langsung (`Mood`, `SymptomCategory`, dll.)                        | Mengurangi boilerplate — mapper assignment langsung tanpa enum conversion |
> | 4   | `mockito` + codegen untuk testing                             | `mocktail` (no codegen) — manual mock classes                                              | Lebih simpel, tidak butuh build_runner step tambahan                      |
> | 5   | `EncryptionKeyManager` via `FlutterSecureStorage` saja        | Two-layer: Android Keystore HSM + FlutterSecureStorage (`KeystoreChannel`)                 | Keamanan lebih kuat dengan hardware-backed master key                     |
> | 6   | Mapper pakai static methods (`JournalEntryMapper.toDomain()`) | Mapper pakai extension methods (`model.toDomain()`, `entity.toModel()`)                    | Lebih idiomatic Dart, chaining lebih natural                              |
>
> **⚠️ Known Issues/Bugs:**
>
> - `main.dart` TIDAK memanggil `configureDependencies()` — GetIt DI container tidak pernah diinisialisasi saat runtime
> - File typo: `secutiry_settings_page.dart` (seharusnya `security`)
> - File typo: `export_symtom_data.dart` (seharusnya `symptom`)
> - `HealthConnectChannel.requestPermissions()` ditandai `NOT_SUPPORTED via MethodChannel` — perlu pendekatan berbeda (Activity result)

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

4. **Vitals Input widget** (`lib/presentation/widgets/journal/vitals_input.dart`)
   - Tampilkan 4 metric: Heart Rate, Steps, Weight, SpO₂
   - Per-metric: import button (jika Health Connect tersedia) + manual input fallback
   - Import via `HealthConnectChannel.readHeartRate()` dan `readSteps()`
   - Weight dan SpO₂: manual input only (readWeight/readSpO2 belum ada di channel)
   - Import banner atas: "Import all from Health Connect" — hanya muncul jika `isAvailable() == true`
   - Semua fields opsional — form tetap bisa di-save tanpa vitals
   - State: `journalFormNotifier.updateVitals(VitalRecord)`

5. **Free Text Input**
   - Multi-line text field untuk catatan bebas
   - Placeholder: "How are you feeling today? Any triggers you noticed?"
   - Word count indicator
   - Nanti di Phase 4, text ini akan diproses NLP

**Deliverable:** Form entry lengkap. User bisa log semua aspek kesehatan termasuk vital signs.

#### Hari 13–14: Journal Entry Page Assembly & Save Flow

**Yang dikerjakan:**

1. **Assemble `JournalEntryPage`**
   - Tab atau accordion layout:
     - Tab 1: Mood + Symptoms (paling penting, default tab)
     - Tab 2: Sleep + Medications
     - Tab 3: Vitals (Health Connect import + manual fallback)
     - Tab 4: Lifestyle + Notes
   - `TabController` length = 4, `vsync: this` (via `TickerProviderStateMixin`)
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

- [ ] ❌ **Splash screen** (`SplashPage`) — handle biometric auth check, enkripsi init (`KeystoreChannel.getOrCreateKey()`), dan routing ke onboarding (user baru) atau home (user returning). Tambah `RouteNames.splash` + `authenticateWithBiometrics()` ke `KeystoreChannel`. Berbeda dari `flutter_native_splash` di Step 17.
- [ ] ❌ `VitalRecord` entity (#13) + `VitalSource` enum + `vitalRecord` field di `JournalEntry` — _Perlu dibuat di domain layer sebelum membangun `VitalsInput` widget._
- [ ] ❌ Mood picker dengan intensity slider — _Tidak ada widget di `presentation/widgets/`. `JournalEntryPage` hanya punya conditional logic New/Edit, belum ada form._
- [ ] ❌ Symptom selector dengan severity + multi-select
- [ ] ❌ Sleep input (bedtime, wake time, quality, disturbances)
- [ ] ❌ Medication logger (quick toggle + detail)
- [ ] ❌ Vitals input — Heart Rate (via HC) + Steps (via HC) + Weight (manual) + SpO₂ (manual); import banner; per-metric sync buttons
- [ ] ❌ Lifestyle factor logger (boolean/numeric/scale)
- [ ] ❌ Free text input
- [ ] ❌ Journal entry form: **4-tab layout** — "Mood & Symptoms" | "Sleep & Meds" | "Vitals" | "Lifestyle & Notes"
- [ ] ❌ Auto-save draft (30 detik interval)
- [ ] ❌ Journal list dengan lazy loading + search — _`JournalListPage` hanya stub: "Journal" text centered._
- [ ] ❌ Home page daily summary + streak counter — _`HomePage` hanya stub: "Home" text centered._
- [ ] ❌ Basic reminder notification system — _Package `flutter_local_notifications` belum di pubspec._
- [ ] ❌ Adaptive reminder analytics foundation
- [ ] ❌ Health Connect platform channel (Kotlin + Dart) — _`health_connect_channel.dart` sudah ada (bukan kosong) dengan `readHeartRate()`, `readSteps()`, `readSleepSessions()`. Perlu: `authenticateWithBiometrics()` untuk splash, dan native Kotlin plugin + Android manifest permissions._
- [ ] ❌ Health Connect settings page — _`HealthConnectSettingsPage` hanya stub kosong._
- [ ] ❌ Widget tests untuk semua input components (termasuk `VitalsInput`)
- [ ] ❌ Integration test: full journal CRUD flow
- [ ] ❌ Git: branch `feature/journal-crud` + `feature/health-connect` merged ke `develop`

> **Ringkasan Phase 2:** Belum dimulai sama sekali. Phase 1 harus diselesaikan dulu (khususnya Isar database, DI, dan repository implementations) sebelum bisa mulai Phase 2. Perubahan terbaru: tab journal entry diperluas menjadi 4 tabs (ditambah Vitals tab), `VitalRecord` entity baru, dan `SplashPage` sebagai screen pertama app.

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

- [ ] ❌ DataPreparationService: journal entries → time series matrix — _`insight_engine.dart` (satu-satunya file di domain/services/) KOSONG._
- [ ] ❌ CorrelationEngine: 4 metode (Pearson, Spearman, point-biserial, chi-square)
- [ ] ❌ P-value calculation
- [ ] ❌ Bonferroni correction
- [ ] ❌ Lagged correlation analysis (lag 0–3)
- [ ] ❌ AnomalyDetector: Z-score + moving average
- [ ] ❌ InsightGenerator: template-based NLG (Bahasa Indonesia + English)
- [ ] ❌ InsightEngine orchestrator
- [ ] ❌ HealthScore calculator
- [ ] ❌ Insight caching di Isar
- [ ] ❌ 100% unit test coverage untuk semua domain services
- [ ] ❌ Property-based tests untuk statistical correctness
- [ ] ❌ Git: branch `feature/insight-engine` merged ke `develop`

> **Ringkasan Phase 3:** Belum dimulai. Membutuhkan data dari Phase 2 (journal entries) untuk bisa diproses. Entity `CorrelationResult`, `HealthScore`, `Insight` sudah didefinisikan di domain, tapi belum ada service/logic yang mengisi mereka.

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
     - **Pro:** cepat development predictable behavior
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

- [ ] ❌ Minimal 2 TFLite models bundled (NLP + anomaly) — _File `.tflite` di `ml/models/` ada tapi KOSONG (0 bytes). Notebooks ada tapi belum dijalankan/trained. `tflite_flutter` package belum di pubspec.yaml._
- [ ] ❌ TFLite inference bekerja di isolate (tidak block UI) — _`tflite_engine.dart`, `isolate_pool_manager.dart` KOSONG._
- [ ] ❌ IsolatePoolManager: load, run, dispose
- [ ] ❌ MLModelManager: lifecycle management dengan AppLifecycleState
- [ ] ❌ SymptomExtractor: ML-based extraction — _`symptom_classifier.dart` KOSONG._
- [ ] ❌ RuleBasedSymptomExtractor: keyword-based fallback
- [ ] ❌ Graceful degradation: ML failure → fallback → still works
- [ ] ❌ NLP results terintegrasi ke journal save flow
- [ ] ❌ ML anomaly score terintegrasi ke Insight Engine — _`anomaly_model.dart`, `correlation_model.dart` KOSONG._
- [ ] ❌ Suggestion dialog untuk medium-confidence extractions
- [ ] ❌ ML integration tests (known input → expected output)
- [ ] ❌ Performance test: inference < 500ms on mid-range device
- [ ] ❌ Git: branch `feature/tflite-integration` merged ke `develop`

> **Ringkasan Phase 4:** Infrastruktur Python ML (requirements.txt, notebook scaffolds) sudah ada. Tapi model belum di-train, TFLite belum di-bundle, dan semua file integrasi Flutter–ML KOSONG. Prerequisites: Phase 3 insight engine harus jalan dulu.

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

- [ ] ❌ Correlation heatmap (CustomPainter) dengan tap interactivity — _Tidak ada widget files di `presentation/widgets/` atau `presentation/pages/insights/widgets/`._
- [ ] ❌ Symptom timeline (CustomPainter) dengan scroll + viewport culling
- [ ] ❌ Health score ring animation (animated, gradient, glow)
- [ ] ❌ Insights page: score + tabs + insight cards + empty state — _`InsightsPage` stub: "Insights" text centered._
- [ ] ❌ PDF report generator — _Package `pdf` dan `printing` belum di pubspec._
- [ ] ❌ CSV export
- [ ] ❌ Export page UI with share — _`ExportPage` stub kosong._
- [ ] ❌ 5 golden tests
- [ ] ❌ E2E integration test (30 entries → insights → export)
- [ ] ❌ Performance profiling documented
- [ ] ❌ Dark mode review — _Tema dark sudah implementasi kuat, tapi belum ada page yang memanfaatkannya secara penuh._
- [ ] ❌ Accessibility audit (semantic labels)
- [ ] ❌ Git: branches `feature/custom-visualizations` + `feature/export` merged ke `develop`

> **Ringkasan Phase 5:** Belum dimulai. Tapi fondasi UI (tema, warna, tipografi) sudah sangat solid — siap dipakai begitu data layer dan insight engine selesai.

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

- [ ] ❌ Sentry error monitoring terpasang dengan PII scrubbing — _Package `sentry_flutter` belum di pubspec._
- [ ] ❌ App size < 30MB
- [ ] ❌ Cold start < 3 detik
- [ ] ❌ 0 jank frames di scrolling
- [ ] ❌ App signing configured
- [ ] ❌ App icon & splash screen
- [ ] ❌ Store listing (screenshots, description, privacy policy)
- [ ] ❌ Release build berhasil
- [ ] ❌ Tested di 3+ device berbeda
- [ ] ❌ All tests pass di CI (tinggal lihat berapa test count)
- [ ] ❌ Code coverage >= 80%
- [ ] ❌ `develop` merged ke `main`
- [ ] ❌ Tagged v1.0.0
- [ ] ❌ Published ke Play Store

> **Ringkasan Phase 6:** Belum dimulai. Sepenuhnya bergantung pada penyelesaian Phase 1–5.

---

## 📍 LANGKAH SELANJUTNYA — Action Plan Detail

> Berdasarkan analisis codebase per 8 Maret 2026:
>
> - **Yang sudah selesai:** Domain layer lengkap (entities, repositories interfaces, use cases), arsitektur/routing/theming, onboarding screen 1. **BARU:** Data layer foundation lengkap — Isar DB + AES-256-GCM enkripsi (`isar_database.dart`), 4 Isar @Collection models + schemas (via `tools/generate_isar_schemas.sh`), 3 local data sources (511 baris), 2 mappers, 9 custom exceptions, DI container (`injection.dart` + `injection.config.dart`).
> - **Bottleneck utama saat ini:** 6 repository implementations (`_impl.dart`) masih kosong → use cases tidak bisa dieksekusi → Riverpod providers tidak bisa berfungsi → UI buta data
> - **Catatan arsitektur:** Model Isar menggunakan domain enums langsung (`Mood`, `SymptomCategory`, `InsightType`, `ActivityLevel`) — tidak ada model-specific enum. Mapper assignment langsung tanpa konversi.
> - **Prinsip:** Setiap step di bawah menghasilkan sesuatu yang bisa dijalankan dan diverifikasi sebelum lanjut ke step berikutnya.

### STEP 1: Selesaikan Core Utilities & Error Handling — 🟡 SEBAGIAN SELESAI

> **Status per 8 Maret 2026:** `exceptions.dart` ✅ selesai (9 typed exceptions). `date_utils.dart` ❌ masih kosong. `logger.dart` ❌ masih kosong. Prioritaskan date_utils dan logger sebelum lanjut ke STEP 4.

**Konteks:** File-file utility dasar (`logger.dart`, `date_utils.dart`, `exceptions.dart`) — `exceptions.dart` sudah selesai, tapi `date_utils.dart` dan `logger.dart` masih kosong. Ini dibutuhkan oleh hampir semua layer di atasnya — data sources perlu logging, repository implementation perlu exception handling, presentation perlu date formatting.

**Sub-tasks:**

1. **`lib/core/utils/logger.dart`** — Inisialisasi Logger instance dari package `logger` (sudah ada di pubspec). Buat singleton `AppLogger` dengan method `d()`, `i()`, `w()`, `e()` yang wrap Logger. Ini akan dipakai di repository implementations dan data sources untuk debugging.

2. **`lib/core/utils/date_utils.dart`** — Implementasi helpers:
   - `DateTime toStartOfDay()` — strip waktu, return awal hari (00:00:00)
   - `DateTime toEndOfDay()` — return akhir hari (23:59:59)
   - `String formatReadable(DateTime)` — human-readable ("Senin, 6 Mar 2026" via `intl`)
   - `String formatRelative(DateTime)` — "Hari ini", "Kemarin", "3 hari lalu"
   - `bool isSameDay(DateTime a, DateTime b)`
   - `DateTimeRange lastNDays(int n)` — helper untuk query data
   - Dibutuhkan oleh: data preparation service (Phase 3), journal list UI (Phase 2), insight engine

3. **`lib/core/errors/exceptions.dart`** — Buat custom exceptions yang di-throw oleh data layer dan di-catch oleh repository implementations untuk dikonversi jadi `Failure`:
   - `DatabaseException` — gagal baca/tulis Isar
   - `EncryptionException` — gagal encrypt/decrypt
   - `ModelParseException` — gagal convert model ↔ entity
   - `MLInferenceException` — TFLite model error
   - `HealthConnectException` — platform channel error
   - Setiap exception punya field `message` dan optional `stackTrace`

**Verifikasi:** `dart analyze` bersih. Import di file lain tidak error.

**Output step ini → input step berikutnya:** Logger siap dipakai di semua data source. Date utils siap untuk formatting & query. Exceptions siap di-throw dari data layer dan di-catch di repository layer.

---

### STEP 2: Setup Dependency Injection (GetIt + Injectable) — 🟡 95% SELESAI

> **Status per 8 Maret 2026:** `injection.dart` ✅ `injection.config.dart` ✅ `main.dart` ⚠️ **BELUM MEMANGGIL `configureDependencies()`** — DI container terdefinisi tapi tidak pernah diinisialisasi saat runtime. Ini adalah BUG yang harus diperbaiki sebelum lanjut. DI wires: KeystoreChannel, FlutterSecureStorage, Isar, JournalLocalDataSource, SymptomLocalDataSource, InsightCacheDataSource, HealthConnectChannel. Catatan: `core_providers.dart` (Riverpod bridge) belum dibuat — itu bagian dari STEP 5.

**Konteks:** ~~`lib/core/di/injection.dart` kosong.~~ DI sudah terkonfigurasi lengkap. Package `get_it` dan `injectable` sudah ada di pubspec dan sudah di-wire.

**Sub-tasks:**

1. **`lib/core/di/injection.dart`** — Implementasi setup:

   ```dart
   final getIt = GetIt.instance;

   @InjectableInit()
   Future<void> configureDependencies() async => getIt.init();
   ```

2. **Jalankan `dart run build_runner build --delete-conflicting-outputs`** — Generate `injection.config.dart`. Pada titik ini file-nya akan kosong karena belum ada class yang di-annotate `@injectable`, tapi file harus ter-generate tanpa error.

3. **Update `lib/main.dart`** — Panggil `await configureDependencies()` sebelum `runApp()`. Ini memastikan semua dependency siap sebelum app start:

   ```dart
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await configureDependencies();
     runApp(const ProviderScope(child: MedMindApp()));
   }
   ```

4. **Buat file `lib/presentation/providers/core_providers.dart`** — Bridge Riverpod ↔ GetIt:
   ```dart
   // Provider yang expose GetIt instances ke Riverpod widget tree
   // Ini menghubungkan Presentation layer (Riverpod) dengan dependency graph (GetIt)
   ```
   Definisikan provider placeholder untuk `JournalRepository`, `SymptomRepository`, dll. yang resolve dari `getIt`. Mereka akan mulai berfungsi setelah Step 4 (repository implementations di-register).

**Verifikasi:** `flutter run` tetap berjalan. `injection.config.dart` ter-generate. `configureDependencies()` dipanggil di `main()`.

**Output step ini → input step berikutnya:** DI container siap. Setiap class yang di-annotate `@injectable` atau `@lazySingleton` otomatis ter-register. Riverpod providers bisa resolve instances dari GetIt.

---

### STEP 3: Implementasi Isar Database + Enkripsi + Data Models — ✅ SELESAI

> **Status per 8 Maret 2026:** Semua sub-tasks selesai. `isar_database.dart` (142 baris, AES-256-GCM field-level encryption). 4 Isar @Collection models + 4 `.g.dart` schemas (di-generate via `tools/generate_isar_schemas.sh` — isolated project karena isar_generator 3.x konflik toolchain). 3 local datasources (511 baris total). 2 mappers. `keystore_channel.dart` sudah pre-exist dan ter-wire ke DI. Catatan penting: model pakai domain enums langsung — tidak ada model-specific enums.

**Konteks:** ~~Isar sudah di pubspec tapi belum ada schema.~~ SELESAI. `isar_database.dart`, semua models, semua datasources, dan semua mappers sudah terimplementasi.

**Dependency dari Step 2:** ✅ DI container sudah aktif.

**Sub-tasks:**

1. **`lib/data/models/journal_entry_model.dart`** — Buat Isar collection model:
   - Annotasi `@Collection()` + `Id` field
   - `@Index(unique: true)` pada `uid` (UUID dari domain entity)
   - `@Index()` pada `date` untuk query by date range
   - Embedded objects: `SymptomLogEmbed`, `MedicationLogEmbed`, `SleepRecordEmbed`, `LifestyleFactorLogEmbed`, `ExtractedSymptomEmbed` — masing-masing pakai `@Embedded()`
   - Enum fields pakai `@Enumerated(EnumType.name)`
   - Semua fields harus _mirror_ domain entity `JournalEntry`, tapi dalam format yang Isar bisa store

2. **`lib/data/models/symptom_model.dart`** — Isar collection untuk master data `Symptom`:
   - `uid`, `name`, `category` (indexed), `icon`, `isCustom`
   - Pre-populate dengan default symptoms saat first launch (via migration/seed)

3. **Buat file baru `lib/data/models/insight_model.dart`** — Isar collection untuk cached insights:
   - Mirror domain entity `Insight` — `uid`, `type`, `title`, `description`, `confidence`, `relatedVariables`, `generatedAt`, `isRead`, `isSaved`

4. **`lib/data/datasources/local/isar_database.dart`** — Database initialization:
   - `static Future<Isar> initialize(String? encryptionKey)` — buka Isar dengan semua schemas
   - Param `encryptionKey` untuk AES-256 (nullable untuk dev/testing tanpa enkripsi)
   - Register sebagai `@lazySingleton` di DI container
   - Pakai `path_provider` untuk mendapatkan documents directory

5. **`lib/platform/keystore_channel.dart`** — Encryption key management:
   - Pakai `FlutterSecureStorage` (sudah di pubspec) untuk store key
   - `getOrCreateKey()` — generate random 32-byte key jika belum ada, simpan di secure storage, return key
   - `destroyKey()` — hapus key (cryptographic erasure untuk account deletion)
   - Register sebagai `@lazySingleton`

6. **Jalankan `dart run build_runner build --delete-conflicting-outputs`** — Generate Isar schema files (`.g.dart`)

7. **Update DI setup** — Register Isar instance di `configureDependencies()`:
   - Baca/generate encryption key → buka Isar → register Isar instance di GetIt
   - Ini harus ASYNC dan dilakukan sebelum `runApp()`

**Verifikasi:** `flutter run` berhasil. Isar instance terbuat di device/emulator. Cek: `getIt<Isar>()` return instance yang valid. Log: "Isar database initialized at /path".

**Output step ini → input step berikutnya:** Database Isar aktif + terenkripsi. Model/schema siap dipakai oleh data sources. Step 4 akan menggunakan Isar instance ini untuk CRUD operations.

---

### STEP 4: Implementasi Mappers + Data Sources + Repository Implementations — 🟡 SEBAGIAN SELESAI

> **Status per 8 Maret 2026:** Mappers ✅ selesai (journal_entry_mapper, symptom_mapper). Data Sources ✅ selesai (journal, symptom, insight_cache — 511 baris total). **Repository Implementations ❌ semua 6 file kosong** — ini yang perlu dikerjakan sekarang.

**Konteks:** Mappers dan data sources sudah selesai. Yang tersisa adalah 6 repository implementations yang menghubungkan use cases (domain) dengan data sources (data layer).

**Dependency dari Step 3:** ✅ Isar instance terenkripsi aktif dan ter-register di GetIt. Model schemas ter-generate. ✅ Mappers sudah tersedia. ✅ Data sources sudah ter-register di DI.

**Sub-tasks (kerjakan berurutan karena saling tergantung):**

**4a. Mappers:**

1. **`lib/data/mappers/journal_entry_mapper.dart`**:
   - `static JournalEntry toDomain(JournalEntryModel model)` — convert semua field termasuk nested objects (SymptomLogEmbed → SymptomLog, dll.)
   - `static JournalEntryModel toModel(JournalEntry entity)` — reverse conversion
   - **Test kunci:** buat round-trip test: `entity → model → entity` harus identik

2. **`lib/data/mappers/symptom_mapper.dart`**:
   - `static Symptom toDomain(SymptomModel model)`
   - `static SymptomModel toModel(Symptom entity)`

**4b. Local Data Sources (semua di-annotate `@lazySingleton` untuk DI):**

3. **`lib/data/datasources/local/journal_local_datasource.dart`**:
   - Constructor: inject `Isar` instance
   - `create(JournalEntryModel)` → `isar.writeTxn(() => isar.journalEntryModels.put(model))`
   - `query({startDate, endDate, limit, offset})` → filtered query, sorted by date desc
   - `getById(String uid)` → query by uid index
   - `update(JournalEntryModel)` → update dalam transaction
   - `delete(String uid)` → hapus by uid
   - `search(String query)` → full-text search di freeText field
   - `watchAll({startDate, endDate})` → `isar.journalEntryModels.where().watch()`

4. **`lib/data/datasources/local/symptom_local_datasource.dart`**:
   - CRUD untuk master data symptoms
   - `getSelected()` → symptoms yang user pilih saat onboarding
   - `setSelected(List<String> ids)` — simpan pilihan user
   - Pre-seed default symptoms (headache, nausea, fatigue, dll.) saat first launch

5. **`lib/data/datasources/local/insight_cache_datasource.dart`**:
   - Save/load cached insight reports
   - TTL-based invalidation (24 jam)

**4c. Repository Implementations (annotate `@LazySingleton(as: XxxRepository)`):**

6. **`lib/data/repositories/journal_repository_impl.dart`**:
   - Inject `JournalLocalDataSource`
   - Setiap method: panggil data source → pakai mapper untuk convert → wrap result dalam `Right()` atau `Left(DatabaseFailure)` jika error
   - Implementasi semua 7 methods dari `JournalRepository` interface

7. **`lib/data/repositories/symptom_repository_impl.dart`**:
   - Inject `SymptomLocalDataSource`
   - Full CRUD + `getSelected`/`setSelected`

8. **`lib/data/repositories/insight_repository_impl.dart`**:
   - Inject `InsightCacheDataSource`
   - Save, load, mark read, toggle saved

9. **`lib/data/repositories/user_preferences_repository_impl.dart`**:
   - Inject `FlutterSecureStorage` atau `SharedPreferences`
   - Manage: biometric on/off, onboarding complete, reminder time, theme mode, tracked symptom IDs
   - **Tambahkan `shared_preferences` ke pubspec.yaml** jika belum ada

10. **`lib/data/repositories/ml_repository_impl.dart`** — Sementara return stub/placeholder (ML belum ready, tapi interface harus ter-satisfy untuk DI). Return `Left(MLFailure('ML models not yet initialized'))` untuk semua methods.

11. **`lib/data/repositories/health_connect_repository_impl.dart`** — Sementara return stub (Health Connect belum ready). Return `Left(HealthConnectFailure('Not yet implemented'))`.

**4d. Jalankan build_runner & register semua di DI:**

12. Jalankan `dart run build_runner build --delete-conflicting-outputs`
13. Pastikan `injection.config.dart` sekarang berisi registration untuk semua data sources dan repository implementations
14. Verify: `getIt<JournalRepository>()` return `JournalRepositoryImpl` instance

**Verifikasi:** Tulis 1 integration test:

- Create journal entry → read back → verify field match
- Search → verify results
- Delete → verify gone
- `flutter test` pass

**Output step ini → input step berikutnya:** Seluruh data pipeline berfungsi (Entity ↔ Model ↔ Database). Use cases dari domain layer sekarang bisa benar-benar dieksekusi. Step 5 akan menghubungkan ini ke UI melalui Riverpod providers.

---

### STEP 5: Wiring Riverpod Providers + State Management

**Konteks:** Use cases sudah ada (domain), repository implementations sudah aktif di DI (Step 4). Sekarang perlu bridge ke Presentation layer. Tanpa providers, UI tidak bisa baca/tulis data.

**Dependency dari Step 4:** Semua repository implementations ter-register dan berfungsi di GetIt. DI resolve berhasil.

**Sub-tasks:**

1. **Buat `lib/presentation/providers/journal_providers.dart`**:
   - `journalRepositoryProvider` — Riverpod `Provider` yang resolve dari `getIt<JournalRepository>()`
   - `journalEntriesProvider` — `FutureProvider.family<List<JournalEntry>, DateRange?>` yang panggil `getEntries()`
   - `journalEntryProvider(String id)` — load single entry by ID
   - `journalFormNotifier` — `StateNotifier` atau `Notifier` yang manage form state (mood, symptoms, sleep, medications, lifestyle, freeText) dan method `submit()` yang panggil `CreateJournalEntry` use case
   - `journalSearchProvider(String query)` — untuk search

2. **Buat `lib/presentation/providers/symptom_providers.dart`**:
   - `allSymptomsProvider` — load semua symptoms dari repo
   - `selectedSymptomsProvider` — symptoms yang user track
   - `symptomSetupNotifier` — manage state untuk onboarding symptom setup page

3. **Buat `lib/presentation/providers/preference_providers.dart`**:
   - `onboardingCompleteProvider` — cek apakah user sudah selesai onboarding
   - `biometricEnabledProvider`
   - `reminderTimeProvider`
   - `themeModeProvider`

4. **Update `lib/app/app.dart`** — Gunakan `onboardingCompleteProvider` untuk tentukan initial route:
   - Kalau belum onboarding → route ke `/onboarding`
   - Kalau sudah → route ke `/` (home)

5. **Update `lib/app/routes/app_router.dart`** — Tambahkan redirect logic berdasarkan onboarding status

**Verifikasi:** `flutter run` → app detect first launch → arahkan ke onboarding. State berubah saat interact. Console log menunjukkan providers resolving correctly.

**Output step ini → input step berikutnya:** UI layer sekarang bisa baca dan tulis data. Step 6 menggunakan providers ini untuk membangun form journal yang fungsional.

---

### STEP 6: Splash Screen + Selesaikan Onboarding Flow (Screen 2–4) & First Launch

**Konteks:** Screen 1 (welcome) sudah selesai dan terlihat profesional. `SymptomSetupPage` ada tapi parsial. Perlu 2-3 screen lagi. Step 5 sudah menyiapkan `symptomSetupNotifier` dan `onboardingCompleteProvider`.

**Dependency dari Step 5:** Provider `selectedSymptomsProvider`, `symptomSetupNotifier`, `onboardingCompleteProvider` sudah aktif dan terhubung ke database.

**Sub-tasks:**

0. **Buat `lib/presentation/pages/splash/splash_page.dart`** — screen pertama setiap kali app dibuka:
   - Widget: `SplashPage` extends `ConsumerWidget`
   - Route: tambah `RouteNames.splash = '/splash'` ke `route_names.dart`; set `initialLocation: RouteNames.splash` di `AppRouter`
   - **Async init chain** (tanpa `Future.delayed` — durasi = waktu nyata async work):
     1. `KeystoreChannel.getOrCreateKey()` — inisialisasi enkripsi
     2. `UserPreferencesRepository.isOnboardingComplete()` — jika false → `context.go(RouteNames.symptomSetup)`; stop
     3. `UserPreferencesRepository.isBiometricEnabled()` — jika true → tampilkan biometric prompt
     4. Navigasi ke `RouteNames.home` setelah semua berhasil
   - **Biometric**: via `KeystoreChannel.authenticateWithBiometrics()` (tambahkan method baru ke channel — memanggil Android `BiometricPrompt` via MethodChannel; tidak pakai package `local_auth` yang tidak ada di pubspec)
   - **Error state**: jika `getOrCreateKey()` gagal → tampilkan error + "Coba Lagi" (retry sequence) + "Hapus Data & Mulai Ulang" (panggil `destroyKey()` lalu navigate ke onboarding)
   - **Berbeda dari `flutter_native_splash` di Step 17** — ini adalah Flutter app screen yang berjalan di dalam Dart runtime, bukan native launch image dari OS
   - Visual: zinc950 bg, logo center, `CircularProgressIndicator` saat initializing, fingerprint icon saat `awaitingBiometric`

1. **`lib/presentation/pages/onboarding/symptom_setup_page.dart`** — Lengkapi implementasi:
   - Load daftar default symptoms dari `allSymptomsProvider`
   - Grid/wrap chips: user tap untuk toggle select
   - Search bar untuk filter symptoms
   - Tombol "+" untuk tambah custom symptom
   - Counter "X gejala dipilih"
   - Continue button → save selected symptoms via `symptomSetupNotifier` → navigate ke screen 3

2. **Buat `lib/presentation/pages/onboarding/lifestyle_setup_page.dart`** (screen 3):
   - Mirip symptom setup tapi untuk lifestyle factors (Caffeine, Alcohol, Exercise, Water, Screen Time, dll.)
   - Toggle yang mana ingin di-track
   - Save pilihan ke `UserPreferencesRepository`
   - Continue → screen 4

3. **Buat `lib/presentation/pages/onboarding/security_setup_page.dart`** (screen 4):
   - Toggle biometric lock on/off
   - Penjelasan singkat tentang enkripsi data
   - Tombol "Mulai Journaling!" → markOnboardingComplete() → navigate ke `/` (home)
   - Skip button untuk skip biometric setup

4. **Update routing**: Pastikan onboarding flow linear: screen 1 → 2 → 3 → 4 → home. Back button di screen 2+ kembali ke screen sebelumnya (bukan keluar onboarding).

5. **Seed default symptoms** — Saat pertama kali Isar dibuka (atau saat `configureDependencies()`), seed 30-50 default symptoms ke database jika tabel masih kosong. Kategorisasi: neurological (migraine, vertigo), digestive (nausea, bloating), respiratory (cough, congestion), dll.

**Verifikasi:** Fresh install → onboarding 4 screen → pilih symptoms → pilih lifestyle → setup security → masuk home. Kill app → reopen → langsung masuk home (skip onboarding).

**Output step ini → input step berikutnya:** User bisa setup tracker mereka. Master data symptoms tersimpan di database. App tahu apa yang harus ditampilkan di journal form (Step 7).

---

### STEP 7: Journal Entry Form — Semua Input Widgets

**Konteks:** Sekarang user sudah onboarding, symptoms tersimpan, database aktif. Saatnya bangun form journal yang lengkap — ini adalah fitur inti MedMind. Step 6 output → kita tahu symptoms dan lifestyle factors apa yang user pilih.

**Dependency dari Step 6:** Selected symptoms & lifestyle factors tersimpan. Journal form notifier dari Step 5 siap. `JournalRepository` berfungsi.

**Sub-tasks:**

1. **`lib/presentation/widgets/journal/mood_picker.dart`**:
   - 5 emoji buttons (😊 🙂 😐 😟 😰) → tap untuk pilih
   - Setelah pilih → intensity slider muncul (1-10) di bawahnya
   - Default intensity: 5
   - Animasi transisi (pakai `flutter_animate` yang sudah di pubspec)
   - State: update `journalFormNotifier.updateMood()`

2. **`lib/presentation/widgets/journal/symptom_selector.dart`**:
   - Tampilkan chips dari `selectedSymptomsProvider` (symptoms yang user pilih saat onboarding)
   - Tap chip → mini-form expand: severity slider (1-10) + optional notes text field
   - Multi-select: bisa log beberapa gejala sekaligus
   - Tombol "+" → dialog search & add gejala tambahan
   - State: `journalFormNotifier.addSymptom()` / `removeSymptom()`

3. **`lib/presentation/widgets/journal/sleep_input.dart`**:
   - Bedtime picker (TimePicker) + wake time picker
   - Auto-calculate & display duration ("7h 30m")
   - Sleep quality slider (1-10)
   - Disturbance counter (+/- stepper, default 0)
   - State: `journalFormNotifier.updateSleep()`

4. **`lib/presentation/widgets/journal/medication_input.dart`**:
   - List obat user (dari setup/settings, atau in-line add)
   - Per obat: toggle taken ✅ / not taken ❌
   - Tap → detail: waktu minum, dosis
   - State: `journalFormNotifier.updateMedication()`

5. **`lib/presentation/widgets/journal/vitals_input.dart`**:
   - 4 metric sections: Heart Rate (avg bpm), Steps, Weight (kg), SpO₂ (%)
   - Import dari Health Connect via `HealthConnectChannel.readHeartRate()` + `readSteps()`
   - Weight & SpO₂: manual input only — `readWeight()` dan `readSpO2()` belum ada di channel
   - Tampilkan import banner ("Import all vitals") hanya jika `isAvailable() == true`
   - Per-metric sync button + manual fallback text fields
   - HC availability dicek sekali saat `journalEntryPage` init
   - State: `journalFormNotifier.updateVitals(VitalRecord)`
   - Semua fields opsional — form valid tanpa vitals

6. **`lib/presentation/widgets/journal/lifestyle_input.dart`**:
   - Render berdasarkan `FactorType` dari entity:
     - `boolean` → toggle switch ("Consumed caffeine? Yes/No")
     - `numeric` → number input + unit label ("Water: \_\_\_ glasses")
     - `scale` → slider 1-10 ("Stress level")
   - State: `journalFormNotifier.updateLifestyleFactor()`

7. **`lib/presentation/widgets/journal/free_text_input.dart`**:
   - Multi-line text field
   - Placeholder: "How are you feeling today? Any triggers you noticed?"
   - Word count di bawah
   - State: `journalFormNotifier.updateFreeText()`

**Verifikasi:** Buat widget test untuk setiap input widget: interact → verify form state berubah. Visual review di emulator.

**Output step ini → input step berikutnya:** Semua 7 input widgets siap. Step 8 merakit mereka menjadi halaman JournalEntryPage penuh dengan tab layout 4 tabs + save flow.

---

### STEP 8: Journal Entry Page Assembly + Save Flow + List Page

**Konteks:** Semua input widgets dari Step 7 sudah tersedia. Sekarang rangkai menjadi halaman lengkap dengan tab/section layout, save logic, dan list page.

**Dependency dari Step 7:** Mood picker, symptom selector, sleep input, medication input, lifestyle input, free text input — semua sudah berfungsi dan terhubung ke `journalFormNotifier`.

**Sub-tasks:**

1. **`lib/presentation/pages/journal/journal_entry_page.dart`** — Full implementation:
   - **Tab/section layout (4 tabs):**
     - Tab 1: Mood + Symptoms (default, paling penting)
     - Tab 2: Sleep + Medications
     - Tab 3: Vitals (Health Connect import + manual fallback)
     - Tab 4: Lifestyle + Notes
   - `TabController(length: 4, vsync: this)` — require `TickerProviderStateMixin`
   - **Date picker** di AppBar — default hari ini, bisa ganti
   - **Edit mode:** Jika `entryId != null`, load existing entry dari `journalEntryProvider(id)`, pre-fill form
   - **Submit button:** Validasi → buat `JournalEntry` entity → panggil `CreateJournalEntry` / `UpdateJournalEntry` use case via notifier → navigate back ke list + show success snackbar
   - **Auto-save draft:** Timer 30 detik → simpan draft ke Isar (tambahkan field `isDraft` ke model)
   - **Unsaved changes guard:** `WillPopScope` / `PopScope` → dialog "Simpan sebagai draft?" jika ada perubahan

2. **`lib/presentation/pages/journal/journal_list_page.dart`** — Full implementation:
   - List dari `journalEntriesProvider`
   - Card UI per entry: tanggal, mood emoji, symptom badges, snippet dari freeText
   - Infinite scroll / lazy loading (pagination via offset)
   - Swipe to delete → undo snackbar (panggil `DeleteJournalEntry` use case)
   - Tap card → navigate ke `/journal/:id` (edit)
   - FAB → navigate ke `/journal/new`
   - Empty state: "Belum ada entri. Mulai journaling hari ini!" dengan CTA button
   - Search bar → `SearchJournalEntries` use case

3. **Update `lib/presentation/pages/home/home_page.dart`**:
   - Cek apakah hari ini sudah ada entry → tampilkan summary card (mood, symptom count, sleep duration)
   - Kalau belum → CTA "Log hari ini" + quick-log buttons (mood-only quick entry)
   - Streak counter: hitung consecutive days with entries
   - Greeting berdasarkan waktu hari ("Selamat pagi, ...")

4. **Loading & error states:**
   - Implement `lib/presentation/shared/loading_indicator.dart` — custom shimmer atau circular progress
   - Implement `lib/presentation/shared/error_widget.dart` — error message + retry button

**Verifikasi:**

- Integration test: create entry → appear in list → tap → see details → edit → save → verify update → delete → verify gone
- Draft auto-save: create entry → isi partial → kill app → reopen → draft masih ada
- `flutter run` → manual walkthrough full flow

**Output step ini → input step berikutnya:** Full journaling flow berfungsi. User bisa buat, lihat, edit, dan hapus entries. Data tersimpan terenkripsi. Step 9 membangun reminder agar user konsisten logging.

---

### STEP 9: Basic Reminder System

**Konteks:** Journaling flow sudah lengkap (Step 8). Sekarang bangun reminder supaya user konsisten. Reminder system sederhana dulu — adaptive analysis nanti.

**Dependency dari Step 8:** User bisa create journal entries. `UserPreferencesRepository` bisa save/load reminder time.

**Sub-tasks:**

1. **Tambahkan di pubspec.yaml:**

   ```yaml
   flutter_local_notifications: ^17.x.x
   ```

2. **Buat `lib/data/datasources/local/notification_service.dart`**:
   - Initialize `FlutterLocalNotificationsPlugin`
   - `scheduleDailyReminder(TimeOfDay time)` — schedule repeating notification
   - `cancelReminder()` — cancel scheduled notification
   - Notification tap → deep link ke journal/new (via GoRouter)

3. **Implement `lib/presentation/pages/settings/reminder_settings_page.dart`**:
   - Toggle reminder on/off
   - Time picker untuk pilih waktu reminder (default 21:00)
   - Save ke `UserPreferencesRepository`
   - Preview: "Kamu akan diingatkan setiap hari jam 21:00"

4. **Implement `lib/presentation/pages/settings/settings_page.dart`**:
   - List tile untuk setiap sub-setting: Reminders, Security, Health Connect, Export
   - Navigate ke masing-masing sub-page
   - Version info di bottom

**Verifikasi:** Set reminder → tunggu → notification muncul → tap → app opens di journal/new page. Toggle off → notification stop.

**Output step ini → input step berikutnya:** User diingatkan untuk journal. App mulai akumulasi data. Step 10 membangun fondasi analisis data (insight engine).

---

### STEP 10: Statistical Insight Engine (Domain Services)

**Konteks:** Dengan Step 8 selesai, user mulai akumulasi journal entries. Sekarang bangun "otak" MedMind — pure Dart statistical engine yang olah data menjadi insights. Ini semua di domain layer — tidak tergantung package eksternal.

**Dependency dari Step 8:** `JournalRepository` berfungsi, bisa query entries by date range. Domain entities `CorrelationResult`, `HealthScore`, `Insight` sudah terdefinisi dari awal.

**Sub-tasks:**

1. **Buat `lib/domain/services/data_preparation_service.dart`**:
   - `TimeSeriesMatrix prepareMatrix(List<JournalEntry> entries)`:
     - Sort entries by date
     - Extract setiap variabel menjadi kolom: `mood_score`, `sleep_hours`, `sleep_quality`, `symptom_{name}_severity`, `med_{name}_taken`, `factor_{name}`, dll.
     - Fill missing dates dengan null rows
     - Normalize: boolean → 0/1, enum → int, severity → 0-10
   - `List<VariablePair> identifyCorrelationCandidates(matrix, {minDataPoints: 14})`
   - **Buat value class `TimeSeriesMatrix`**: `dates`, `columns (Map<String, List<double?>>)`, `variableTypes`, `getLaggedColumn(name, lag)`

2. **Buat `lib/domain/services/correlation_engine.dart`**:
   - `pearsonCorrelation(x, y)` → CorrelationResult (r, p-value)
   - `spearmanCorrelation(x, y)` — rank-based, untuk ordinal data
   - `pointBiserialCorrelation(binary, continuous)` — binary × continuous
   - `chiSquareTest(x, y)` — binary × binary
   - `riskRatio(exposure, outcome)` — relative risk calculation
   - `bonferroniThreshold(numberOfTests)` — multiple testing correction
   - **P-value:** Implementasi standard normal CDF (Abramowitz & Stegun approximation). Untuk n > 30, t-distribution ≈ normal distribution — cukup akurat.
   - **WAJIB: Unit test coverage 100%** — test dengan data yang hasilnya diketahui pasti

3. **Buat `lib/domain/services/anomaly_detector.dart`**:
   - `detectZScoreAnomalies(matrix, {threshold: 2.0, baselineWindow: 30})` — flag hari yang >2 standard deviations dari mean
   - `detectMovingAverageAnomalies(matrix, {window: 7, threshold: 1.5})` — moving average + MAD
   - Helper: `_mean()`, `_standardDeviation()`, `_median()`, `_medianAbsoluteDeviation()`

4. **Buat `lib/domain/services/insight_generator.dart`**:
   - Template-based NLG (Natural Language Generation)
   - `generateCorrelationInsight(CorrelationResult)` → `Insight` entity
   - `generateAnomalyInsight(AnomalyResult)` → `Insight` entity
   - Variasi template supaya tidak robotik (minimal 3 template per tipe)
   - Human-readable variable names: `sleep_hours` → "durasi tidur", `symptom_migraine_severity` → "tingkat migraine"
   - **Dual language:** Bahasa Indonesia primary, English secondary

5. **Implementasi `lib/domain/services/insight_engine.dart`** (saat ini KOSONG):
   - Orchestrator: `analyzeAll(List<JournalEntry> entries)` → `InsightReport`
   - Pipeline: prepare matrix → run correlations (lag 0-3) → run anomaly detection → generate insights → deduplicate & rank by confidence → calculate health score → return report
   - `_calculateHealthScore(matrix, anomalies)` — composite weighted score (mood trend, symptom frequency, sleep quality, anomaly count, medication compliance) → normalize 0-100

6. **Buat value classes:** `InsightReport`, `AnomalyResult`, `TimeSeriesMatrix`, `VariablePair`

**Verifikasi:**

- Unit test `CorrelationEngine`: perfect positive (r=1), perfect negative (r=-1), no correlation (r≈0), known textbook results. Property tests: |r| ≤ 1, symmetry, p-value 0-1.
- Unit test `AnomalyDetector`: injected outlier detected, normal data → no anomalies
- Integration test: 30+ fixture journal entries → `InsightEngine.analyzeAll()` → returns ranked insights & health score
- `dart analyze` bersih

**Output step ini → input step berikutnya:** InsightEngine berfungsi end-to-end. Bisa feed data journal → dapat ranked insights + health score. Step 11 cache results dan expose ke UI.

---

### STEP 11: Insight Caching + Riverpod Wiring untuk Insights

**Konteks:** Insight engine berjalan (Step 10), tapi analysis bisa lambat kalau banyak data. Perlu caching agar UI responsive. Plus konek ke Riverpod supaya insights muncul di Insights page.

**Dependency dari Step 10:** `InsightEngine.analyzeAll()` berfungsi, return `InsightReport`.

**Sub-tasks:**

1. **`lib/data/datasources/local/insight_cache_datasource.dart`** — Full implementation:
   - Save `InsightReport` ke Isar (convert masing-masing insight ke `InsightModel`)
   - Load cached insights
   - Check staleness: `isStale()` → true jika >24 jam sejak last analysis ATAU ada entry baru sejak last analysis
   - Clear cache

2. **`lib/data/repositories/insight_repository_impl.dart`** — Full implementation:
   - `getInsights()`: cek cache → kalau stale, re-analyze → save to cache → return
   - `saveInsight()`, `markAsRead()`, `toggleSaved()`, `getHealthScore()`, `saveHealthScore()`
   - Semua wrapped dalam `Either<Failure, T>`

3. **Buat `lib/presentation/providers/insight_providers.dart`**:
   - `insightEngineProvider` — resolve InsightEngine dari DI
   - `insightReportProvider` — `FutureProvider` yang load insights (dari cache atau fresh analysis)
   - `healthScoreProvider` — expose HealthScore ke UI
   - `topInsightsProvider` — top 5 insights sorted by confidence

4. **Register `InsightEngine` dan sub-services di DI** — `DataPreparationService`, `CorrelationEngine`, `AnomalyDetector`, `InsightGenerator` semua `@lazySingleton`

**Verifikasi:** `insightReportProvider` resolves. Mock/test: buat entries → load insights → cek cache hit on second load.

**Output step ini → input step berikutnya:** Insights tersedia via Riverpod. Step 12 membangun UI page untuk menampilkannya.

---

### STEP 12: Insights Page UI + Health Score Ring + Visualization

**Konteks:** Data insights tersedia via providers (Step 11). Sekarang bangun UI yang menampilkannya — health score ring, insight cards, dan minimal 1 custom visualization.

**Dependency dari Step 11:** `insightReportProvider`, `healthScoreProvider`, `topInsightsProvider` aktif dan return data.

**Sub-tasks:**

1. **`lib/presentation/pages/insights/widgets/health_score_ring.dart`** — CustomPainter:
   - Animated circular progress (score 0-100)
   - Gradient arc: red (0-30), yellow (30-60), green (60-100)
   - Glow effect di ujung arc
   - Score number di center dengan trend arrow (↑ improving, → stable, ↓ declining)
   - `AnimationController` + `CurvedAnimation` (1.5s, easeOutCubic)

2. **`lib/presentation/pages/insights/widgets/insight_card.dart`**:
   - Card: icon (correlation/anomaly/trend), title, description, confidence badge
   - Read/unread indicator (bold vs regular)
   - Tap → expand detail
   - Bookmark toggle (isSaved)

3. **`lib/presentation/pages/insights/widgets/correlation_heatmap.dart`** — CustomPainter:
   - NxN grid of correlation cells
   - Color: red (negative) ← white (zero) → blue (positive)
   - Row/column labels (short variable names)
   - Tap cell → show detail insight for that variable pair
   - Pinch to zoom jika banyak variabel

4. **`lib/presentation/pages/insights/insights_page.dart`** — Full implementation:
   - Top: HealthScoreRing (prominent)
   - Tab bar: "Insights" | "Heatmap" | "Timeline"
   - "Insights" tab: ranked list of InsightCards
   - "Heatmap" tab: CorrelationHeatmap
   - "Timeline" tab: (placeholder dulu, atau simple date-based list) — symptom timeline CustomPainter bisa di Step 14 jika ada waktu
   - **Empty state:** Jika < 14 hari data: progress bar "Journal X hari lagi untuk insight pertamamu!"
   - **Loading state:** Shimmer saat analysis berjalan
   - **Error state:** "Ada masalah saat analisis. Coba lagi?" + retry button

**Verifikasi:** `flutter run` → navigate ke Insights tab → health score ring animates → insight cards appear → tap card expands. Heatmap renders dengan data korelasi.

**Output step ini → input step berikutnya:** Fitur inti MedMind (journal + insights) sudah complete. Step 13-17 adalah polish, enhanced features, dan production prep.

---

### STEP 13: Export Pipeline (PDF + CSV)

**Konteks:** User sudah punya data journal dan insights. Sekarang bangun cara export data — penting untuk user yang mau share ke dokter, dan untuk portfolio showcase.

**Dependency dari Step 8 & 11:** Journal entries dan insight reports tersedia.

**Sub-tasks:**

1. **Tambahkan di pubspec.yaml:**

   ```yaml
   pdf: ^3.10.x
   printing: ^5.12.x
   share_plus: ^10.x.x
   ```

2. **Buat `lib/data/datasources/local/pdf_generator.dart`**:
   - `generatePdf({period, entries, insights})` → `Uint8List` (PDF bytes)
   - Sections: summary, symptom frequency table, medication compliance, sleep analysis, top insights, correlation summary
   - Layout: professional multi-page report

3. **Buat `lib/data/datasources/local/csv_exporter.dart`**:
   - `exportEntries(entries)` → String (CSV content)
   - Columns: date, mood, mood_intensity, per-symptom severity, sleep_hours, sleep_quality, per-medication taken, per-lifestyle value

4. **Implement `lib/presentation/pages/settings/export_page.dart`**:
   - Date range picker (last 30, 90 days, custom)
   - Format picker (PDF / CSV)
   - Generate button → loading → share via `share_plus`

**Verifikasi:** Generate PDF → open → verify content. Generate CSV → open in spreadsheet → verify columns and data.

**Output step ini → input step berikutnya:** Export fungsional. App sudah MVP-worthy. Langkah selanjutnya = Health Connect (enhancement) atau ML (enhancement).

---

### STEP 14: Health Connect Integration (Platform Channel)

**Konteks:** Enhancement feature. Android Health Connect bisa auto-import sleep & step data ke journal. Dependency `androidx.health.connect:connect-client` sudah di `android/app/build.gradle.kts`.

**Dependency dari Step 8:** Journal flow sudah berfungsi untuk menerima imported data.

**Sub-tasks:**

1. **Android manifest:** Tambahkan permissions `READ_SLEEP`, `READ_STEPS`, `READ_HEART_RATE`

2. **Buat `android/app/src/main/kotlin/.../health_connect/HealthConnectPlugin.kt`**:
   - `isAvailable()` → cek Health Connect terinstal
   - `requestPermissions()` → request data access
   - `readSleepSessions(startTime, endTime)` → List<Map> sleep data
   - `readSteps(startTime, endTime)` → step count
   - Error handling: try/catch semua Health Connect calls

3. **Implement `lib/platform/health_connect_channel.dart`**:
   - MethodChannel `com.yourblooo.medmind/health_connect`
   - Dart methods mirror Kotlin: `isAvailable()`, `requestPermissions()`, `readSleepSessions()`, `readSteps()`

4. **Implement `lib/data/repositories/health_connect_repository_impl.dart`**:
   - Wrap channel calls dengan error handling → `Either<Failure, T>`
   - When HC not available → return gracefully, don't crash

5. **Implement settings page `health_connect_settings_page.dart`**:
   - Toggle on/off
   - Connection status
   - Data types being synced
   - Last sync timestamp

6. **Auto-import in journal flow:** Saat user buka new journal entry → jika HC enabled, pre-fill sleep data dari Health Connect (user can override)

**Verifikasi:** Test pada device dengan Health Connect installed. Import sleep data → muncul di journal form.

---

### STEP 15: ML Model Training + TFLite Integration

**Konteks:** Enhancement. ML model untuk NLP symptom extraction dari free text dan anomaly detection. Pure statistical engine (Step 10) sudah berfungsi — ML adalah lapisan tambahan.

**Dependency dari Step 10:** Insight engine berfungsi. ML fallback strategy: kalau ML gagal, statistical methods tetap berjalan.

**Sub-tasks:**

1. **Python side (ml/notebooks/):**
   - Train NLP symptom extraction model (rule-based + small classifier → TFLite, ~500KB)
   - Train anomaly detection model (Isolation Forest → TFLite, ~1MB)
   - Export ke `ml/models/*.tflite`

2. **Tambahkan `tflite_flutter: ^0.10.x` di pubspec.yaml dan asset paths di flutter section**

3. **Implement `lib/data/datasources/ml/tflite_engine.dart`**:
   - Load model from assets
   - `runInference(List<double> input)` → `List<double>` output
   - Dispose on lifecycle change

4. **Implement `lib/data/datasources/ml/symptom_classifier.dart`**:
   - Tokenize free text → vector → TFLite inference → extract symptoms
   - Rule-based fallback: keyword dictionary (ID + EN) for when ML confidence low

5. **Implement `lib/data/datasources/ml/anomaly_model.dart`**:
   - Daily feature vector → anomaly score (0-1)
   - Complement statistical Z-score detector

6. **Implement `lib/data/datasources/ml/isolate_pool_manager.dart`**:
   - Run inference in separate isolate (don't block UI)
   - Manage model lifecycle (load lazy, dispose on background)

7. **Implement `lib/data/repositories/ml_repository_impl.dart`** — Replace stubs with real implementations:
   - `extractSymptomsFromText()` → ML-first, rule-based fallback
   - `predictAnomaly()` → ML score as additional signal

8. **Wire into journal save flow:**
   - After save → background: run NLP on free text
   - High confidence (>0.85): auto-add extracted symptoms
   - Medium confidence (0.5-0.85): show suggestion dialog
   - Low confidence (<0.5): skip

**Verifikasi:** ML inference < 500ms. NLP extracts "sakit kepala" → "headache" with confidence > 0.6. Fallback works when model is unavailable.

---

### STEP 16: Comprehensive Testing + Settings Pages

**Konteks:** Core fitur sudah jalan. Sekarang stabilkan dengan testing menyeluruh dan lengkapi settings pages yang masih kosong.

**Sub-tasks:**

1. **Implement `lib/presentation/pages/settings/secutiry_settings_page.dart`**:
   - Toggle biometric lock
   - Change PIN (kalau pakai PIN fallback)
   - "Delete all data" button (dengan double confirmation + destroy encryption key)

2. **Unit tests (minimal 20):**
   - Correlation engine: semua 4 metode × 3 skenario = 12 tests
   - Anomaly detector: 3 tests
   - Data preparation service: 3 tests
   - Mapper round-trip: 2 tests

3. **Widget tests (minimal 10):**
   - Mood picker, symptom selector, sleep input, medication input, lifestyle input
   - Journal entry page: submit flow
   - Journal list page: empty state, card display
   - Insights page: score ring, insight cards
   - Onboarding flow

4. **Integration tests (minimal 3):**
   - Full journal CRUD cycle
   - 30 entries → insight generation → verify insights
   - Export: entries → PDF → verify generated

5. **CI/CD Pipeline** — Buat `.github/workflows/ci.yml`:
   - analyze → test → build APK
   - Trigger on push to develop/main

**Verifikasi:** `flutter test` → all green. `flutter analyze` → 0 warnings. CI pipeline runs successfully.

---

### STEP 17: Production Polish & Play Store

**Konteks:** Fitur lengkap, tests passing. Final polish untuk production release.

**Sub-tasks:**

1. **Error monitoring:** Tambahkan `sentry_flutter`, setup PII scrubbing (JANGAN kirim health data ke Sentry)
2. **Performance:**
   - App size audit: `flutter build apk --analyze-size` (target < 30MB)
   - Cold start profiling (target < 3s)
   - Lazy-load TFLite models (bukan startup)
3. **App icon & splash screen:** Pakai `flutter_launcher_icons` + `flutter_native_splash`
4. **Store listing:** Screenshots, description, privacy policy
5. **App signing:** Generate keystore, configure `build.gradle` signing config
6. **Release build:** `flutter build appbundle --release`
7. **Internal testing:** Upload ke Play Store internal testing track, test di 3+ devices
8. **Fix issues found** → merge develop → main → tag v1.0.0 → publish

---

### 🗺️ Dependency Flow Antar Steps

```
Step 1 (Utils/Errors)
  ↓
Step 2 (DI Container)
  ↓
Step 3 (Isar + Enkripsi + Models)
  ↓
Step 4 (Mappers + DataSources + Repo Impls)  ←── Ini BLOCKER terbesar saat ini
  ↓
Step 5 (Riverpod Providers)
  ↓
Step 6 (Onboarding Complete)
  ↓
Step 7 (Journal Form Widgets)
  ↓
Step 8 (Journal Pages + Save Flow)  ←── MVP minimum mulai dari sini
  ↓
Step 9 (Reminders)          Step 10 (Insight Engine)
  ↓                            ↓
  │                         Step 11 (Insight Caching + Providers)
  │                            ↓
  │                         Step 12 (Insights UI + Visualizations)
  ↓                            ↓
Step 13 (Export)    ←──────────┘
  ↓
Step 14 (Health Connect)     ← Enhancement, bisa parallel
Step 15 (ML Integration)     ← Enhancement, bisa parallel
  ↓
Step 16 (Testing + Settings)
  ↓
Step 17 (Production)
```

**Critical path ke MVP:** Step 1 → 2 → 3 → 4 → 5 → 6 → 7 → 8 → 10 → 11 → 12 → 13
**Nice to have:** Step 9, 14, 15 (bisa ditambahkan kapan saja setelah Step 8)

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
