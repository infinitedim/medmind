import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medmind/app/routes/route_names.dart';
import 'package:medmind/app/theme/app_colors.dart';
import 'package:medmind/app/theme/app_typography.dart';
import 'package:medmind/core/di/injection.dart';
import 'package:medmind/platform/keystore_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _splashInitProvider = FutureProvider<_SplashDestination>((ref) async {
  await getIt<KeystoreChannel>().getOrCreateKey();
  final prefs = await SharedPreferences.getInstance();
  final isFirstLaunch = prefs.getBool('first_launch_complete') != true;
  return isFirstLaunch
      ? _SplashDestination.onboarding
      : _SplashDestination.home;
});

enum _SplashDestination { onboarding, home }

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(_splashInitProvider, (_, next) {
      next.whenData((destination) {
        final route = destination == _SplashDestination.onboarding
            ? RouteNames.onboarding
            : RouteNames.home;
        context.go(route);
      });
    });

    final state = ref.watch(_splashInitProvider);

    return Scaffold(
      backgroundColor: AppColors.zinc950,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.teal500_20,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    size: 40,
                    color: AppColors.teal400,
                  ),
                )
                .animate()
                .fadeIn(duration: 600.ms)
                .scale(begin: const Offset(0.8, 0.8), duration: 600.ms),
            const SizedBox(height: 20),
            Text(
              'MedMind',
              style: AppTypography.h1,
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
            const SizedBox(height: 40),
            if (state.isLoading)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.teal500,
                ),
              ).animate().fadeIn(delay: 400.ms, duration: 300.ms),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Gagal memulai aplikasi. Coba lagi.',
                  style: AppTypography.caption,
                  textAlign: TextAlign.center,
                ),
              ).animate().fadeIn(delay: 200.ms),
          ],
        ),
      ),
    );
  }
}
