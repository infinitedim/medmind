import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medmind/app/theme/app_colors.dart';
import 'package:medmind/app/theme/app_typography.dart';
import 'package:medmind/domain/entities/sleep_record.dart';
import 'package:medmind/presentation/providers/journal_providers.dart';

class SleepInput extends ConsumerStatefulWidget {
  const SleepInput({required this.entryId, super.key});

  final String? entryId;

  @override
  ConsumerState<SleepInput> createState() => _SleepInputState();
}

class _SleepInputState extends ConsumerState<SleepInput> {
  TimeOfDay _bedTime = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _wakeTime = const TimeOfDay(hour: 7, minute: 0);
  int _quality = 7;
  int _disturbances = 0;
  bool _enabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final form = ref.read(journalFormProvider(widget.entryId)).asData?.value;
      if (form?.sleepRecord != null) {
        final r = form!.sleepRecord!;
        setState(() {
          _bedTime = TimeOfDay.fromDateTime(r.bedTime);
          _wakeTime = TimeOfDay.fromDateTime(r.wakeTime);
          _quality = r.quality;
          _disturbances = r.disturbances ?? 0;
          _enabled = true;
        });
      }
    });
  }

  void _save() {
    final notifier = ref.read(journalFormProvider(widget.entryId).notifier);
    if (!_enabled) {
      notifier.setSleepRecord(null);
      return;
    }
    final now = DateTime.now();
    final bed = DateTime(now.year, now.month, now.day, _bedTime.hour, _bedTime.minute);
    final wake = DateTime(now.year, now.month, now.day, _wakeTime.hour, _wakeTime.minute);
    final adjustedWake = wake.isBefore(bed) ? wake.add(const Duration(days: 1)) : wake;
    notifier.setSleepRecord(
      SleepRecord(
        bedTime: bed,
        wakeTime: adjustedWake,
        quality: _quality,
        disturbances: _disturbances,
      ),
    );
  }

  String _formatDuration() {
    final now = DateTime.now();
    final bed = DateTime(now.year, now.month, now.day, _bedTime.hour, _bedTime.minute);
    var wake = DateTime(now.year, now.month, now.day, _wakeTime.hour, _wakeTime.minute);
    if (wake.isBefore(bed)) wake = wake.add(const Duration(days: 1));
    final diff = wake.difference(bed);
    final h = diff.inHours;
    final m = diff.inMinutes % 60;
    return '${h}h ${m}m';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Sleep', style: AppTypography.h3),
            Switch(
              value: _enabled,
              onChanged: (v) {
                setState(() => _enabled = v);
                _save();
              },
              activeThumbColor: AppColors.teal400,
              activeTrackColor: AppColors.teal700,
              inactiveThumbColor: AppColors.zinc600,
              inactiveTrackColor: AppColors.zinc800,
            ),
          ],
        ),
        if (_enabled) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.zinc900,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.zinc800),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _TimePickerTile(
                        label: 'Bedtime',
                        icon: Icons.bedtime_outlined,
                        time: _bedTime,
                        onChanged: (t) {
                          setState(() => _bedTime = t);
                          _save();
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _TimePickerTile(
                        label: 'Wake up',
                        icon: Icons.wb_sunny_outlined,
                        time: _wakeTime,
                        onChanged: (t) {
                          setState(() => _wakeTime = t);
                          _save();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.zinc800,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.access_time, size: 16, color: AppColors.teal400),
                      const SizedBox(width: 8),
                      Text(
                        'Duration: ${_formatDuration()}',
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.teal300),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Sleep quality', style: AppTypography.small),
                    Text(
                      '$_quality/10',
                      style: AppTypography.captionMedium.copyWith(color: AppColors.teal400),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.teal500,
                    inactiveTrackColor: AppColors.zinc800,
                    thumbColor: AppColors.teal400,
                    overlayColor: AppColors.teal500_20,
                    trackHeight: 4,
                  ),
                  child: Slider(
                    value: _quality.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    onChanged: (v) {
                      setState(() => _quality = v.round());
                      _save();
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Disturbances', style: AppTypography.small),
                    Row(
                      children: [
                        _StepperButton(
                          icon: Icons.remove,
                          onTap: _disturbances > 0
                              ? () {
                                  setState(() => _disturbances--);
                                  _save();
                                }
                              : null,
                        ),
                        SizedBox(
                          width: 36,
                          child: Center(
                            child: Text(
                              '$_disturbances',
                              style: AppTypography.h3,
                            ),
                          ),
                        ),
                        _StepperButton(
                          icon: Icons.add,
                          onTap: () {
                            setState(() => _disturbances++);
                            _save();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _TimePickerTile extends StatelessWidget {
  const _TimePickerTile({
    required this.label,
    required this.icon,
    required this.time,
    required this.onChanged,
  });

  final String label;
  final IconData icon;
  final TimeOfDay time;
  final ValueChanged<TimeOfDay> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: time,
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
        if (picked != null) onChanged(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.zinc800,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: AppColors.zinc500),
                const SizedBox(width: 4),
                Text(label, style: AppTypography.caption.copyWith(color: AppColors.zinc500)),
              ],
            ),
            const SizedBox(height: 4),
            Text(time.format(context), style: AppTypography.h3),
          ],
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: onTap != null ? AppColors.zinc700 : AppColors.zinc800,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 16,
          color: onTap != null ? AppColors.zinc200 : AppColors.zinc600,
        ),
      ),
    );
  }
}
