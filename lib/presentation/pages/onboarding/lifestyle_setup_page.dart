import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medmind/app/routes/route_names.dart';
import 'package:medmind/app/theme/app_colors.dart';
import 'package:medmind/app/theme/app_typography.dart';
import 'package:medmind/presentation/providers/core_providers.dart';

const _kDefaultFactors = [
  (id: 'caffeine', label: 'Kafein', description: 'Kopi, teh, minuman energi'),
  (id: 'alcohol', label: 'Alkohol', description: 'Beer, wine, spirits'),
  (id: 'exercise', label: 'Olahraga', description: 'Aktivitas fisik harian'),
  (
    id: 'water',
    label: 'Air minum',
    description: 'Jumlah cairan yang dikonsumsi',
  ),
  (
    id: 'screen_time',
    label: 'Screen time',
    description: 'Penggunaan layar digital',
  ),
  (id: 'stress', label: 'Tingkat stres', description: 'Level stres harian'),
  (
    id: 'sleep_quality',
    label: 'Kualitas tidur',
    description: 'Seberapa nyenyak tidur',
  ),
  (
    id: 'diet',
    label: 'Pola makan',
    description: 'Kualitas makanan yang dikonsumsi',
  ),
  (
    id: 'social',
    label: 'Interaksi sosial',
    description: 'Bertemu teman/keluarga',
  ),
  (
    id: 'sunlight',
    label: 'Paparan sinar matahari',
    description: 'Waktu di luar ruangan',
  ),
  (
    id: 'meditation',
    label: 'Meditasi',
    description: 'Meditasi atau mindfulness',
  ),
  (id: 'smoking', label: 'Merokok', description: 'Konsumsi rokok/vaping'),
  (id: 'sugar', label: 'Gula', description: 'Konsumsi makanan/minuman manis'),
  (id: 'posture', label: 'Postur', description: 'Posisi duduk/berdiri'),
  (id: 'reading', label: 'Membaca', description: 'Aktivitas membaca'),
];

class LifestyleSetupPage extends ConsumerStatefulWidget {
  const LifestyleSetupPage({super.key});

  @override
  ConsumerState<LifestyleSetupPage> createState() => _LifestyleSetupPageState();
}

class _LifestyleSetupPageState extends ConsumerState<LifestyleSetupPage> {
  final Set<String> _selected = {};
  bool _saving = false;

  Future<void> _continue() async {
    setState(() => _saving = true);
    final repo = ref.read(userPreferencesRepositoryProvider);
    await repo.setTrackedLifestyleFactorIds(_selected.toList());
    if (!mounted) return;
    setState(() => _saving = false);
    context.go(RouteNames.securitySetup);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.zinc950,
      appBar: AppBar(
        backgroundColor: AppColors.zinc950,
        title: Text('Faktor Gaya Hidup', style: AppTypography.h2),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              '3 dari 4',
              style: AppTypography.caption.copyWith(color: AppColors.zinc400),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Faktor apa yang mempengaruhi kesehatanmu?',
                    style: AppTypography.h1,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pilih faktor yang ingin dicatat. Analisis AI akan menggunakannya.',
                    style: AppTypography.muted,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _kDefaultFactors.length,
                separatorBuilder: (_, i) =>
                    const Divider(height: 1, color: AppColors.zinc800),
                itemBuilder: (context, index) {
                  final factor = _kDefaultFactors[index];
                  final isSelected = _selected.contains(factor.id);
                  return InkWell(
                    onTap: () => setState(() {
                      if (isSelected) {
                        _selected.remove(factor.id);
                      } else {
                        _selected.add(factor.id);
                      }
                    }),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  factor.label,
                                  style: AppTypography.bodyMedium,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  factor.description,
                                  style: AppTypography.muted,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? AppColors.teal500
                                  : AppColors.zinc800,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.teal500
                                    : AppColors.zinc600,
                              ),
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    size: 14,
                                    color: AppColors.zinc950,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
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
            if (_selected.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '\${_selected.length} faktor dipilih',
                  style: AppTypography.captionMedium.copyWith(
                    color: AppColors.teal400,
                  ),
                ),
              ),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: _selected.isEmpty || _saving ? null : _continue,
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.zinc950,
                        ),
                      )
                    : const Text('Lanjut'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: _saving
                    ? null
                    : () => context.go(RouteNames.securitySetup),
                child: Text(
                  'Lewati',
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
