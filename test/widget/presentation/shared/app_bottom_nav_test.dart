// test/widget/presentation/shared/app_bottom_nav_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:medmind/presentation/shared/app_bottom_nav.dart';

void main() {
  /// Helper: wrap AppShell dengan GoRouter stub.
  Widget buildWithRouter({required Widget child}) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        ShellRoute(
          builder: (context, state, child) =>
              AppShell(state: state, child: child),
          routes: [
            GoRoute(path: '/', builder: (_, _) => const SizedBox()),
            GoRoute(path: '/journal', builder: (_, _) => const SizedBox()),
            GoRoute(path: '/insights', builder: (_, _) => const SizedBox()),
            GoRoute(path: '/settings', builder: (_, _) => const SizedBox()),
          ],
        ),
      ],
    );

    return MaterialApp.router(routerConfig: router);
  }

  group('AppShell / AppBottomNav', () {
    testWidgets('render tanpa error', (tester) async {
      await tester.pumpWidget(buildWithRouter(child: const SizedBox()));
      await tester.pumpAndSettle();
      expect(find.byType(AppShell), findsOneWidget);
    });

    testWidgets('menampilkan NavigationBar', (tester) async {
      await tester.pumpWidget(buildWithRouter(child: const SizedBox()));
      await tester.pumpAndSettle();
      expect(find.byType(NavigationBar), findsOneWidget);
    });

    // TODO: tambahkan test saat navigasi sudah stabil
    // - test tap bottom-nav item → berpindah route
    // - test item aktif sesuai route saat ini
  });
}
