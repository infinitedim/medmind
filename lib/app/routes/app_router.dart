import 'package:go_router/go_router.dart';
import 'package:medmind/app/routes/route_names.dart';
import 'package:medmind/presentation/pages/home/home_page.dart';
import 'package:medmind/presentation/pages/insights/insights_page.dart';
import 'package:medmind/presentation/pages/journal/journal_entry_page.dart';
import 'package:medmind/presentation/pages/journal/journal_list_page.dart';
import 'package:medmind/presentation/pages/onboarding/onboarding_page.dart';
import 'package:medmind/presentation/pages/onboarding/symptom_setup_page.dart';
import 'package:medmind/presentation/pages/settings/export_page.dart';
import 'package:medmind/presentation/pages/settings/health_connect_settings_page.dart';
import 'package:medmind/presentation/pages/settings/reminder_settings_page.dart';
import 'package:medmind/presentation/pages/settings/secutiry_settings_page.dart';
import 'package:medmind/presentation/pages/settings/settings_page.dart';
import 'package:medmind/presentation/pages/splash/splash_page.dart';
import 'package:medmind/presentation/shared/app_bottom_nav.dart';

final appRouter = GoRouter(
  initialLocation: RouteNames.splash,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: RouteNames.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: RouteNames.onboarding,
      builder: (context, state) => const OnboardingPage(),
      routes: [
        GoRoute(
          path: 'symptoms',
          builder: (context, state) => const SymptomSetupPage(),
        ),
      ],
    ),
    ShellRoute(
      builder: (context, state, child) => AppShell(state: state, child: child),
      routes: [
        GoRoute(
          path: RouteNames.home,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: HomePage()),
        ),
        GoRoute(
          path: RouteNames.journal,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: JournalListPage()),
          routes: [
            GoRoute(
              path: 'new',
              builder: (context, state) => const JournalEntryPage(),
            ),
            GoRoute(
              path: 'entry',
              builder: (context, state) {
                final id = state.uri.queryParameters['id'];
                return JournalEntryPage(entryId: id);
              },
            ),
          ],
        ),
        GoRoute(
          path: RouteNames.insights,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: InsightsPage()),
        ),
        GoRoute(
          path: RouteNames.settings,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SettingsPage()),
          routes: [
            GoRoute(
              path: 'security',
              builder: (context, state) => const SecuritySettingsPage(),
            ),
            GoRoute(
              path: 'reminders',
              builder: (context, state) => const ReminderSettingsPage(),
            ),
            GoRoute(
              path: 'health-connect',
              builder: (context, state) => const HealthConnectSettingsPage(),
            ),
            GoRoute(
              path: 'export',
              builder: (context, state) => const ExportPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
