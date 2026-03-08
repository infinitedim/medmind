// integration_test/app_test.dart
// E2E test: smoke test — memastikan aplikasi bisa launch tanpa crash.

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:medmind/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App E2E — Smoke Test', () {
    testWidgets('aplikasi bisa launch dan menampilkan layar awal', (
      tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      // Aplikasi tidak crash saat launch
      expect(tester.takeException(), isNull);
    });

    // TODO: tambahkan test navigasi setelah onboarding flow diimplementasikan
    // testWidgets('navigasi dari Home ke Journal', ...);
    // testWidgets('navigasi dari Home ke Insights', ...);
    // testWidgets('navigasi dari Home ke Settings', ...);
  });
}
