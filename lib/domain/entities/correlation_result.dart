import 'package:freezed_annotation/freezed_annotation.dart';

part 'correlation_result.freezed.dart';

@freezed
abstract class CorrelationResult with _$CorrelationResult {
  const factory CorrelationResult({
    required String variableA,
    required String variableB,
    required double correlationCoefficient, // -1.0 to 1.0
    required double pValue,
    required int sampleSize,
    required int lag, // 0 = same day, 1 = next day, etc.
    required bool isSignificant, // p < 0.05 after Bonferroni correction
  }) = _CorrelationResult;
}
