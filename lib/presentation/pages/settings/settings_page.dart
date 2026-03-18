import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:medmind/app/routes/route_names.dart';
import 'package:medmind/app/theme/app_colors.dart';
import 'package:medmind/app/theme/app_typography.dart';
import 'package:medmind/presentation/providers/auth_providers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final biometricAvailable = ref.watch(biometricAvailableProvider);
    final biometricEnabled = ref.watch(biometricEnabledNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.zinc950,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.teal500_10,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      LucideIcons.heart,
                      color: AppColors.teal500,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('MedMind', style: AppTypography.h2),
                      Text(
                        'Pengaturan',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.zinc500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Section: Journal
            _SectionHeader(label: 'Journal'),
            const SizedBox(height: 8),
            _SettingsGroup(
              children: [
                _NavTile(
                  icon: LucideIcons.bell,
                  label: 'Pengingat harian',
                  subtitle: 'Atur jadwal journaling',
                  onTap: () => context.push(RouteNames.reminders),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Section: Keamanan
            _SectionHeader(label: 'Keamanan'),
            const SizedBox(height: 8),
            _SettingsGroup(
              children: [
                biometricAvailable.when(
                  data: (available) {
                    if (!available) return const SizedBox.shrink();
                    return SwitchListTile(
                      value: biometricEnabled.asData?.value ?? false,
                      onChanged: biometricEnabled.isLoading
                          ? null
                          : (value) => ref
                                .read(biometricEnabledNotifierProvider.notifier)
                                .toggle(enabled: value),
                      title: Text('Kunci Biometrik', style: AppTypography.body),
                      subtitle: Text(
                        'Sidik jari atau wajah',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.zinc500,
                        ),
                      ),
                      secondary: const Icon(
                        LucideIcons.fingerprint,
                        color: AppColors.zinc400,
                      ),
                      activeThumbColor: AppColors.teal500,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
                _NavTile(
                  icon: LucideIcons.shieldCheck,
                  label: 'Pengaturan keamanan',
                  subtitle: 'PIN, biometrik, dan data',
                  onTap: () => context.push(RouteNames.securitySettings),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Section: Data
            _SectionHeader(label: 'Data'),
            const SizedBox(height: 8),
            _SettingsGroup(
              children: [
                _NavTile(
                  icon: LucideIcons.heartPulse,
                  label: 'Health Connect',
                  subtitle: 'Sinkronisasi data kesehatan',
                  onTap: () => context.push(RouteNames.healthConnect),
                ),
                _NavTile(
                  icon: LucideIcons.download,
                  label: 'Ekspor data',
                  subtitle: 'Unduh data journalmu',
                  onTap: () => context.push(RouteNames.exportData),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: AppTypography.overline.copyWith(color: AppColors.zinc500),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.zinc900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1)
              Divider(height: 1, color: AppColors.zinc800, indent: 52),
          ],
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.icon,
    required this.label,
    this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.zinc400, size: 20),
      title: Text(label, style: AppTypography.body),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTypography.caption.copyWith(color: AppColors.zinc500),
            )
          : null,
      trailing: const Icon(
        LucideIcons.chevronRight,
        size: 16,
        color: AppColors.zinc600,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
