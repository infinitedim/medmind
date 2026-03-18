import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:medmind/app/routes/route_names.dart';
import 'package:medmind/app/theme/app_colors.dart';
import 'package:medmind/app/theme/app_typography.dart';
import 'package:medmind/presentation/providers/auth_providers.dart';
import 'package:medmind/presentation/widgets/settings_switch_tile.dart';

class SecuritySettingsPage extends ConsumerWidget {
  const SecuritySettingsPage({super.key});

  Future<void> _confirmDeleteAll(BuildContext context) async {
    final first = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.zinc900,
        title: Text('Hapus semua data?', style: AppTypography.h3),
        content: Text(
          'Semua data journal, pengaturan, dan riwayat akan dihapus secara permanen.',
          style: AppTypography.body.copyWith(color: AppColors.zinc400),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: Text(
              'Batal',
              style: AppTypography.body.copyWith(color: AppColors.zinc400),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
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
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.zinc900,
        title: Text('Yakin?', style: AppTypography.h3),
        content: Text(
          'Tindakan ini tidak dapat dibatalkan. Ketik "HAPUS" untuk melanjutkan.',
          style: AppTypography.body.copyWith(color: AppColors.zinc400),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: Text(
              'Batal',
              style: AppTypography.body.copyWith(color: AppColors.zinc400),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
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
    final biometricAvailable = ref.watch(biometricAvailableProvider);
    final biometricEnabled = ref.watch(biometricEnabledNotifierProvider);
    final pinEnabled = ref.watch(pinEnabledNotifierProvider);

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
            child: Column(
              children: [
                // Biometric toggle
                biometricAvailable.when(
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
                    return SettingsSwitchTile(
                      icon: LucideIcons.fingerprint,
                      title: 'Kunci Biometrik',
                      subtitle:
                          'Gunakan sidik jari atau wajah untuk membuka aplikasi',
                      value: biometricEnabled.asData?.value ?? false,
                      loading: biometricEnabled.isLoading,
                      onChanged: biometricEnabled.isLoading
                          ? null
                          : (value) => ref
                                .read(biometricEnabledNotifierProvider.notifier)
                                .toggle(enabled: value),
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
                Divider(height: 1, color: AppColors.zinc800, indent: 52),
                // PIN toggle
                SettingsSwitchTile(
                  icon: LucideIcons.keyRound,
                  title: 'Kunci PIN',
                  subtitle: 'PIN 4 digit sebagai fallback biometrik',
                  value: pinEnabled.asData?.value ?? false,
                  loading: pinEnabled.isLoading,
                  onChanged: pinEnabled.isLoading
                      ? null
                      : (value) {
                          if (value) {
                            context.push(
                              RouteNames.pinLock,
                              extra: {'mode': 'create'},
                            );
                          } else {
                            ref
                                .read(pinEnabledNotifierProvider.notifier)
                                .toggle(enabled: false);
                          }
                        },
                ),
              ],
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
