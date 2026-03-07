<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat&logo=flutter" />
  <img src="https://img.shields.io/badge/Dart-3.11+-0175C2?style=flat&logo=dart" />
  <img src="https://img.shields.io/badge/Platform-Android-3DDC84?style=flat&logo=android" />
  <img src="https://img.shields.io/badge/AI-On--device%20TFLite-FF6F00?style=flat&logo=tensorflow" />
  <img src="https://img.shields.io/badge/Storage-Isar%20AES--256-6366F1?style=flat" />
  <img src="https://img.shields.io/badge/Status-In%20Development-yellow?style=flat" />
</p>

<h1 align="center">🧠 MedMind</h1>
<p align="center"><em>Track symptoms. Discover patterns. Own your health data.</em></p>

---

## What is MedMind?

MedMind is a **privacy-first health journaling app** for Android that helps you understand your own health patterns without ever exposing your data to a server. You log daily health data — symptoms, sleep, medications, mood, and lifestyle factors — and the app runs statistical and AI/ML analysis entirely on-device to surface actionable insights like:

- _"You are 2.8× more likely to get a migraine on days you sleep under 6 hours."_
- _"Your anxiety score is consistently higher on days following alcohol consumption."_
- _"Unusual fatigue pattern detected — this is the 3rd recurrence in 2 weeks."_

Every byte of your health data lives only on your device, encrypted at rest with AES-256 backed by the Android hardware Keystore.

---

## Core Features

| Feature                   | Description                                                                                                                                          |
| ------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| 📓 **Daily Journal**      | Log mood (5-scale), symptoms (severity 0–10), sleep, medications, and lifestyle factors (caffeine, exercise, stress, etc.) across a 3-tab entry form |
| 🤖 **On-device AI**       | NLP symptom extraction from free text and anomaly detection via TensorFlow Lite models — no cloud, no API                                            |
| 📊 **Correlation Engine** | Pure-Dart statistical engine (Pearson, Spearman, Point-Biserial, Chi-Square) with Bonferroni correction, supporting lag analysis up to 3 days        |
| 🔍 **Insight Generation** | Human-readable health insights with confidence scores derived from statistical significance (p-value)                                                |
| 🏥 **Health Connect**     | Optional auto-import of sleep, steps, and heart-rate data from Android Health Connect via a custom platform channel                                  |
| 📤 **Data Export**        | Export your full health history as PDF or CSV                                                                                                        |
| 🔒 **Privacy by Design**  | AES-256-GCM encrypted Isar database, hardware-backed key management (AndroidKeyStore), zero network requests for health data                         |
| 📴 **Offline-first**      | Fully functional without internet — journaling, insights, and ML inference all run locally                                                           |

---

## Tech Stack

### Application

| Layer                     | Technology                                                 |
| ------------------------- | ---------------------------------------------------------- |
| Framework                 | Flutter 3.x / Dart 3.11+                                   |
| State Management          | Riverpod 3 + `riverpod_annotation` (code-gen)              |
| Navigation                | GoRouter 17                                                |
| Local Database            | Isar 2 (NoSQL, AES-256 encrypted)                          |
| Dependency Injection      | GetIt + Injectable (compile-time safe)                     |
| Domain Models             | Freezed (immutable, union types)                           |
| Functional Error Handling | Dartz (`Either<Failure, T>`)                               |
| UI                        | Material 3 · Google Fonts · Lucide Icons · flutter_animate |
| Encryption (extra layer)  | `encrypt` package (AES) + `flutter_secure_storage`         |

### ML / Python (Training Pipeline)

| Library                   | Purpose                                                  |
| ------------------------- | -------------------------------------------------------- |
| TensorFlow 2.21 + Keras 3 | Model training and TFLite export                         |
| scikit-learn 1.8          | `IsolationForest` (anomaly), `TfidfVectorizer` (NLP)     |
| NLTK 3.9                  | Indonesian + English text tokenisation and preprocessing |
| NumPy / Pandas / SciPy    | Data wrangling and statistical validation                |
| FlatBuffers 25            | TFLite model serialisation compatibility                 |
| JupyterLab 4              | Interactive training notebooks                           |

### Native Android

