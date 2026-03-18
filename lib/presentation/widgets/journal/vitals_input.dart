import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medmind/app/theme/app_colors.dart';
import 'package:medmind/app/theme/app_typography.dart';
import 'package:medmind/core/enum/enum_collection.dart';
import 'package:medmind/domain/entities/vital_record.dart';
import 'package:medmind/presentation/providers/core_providers.dart';
import 'package:medmind/presentation/providers/journal_providers.dart';

class VitalsInput extends ConsumerStatefulWidget {
  const VitalsInput({required this.entryId, super.key});

  final String? entryId;

  @override
  ConsumerState<VitalsInput> createState() => _VitalsInputState();
}

class _VitalsInputState extends ConsumerState<VitalsInput> {
  bool _hcAvailable = false;
  bool _importing = false;

  final _heartRateCtrl = TextEditingController();
  final _stepsCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _spo2Ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkHc();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final form = ref.read(journalFormProvider(widget.entryId)).asData?.value;
      if (form?.vitalRecord != null) {
        final v = form!.vitalRecord!;
        _heartRateCtrl.text = v.heartRate?.toString() ?? '';
        _stepsCtrl.text = v.steps?.toString() ?? '';
        _weightCtrl.text = v.weight?.toString() ?? '';
        _spo2Ctrl.text = v.spO2?.toString() ?? '';
      }
    });
  }

  @override
  void dispose() {
    _heartRateCtrl.dispose();
    _stepsCtrl.dispose();
    _weightCtrl.dispose();
    _spo2Ctrl.dispose();
    super.dispose();
  }

  Future<void> _checkHc() async {
    final repo = ref.read(healthConnectRepositoryProvider);
    final result = await repo.checkAvailability();
    if (mounted) {
      setState(() => _hcAvailable = result.fold((_) => false, (v) => v));
    }
  }

  Future<void> _importFromHc() async {
    setState(() => _importing = true);
    try {
      final repo = ref.read(healthConnectRepositoryProvider);
      final now = DateTime.now();
      final start = DateTime(now.year, now.month, now.day);
      final result = await repo.importStepData(startDate: start, endDate: now);
      result.fold((_) {}, (map) {
        final total = map.values.fold<int>(0, (a, b) => a + b);
        if (total > 0) _stepsCtrl.text = total.toString();
      });
      _saveVitals(source: VitalSource.healthConnect);
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  void _saveVitals({VitalSource source = VitalSource.manual}) {
    final notifier = ref.read(journalFormProvider(widget.entryId).notifier);
    final hr = int.tryParse(_heartRateCtrl.text);
    final steps = int.tryParse(_stepsCtrl.text);
    final weight = double.tryParse(_weightCtrl.text);
    final spo2 = double.tryParse(_spo2Ctrl.text);

    if (hr == null && steps == null && weight == null && spo2 == null) {
      notifier.updateVitals(null);
      return;
    }

    notifier.updateVitals(
      VitalRecord(
        heartRate: hr,
        steps: steps,
        weight: weight,
        spO2: spo2,
        date: DateTime.now(),
        source: source,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Vitals', style: AppTypography.h3),
            Text(
              'All optional',
              style: AppTypography.caption.copyWith(color: AppColors.zinc500),
            ),
          ],
        ),
        if (_hcAvailable) ...[
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _importing ? null : _importFromHc,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.teal500_10,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.teal700),
              ),
              child: Row(
                children: [
                  if (_importing)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.teal400,
                      ),
                    )
                  else
                    const Icon(Icons.sync, size: 18, color: AppColors.teal400),
                  const SizedBox(width: 10),
                  Text(
                    _importing ? 'Importing...' : 'Import from Health Connect',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.teal300,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.zinc900,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.zinc800),
          ),
          child: Column(
            children: [
              _VitalField(
                label: 'Heart Rate',
                unit: 'bpm',
                icon: Icons.favorite_outline,
                iconColor: AppColors.red400,
                controller: _heartRateCtrl,
                inputType: const TextInputType.numberWithOptions(),
                onChanged: (_) => _saveVitals(),
              ),
              const Divider(color: AppColors.zinc800, height: 24),
              _VitalField(
                label: 'Steps',
                unit: 'steps',
                icon: Icons.directions_walk_outlined,
                iconColor: AppColors.teal400,
                controller: _stepsCtrl,
                inputType: const TextInputType.numberWithOptions(),
                onChanged: (_) => _saveVitals(),
              ),
              const Divider(color: AppColors.zinc800, height: 24),
              _VitalField(
                label: 'Weight',
                unit: 'kg',
                icon: Icons.monitor_weight_outlined,
                iconColor: AppColors.amber400,
                controller: _weightCtrl,
                inputType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => _saveVitals(),
              ),
              const Divider(color: AppColors.zinc800, height: 24),
              _VitalField(
                label: 'SpO₂',
                unit: '%',
                icon: Icons.air_outlined,
                iconColor: AppColors.indigo400,
                controller: _spo2Ctrl,
                inputType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => _saveVitals(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VitalField extends StatelessWidget {
  const _VitalField({
    required this.label,
    required this.unit,
    required this.icon,
    required this.iconColor,
    required this.controller,
    required this.inputType,
    required this.onChanged,
  });

  final String label;
  final String unit;
  final IconData icon;
  final Color iconColor;
  final TextEditingController controller;
  final TextInputType inputType;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.small.copyWith(color: AppColors.zinc400),
              ),
              const SizedBox(height: 2),
              TextField(
                controller: controller,
                keyboardType: inputType,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                style: AppTypography.bodyMedium,
                decoration: InputDecoration(
                  hintText: '—',
                  hintStyle: AppTypography.bodyMedium.copyWith(
                    color: AppColors.zinc600,
                  ),
                  suffixText: unit,
                  suffixStyle: AppTypography.caption.copyWith(
                    color: AppColors.zinc500,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
