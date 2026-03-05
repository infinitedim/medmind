import 'package:freezed_annotation/freezed_annotation.dart';

part 'correlation_result.freezed.dart';

@freezed
abstract class CorrelationResult with _$CorrelationResult {
  const factory CorrelationResult({
    required String variableA,
    required String variableB,
    required double correlationCoefficient,
    required double pValue,
    required int sampleSize,
    required int lag,
    required bool isSignificant,
  }) = _CorrelationResult;
}