| Component                | Purpose                                                         |
| ------------------------ | --------------------------------------------------------------- |
| `KeystorePlugin.kt`      | Hardware-backed AES-256-GCM master key via `AndroidKeyStore`    |
| `HealthConnectPlugin.kt` | Sleep / steps / heart-rate import via `androidx.health.connect` |
| `MainActivity.kt`        | `configureFlutterEngine` — registers both MethodChannel plugins |

---

## Architecture

MedMind follows **Clean Architecture** with a strict unidirectional dependency rule:

```
Presentation  →  Domain  ←  Data
```

The Domain layer has **zero external dependencies** — only pure Dart. All infrastructure (Isar, TFLite, Health Connect, Keystore) lives in the Data layer behind repository interfaces, making it trivial to swap implementations or mock in tests.

```
lib/
├── app/                      # MaterialApp, GoRouter, Material 3 theme
│   ├── routes/
│   └── theme/                # AppColors, AppTypography tokens
│
├── core/                     # App-wide utilities (no business logic)
│   ├── constants/
│   ├── di/                   # GetIt + Injectable setup
│   ├── enum/
│   ├── errors/               # Failure sealed class hierarchy
│   ├── extensions/
│   └── utils/
│
├── domain/                   # ★ Pure Dart — no Flutter, no packages
│   ├── entities/             # Freezed value objects
│   │   ├── journal_entry.dart
│   │   ├── symptom.dart
│   │   ├── medication.dart
│   │   ├── mood.dart
│   │   ├── sleep_record.dart
│   │   ├── lifestyle_factor.dart
│   │   ├── insight.dart
│   │   ├── health_score.dart
│   │   └── correlation_result.dart
│   ├── repositories/         # Abstract interfaces
│   ├── usecases/             # One class per use-case (journal, insight, ml, export)
│   └── services/             # InsightEngine (correlation + anomaly orchestrator)
│
├── data/                     # Infrastructure implementations
│   ├── datasources/
│   │   ├── local/            # Isar CRUD (journal, symptom, insight cache)
│   │   ├── ml/               # TFLite engine, isolate pool, classifiers
│   │   ├── sensor/           # Activity sensor
│   │   └── remote/           # Firebase auth (future)
│   ├── mappers/              # Entity ↔ Model bidirectional converters
│   ├── models/               # Isar-annotated DTOs (json_serializable)
│   └── repositories/         # Concrete implementations of domain interfaces
│
├── platform/                 # Flutter ↔ Native platform channels (Dart side)
│   ├── keystore_channel.dart      # Two-layer encryption key management
│   └── health_connect_channel.dart # Sleep / steps / heart-rate import
│
└── presentation/
    ├── pages/
    │   ├── home/             # Dashboard, health score ring, daily summary
    │   ├── journal/          # Journal list + 3-tab entry form
    │   ├── insights/         # Insight cards, correlation heatmap, timeline
    │   ├── settings/         # Privacy, Health Connect, export, reminders
    │   └── onboarding/       # Welcome flow + symptom setup
    ├── providers/            # Riverpod AsyncNotifiers and providers
    └── shared/               # Reusable widgets, bottom nav
```

---

## Privacy & Security

Security is a first-class concern, not an afterthought.

### Two-layer encryption key architecture

```
┌────────────────────────────────────────────────┐
│  Layer 1 — AndroidKeyStore (hardware-backed)   │
│  AES-256-GCM master key                        │
│  Never leaves secure hardware                  │
└───────────────────┬────────────────────────────┘
                    │ encrypt / decrypt
┌───────────────────▼────────────────────────────┐
│  Layer 2 — Random 32-byte DB key               │
│  Stored as AES-GCM ciphertext + IV in          │
│  EncryptedSharedPreferences                    │
└───────────────────┬────────────────────────────┘
                    │ open database
┌───────────────────▼────────────────────────────┐
│  Isar database — AES-256 at rest               │
│  All journal data, insights, health scores     │
└────────────────────────────────────────────────┘
```

- The raw database key **never exists on disk unencrypted** — it lives in memory only for the duration of a single app launch
- `KeystoreChannel.destroyKey()` deletes the hardware master key AND the stored ciphertext — making the database permanently unreadable (cryptographic erasure for account deletion)
- Health data is **never sent to any server** — all ML inference, correlation analysis, and insight generation run on-device

---

## ML Models

Three TFLite models are bundled with the app (`ml/models/`):

