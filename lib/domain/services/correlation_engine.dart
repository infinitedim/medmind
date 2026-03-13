import 'dart:math';

class CorrelationEngine {
  CorrelationEngine._();

  static double bonferroniThreshold(int numberOfTests) {
    assert(numberOfTests > 0);
    return 0.05 / numberOfTests;
  }

  static double _lgamma(double x) {
    const coefficients = [
      76.18009172947146,
      -86.50532032941677,
      24.01409824083091,
      -1.231739572450155,
      0.1208650973866179e-2,
      -0.5395239384953e-5,
    ];
    double y = x;
    final tmp = x + 5.5 - (x + 0.5) * log(x + 5.5);
    double ser = 1.000000000190015;
    for (final c in coefficients) {
      ser += c / ++y;
    }
    return -tmp + log(2.5066282746310005 * ser / x);
  }

  static double _betaCf(double x, double a, double b) {
    const maxIter = 200;
    const eps = 3e-7;
    final qab = a + b;
    final qap = a + 1.0;
    final qam = a - 1.0;
    double c = 1.0;
    double d = 1.0 - qab * x / qap;
    if (d.abs() < 1e-30) d = 1e-30;
    d = 1.0 / d;
    double h = d;
    for (int m = 1; m <= maxIter; m++) {
      final m2 = 2 * m;
      double aa = m * (b - m) * x / ((qam + m2) * (a + m2));
      d = 1.0 + aa * d;
      if (d.abs() < 1e-30) d = 1e-30;
      c = 1.0 + aa / c;
      if (c.abs() < 1e-30) c = 1e-30;
      d = 1.0 / d;
      h *= d * c;
      aa = -(a + m) * (qab + m) * x / ((a + m2) * (qap + m2));
      d = 1.0 + aa * d;
      if (d.abs() < 1e-30) d = 1e-30;
      c = 1.0 + aa / c;
      if (c.abs() < 1e-30) c = 1e-30;
      d = 1.0 / d;
      final del = d * c;
      h *= del;
      if ((del - 1.0).abs() < eps) break;
    }
    return h;
  }

  static double _betaInc(double x, double a, double b) {
    if (x <= 0.0) return 0.0;
    if (x >= 1.0) return 1.0;
    final bt = exp(
      _lgamma(a + b) - _lgamma(a) - _lgamma(b) + a * log(x) + b * log(1 - x),
    );
    if (x < (a + 1.0) / (a + b + 2.0)) {
      return bt * _betaCf(x, a, b) / a;
    }
    return 1.0 - bt * _betaCf(1.0 - x, b, a) / b;
  }

  static double pValue(double t, int degreesOfFreedom) {
    assert(degreesOfFreedom > 0);
    final df = degreesOfFreedom.toDouble();
    final x = df / (df + t * t);
    return _betaInc(x, df / 2.0, 0.5);
  }
}
