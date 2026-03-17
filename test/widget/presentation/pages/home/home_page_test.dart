// test/widget/presentation/pages/home/home_page_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medmind/presentation/pages/home/home_page.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  group('HomePage', () {
    testWidgets('render tanpa error', (tester) async {
      await tester.pumpApp(const HomePage());
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('menampilkan teks "MedMind"', (tester) async {
      await tester.pumpApp(const HomePage());
      expect(find.text('MedMind'), findsOneWidget);
    });

    testWidgets('background adalah Scaffold', (tester) async {
      await tester.pumpApp(const HomePage());
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('dikemas dalam SafeArea', (tester) async {
      await tester.pumpApp(const HomePage());
      expect(find.byType(SafeArea), findsOneWidget);
    });
  });
}
