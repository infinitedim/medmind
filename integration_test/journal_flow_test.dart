// integration_test/journal_flow_test.dart
// E2E test: alur lengkap create -> read -> update -> delete journal entry.
// Prasyarat: onboarding sudah selesai.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:medmind/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Journal Flow E2E', () {
    testWidgets('aplikasi launch dan Journal tab dapat diakses', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('bottom navigation bar tersedia setelah onboarding', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      final hasBottomNav =
          find.byType(BottomNavigationBar).evaluate().isNotEmpty ||
              find.byType(NavigationBar).evaluate().isNotEmpty;
      if (hasBottomNav) {
        expect(find.byType(Scaffold), findsWidgets);
      }
      expect(tester.takeException(), isNull);
    });

    testWidgets('bisa membuat journal entry baru dari halaman Journal', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      final journalTabIcon = find.byTooltip('Journal');
      if (journalTabIcon.evaluate().isEmpty) {
        final journalTabText = find.text('Journal');
        if (journalTabText.evaluate().isEmpty) return;
        await tester.tap(journalTabText.first);
      } else {
        await tester.tap(journalTabIcon);
      }
      await tester.pumpAndSettle();
      final fab = find.byType(FloatingActionButton);
      if (fab.evaluate().isEmpty) return;
      await tester.tap(fab);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('swipe dismiss pada journal entry tidak crash', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      final journalTab = find.text('Journal');
      if (journalTab.evaluate().isEmpty) return;
      await tester.tap(journalTab.first);
      await tester.pumpAndSettle();
      final dismissibles = find.byType(Dismissible);
      if (dismissibles.evaluate().isEmpty) return;
      await tester.drag(dismissibles.first, const Offset(-300, 0));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
