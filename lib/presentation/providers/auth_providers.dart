import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medmind/core/services/biometric_auth_service.dart';
import 'package:medmind/presentation/providers/core_providers.dart';

// ---------------------------------------------------------------------------
// Biometric service — single instance via DI
// ---------------------------------------------------------------------------

final biometricServiceProvider = Provider<BiometricAuthService>(
  (_) => BiometricAuthService(),
);

/// Whether the device hardware supports biometric authentication.
final biometricAvailableProvider = FutureProvider<bool>(
  (ref) => ref.read(biometricServiceProvider).isAvailable(),
);

// ---------------------------------------------------------------------------
// Biometric enabled toggle (backed by UserPreferencesRepository)
// ---------------------------------------------------------------------------

final biometricEnabledNotifierProvider =
    AsyncNotifierProvider<BiometricEnabledNotifier, bool>(
      BiometricEnabledNotifier.new,
    );

class BiometricEnabledNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final result = await ref
        .read(userPreferencesRepositoryProvider)
        .isBiometricEnabled();
    return result.fold((_) => false, (v) => v);
  }

  Future<void> toggle({required bool enabled}) async {
    await ref
        .read(userPreferencesRepositoryProvider)
        .setBiometricEnabled(enabled: enabled);
    state = AsyncValue.data(enabled);
  }
}

// ---------------------------------------------------------------------------
// PIN enabled toggle (backed by UserPreferencesRepository)
// ---------------------------------------------------------------------------

final pinEnabledNotifierProvider =
    AsyncNotifierProvider<PinEnabledNotifier, bool>(PinEnabledNotifier.new);

class PinEnabledNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final result = await ref
        .read(userPreferencesRepositoryProvider)
        .isPinEnabled();
    return result.fold((_) => false, (v) => v);
  }

  Future<void> toggle({required bool enabled}) async {
    final repo = ref.read(userPreferencesRepositoryProvider);
    if (!enabled) await repo.clearPin();
    await repo.setPinEnabled(enabled: enabled);
    state = AsyncValue.data(enabled);
  }
}
