import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medmind/app/routes/route_names.dart';
import 'package:medmind/presentation/pages/home/home_page.dart';
import 'package:medmind/presentation/pages/insights/insights_page.dart';
import 'package:medmind/presentation/pages/journal/journal_entry_page.dart';
import 'package:medmind/presentation/pages/journal/journal_list_page.dart';
import 'package:medmind/presentation/pages/onboarding/lifestyle_setup_page.dart';
import 'package:medmind/presentation/pages/onboarding/onboarding_page.dart';
import 'package:medmind/presentation/pages/onboarding/security_setup_page.dart';
import 'package:medmind/presentation/pages/onboarding/symptom_setup_page.dart';
import 'package:medmind/presentation/pages/settings/export_page.dart';
import 'package:medmind/presentation/pages/settings/health_connect_settings_page.dart';
import 'package:medmind/presentation/pages/settings/reminder_settings_page.dart';
import 'package:medmind/presentation/pages/settings/secutiry_settings_page.dart';
import 'package:medmind/presentation/pages/settings/settings_page.dart';
import 'package:medmind/presentation/pages/splash/splash_page.dart';
import 'package:medmind/presentation/providers/preference_providers.dart';
import 'package:medmind/presentation/shared/app_bottom_nav.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterRefreshNotifier(ref);
  ref.onDispose(notifier.dispose);
  return GoRouter(
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: true,
    refreshListenable: notifier,
    redirect: (context, state) {
      final onboardingAsync = ref.read(onboardingCompleteProvider);
      if (onboardingAsync is AsyncLoading) return null;
      final isComplete = onboardingAsync.asData?.value ?? false;
      final loc = state.matchedLocation;
      final onSplash = loc == RouteNames.splash;
      final onOnboarding = loc.startsWith(RouteNames.onboarding);
      if (!isComplete && !onOnboarding && !onSplash) {
        return RouteNames.onboarding;
      }
      if (isComplete && onOnboarding) {
        return RouteNames.home;
      }
      return null;
    },
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
          GoRoute(
            path: 'lifestyle',
            builder: (context, state) => const LifestyleSetupPage(),
          ),
          GoRoute(
            path: 'security',
            builder: (context, state) => const SecuritySetupPage(),
          ),
        ],
      ),
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(state: state, child: child),
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
});

class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(Ref ref) {
    ref.listen<AsyncValue<bool>>(onboardingCompleteProvider, (_, next) {
      notifyListeners();
    });
  }
}
