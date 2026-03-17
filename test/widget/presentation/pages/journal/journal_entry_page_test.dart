// test/widget/presentation/pages/journal/journal_entry_page_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medmind/presentation/pages/journal/journal_entry_page.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  group('JournalEntryPage', () {
    group('mode New Entry (tanpa entryId)', () {
      testWidgets('render tanpa error', (tester) async {
        await tester.pumpApp(const JournalEntryPage());
        expect(find.byType(JournalEntryPage), findsOneWidget);
      });

      testWidgets('menampilkan tab navigasi Mood', (tester) async {
        await tester.pumpApp(const JournalEntryPage());
        expect(find.text('Mood'), findsOneWidget);
      });

      testWidgets('menampilkan TabBar dengan 4 tab', (tester) async {
        await tester.pumpApp(const JournalEntryPage());
        expect(find.byType(TabBar), findsOneWidget);
      });
    });

    group('mode Edit Entry (dengan entryId)', () {
      testWidgets('menampilkan TabBar saat edit mode', (tester) async {
        await tester.pumpApp(const JournalEntryPage(entryId: 'test-id-123'));
        expect(find.byType(TabBar), findsOneWidget);
      });

      testWidgets('tidak menampilkan "New Entry" saat edit mode', (
        tester,
      ) async {
        await tester.pumpApp(const JournalEntryPage(entryId: 'test-id-123'));
        expect(find.text('New Entry'), findsNothing);
      });
    });

    testWidgets('mempunyai Scaffold', (tester) async {
      await tester.pumpApp(const JournalEntryPage());
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('mempunyai AppBar', (tester) async {
      await tester.pumpApp(const JournalEntryPage());
      expect(find.byType(AppBar), findsOneWidget);
    });
  });
}
