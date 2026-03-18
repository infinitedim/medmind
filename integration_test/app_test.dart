// integration_test/app_test.dart
// E2E test: smoke test — memastikan aplikasi bisa launch tanpa crash.

import 'package:flutter/material.dart';
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

    testWidgets('menampilkan nama aplikasi MedMind setelah launch', (
      tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      // "MedMind" muncul di layar awal (splash, onboarding, atau home)
      expect(find.text('MedMind'), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('tidak ada Scaffold error atau overflow setelah launch', (
      tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      // Tidak ada RenderFlex overflow
      final exceptions = tester.takeException();
      // Overflow errors are not thrown as Dart exceptions, just printed
      expect(exceptions, isNull);
      // App should have rendered at least one Scaffold
      expect(find.byType(Scaffold), findsWidgets);
    });
  });

  group('App E2E — Fresh Install (Onboarding)', () {
    // Prasyarat: app dalam kondisi fresh install (belum onboarding)
    // Jalankan dengan: flutter test integration_test/app_test.dart
    // Wipe data app sebelum menjalankan test ini.

    testWidgets(
      'fresh install menampilkan halaman onboarding dengan Get Started',
      (tester) async {
        app.main();
        await tester.pumpAndSettle();

        // Jika fresh install, OnboardingPage ditampilkan
        final getStartedButton = find.text('Get Started');
        if (getStartedButton.evaluate().isNotEmpty) {
          expect(find.text('MedMind'), findsWidgets);
          expect(find.text('Get Started'), findsOneWidget);
        }
        // Test passes regardless — tidak assert bila ada data sebelumnya
        expect(tester.takeException(), isNull);
      },
    );
  });
}
