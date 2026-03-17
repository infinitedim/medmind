import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medmind/app/theme/app_colors.dart';
import 'package:medmind/app/theme/app_typography.dart';
import 'package:medmind/domain/entities/symptom.dart';
import 'package:medmind/presentation/providers/journal_providers.dart';
import 'package:medmind/presentation/providers/symptom_providers.dart';

class SymptomSelector extends ConsumerStatefulWidget {
  const SymptomSelector({required this.entryId, super.key});

  final String? entryId;

  @override
  ConsumerState<SymptomSelector> createState() => _SymptomSelectorState();
}

class _SymptomSelectorState extends ConsumerState<SymptomSelector> {
  String? _expandedSymptomId;

  @override
  Widget build(BuildContext context) {
    final symptomsAsync = ref.watch(selectedSymptomsProvider);
    final formAsync = ref.watch(journalFormProvider(widget.entryId));
    final notifier = ref.read(journalFormProvider(widget.entryId).notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Symptoms', style: AppTypography.h3),
            formAsync.whenData((form) => Text(
              '${form.symptoms.length} logged',
              style: AppTypography.caption.copyWith(color: AppColors.teal400),
            )).value ?? const SizedBox.shrink(),
          ],
        ),
        const SizedBox(height: 12),
        symptomsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, e) => Text('Failed to load symptoms', style: AppTypography.body),
          data: (symptoms) {
            if (symptoms.isEmpty) {
              return Text(
                'No symptoms tracked. Add symptoms in settings.',
                style: AppTypography.body.copyWith(color: AppColors.zinc500),
              );
            }
            return formAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, e2) => const SizedBox.shrink(),
              data: (form) => Column(
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: symptoms.map((symptom) {
                      final log = form.symptoms
                          .where((s) => s.symptomId == symptom.id)
                          .firstOrNull;
                      final isLogged = log != null;
                      return _SymptomChip(
                        symptom: symptom,
                        isLogged: isLogged,
                        onTap: () {
                          if (isLogged) {
                            if (_expandedSymptomId == symptom.id) {
                              setState(() => _expandedSymptomId = null);
                            } else {
                              setState(() => _expandedSymptomId = symptom.id);
                            }
                          } else {
                            notifier.addSymptomLog(
                              SymptomLog(symptomId: symptom.id, severity: 5),
                            );
                            setState(() => _expandedSymptomId = symptom.id);
                          }
                        },
                        onRemove: () {
                          notifier.removeSymptomLog(symptom.id);
                          if (_expandedSymptomId == symptom.id) {
                            setState(() => _expandedSymptomId = null);
                          }
                        },
                      );
                    }).toList(),
                  ),
                  if (_expandedSymptomId != null) ...[
                    const SizedBox(height: 12),
                    _buildDetailPanel(form, symptoms, notifier),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDetailPanel(
    JournalFormState form,
    List<Symptom> symptoms,
    JournalFormNotifier notifier,
  ) {
    final symptom = symptoms.firstWhere(
      (s) => s.id == _expandedSymptomId,
      orElse: () => symptoms.first,
    );
    final log = form.symptoms
        .where((s) => s.symptomId == _expandedSymptomId)
        .firstOrNull;
    if (log == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.zinc900,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.zinc800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(symptom.name, style: AppTypography.bodyMedium),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Severity', style: AppTypography.small),
              Text(
                _severityLabel(log.severity),
                style: AppTypography.captionMedium.copyWith(
                  color: _severityColor(log.severity),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _severityColor(log.severity),
              inactiveTrackColor: AppColors.zinc800,
              thumbColor: _severityColor(log.severity),
              overlayColor: _severityColor(log.severity).withAlpha(40),
              trackHeight: 4,
            ),
            child: Slider(
              value: log.severity.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (v) => notifier.addSymptomLog(
                log.copyWith(severity: v.round()),
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            style: AppTypography.body,
            decoration: InputDecoration(
              hintText: 'Notes (optional)',
              hintStyle: AppTypography.body.copyWith(color: AppColors.zinc600),
              filled: true,
              fillColor: AppColors.zinc800,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              isDense: true,
            ),
            controller: TextEditingController(text: log.notes ?? ''),
            onChanged: (v) => notifier.addSymptomLog(
              log.copyWith(notes: v.isEmpty ? null : v),
            ),
          ),
        ],
      ),
    );
  }

  String _severityLabel(int severity) {
    if (severity <= 3) return 'Mild ($severity/10)';
    if (severity <= 6) return 'Moderate ($severity/10)';
    if (severity <= 8) return 'High ($severity/10)';
    return 'Severe ($severity/10)';
  }

  Color _severityColor(int severity) {
    if (severity <= 3) return AppColors.severityLow;
    if (severity <= 6) return AppColors.severityModerate;
    if (severity <= 8) return AppColors.severityHigh;
    return AppColors.severitySevere;
  }
}

class _SymptomChip extends StatelessWidget {
  const _SymptomChip({
    required this.symptom,
    required this.isLogged,
    required this.onTap,
    required this.onRemove,
  });

  final Symptom symptom;
  final bool isLogged;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isLogged ? AppColors.teal500_20 : AppColors.zinc900,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isLogged ? AppColors.teal500 : AppColors.zinc700,
            width: isLogged ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(symptom.icon, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(
              symptom.name,
              style: AppTypography.small.copyWith(
                color: isLogged ? AppColors.teal300 : AppColors.zinc300,
              ),
            ),
            if (isLogged) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onRemove,
                child: Icon(Icons.close, size: 14, color: AppColors.zinc500),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
