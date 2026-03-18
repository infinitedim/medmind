import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:medmind/app/routes/route_names.dart';
import 'package:medmind/app/theme/app_colors.dart';
import 'package:medmind/app/theme/app_typography.dart';
import 'package:medmind/presentation/providers/auth_providers.dart';
import 'package:medmind/presentation/providers/core_providers.dart';

// ---------------------------------------------------------------------------
// Public API
// ---------------------------------------------------------------------------

/// Operating mode for [PinEntryPage].
enum PinMode {
  /// Verify an existing PIN (used at app unlock).
  verify,

  /// Set a new PIN (used from Security Settings).
  create,
}

/// Full-screen PIN entry page.
///
/// Route extra: `{'mode': 'verify'}` or `{'mode': 'create'}`.
/// Defaults to [PinMode.verify] when no extra is provided.
class PinEntryPage extends ConsumerStatefulWidget {
  const PinEntryPage({super.key});

  @override
  ConsumerState<PinEntryPage> createState() => _PinEntryPageState();
}

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

class _PinEntryPageState extends ConsumerState<PinEntryPage>
    with SingleTickerProviderStateMixin {
  static const _pinLength = 4;
  static const _maxAttempts = 5;
  static const _shakeDuration = Duration(milliseconds: 400);
  static const _cooldownDuration = Duration(seconds: 2);

  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  PinMode _mode = PinMode.verify;
  final List<String> _digits = [];
  List<String>? _firstEntry; // used in create mode to hold first input
  bool _isConfirmStep = false;
  int _attempts = 0;
  bool _locked = false;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: _shakeDuration,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra;
    if (extra is Map<String, dynamic> && extra['mode'] == 'create') {
      _mode = PinMode.create;
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  // -------------------------------------------------------------------------
  // Input handling
  // -------------------------------------------------------------------------

  void _onDigit(String digit) {
    if (_locked || _digits.length >= _pinLength) return;
    setState(() => _digits.add(digit));
    if (_digits.length == _pinLength) {
      _onComplete();
    }
  }

  void _onBackspace() {
    if (_locked || _digits.isEmpty) return;
    setState(() => _digits.removeLast());
  }

  Future<void> _onComplete() async {
    final pin = _digits.join();
    switch (_mode) {
      case PinMode.create:
        await _handleCreate(pin);
      case PinMode.verify:
        await _handleVerify(pin);
    }
  }

  // -------------------------------------------------------------------------
  // Create flow
  // -------------------------------------------------------------------------

  Future<void> _handleCreate(String pin) async {
    if (!_isConfirmStep) {
      // First entry — wait for confirmation
      setState(() {
        _firstEntry = List<String>.from(_digits);
        _digits.clear();
        _isConfirmStep = true;
      });
      return;
    }

    // Confirmation step
    if (pin == _firstEntry!.join()) {
      final repo = ref.read(userPreferencesRepositoryProvider);
      await repo.setPin(pin);
      await repo.setPinEnabled(enabled: true);
      ref.invalidate(pinEnabledNotifierProvider);
      if (!mounted) return;
      context.pop();
    } else {
      await _shake();
      if (!mounted) return;
      setState(() {
        _digits.clear();
        _firstEntry = null;
        _isConfirmStep = false;
      });
      _showSnack('PIN tidak cocok. Coba lagi.');
    }
  }

  // -------------------------------------------------------------------------
  // Verify flow
  // -------------------------------------------------------------------------

  Future<void> _handleVerify(String pin) async {
    final repo = ref.read(userPreferencesRepositoryProvider);
    final result = await repo.getPin();
    final storedPin = result.fold((_) => null, (v) => v);

    if (storedPin != null && pin == storedPin) {
      if (!mounted) return;
      context.go(RouteNames.home);
      return;
    }

    await _shake();
    if (!mounted) return;

    _attempts++;
    if (_attempts >= _maxAttempts) {
      setState(() {
        _locked = true;
        _digits.clear();
      });
      await Future.delayed(_cooldownDuration);
      if (!mounted) return;
      setState(() {
        _locked = false;
        _attempts = 0;
      });
    } else {
      setState(() => _digits.clear());
      _showSnack('PIN salah. ${_maxAttempts - _attempts} percobaan tersisa.');
    }
  }

  // -------------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------------

  Future<void> _shake() async {
    _shakeController.reset();
    await _shakeController.forward();
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: AppTypography.body),
        backgroundColor: AppColors.zinc800,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Build
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final title = switch ((_mode, _isConfirmStep)) {
      (PinMode.create, false) => 'Buat PIN baru',
      (PinMode.create, true) => 'Konfirmasi PIN',
      (PinMode.verify, _) => 'Masukkan PIN',
    };

    final subtitle = switch ((_mode, _isConfirmStep)) {
      (PinMode.create, false) => 'Masukkan 4 digit PIN',
      (PinMode.create, true) => 'Masukkan PIN yang sama sekali lagi',
      (PinMode.verify, _) => 'Masukkan PIN untuk membuka aplikasi',
    };

    return PopScope(
      canPop: _mode == PinMode.create,
      child: Scaffold(
        backgroundColor: AppColors.zinc950,
        appBar: _mode == PinMode.create
            ? AppBar(
                backgroundColor: AppColors.zinc950,
                leading: IconButton(
                  icon: const Icon(
                    LucideIcons.x,
                    color: AppColors.zinc400,
                    size: 20,
                  ),
                  onPressed: () => context.pop(),
                ),
              )
            : null,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const Spacer(flex: 2),
                // Icon
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.teal500_10,
                  ),
                  child: const Icon(
                    LucideIcons.keyRound,
                    color: AppColors.teal400,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: AppTypography.h1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: AppTypography.muted,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Dot indicators with shake animation
                AnimatedBuilder(
                  animation: _shakeAnimation,
                  builder: (context, child) {
                    final offset = Tween<double>(begin: 0, end: 12).animate(
                      CurvedAnimation(
                        parent: _shakeController,
                        curve: _ShakeCurve(),
                      ),
                    );
                    return Transform.translate(
                      offset: Offset(offset.value, 0),
                      child: child,
                    );
                  },
                  child: _DotIndicator(
                    total: _pinLength,
                    filled: _digits.length,
                    locked: _locked,
                  ),
                ),

                const Spacer(flex: 3),

                // Numpad
                _Numpad(
                  onDigit: _onDigit,
                  onBackspace: _onBackspace,
                  enabled: !_locked,
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Dot indicator row
// ---------------------------------------------------------------------------

class _DotIndicator extends StatelessWidget {
  const _DotIndicator({
    required this.total,
    required this.filled,
    required this.locked,
  });

  final int total;
  final int filled;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final isFilled = i < filled;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: locked
                ? AppColors.red500
                : isFilled
                ? AppColors.teal400
                : Colors.transparent,
            border: Border.all(
              color: locked
                  ? AppColors.red500
                  : isFilled
                  ? AppColors.teal400
                  : AppColors.zinc600,
              width: 2,
            ),
          ),
        );
      }),
    );
  }
}

