import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medmind/app/theme/app_colors.dart';
import 'package:medmind/app/theme/app_typography.dart';
import 'package:medmind/core/services/biometric_auth_service.dart';

final _biometricServiceProvider = Provider<BiometricAuthService>(
  (_) => BiometricAuthService(),
);

final _biometricAvailableProvider = FutureProvider<bool>((ref) {
  return ref.read(_biometricServiceProvider).isAvailable();
});

final _biometricEnabledProvider =
    AsyncNotifierProvider<_BiometricEnabledNotifier, bool>(
      _BiometricEnabledNotifier.new,
    );

class _BiometricEnabledNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() {
    return ref.read(_biometricServiceProvider).isEnabled();
  }

  Future<void> toggle({required bool enabled}) async {
    await ref.read(_biometricServiceProvider).setEnabled(enabled: enabled);
    state = AsyncValue.data(enabled);
  }
}

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final biometricAvailable = ref.watch(_biometricAvailableProvider);
    final biometricEnabled = ref.watch(_biometricEnabledProvider);

    return Scaffold(
      backgroundColor: AppColors.zinc950,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          children: [
            Text('Settings', style: AppTypography.h1),
            const SizedBox(height: 32),
            Text('Keamanan', style: AppTypography.overline),
            const SizedBox(height: 8),
            biometricAvailable.when(
              data: (available) {
                if (!available) return const SizedBox.shrink();
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.zinc900,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SwitchListTile(
                    value: biometricEnabled.asData?.value ?? false,
                    onChanged: biometricEnabled.isLoading
                        ? null
                        : (value) => ref
                              .read(_biometricEnabledProvider.notifier)
                              .toggle(enabled: value),
                    title: Text('Kunci Biometrik', style: AppTypography.body),
                    subtitle: Text(
                      'Gunakan sidik jari atau wajah untuk membuka aplikasi',
                      style: AppTypography.caption,
                    ),
                    activeThumbColor: AppColors.teal500,
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