| Model                 | File                            | Architecture                          | Input                                                   | Output                        |
| --------------------- | ------------------------------- | ------------------------------------- | ------------------------------------------------------- | ----------------------------- |
| NLP Symptom Extractor | `npl_symptom_v1.tflite`         | TF-IDF + shallow classifier (~500 KB) | Free-text journal note                                  | Symptom tags + severity       |
| Anomaly Detector      | `anomaly_detection_v1.tflite`   | Isolation Forest (~1 MB)              | Daily feature vector (sleep, mood, symptom count, etc.) | Anomaly score 0–1             |
| Correlation Helper    | `symptom_correlation_v1.tflite` | Optional enhancement                  | Feature pairs                                           | Non-linear correlation signal |

> The statistical correlation engine (Pearson / Spearman / Point-Biserial / Chi-Square with Bonferroni correction) is implemented in **pure Dart** and runs without the ML models. TFLite models are an additional signal layer on top.

Training notebooks are in `ml/notebooks/`. See `ml/requirements.txt` for the full Python dependency list.

---

## Getting Started

### Prerequisites

- Flutter SDK `≥ 3.x` (stable channel)
- Android SDK with target API **34+**
- Java 17
- Python `≥ 3.11` (for ML training only — not required to run the app)

### Clone & run

```bash
git clone https://github.com/yourblooo/medmind.git
cd medmind

# Install Flutter dependencies
flutter pub get

# Generate code (Isar schemas, Freezed models, Riverpod providers, Injectable)
dart run build_runner build --delete-conflicting-outputs

# Run on a connected Android device or emulator
flutter run
```

### ML training (optional)

```bash
cd ml

python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

# Launch notebooks
jupyter lab
```

Open any notebook in `ml/notebooks/` and run all cells to train and export the TFLite models to `ml/models/`.

---

## Development Status

> Last updated: **March 2026** — ~30–35% complete

| Phase                                | Scope                                                                               | Status         |
| ------------------------------------ | ----------------------------------------------------------------------------------- | -------------- |
| **Phase 1** — Foundation             | Clean Architecture scaffold, domain entities, DI, routing, theme, platform channels | 🟡 ~60%        |
| **Phase 2** — Smart Journaling       | Journal entry form, CRUD flow, reminder system, Health Connect import               | ❌ Not started |
| **Phase 3** — Statistical Engine     | Correlation engine, anomaly detector, insight generator, health score               | ❌ Not started |
| **Phase 4** — ML Integration         | TFLite inference pipeline, isolate pool, NLP + anomaly model integration            | ❌ Not started |
| **Phase 5** — Visualization & Polish | Correlation heatmap, symptom timeline, animations, export (PDF/CSV)                 | ❌ Not started |
| **Phase 6** — Production             | Testing, Play Store build, signing, privacy policy                                  | ❌ Not started |

### What's implemented

- ✅ Complete domain layer — all entities, repository interfaces, use-cases, `InsightEngine` service skeleton
- ✅ App routing (GoRouter), Material 3 theme system, color/typography tokens
- ✅ Dependency injection setup (GetIt + Injectable)
- ✅ `KeystorePlugin.kt` + `KeystoreChannel` — full hardware-backed encryption key bridge
- ✅ `HealthConnectPlugin.kt` + `HealthConnectChannel` — Health Connect data import bridge
- ✅ `MainActivity.kt` — both platform channels registered
- ✅ Onboarding page scaffold
- ✅ ML training requirements + notebook scaffolds

### What remains

- 🔲 Isar database initialization with encrypted key
- 🔲 Data source + repository implementations (journal, symptom, insight)
- 🔲 Journal entry form (3-tab UI + save flow)
- 🔲 Insights page (health score ring, correlation heatmap, insight cards)
- 🔲 ML model training + TFLite inference pipeline
- 🔲 Export (PDF/CSV), settings pages, reminder system
- 🔲 Tests (unit, widget, integration)

---

## Roadmap

```
march 2026   ──▶  Phase 1 complete (database + DI + repositories)
april 2026   ──▶  Phase 2 complete (journaling flow end-to-end)
may 2026     ──▶  Phase 3 complete (statistical insight engine)
june 2026    ──▶  Phase 4-5 complete (ML + visualization)
july 2026    ──▶  Play Store release
```

---

## Contributing

This is a solo-dev project. If you found a bug or have a suggestion, feel free to open an issue.

---

## License

This project is private and not yet licensed for public distribution. All rights reserved.
