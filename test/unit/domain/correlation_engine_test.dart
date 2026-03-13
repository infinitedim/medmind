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

    test('returns 0.0025 for 20 tests', () {
      expect(CorrelationEngine.bonferroniThreshold(20), closeTo(0.0025, 1e-10));
    });
  });

  group('CorrelationEngine.pValue', () {
    test('p-value for t=0 is 1.0 (no effect)', () {
      expect(CorrelationEngine.pValue(0, 10), closeTo(1.0, 1e-6));
    });

    test('p-value for large |t| approaches 0', () {
      expect(CorrelationEngine.pValue(10.0, 30), lessThan(0.001));
    });

    test('p-value is symmetric (positive and negative t)', () {
      final pos = CorrelationEngine.pValue(2.0, 10);
      final neg = CorrelationEngine.pValue(-2.0, 10);
      expect(pos, closeTo(neg, 1e-8));
    });

    test('p-value for t=2.228, df=10 is ~0.05 (textbook value)', () {
      expect(CorrelationEngine.pValue(2.228, 10), closeTo(0.05, 0.002));
    });

    test('p-value for t=1.96, df=120 is ~0.05 (approx normal)', () {
      expect(CorrelationEngine.pValue(1.96, 120), closeTo(0.052, 0.005));
    });

    test('p-value for t=3.169, df=10 is ~0.01 (textbook value)', () {
      expect(CorrelationEngine.pValue(3.169, 10), closeTo(0.01, 0.002));
    });

    test('p-value is always in [0, 1]', () {
      for (final t in [-5.0, -2.0, -0.5, 0.0, 0.5, 2.0, 5.0]) {
        for (final df in [1, 5, 10, 30, 100]) {
          final p = CorrelationEngine.pValue(t, df);
          expect(p, inInclusiveRange(0.0, 1.0));
        }
      }
    });
  });
}
