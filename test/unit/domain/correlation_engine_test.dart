import 'package:flutter_test/flutter_test.dart';
import 'package:medmind/domain/services/correlation_engine.dart';

void main() {
  group('CorrelationEngine.bonferroniThreshold', () {
    test('returns 0.05 for 1 test', () {
      expect(CorrelationEngine.bonferroniThreshold(1), closeTo(0.05, 1e-10));
    });

    test('returns 0.01 for 5 tests', () {
      expect(CorrelationEngine.bonferroniThreshold(5), closeTo(0.01, 1e-10));
    });
  });

  group('CorrelationEngine.calculatePearson', () {
    test('returns 1.0 for perfect positive correlation', () {
      final x = [1.0, 2.0, 3.0, 4.0, 5.0];
      final y = [1.0, 2.0, 3.0, 4.0, 5.0];
      expect(CorrelationEngine.calculatePearson(x, y), closeTo(1.0, 1e-10));
    });

    test('returns -1.0 for perfect negative correlation', () {
      final x = [1.0, 2.0, 3.0, 4.0, 5.0];
      final y = [5.0, 4.0, 3.0, 2.0, 1.0];
      expect(CorrelationEngine.calculatePearson(x, y), closeTo(-1.0, 1e-10));
    });

    test('returns 0.0 for no correlation', () {
      final x = [1.0, 2.0, 3.0, 4.0, 5.0];
      final y = [1.0, 5.0, 2.0, 4.0, 3.0];
      // Note: This won't be exactly 0, but should be low
      expect(CorrelationEngine.calculatePearson(x, y).abs(), lessThan(0.5));
    });
  });

  group('CorrelationEngine.computeSignificantCorrelations', () {
    test('filters insignificant results based on p-value', () {
      final data = [
        [1.0, 1.1],
        [2.0, 2.2],
        [3.0, 2.9],
        [4.0, 4.1],
        [5.0, 4.8],
        [6.0, 6.2],
      ];
      final names = ['A', 'B'];

      final results = CorrelationEngine.computeSignificantCorrelations(
        data: data,
        variableNames: names,
      );

      expect(results, hasLength(1));
      expect(results.first.isSignificant, isTrue);
      expect(results.first.correlationCoefficient, greaterThan(0.9));
    });

    test('handles lag correctly', () {
      final data = [
        [1.0, 0.0],
        [2.0, 1.0],
        [3.0, 2.0],
        [4.0, 3.0],
        [5.0, 4.0],
        [6.0, 5.0],
      ];
      final names = ['A', 'B'];

      // Lag 1: A[k] correlate with B[k+1]
      // Samples: (1,1), (2,2), (3,3), (4,4), (5,5) -> 5 samples
      final results = CorrelationEngine.computeSignificantCorrelations(
        data: data,
        variableNames: names,
        lag: 1,
      );

      expect(results, isNotEmpty);
      expect(results.first.correlationCoefficient, closeTo(1.0, 1e-10));
    });

  });

  group('CorrelationEngine.pValue', () {
    test('p-value for t=0 is 1.0 (no effect)', () {
      expect(CorrelationEngine.pValue(0, 10), closeTo(1.0, 1e-6));
    });

    test('p-value for large |t| approaches 0', () {
      expect(CorrelationEngine.pValue(10.0, 30), lessThan(0.001));
    });

    test('p-value for t=2.228, df=10 is ~0.05 (textbook value)', () {
      expect(CorrelationEngine.pValue(2.228, 10), closeTo(0.05, 0.002));
    });
  });
}

