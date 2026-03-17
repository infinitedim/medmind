import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:medmind/app/theme/app_colors.dart';
import 'package:medmind/app/theme/app_typography.dart';
import 'package:medmind/core/enum/enum_collection.dart';
import 'package:medmind/presentation/providers/journal_providers.dart';
import 'package:medmind/presentation/providers/preference_providers.dart';
import 'package:medmind/presentation/shared/loading_indicator.dart';
import 'package:medmind/presentation/widgets/journal/free_text_input.dart';
import 'package:medmind/presentation/widgets/journal/lifestyle_input.dart';
import 'package:medmind/presentation/widgets/journal/medication_input.dart';
import 'package:medmind/presentation/widgets/journal/mood_picker.dart';
import 'package:medmind/presentation/widgets/journal/sleep_input.dart';
import 'package:medmind/presentation/widgets/journal/symptom_selector.dart';
import 'package:medmind/presentation/widgets/journal/vitals_input.dart';

class JournalEntryPage extends ConsumerStatefulWidget {
  const JournalEntryPage({this.entryId, super.key});

  final String? entryId;

  @override
  ConsumerState<JournalEntryPage> createState() => _JournalEntryPageState();
}

class _JournalEntryPageState extends ConsumerState<JournalEntryPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool _hasData(JournalFormState form) =>
      form.mood != null ||
      form.symptoms.isNotEmpty ||
      form.sleepRecord != null ||
      form.medications.isNotEmpty ||
      form.lifestyleFactors.isNotEmpty ||
      form.freeText != null ||
      form.activityLevel != null ||
      form.vitalRecord != null;

  Future<bool> _confirmDiscard(JournalFormState? form) async {
    if (form == null || !_hasData(form)) return true;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.zinc900,
        title: Text('Tinggalkan halaman?', style: AppTypography.h3),
        content: Text(
          'Perubahan belum disimpan akan hilang.',
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
              'Tinggalkan',
              style: AppTypography.body.copyWith(color: AppColors.red400),
            ),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  Future<void> _pickDate(BuildContext context, DateTime current) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.teal500,
            onPrimary: AppColors.zinc950,
            surface: AppColors.zinc900,
            onSurface: AppColors.zinc50,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null && mounted) {
      ref.read(journalFormProvider(widget.entryId).notifier).setDate(picked);
    }
  }

  Future<void> _deleteEntry() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.zinc900,
        title: Text('Hapus entri?', style: AppTypography.h3),
        content: Text(
          'Entri ini akan dihapus secara permanen.',
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
              'Hapus',
              style: AppTypography.body.copyWith(color: AppColors.red400),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final success = await ref
        .read(journalFormProvider(widget.entryId).notifier)
        .delete();
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Entri berhasil dihapus')));
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menghapus entri'),
          backgroundColor: AppColors.red500,
        ),
      );
    }
  }

  Future<void> _submit() async {
    final success = await ref
        .read(journalFormProvider(widget.entryId).notifier)
        .submit();
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Entri berhasil disimpan')));
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menyimpan entri'),
          backgroundColor: AppColors.red500,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formAsync = ref.watch(journalFormProvider(widget.entryId));
    final medicationsAsync = ref.watch(userMedicationsProvider);
    final factorsAsync = ref.watch(trackedLifestyleFactorsProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final canPop = await _confirmDiscard(formAsync.asData?.value);
        if (canPop && mounted) context.pop();
      },
      child: Scaffold(
        backgroundColor: AppColors.zinc950,
        appBar: AppBar(
          backgroundColor: AppColors.zinc950,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(LucideIcons.x, color: AppColors.zinc400),
            onPressed: () async {
              final canPop = await _confirmDiscard(formAsync.asData?.value);
              if (canPop && mounted) context.pop();
            },
          ),
          title: formAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (form) => GestureDetector(
              onTap: () => _pickDate(context, form.date),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateFormat('d MMM yyyy').format(form.date),
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.teal400,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    LucideIcons.chevronDown,
                    size: 16,
                    color: AppColors.teal400,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            if (widget.entryId != null)
              formAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
                data: (form) => IconButton(
                  icon: const Icon(LucideIcons.trash2, color: AppColors.red400),
                  onPressed: form.isSaving ? null : _deleteEntry,
                ),
              ),
          ],
          bottom: TabBar(
            controller: _tabController,
            labelColor: AppColors.teal400,
            unselectedLabelColor: AppColors.zinc500,
            indicatorColor: AppColors.teal500,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: AppColors.zinc800,
            tabs: const [
              Tab(icon: Icon(LucideIcons.smile, size: 20), text: 'Mood'),
              Tab(icon: Icon(LucideIcons.moon, size: 20), text: 'Tidur'),
              Tab(icon: Icon(LucideIcons.activity, size: 20), text: 'Vital'),
              Tab(icon: Icon(LucideIcons.leaf, size: 20), text: 'Lainnya'),
            ],
          ),
        ),
        body: formAsync.when(
          loading: () => const LoadingIndicator(message: 'Memuat entri...'),
          error: (e, _) =>
              Center(child: Text('Error: $e', style: AppTypography.body)),
          data: (form) => TabBarView(
            controller: _tabController,
            children: [
              _MoodTab(
                entryId: widget.entryId,
                activityLevel: form.activityLevel,
              ),
              _SleepTab(
                entryId: widget.entryId,
                medicationsAsync: medicationsAsync,
              ),
              _VitalsTab(entryId: widget.entryId),
              _LifestyleTab(
                entryId: widget.entryId,
                factorsAsync: factorsAsync,
              ),
            ],
          ),
        ),
        floatingActionButton: formAsync.asData?.value != null
            ? FloatingActionButton.extended(
                onPressed: formAsync.asData!.value.isSaving ? null : _submit,
                backgroundColor: AppColors.teal600,
                label: formAsync.asData!.value.isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Simpan',
                        style: AppTypography.bodyMedium.copyWith(
                          color: Colors.white,
                        ),
                      ),
                icon: formAsync.asData!.value.isSaving
                    ? null
                    : const Icon(LucideIcons.save, color: Colors.white),
              )
            : null,
      ),
    );
  }
}

