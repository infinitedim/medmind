import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:medmind/app/routes/route_names.dart';
import 'package:medmind/app/theme/app_colors.dart';
import 'package:medmind/app/theme/app_typography.dart';
import 'package:medmind/core/enum/enum_collection.dart';
import 'package:medmind/domain/entities/symptom.dart';
import 'package:medmind/presentation/providers/core_providers.dart';
import 'package:medmind/presentation/providers/symptom_providers.dart';
import 'package:uuid/uuid.dart';

class SymptomSetupPage extends ConsumerStatefulWidget {
  const SymptomSetupPage({super.key});

  @override
  ConsumerState<SymptomSetupPage> createState() => _SymptomSetupPageState();
}

class _SymptomSetupPageState extends ConsumerState<SymptomSetupPage> {
  final _searchController = TextEditingController();
  final _customController = TextEditingController();
  String _query = '';
  bool _saving = false;

  @override
  void dispose() {
    _searchController.dispose();
    _customController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    setState(() => _saving = true);
    await ref.read(symptomSetupNotifierProvider.notifier).save();
    if (!mounted) return;
    setState(() => _saving = false);
    context.go(RouteNames.lifestyleSetup);
  }

  Future<void> _addCustom(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    final symptom = Symptom(
      id: const Uuid().v4(),
      name: trimmed,
      category: SymptomCategory.general,
      icon: 'circle',
      isCustom: true,
    );
    final repo = ref.read(symptomRepositoryProvider);
    await repo.createSymptom(symptom);
    ref.invalidate(allSymptomsProvider);
    ref.read(symptomSetupNotifierProvider.notifier).toggle(symptom.id);
  }

  void _showAddCustomDialog() {
    _customController.clear();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.zinc900,
        title: Text('Tambah Gejala', style: AppTypography.h2),
        content: TextField(
          controller: _customController,
          autofocus: true,
          style: AppTypography.body,
          decoration: InputDecoration(
            hintText: 'Nama gejala...',
            hintStyle: AppTypography.body.copyWith(color: AppColors.zinc600),
          ),
          textCapitalization: TextCapitalization.sentences,
          onSubmitted: (v) {
            Navigator.of(ctx).pop();
            _addCustom(v);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _addCustom(_customController.text);
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final symptomsAsync = ref.watch(allSymptomsProvider);
    final selected = ref.watch(symptomSetupNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.zinc950,
      appBar: AppBar(
        backgroundColor: AppColors.zinc950,
        title: Text('Pilih Gejala', style: AppTypography.h2),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              '2 dari 4',
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
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Apa yang ingin kamu pantau?', style: AppTypography.h1),
                  const SizedBox(height: 4),
                  Text(
                    'Pilih gejala untuk dimonitor. Bisa diubah nanti.',
                    style: AppTypography.muted,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _searchController,
                    style: AppTypography.body,
                    decoration: InputDecoration(
                      hintText: 'Cari gejala...',
                      hintStyle: AppTypography.body.copyWith(
                        color: AppColors.zinc600,
                      ),
                      prefixIcon: const Icon(
                        LucideIcons.search,
                        size: 16,
                        color: AppColors.zinc500,
                      ),
                      filled: true,
                      fillColor: AppColors.zinc900,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.zinc800),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.zinc800),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    onChanged: (v) => setState(() => _query = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: symptomsAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.teal500,
                  ),
                ),
                error: (_, e) => Center(
                  child: Text(
                    'Gagal memuat gejala',
                    style: AppTypography.muted,
                  ),
                ),
                data: (symptoms) {
                  final filtered = _query.isEmpty
                      ? symptoms
                      : symptoms
                            .where(
                              (s) => s.name.toLowerCase().contains(
                                _query.toLowerCase(),
                              ),
                            )
                            .toList();
                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildCategoryChips(
                        filtered,
                        selected,
                        SymptomCategory.neurological,
                        'Neurologis',
                      ),
                      _buildCategoryChips(
                        filtered,
                        selected,
                        SymptomCategory.digestive,
                        'Pencernaan',
                      ),
                      _buildCategoryChips(
                        filtered,
                        selected,
                        SymptomCategory.respiratory,
                        'Pernapasan',
                      ),
                      _buildCategoryChips(
                        filtered,
                        selected,
                        SymptomCategory.musculoskeletal,
                        'Otot & Sendi',
                      ),
                      _buildCategoryChips(
                        filtered,
                        selected,
                        SymptomCategory.psychological,
                        'Psikologis',
                      ),
                      _buildCategoryChips(
                        filtered,
                        selected,
                        SymptomCategory.skin,
                        'Kulit',
                      ),
                      _buildCategoryChips(
                        filtered,
                        selected,
                        SymptomCategory.general,
                        'Umum',
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: _showAddCustomDialog,
                        icon: const Icon(LucideIcons.plus, size: 16),
                        label: const Text('Tambah gejala kustom'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.teal400,
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
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
            if (selected.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '\${selected.length} gejala dipilih',
                  style: AppTypography.captionMedium.copyWith(
                    color: AppColors.teal400,
                  ),
                ),
              ),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: selected.isEmpty || _saving ? null : _continue,
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
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChips(
    List<Symptom> symptoms,
    Set<String> selected,
    SymptomCategory category,
    String label,
  ) {
    final inCategory = symptoms.where((s) => s.category == category).toList();
    if (inCategory.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          label,
          style: AppTypography.captionMedium.copyWith(color: AppColors.zinc400),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: inCategory.map((symptom) {
            final isSelected = selected.contains(symptom.id);
            return _SymptomChip(
              label: symptom.name,
              selected: isSelected,
              onTap: () => ref
                  .read(symptomSetupNotifierProvider.notifier)
                  .toggle(symptom.id),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _SymptomChip extends StatelessWidget {
  const _SymptomChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? AppColors.teal500_20 : AppColors.zinc900,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? AppColors.teal500 : AppColors.zinc700,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.small.copyWith(
            color: selected ? AppColors.teal300 : AppColors.zinc300,
          ),
        ),
      ),
    );
  }
}
