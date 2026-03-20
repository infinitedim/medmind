// test/widget/presentation/pages/insights/insights_page_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:medmind/domain/entities/journal_entry.dart';
import 'package:medmind/presentation/pages/insights/insights_page.dart';
import 'package:medmind/presentation/providers/core_providers.dart';
import 'package:medmind/presentation/providers/journal_providers.dart';

import '../../../../helpers/mock_repositories.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  setUp(() {
    registerFallbackValues();
  });

  group('InsightsPage — not enough data (count < 14)', () {
    testWidgets('shows "Butuh lebih banyak data" when count = 0', (
      tester,
    ) async {
      await tester.pumpApp(
        const InsightsPage(),
        overrides: [journalEntriesCountProvider.overrideWithValue(0)],
      );

      expect(find.text('Butuh lebih banyak data'), findsOneWidget);
    });

    testWidgets('shows correct remaining count', (tester) async {
      await tester.pumpApp(
        const InsightsPage(),
        overrides: [journalEntriesCountProvider.overrideWithValue(5)],
      );

      // 14 - 5 = 9 remaining
      expect(find.textContaining('9 hari lagi'), findsOneWidget);
    });

    testWidgets('shows progress as count / 14', (tester) async {
      await tester.pumpApp(
        const InsightsPage(),
        overrides: [journalEntriesCountProvider.overrideWithValue(7)],
      );

      // Shows "7 / 14 hari" in progress row
      expect(find.textContaining('7 / 14 hari'), findsOneWidget);
    });

    testWidgets('does not show TabBar when data is insufficient', (
      tester,
    ) async {
      await tester.pumpApp(
        const InsightsPage(),
        overrides: [journalEntriesCountProvider.overrideWithValue(13)],
      );

      expect(find.byType(TabBar), findsNothing);
    });
  });

  group('InsightsPage — enough data (count >= 14)', () {
    testWidgets('shows "Insights" header and TabBar when count = 14', (
      tester,
    ) async {
      // ignore: unused_local_variable
      final mockRepo = MockJournalRepository();
      // journalEntriesCountProvider depends on journalEntriesProvider, but
      // we override journalEntriesCountProvider directly → repo not called.
      await tester.pumpApp(
        const InsightsPage(),
        overrides: [journalEntriesCountProvider.overrideWithValue(14)],
      );

      expect(find.byType(TabBar), findsOneWidget);
      expect(find.text('Insights'), findsWidgets); // page header + tab label
    });

    testWidgets('shows Insights and Heatmap tabs', (tester) async {
      await tester.pumpApp(
        const InsightsPage(),
        overrides: [journalEntriesCountProvider.overrideWithValue(20)],
      );

      expect(find.text('Heatmap'), findsOneWidget);
    });

    testWidgets(
      'does not show "Butuh lebih banyak data" when data sufficient',
      (tester) async {
        await tester.pumpApp(
          const InsightsPage(),
          overrides: [journalEntriesCountProvider.overrideWithValue(14)],
        );

        expect(find.text('Butuh lebih banyak data'), findsNothing);
      },
    );
  });

  group('InsightsPage — provider integration', () {
    testWidgets('renders from journalEntriesCountProvider via stream', (
      tester,
    ) async {
      final mockRepo = MockJournalRepository();
      when(
        () => mockRepo.watchEntries(
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      ).thenAnswer(
        (_) => Stream.value(
          List.generate(
            3,
            (i) => JournalEntry(
              id: 'e$i',
              date: DateTime(2026, 3, i + 1),
              createdAt: DateTime(2026),
              updatedAt: DateTime(2026),
            ),
          ),
        ),
      );

      await tester.pumpAppAndSettle(
        const InsightsPage(),
        overrides: [journalRepositoryProvider.overrideWithValue(mockRepo)],
      );

      // 3 entries < 14 → shows not enough data screen
      expect(find.text('Butuh lebih banyak data'), findsOneWidget);
    });
  });
}
