import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:medmind/app/theme/app_colors.dart';
import 'package:medmind/app/theme/app_typography.dart';
import 'package:medmind/core/services/biometric_auth_service.dart';

final _secBiometricServiceProvider = Provider<BiometricAuthService>(
  (_) => BiometricAuthService(),
);

final _secBiometricAvailableProvider = FutureProvider<bool>((ref) {
  return ref.read(_secBiometricServiceProvider).isAvailable();
});

final _secBiometricEnabledProvider =
    AsyncNotifierProvider<_SecBiometricNotifier, bool>(
      _SecBiometricNotifier.new,
    );

class _SecBiometricNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() => ref.read(_secBiometricServiceProvider).isEnabled();

  Future<void> toggle({required bool enabled}) async {
    await ref.read(_secBiometricServiceProvider).setEnabled(enabled: enabled);
    state = AsyncValue.data(enabled);
  }
}

class SecuritySettingsPage extends ConsumerWidget {
  const SecuritySettingsPage({super.key});

  Future<void> _confirmDeleteAll(BuildContext context) async {
    final first = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.zinc900,
        title: Text('Hapus semua data?', style: AppTypography.h3),
        content: Text(
          'Semua data journal, pengaturan, dan riwayat akan dihapus secara permanen.',
          style: AppTypography.body.copyWith(color: AppColors.zinc400),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Batal',
              style: AppTypography.body.copyWith(color: AppColors.zinc400),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Hapus permanen',
              style: AppTypography.body.copyWith(color: AppColors.red400),
            ),
          ),
        ],
      ),
    );
    if (first != true || !context.mounted) return;

    // Second confirmation
    final second = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.zinc900,
        title: Text('Yakin?', style: AppTypography.h3),
        content: Text(
          'Tindakan ini tidak dapat dibatalkan. Ketik "HAPUS" untuk melanjutkan.',
          style: AppTypography.body.copyWith(color: AppColors.zinc400),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Batal',
              style: AppTypography.body.copyWith(color: AppColors.zinc400),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Konfirmasi hapus',
              style: AppTypography.body.copyWith(color: AppColors.red500),
            ),
          ),
        ],
      ),
    );
    if (second != true || !context.mounted) return;

    // Placeholder – wired to actual deletion in Step 16
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fitur hapus data akan segera tersedia')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final biometricAvailable = ref.watch(_secBiometricAvailableProvider);
    final biometricEnabled = ref.watch(_secBiometricEnabledProvider);

    return Scaffold(
      backgroundColor: AppColors.zinc950,
      appBar: AppBar(
        backgroundColor: AppColors.zinc950,
        title: Text('Keamanan', style: AppTypography.h2),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          // Biometric section
          Text(
            'AUTENTIKASI',
            style: AppTypography.overline.copyWith(color: AppColors.zinc500),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.zinc900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: biometricAvailable.when(
              data: (available) {
                if (!available) {
                  return ListTile(
                    leading: const Icon(
                      LucideIcons.fingerprint,
                      color: AppColors.zinc600,
                    ),
                    title: Text(
                      'Biometrik tidak tersedia',
                      style: AppTypography.body.copyWith(
                        color: AppColors.zinc500,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                  );
                }
                return SwitchListTile(
                  value: biometricEnabled.asData?.value ?? false,
                  onChanged: biometricEnabled.isLoading
                      ? null
                      : (value) => ref
                            .read(_secBiometricEnabledProvider.notifier)
                            .toggle(enabled: value),
                  secondary: const Icon(
                    LucideIcons.fingerprint,
                    color: AppColors.zinc400,
                  ),
                  title: Text('Kunci Biometrik', style: AppTypography.body),
                  subtitle: Text(
                    'Gunakan sidik jari atau wajah untuk membuka aplikasi',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.zinc500,
                    ),
                  ),
                  activeThumbColor: AppColors.teal500,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                );
              },
              loading: () => const ListTile(
                leading: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                title: Text('Memuat...'),
              ),
              error: (_, _) => const SizedBox.shrink(),
            ),
          ),
          const SizedBox(height: 32),

          // Danger zone
          Text(
            'ZONA BERBAHAYA',
            style: AppTypography.overline.copyWith(color: AppColors.red400),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.zinc900,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.red900_20),
            ),
            child: ListTile(
              leading: const Icon(
                LucideIcons.trash2,
                color: AppColors.red400,
                size: 20,
              ),
              title: Text(
                'Hapus semua data',
                style: AppTypography.body.copyWith(color: AppColors.red400),
              ),
              subtitle: Text(
                'Hapus seluruh data aplikasi secara permanen',
                style: AppTypography.caption.copyWith(color: AppColors.zinc500),
              ),
              onTap: () => _confirmDeleteAll(context),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
