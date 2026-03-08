// test/widget/presentation/pages/journal/journal_list_page_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medmind/presentation/pages/journal/journal_list_page.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  group('JournalListPage', () {
    testWidgets('render tanpa error', (tester) async {
      await tester.pumpApp(const JournalListPage());
      expect(find.byType(JournalListPage), findsOneWidget);
    });

    testWidgets('memiliki Scaffold', (tester) async {
      await tester.pumpApp(const JournalListPage());
      expect(find.byType(Scaffold), findsOneWidget);
    });

    // TODO: tambahkan test saat JournalListPage sudah diimplementasikan
    // - test menampilkan list entries
    // - test empty state ketika tidak ada entries
    // - test tombol "Add Entry" navigasi ke JournalEntryPage
    // - test pull-to-refresh
  });
}