// ---------------------------------------------------------------------------
// Numpad
// ---------------------------------------------------------------------------

class _Numpad extends StatelessWidget {
  const _Numpad({
    required this.onDigit,
    required this.onBackspace,
    required this.enabled,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final bool enabled;

  static const _keys = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['', '0', '<'],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _keys.map((row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((key) {
              if (key.isEmpty) return const SizedBox(width: 80, height: 64);
              if (key == '<') {
                return _NumKey(
                  onTap: enabled ? onBackspace : null,
                  child: const Icon(
                    LucideIcons.delete,
                    size: 22,
                    color: AppColors.zinc400,
                  ),
                );
              }
              return _NumKey(
                onTap: enabled ? () => onDigit(key) : null,
                child: Text(key, style: AppTypography.h1),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}

class _NumKey extends StatelessWidget {
  const _NumKey({required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(40),
          splashColor: AppColors.teal500_10,
          highlightColor: AppColors.zinc800,
          child: SizedBox(width: 72, height: 72, child: Center(child: child)),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shake curve
// ---------------------------------------------------------------------------

class _ShakeCurve extends Curve {
  @override
  double transform(double t) =>
      // Two quick bounces left/right
      (t < 0.25)
      ? t * 4
      : (t < 0.5)
      ? (0.5 - t) * 4
      : (t < 0.75)
      ? (t - 0.5) * 4
      : (1.0 - t) * 4;
}
