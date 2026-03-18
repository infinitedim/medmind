import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:medmind/app/routes/route_names.dart';
import 'package:medmind/app/theme/app_colors.dart';
import 'package:medmind/app/theme/app_typography.dart';
import 'package:medmind/core/di/injection.dart';
import 'package:medmind/core/services/biometric_auth_service.dart';
import 'package:medmind/data/seed/symptom_seeder.dart';
import 'package:medmind/domain/repositories/user_preferences_repository.dart';
import 'package:medmind/platform/keystore_channel.dart';

// ---------------------------------------------------------------------------
// State machine
// ---------------------------------------------------------------------------

enum _SplashState { initializing, finishing, awaitingBiometric, error }

// ---------------------------------------------------------------------------
// Page
// ---------------------------------------------------------------------------

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  _SplashState _state = _SplashState.initializing;
  String? _errorMessage;
  double _progress = 0.0;
  String _stepLabel = 'Memuat...';
  int _biometricFailures = 0;
  bool _pinEnabled = false;

  final _bioService = BiometricAuthService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setSystemUI();
      _runInitSequence();
    });
  }

  void _setSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  void _setProgress(double value, String label) {
    if (!mounted) return;
    setState(() {
      _progress = value;
      _stepLabel = label;
    });
  }

  /// Runs all init steps with progress tracking.
  /// Waits a minimum of [_kMinSplashMs] so brand animations finish playing.
  Future<void> _runInitSequence() async {
    if (!mounted) return;
    setState(() {
      _state = _SplashState.initializing;
      _progress = 0.0;
      _stepLabel = 'Memuat...';
      _errorMessage = null;
    });

    final startTime = DateTime.now();

    // STEP 1 — seed default symptoms (fast DB write, non-fatal)
    _setProgress(0.0, 'Menyiapkan data...');
    try {
      await seedDefaultSymptoms();
    } catch (_) {
      // Non-fatal: proceed even if seeding fails
    }

    // STEP 2 — keystore / encryption init
    _setProgress(0.30, 'Menginisialisasi enkripsi...');
    try {
      await getIt<KeystoreChannel>().getOrCreateKey();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _state = _SplashState.error;
        _errorMessage = e.toString();
      });
      return;
    }

    // STEP 3 — read preferences
    _setProgress(0.60, 'Memeriksa akun...');
    final repo = getIt<UserPreferencesRepository>();
    final onboardingResult = await repo.isOnboardingComplete();
    if (!mounted) return;

    _setProgress(0.80, 'Hampir selesai...');
    final biometricResult = await repo.isBiometricEnabled();
    final pinResult = await repo.isPinEnabled();
    if (!mounted) return;

    _setProgress(1.0, 'Selesai');

    // Guarantee the brand animation (≈750ms) has time to play
    const kMinSplash = Duration(milliseconds: 1600);
    final elapsed = DateTime.now().difference(startTime);
    if (elapsed < kMinSplash) {
      await Future.delayed(kMinSplash - elapsed);
    }
    if (!mounted) return;

    // Brief circular spinner before navigating (visual cue that work finished)
    setState(() => _state = _SplashState.finishing);
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    // Navigate
    final onboardingComplete = onboardingResult.fold((_) => false, (v) => v);
    if (!onboardingComplete) {
      context.go(RouteNames.onboarding);
      return;
    }

    final biometricEnabled = biometricResult.fold((_) => false, (v) => v);
    if (!biometricEnabled) {
      context.go(RouteNames.home);
      return;
    }

    _pinEnabled = pinResult.fold((_) => false, (v) => v);
    _biometricFailures = 0;
    setState(() => _state = _SplashState.awaitingBiometric);
    await _showBiometricPrompt();
  }

  Future<void> _showBiometricPrompt() async {
    try {
      final authenticated = await _bioService.authenticate();
      if (!mounted) return;
      if (authenticated) {
        context.go(RouteNames.home);
        return;
      }
      // User cancelled — increment failure counter.
      _biometricFailures++;
      if (_biometricFailures >= 3) {
        if (_pinEnabled) {
          context.go(RouteNames.pinLock);
        } else {
          // No PIN configured — fail-open.
          context.go(RouteNames.home);
        }
      }
      // < 3 failures → stay on awaitingBiometric; user can tap to retry.
    } on PlatformException {
      // Hardware unavailable / lockout → fall back to PIN if available.
      if (!mounted) return;
      if (_pinEnabled) {
        context.go(RouteNames.pinLock);
      } else {
        context.go(RouteNames.home);
      }
    }
  }

  Future<void> _handleReset() async {
    await getIt<KeystoreChannel>().destroyKey();
    if (!mounted) return;
    context.go(RouteNames.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.zinc950,
        extendBody: true,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _BrandBlock(),
                  const SizedBox(height: 48),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) =>
                        FadeTransition(opacity: animation, child: child),
                    child: switch (_state) {
                      _SplashState.initializing => _LoadingBar(
                        key: const ValueKey('bar'),
                        progress: _progress,
                        label: _stepLabel,
                      ),
                      _SplashState.finishing => const _CircularIndicator(
                        key: ValueKey('spinner'),
                      ),
                      _SplashState.awaitingBiometric => _BiometricPrompt(
                        key: const ValueKey('biometric'),
                        onRetry: _showBiometricPrompt,
                      ),
                      _SplashState.error => _ErrorContent(
                        key: const ValueKey('error'),
                        message: _errorMessage,
                        onRetry: _runInitSequence,
                        onReset: _handleReset,
                      ),
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sub-widgets
// ---------------------------------------------------------------------------

class _BrandBlock extends StatelessWidget {
  const _BrandBlock();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
              'assets/icon/medmind-logo.png',
              width: 80,
              height: 80,
              filterQuality: FilterQuality.high,
            )
            .animate()
            .fadeIn(duration: 600.ms)
            .scale(
              begin: const Offset(0.85, 0.85),
              duration: 600.ms,
              curve: Curves.easeOutCubic,
            ),
        const SizedBox(height: 20),
        Text(
          'MedMind',
          style: AppTypography.display,
        ).animate().fadeIn(delay: 150.ms, duration: 400.ms),
        const SizedBox(height: 8),
        Text(
          'Your private health journal',
          style: AppTypography.body.copyWith(color: AppColors.zinc400),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 250.ms, duration: 400.ms),
      ],
    );
  }
}

