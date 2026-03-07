// health_connect_channel.dart
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

/// Dart-side bridge to the native Android Health Connect plugin.
///
/// Channel: com.yourblooo.medmind/health_connect
///
/// Methods exposed by HealthConnectPlugin.kt:
///   isAvailable     → bool
///   readSleepSessions(startTime, endTime) → List<Map>
///   readSteps(startTime, endTime)         → int
///   readHeartRate(startTime, endTime)     → List<Map>
///
/// Note on requestPermissions:
///   Health Connect requires an Android ActivityResult callback that cannot be
///   dispatched through a plain MethodChannel. Until a dedicated
///   ActivityResultPlugin is wired up, call this channel method to obtain a
///   "NOT_SUPPORTED" error and handle permissions via the Android Settings
///   deep-link approach on the Flutter side.
@lazySingleton
class HealthConnectChannel {
  static const _channel = MethodChannel('com.yourblooo.medmind/health_connect');

  // ---------------------------------------------------------------------------
  // Availability & permissions
  // ---------------------------------------------------------------------------

  /// Returns `true` when the Health Connect SDK is available on this device.
  ///
  /// Requires Android 9+ with the Health Connect app installed (or Android 14+
  /// where it ships as part of the OS).
  Future<bool> isAvailable() async {
    try {
      return await _channel.invokeMethod<bool>('isAvailable') ?? false;
    } on PlatformException catch (e) {
      throw HealthConnectException(e.code, e.message ?? 'isAvailable failed');
    }
  }

  /// Attempts to request Health Connect permissions.
  ///
  /// **Currently not supported via MethodChannel** — the native side returns a
  /// `NOT_SUPPORTED` error. Use an Android Settings deep-link on the Flutter
  /// side to guide the user to the Health Connect permissions screen.
  Future<bool> requestPermissions() async {
    try {
      return await _channel.invokeMethod<bool>('requestPermissions') ?? false;
    } on PlatformException catch (e) {
      if (e.code == 'NOT_SUPPORTED') return false;
      throw HealthConnectException(
        e.code,
        e.message ?? 'requestPermissions failed',
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Data reads
  // ---------------------------------------------------------------------------

  /// Reads all sleep sessions in [startTime]–[endTime] from Health Connect.
  ///
  /// Each [SleepSession] contains the bed/wake times plus granular [SleepStage]
  /// entries (AWAKE, LIGHT, DEEP, REM, etc.) that the repository layer can use
  /// to compute a quality score and disturbance count for [SleepRecord].
  Future<List<SleepSession>> readSleepSessions({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      final raw = await _channel
          .invokeMethod<List<Object?>>('readSleepSessions', {
            'startTime': startTime.toUtc().toIso8601String(),
            'endTime': endTime.toUtc().toIso8601String(),
          });
      if (raw == null) return [];
      return raw
          .whereType<Map<Object?, Object?>>()
          .map(SleepSession.fromMap)
          .toList();
    } on PlatformException catch (e) {
      throw HealthConnectException(
        e.code,
        e.message ?? 'readSleepSessions failed',
      );
    }
  }

  /// Returns the total step count in [startTime]–[endTime].
  ///
  /// The repository layer is responsible for splitting a longer period into
  /// day-sized windows and calling this method once per day to build the
  /// `Map<DateTime, int>` expected by [HealthConnectRepository.importStepData].
  Future<int> readSteps({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      final total = await _channel.invokeMethod<int>('readSteps', {
        'startTime': startTime.toUtc().toIso8601String(),
        'endTime': endTime.toUtc().toIso8601String(),
      });
      return total ?? 0;
    } on PlatformException catch (e) {
      throw HealthConnectException(e.code, e.message ?? 'readSteps failed');
    }
  }

  /// Returns all heart-rate samples in [startTime]–[endTime].
  ///
  /// Each [HeartRateSample] has a [bpm] value and the exact [time] it was
  /// recorded. Useful for computing resting / average heart rate per day.
  Future<List<HeartRateSample>> readHeartRate({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      final raw = await _channel.invokeMethod<List<Object?>>('readHeartRate', {
        'startTime': startTime.toUtc().toIso8601String(),
        'endTime': endTime.toUtc().toIso8601String(),
      });
      if (raw == null) return [];
      return raw
          .whereType<Map<Object?, Object?>>()
          .map(HeartRateSample.fromMap)
          .toList();
    } on PlatformException catch (e) {
      throw HealthConnectException(e.code, e.message ?? 'readHeartRate failed');
    }
  }
}

// ---------------------------------------------------------------------------
// DTOs — transport-layer data models
// ---------------------------------------------------------------------------

/// Raw sleep session as returned by HealthConnectPlugin.kt.
///
/// Maps to [SleepRecord] domain entity at the repository layer:
///   bedTime  → startTime
///   wakeTime → endTime
///   quality  → derived from stages (DEEP minutes / total minutes * 10)
///   disturbances → count of AWAKE stages
class SleepSession {
  const SleepSession({
    required this.startTime,
    required this.endTime,
    required this.stages,
  });

  final DateTime startTime;
  final DateTime endTime;
  final List<SleepStage> stages;

  factory SleepSession.fromMap(Map<Object?, Object?> map) {
    final stagesRaw = map['stages'];
    final stages = stagesRaw is List
        ? stagesRaw
              .whereType<Map<Object?, Object?>>()
              .map(SleepStage.fromMap)
              .toList()
        : <SleepStage>[];

    return SleepSession(
      startTime: DateTime.parse(map['startTime']! as String),
      endTime: DateTime.parse(map['endTime']! as String),
      stages: stages,
    );
  }

  @override
  String toString() =>
      'SleepSession($startTime → $endTime, ${stages.length} stages)';
}

/// A single stage within a [SleepSession].
///
/// [type] corresponds to Android's `SleepSessionRecord.STAGE_TYPE_*` constants:
///   0  UNKNOWN
///   1  AWAKE (in bed but not sleeping — counts as disturbance)
///   2  SLEEPING (generic)
///   3  OUT_OF_BED
///   4  LIGHT
///   5  DEEP
///   6  REM
class SleepStage {
  const SleepStage({
    required this.type,
    required this.start,
    required this.end,
  });

  final int type;
  final DateTime start;
  final DateTime end;

  Duration get duration => end.difference(start);

  factory SleepStage.fromMap(Map<Object?, Object?> map) {
    return SleepStage(
      type: map['type'] as int? ?? 0,
      start: DateTime.parse(map['start']! as String),
      end: DateTime.parse(map['end']! as String),
    );
  }

  @override
  String toString() => 'SleepStage(type=$type, $start → $end)';
}

/// A single heart-rate measurement from Health Connect.
class HeartRateSample {
  const HeartRateSample({required this.bpm, required this.time});

  final int bpm;
  final DateTime time;

  factory HeartRateSample.fromMap(Map<Object?, Object?> map) {
    return HeartRateSample(
      bpm: (map['bpm'] as num?)?.toInt() ?? 0,
      time: DateTime.parse(map['time']! as String),
    );
  }

  @override
  String toString() => 'HeartRateSample($bpm bpm at $time)';
}

// ---------------------------------------------------------------------------
// Exception type
// ---------------------------------------------------------------------------

/// Thrown when a Health Connect platform call fails.
class HealthConnectException implements Exception {
  const HealthConnectException(this.code, this.message);

  final String code;
  final String message;

  @override
  String toString() => 'HealthConnectException[$code]: $message';
}
