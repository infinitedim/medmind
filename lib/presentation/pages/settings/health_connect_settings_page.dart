import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:medmind/app/theme/app_colors.dart';
import 'package:medmind/app/theme/app_typography.dart';
import 'package:medmind/presentation/providers/core_providers.dart';

final _hcAvailableProvider = FutureProvider<bool>((ref) async {
  final repo = ref.watch(healthConnectRepositoryProvider);
  final result = await repo.checkAvailability();
  return result.fold((_) => false, (v) => v);
});

class HealthConnectSettingsPage extends ConsumerStatefulWidget {
  const HealthConnectSettingsPage({super.key});

  @override
  ConsumerState<HealthConnectSettingsPage> createState() =>
      _HealthConnectSettingsPageState();
}

class _HealthConnectSettingsPageState
    extends ConsumerState<HealthConnectSettingsPage> {
  bool _isConnecting = false;

  static final _dataTypes = [
    (icon: LucideIcons.moon, label: 'Data tidur'),
    (icon: LucideIcons.footprints, label: 'Jumlah langkah'),
    (icon: LucideIcons.scale, label: 'Berat badan'),
    (icon: LucideIcons.heartPulse, label: 'Detak jantung'),
  ];

  @override
  Widget build(BuildContext context) {
    final availableAsync = ref.watch(_hcAvailableProvider);
    final isConnecting = _isConnecting;

    return Scaffold(
      backgroundColor: AppColors.zinc950,
      appBar: AppBar(
        backgroundColor: AppColors.zinc950,
        title: Text('Health Connect', style: AppTypography.h2),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          // Status card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.zinc900,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.zinc800),
            ),
            child: availableAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.teal500),
              ),
              error: (_, _) => Row(
                children: [
                  const Icon(
                    LucideIcons.alertCircle,
                    color: AppColors.red400,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Gagal memeriksa ketersediaan',
                    style: AppTypography.body.copyWith(color: AppColors.red400),
                  ),
                ],
              ),
              data: (available) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: available
                              ? AppColors.emerald900_30
                              : AppColors.zinc800,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          LucideIcons.heartPulse,
                          size: 22,
                          color: available
                              ? AppColors.emerald400
                              : AppColors.zinc500,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Health Connect',
                            style: AppTypography.bodyMedium,
                          ),
                          Text(
                            available
                                ? 'Tersedia di perangkat ini'
                                : 'Tidak tersedia di perangkat ini',
                            style: AppTypography.caption.copyWith(
                              color: available
                                  ? AppColors.emerald400
                                  : AppColors.zinc500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (available) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: isConnecting
                            ? null
                            : () async {
                                setState(() => _isConnecting = true);
                                final repo = ref.read(
                                  healthConnectRepositoryProvider,
                                );
                                await repo.requestPermissions();
                                if (!mounted) return;
                                setState(() => _isConnecting = false);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Izin Health Connect diminta',
                                      ),
                                    ),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.teal600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: isConnecting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(LucideIcons.link, size: 18),
                        label: Text(
                          isConnecting
                              ? 'Menghubungkan...'
                              : 'Hubungkan Health Connect',
                          style: AppTypography.bodyMedium.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 12),
                    Text(
                      'Health Connect tidak tersedia di perangkat atau versi Android ini.',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.zinc500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          Text(
            'DATA YANG DISINKRONKAN',
            style: AppTypography.overline.copyWith(color: AppColors.zinc500),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.zinc900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                for (int i = 0; i < _dataTypes.length; i++) ...[
                  ListTile(
                    leading: Icon(
                      _dataTypes[i].icon,
                      color: AppColors.zinc400,
                      size: 20,
                    ),
                    title: Text(_dataTypes[i].label, style: AppTypography.body),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 2,
                    ),
                  ),
                  if (i < _dataTypes.length - 1)
                    Divider(height: 1, color: AppColors.zinc800, indent: 52),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
