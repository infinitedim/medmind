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
import 'package:medmind/platform/keystore_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ---------------------------------------------------------------------------
// State machine
// ---------------------------------------------------------------------------

enum _SplashState { initializing, awaitingBiometric, error }

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

  // BiometricAuthService has no DI deps — instantiated directly once.
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

  /// STEP 1 → keystore init
  /// STEP 2 → onboarding check
  /// STEP 3 → biometric check
  Future<void> _runInitSequence() async {
    if (!mounted) return;
    setState(() {
      _state = _SplashState.initializing;
      _errorMessage = null;
    });

    // STEP 1 — keystore
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

    // STEP 2 — onboarding
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    if (prefs.getBool('first_launch_complete') != true) {
      context.go(RouteNames.onboarding);
      return;
    }

    // STEP 3 — biometric
    final biometricEnabled = await _bioService.isEnabled();
    if (!mounted) return;
    if (!biometricEnabled) {
      context.go(RouteNames.home);
      return;
    }

    setState(() => _state = _SplashState.awaitingBiometric);
    await _showBiometricPrompt();
  }

  Future<void> _showBiometricPrompt() async {
    try {
      final authenticated = await _bioService.authenticate();
      if (!mounted) return;
      if (authenticated) context.go(RouteNames.home);
      // User cancelled → stay on awaitingBiometric; tap fingerprint to retry.
    } on PlatformException {
      // Hardware unavailable / lockout → fail-open to home.
      if (!mounted) return;
      context.go(RouteNames.home);
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
                  const SizedBox(height: 40),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: switch (_state) {
                      _SplashState.initializing => const _LoadingIndicator(
                        key: ValueKey('loading'),
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
// Sub-widgets — private, stateless, zero unnecessary rebuilds
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

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: AppColors.teal500,
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 300.ms);
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
