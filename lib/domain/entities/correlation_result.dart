class CorrelationResult {
  final String variableA;
  final String variableB;
  final double correlationCoefficient; // -1.0 to 1.0
  final double pValue;
  final int sampleSize;
  final int lag; // 0 = same day, 1 = next day, etc.
  final bool isSignificant; // p < 0.05 after Bonferroni correction

  CorrelationResult({
    required this.variableA,
    required this.variableB,
    required this.correlationCoefficient,
    required this.pValue,
    required this.sampleSize,
    required this.lag,
    required this.isSignificant,
  });
}
