import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:medmind/app/theme/app_colors.dart';
import 'package:medmind/app/theme/app_typography.dart';
import 'package:medmind/core/services/biometric_auth_service.dart';
import 'package:medmind/presentation/providers/core_providers.dart';
import 'package:medmind/presentation/providers/preference_providers.dart';

class SecuritySetupPage extends ConsumerStatefulWidget {
  const SecuritySetupPage({super.key});

  @override
  ConsumerState<SecuritySetupPage> createState() => _SecuritySetupPageState();
}

class _SecuritySetupPageState extends ConsumerState<SecuritySetupPage> {
  bool _biometricEnabled = false;
  bool _biometricAvailable = false;
  bool _finishing = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    final service = BiometricAuthService();
    final available = await service.isAvailable();
    if (mounted) setState(() => _biometricAvailable = available);
  }

  Future<void> _finish({bool skipBiometric = false}) async {
    setState(() => _finishing = true);
    final repo = ref.read(userPreferencesRepositoryProvider);
    if (!skipBiometric) {
      await repo.setBiometricEnabled(enabled: _biometricEnabled);
    }
    await repo.completeOnboarding();
    if (!mounted) return;
    ref.invalidate(onboardingCompleteProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.zinc950,
      appBar: AppBar(
        backgroundColor: AppColors.zinc950,
        title: Text('Keamanan', style: AppTypography.h2),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              '4 dari 4',
              style: AppTypography.caption.copyWith(color: AppColors.zinc400),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Lindungi data kesehatanmu', style: AppTypography.h1),
              const SizedBox(height: 4),
              Text(
                'Semua data dienkripsi AES-256 dan tidak pernah meninggalkan perangkatmu.',
                style: AppTypography.muted,
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.zinc900,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.zinc800),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.teal500_10,
                      ),
                      child: const Icon(
                        LucideIcons.fingerprint,
                        size: 20,
                        color: AppColors.teal400,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kunci Biometrik',
                            style: AppTypography.bodyMedium,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _biometricAvailable
                                ? 'Gunakan sidik jari atau wajah untuk membuka aplikasi'
                                : 'Perangkat tidak mendukung biometrik',
                            style: AppTypography.muted,
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _biometricEnabled,
                      onChanged: _biometricAvailable
                          ? (v) => setState(() => _biometricEnabled = v)
                          : null,
                      activeThumbColor: AppColors.teal500,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.teal500_10,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.teal500_20),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      LucideIcons.shieldCheck,
                      size: 18,
                      color: AppColors.teal400,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Data dienkripsi menggunakan AES-256-GCM dengan kunci yang tersimpan di Android Keystore hardware. Tidak ada cloud sync — semua data hanya ada di perangkat ini.',
                        style:
                            AppTypography.small.copyWith(color: AppColors.teal300),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          8,
          16,
          MediaQuery.of(context).padding.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: _finishing ? null : _finish,
                child: _finishing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.zinc950,
                        ),
                      )
                    : const Text('Mulai Journaling!'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed:
                    _finishing ? null : () => _finish(skipBiometric: true),
                child: Text(
                  'Lewati pengaturan keamanan',
                  style: AppTypography.body.copyWith(color: AppColors.zinc500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
