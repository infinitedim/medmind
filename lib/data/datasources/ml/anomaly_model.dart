import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import 'package:medmind/core/errors/exceptions.dart';
import 'package:medmind/domain/entities/anomaly_result.dart';

@lazySingleton
class AnomalyTFLiteModel {
  Interpreter? _interpreter;
  double threshold = 0.05;
  List<double> scalerMin = [60.0, 95.0, 36.1, 12.0];
  List<double> scalerMax = [100.0, 100.0, 37.2, 20.0];
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    try {
      final vocabJson = await rootBundle.loadString(
        'assets/models/symptom_vocab.json',
      );
      final map = json.decode(vocabJson) as Map<String, dynamic>;
      threshold = (map['anomaly_threshold'] as num?)?.toDouble() ?? threshold;
      final minList = (map['scaler_min'] as List?)
          ?.map((e) => (e as num).toDouble())
          .toList();
      final maxList = (map['scaler_max'] as List?)
          ?.map((e) => (e as num).toDouble())
          .toList();
      if (minList != null && maxList != null) {
        scalerMin = List<double>.from(minList);
        scalerMax = List<double>.from(maxList);
      }

      final modelData = await rootBundle.load(
        'assets/models/anomaly_detection_v1.tflite',
      );
      _interpreter = Interpreter.fromBuffer(modelData.buffer.asUint8List());
      _initialized = true;
    } catch (e) {
      throw ModelLoadException('assets/models/anomaly_detection_v1.tflite');
    }
  }

  /// Expects `window` shape `[10][4]` (sliding window of 10 timesteps, 4 features)
  Future<AnomalyResult> detect(List<List<double>> window) async {
    if (!_initialized || _interpreter == null) {
      throw MlInferenceException('Model not initialized');
    }
    if (window.length != 10) {
      throw MlInferenceException('Window size must be 10');
    }

    // Normalize using scaler_min/scaler_max
    final normalized = List<List<double>>.generate(
      10,
      (i) => List<double>.filled(4, 0.0),
    );

    for (var i = 0; i < 10; i++) {
      for (var j = 0; j < 4; j++) {
        final v = window[i][j];
        final minv = scalerMin[j];
        final maxv = scalerMax[j];
        final denom = (maxv - minv).abs();
        final norm = denom > 0 ? ((v - minv) / denom) : 0.0;
        normalized[i][j] = norm.isFinite ? norm.clamp(0.0, 1.0) : 0.0;
      }
    }

    // Prepare input shape [1, 10, 4]
    final input = <dynamic>[normalized];

    // Prepare output buffer [1, 10, 4]
    final output = List.generate(
      1,
      (_) => List.generate(10, (_) => List<double>.filled(4, 0.0)),
    );

    try {
      _interpreter!.run(input, output);
    } catch (e) {
      throw MlInferenceException('TFLite inference failed: ${e.toString()}');
    }

    // Compute MSE between normalized input and reconstructed output
    double mse = 0.0;
    final n = 10 * 4;
    for (var i = 0; i < 10; i++) {
      for (var j = 0; j < 4; j++) {
        final diff = normalized[i][j] - output[0][i][j];
        mse += diff * diff;
      }
    }
    final reconError = mse / n;
    final isAnomaly = reconError > threshold;

    String severity;
    if (reconError < threshold) {
      severity = 'normal';
    } else if (reconError < threshold * 2) {
      severity = 'mild';
    } else if (reconError < threshold * 4) {
      severity = 'moderate';
    } else {
      severity = 'severe';
    }

    return AnomalyResult(
      reconstructionError: reconError,
      isAnomaly: isAnomaly,
      severity: severity,
    );
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _initialized = false;
  }
}
