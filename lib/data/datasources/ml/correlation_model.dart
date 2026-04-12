import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import 'package:medmind/core/errors/exceptions.dart';

@lazySingleton
class CorrelationTFLiteModel {
  Interpreter? _interpreter;
  List<String> symptomNames = [];
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    try {
      final vocabJson = await rootBundle.loadString(
        'assets/models/symptom_vocab.json',
      );
      final map = json.decode(vocabJson) as Map<String, dynamic>;
      symptomNames =
          (map['symptoms'] as List?)?.map((e) => e.toString()).toList() ?? [];

      final modelData = await rootBundle.load(
        'assets/models/symptom_correlation_v1.tflite',
      );
      _interpreter = Interpreter.fromBuffer(modelData.buffer.asUint8List());
      _initialized = true;
    } catch (e) {
      throw ModelLoadException('assets/models/symptom_correlation_v1.tflite');
    }
  }

  /// Returns a list of (symptom, score) sorted descending. Filters out input symptoms.
  Future<List<MapEntry<String, double>>> getCorrelated(
    List<String> presentSymptoms,
  ) async {
    if (!_initialized || _interpreter == null) {
      throw MlInferenceException('Model not initialized');
    }

    final numSymptoms = symptomNames.length;
    final inputVec = List<double>.filled(numSymptoms, 0.0);
    final presentSet = presentSymptoms.toSet();
    for (var i = 0; i < numSymptoms; i++) {
      if (presentSet.contains(symptomNames[i])) inputVec[i] = 1.0;
    }

    final input = <dynamic>[inputVec];
    final output = List.generate(
      1,
      (_) => List<double>.filled(numSymptoms, 0.0),
    );

    try {
      _interpreter!.run(input, output);
    } catch (e) {
      throw MlInferenceException('TFLite inference failed: ${e.toString()}');
    }

    final scores = output[0];
    final results = <MapEntry<String, double>>[];
    for (var i = 0; i < numSymptoms; i++) {
      final name = symptomNames[i];
      if (!presentSet.contains(name)) results.add(MapEntry(name, scores[i]));
    }

    results.sort((a, b) => b.value.compareTo(a.value));
    return results;
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _initialized = false;
  }
}
