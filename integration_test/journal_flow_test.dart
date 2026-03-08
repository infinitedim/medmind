// integration_test/journal_flow_test.dart
// E2E test: alur lengkap create → read → update → delete journal entry.
//
// Catatan: test ini bergantung pada implementasi UI yang sudah jadi.
// Saat ini berfungsi sebagai template — aktifkan bertahap seiring progress.

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:medmind/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Journal Flow E2E', () {
    testWidgets('aplikasi launch dan Journal tab dapat diakses', (
      tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      // Tidak ada exception saat launch
      expect(tester.takeException(), isNull);

      // TODO: aktifkan saat bottom nav sudah stabil
      // final journalTab = find.byTooltip('Journal');
      // if (journalTab.evaluate().isNotEmpty) {
      //   await tester.tap(journalTab);
      //   await tester.pumpAndSettle();
      //   expect(find.byType(JournalListPage), findsOneWidget);
      // }
    });

    // ─── Template: Create Entry ───────────────────────────────────────────
    // testWidgets('bisa membuat journal entry baru', (tester) async {
    //   await app.main();
    //   await tester.pumpAndSettle();
    //
    //   // Navigasi ke Journal tab
    //   await tester.tap(find.byTooltip('Journal'));
    //   await tester.pumpAndSettle();
    //
    //   // Tap FAB / "New Entry" button
    //   await tester.tap(find.byType(FloatingActionButton));
    //   await tester.pumpAndSettle();
    //
    //   // Verifikasi halaman JournalEntryPage terbuka
    //   expect(find.text('New Entry'), findsOneWidget);
    //
    //   // Isi form
    //   await tester.enterText(find.byKey(Key('freeTextInput')), 'Feeling great');
    //   await tester.pumpAndSettle();
    //
    //   // Submit
    //   await tester.tap(find.byKey(Key('saveEntryButton')));
    //   await tester.pumpAndSettle();
    //
    //   // Verifikasi balik ke list
    //   expect(find.byType(JournalListPage), findsOneWidget);
    //   expect(find.text('Feeling great'), findsOneWidget);
    // });

    // ─── Template: Delete Entry ───────────────────────────────────────────
    // testWidgets('bisa menghapus journal entry', (tester) async {
    //   // ... setup + swipe to delete / tap delete icon
    //   // expect entry tidak ada di list
    // });
  });
}