class _MoodTab extends StatelessWidget {
  const _MoodTab({required this.entryId, required this.activityLevel});

  final String? entryId;
  final ActivityLevel? activityLevel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MoodPicker(entryId: entryId),
          const SizedBox(height: 28),
          Text('Aktivitas Fisik', style: AppTypography.h3),
          const SizedBox(height: 12),
          _ActivityLevelSelector(entryId: entryId, current: activityLevel),
          const SizedBox(height: 28),
          SymptomSelector(entryId: entryId),
        ],
      ),
    );
  }
}

class _SleepTab extends StatelessWidget {
  const _SleepTab({required this.entryId, required this.medicationsAsync});

  final String? entryId;
  final AsyncValue medicationsAsync;

  @override
  Widget build(BuildContext context) {
    final meds = medicationsAsync.asData?.value ?? const [];
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SleepInput(entryId: entryId),
          const SizedBox(height: 28),
          MedicationInput(entryId: entryId, medications: meds),
        ],
      ),
    );
  }
}

class _VitalsTab extends StatelessWidget {
  const _VitalsTab({required this.entryId});

  final String? entryId;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
      child: VitalsInput(entryId: entryId),
    );
  }
}

class _LifestyleTab extends StatelessWidget {
  const _LifestyleTab({required this.entryId, required this.factorsAsync});

  final String? entryId;
  final AsyncValue factorsAsync;

  @override
  Widget build(BuildContext context) {
    final factors = factorsAsync.asData?.value ?? const [];
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LifestyleInput(entryId: entryId, factors: factors),
          const SizedBox(height: 28),
          FreeTextInput(entryId: entryId),
        ],
      ),
    );
  }
}

class _ActivityLevelSelector extends ConsumerWidget {
  const _ActivityLevelSelector({required this.entryId, required this.current});

  final String? entryId;
  final ActivityLevel? current;

  static const _levels = [
    (level: ActivityLevel.sedentary, label: 'Santai', emoji: '🪑'),
    (level: ActivityLevel.light, label: 'Ringan', emoji: '🚶'),
    (level: ActivityLevel.moderate, label: 'Sedang', emoji: '🏃'),
    (level: ActivityLevel.active, label: 'Aktif', emoji: '💪'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _levels.map((item) {
        final isSelected = current == item.level;
        return GestureDetector(
          onTap: () => ref
              .read(journalFormProvider(entryId).notifier)
              .setActivityLevel(item.level),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.teal500_20 : AppColors.zinc900,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.teal500 : AppColors.zinc700,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(item.emoji, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Text(
                  item.label,
                  style: AppTypography.body.copyWith(
                    color: isSelected ? AppColors.teal400 : AppColors.zinc300,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
