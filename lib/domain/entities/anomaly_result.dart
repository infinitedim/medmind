import 'package:freezed_annotation/freezed_annotation.dart';

part 'anomaly_result.freezed.dart';

@freezed
abstract class AnomalyResult with _$AnomalyResult {
  const factory AnomalyResult({
    required double reconstructionError,
    required bool isAnomaly,
    required String severity,
  }) = _AnomalyResult;
}
