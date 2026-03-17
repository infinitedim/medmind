import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medmind/app/theme/app_colors.dart';
import 'package:medmind/app/theme/app_typography.dart';
import 'package:medmind/domain/entities/medication.dart';
import 'package:medmind/presentation/providers/journal_providers.dart';

class MedicationInput extends ConsumerWidget {
  const MedicationInput({
    required this.entryId,
    required this.medications,
    super.key,
  });

  final String? entryId;
  final List<Medication> medications;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formAsync = ref.watch(journalFormProvider(entryId));
    final notifier = ref.read(journalFormProvider(entryId).notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Medications', style: AppTypography.h3),
        const SizedBox(height: 12),
        if (medications.isEmpty)
          Text(
            'No medications added. Add medications in settings.',
            style: AppTypography.body.copyWith(color: AppColors.zinc500),
          )
        else
          formAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, e) => const SizedBox.shrink(),
            data: (form) => ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: medications.length,
              separatorBuilder: (_, i) => const Divider(
                color: AppColors.zinc800,
                height: 1,
              ),
              itemBuilder: (_, idx) {
                final med = medications[idx];
                final log = form.medications
                    .where((m) => m.medicationId == med.id)
                    .firstOrNull;
                return _MedicationTile(
                  medication: med,
                  log: log,
                  onToggle: (taken) => notifier.addMedicationLog(
                    MedicationLog(medicationId: med.id, taken: taken),
                  ),
                  onTimeChanged: (time) {
                    if (log != null) {
                      notifier.addMedicationLog(log.copyWith(time: time));
                    }
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}

class _MedicationTile extends StatelessWidget {
  const _MedicationTile({
    required this.medication,
    required this.log,
    required this.onToggle,
    required this.onTimeChanged,
  });

  final Medication medication;
  final MedicationLog? log;
  final ValueChanged<bool> onToggle;
  final ValueChanged<TimeOfDay> onTimeChanged;

  @override
  Widget build(BuildContext context) {
    final taken = log?.taken ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => onToggle(!taken),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: taken ? AppColors.emerald900_30 : AppColors.zinc800,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: taken ? AppColors.emerald500 : AppColors.zinc700,
                ),
              ),
              child: Icon(
                taken ? Icons.check : Icons.close,
                size: 18,
                color: taken ? AppColors.emerald400 : AppColors.zinc600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(medication.name, style: AppTypography.bodyMedium),
                if (medication.dosage != null)
                  Text(
                    medication.dosage!,
                    style: AppTypography.caption.copyWith(color: AppColors.zinc500),
                  ),
              ],
            ),
          ),
          if (taken)
            GestureDetector(
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: log?.time ?? TimeOfDay.now(),
                  builder: (ctx, child) => Theme(
                    data: Theme.of(ctx).copyWith(
                      colorScheme: const ColorScheme.dark(
                        primary: AppColors.teal500,
                        surface: AppColors.zinc900,
                      ),
                    ),
                    child: child!,
                  ),
                );
                if (picked != null) onTimeChanged(picked);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.zinc800,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  log?.time?.format(context) ?? 'Set time',
                  style: AppTypography.caption.copyWith(color: AppColors.zinc400),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