/// Animated progress bar that tweens smoothly to [progress] (0.0 – 1.0).
class _LoadingBar extends StatelessWidget {
  const _LoadingBar({super.key, required this.progress, required this.label});

  final double progress;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: progress),
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOut,
          builder: (context, value, _) => LinearProgressIndicator(
            value: value,
            backgroundColor: AppColors.zinc800,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.teal500),
            minHeight: 2,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: AppTypography.caption.copyWith(color: AppColors.zinc600),
        ),
      ],
    ).animate().fadeIn(delay: 400.ms, duration: 350.ms);
  }
}

class _CircularIndicator extends StatelessWidget {
  const _CircularIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: AppColors.teal500,
      ),
    );
  }
}

class _BiometricPrompt extends StatelessWidget {
  const _BiometricPrompt({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onRetry,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            LucideIcons.fingerprint,
            color: AppColors.zinc400,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            'Gunakan sidik jari atau wajah\nuntuk membuka aplikasi',
            style: AppTypography.small.copyWith(color: AppColors.zinc400),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

class _ErrorContent extends StatelessWidget {
  const _ErrorContent({
    super.key,
    required this.message,
    required this.onRetry,
    required this.onReset,
  });

  final String? message;
  final VoidCallback onRetry;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.lock_outline, color: AppColors.red500, size: 48),
        const SizedBox(height: 16),
        Text(
          'Gagal menginisialisasi enkripsi',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.zinc300),
          textAlign: TextAlign.center,
        ),
        if (message != null) ...[
          const SizedBox(height: 8),
          Text(
            message!,
            style: AppTypography.caption.copyWith(color: AppColors.zinc500),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: onRetry,
            child: const Text('Coba Lagi'),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: AppColors.red500),
          onPressed: onReset,
          child: const Text('Hapus Data & Mulai Ulang'),
        ),
      ],
    ).animate().fadeIn(duration: 300.ms);
  }
}
