import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:medmind/app/theme/app_colors.dart';
import 'package:medmind/app/theme/app_typography.dart';
import 'package:medmind/presentation/providers/core_providers.dart';

final _reminderTimeProvider =
    AsyncNotifierProvider<_ReminderTimeNotifier, String?>(
      _ReminderTimeNotifier.new,
    );

class _ReminderTimeNotifier extends AsyncNotifier<String?> {
  @override
  Future<String?> build() async {
    final repo = ref.watch(userPreferencesRepositoryProvider);
    final result = await repo.getReminderTime();
    return result.fold((_) => null, (v) => v);
  }

  Future<void> setTime(String? time) async {
    final repo = ref.read(userPreferencesRepositoryProvider);
    if (time == null) {
      await repo.setReminderTime('');
      state = const AsyncData(null);
    } else {
      await repo.setReminderTime(time);
      state = AsyncData(time);
    }
  }
}

class ReminderSettingsPage extends ConsumerStatefulWidget {
  const ReminderSettingsPage({super.key});

  @override
  ConsumerState<ReminderSettingsPage> createState() =>
      _ReminderSettingsPageState();
}

class _ReminderSettingsPageState extends ConsumerState<ReminderSettingsPage> {
  TimeOfDay _selectedTime = const TimeOfDay(hour: 20, minute: 0);

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
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
    if (picked == null || !mounted) return;
    setState(() => _selectedTime = picked);
    final hh = picked.hour.toString().padLeft(2, '0');
    final mm = picked.minute.toString().padLeft(2, '0');
    await ref.read(_reminderTimeProvider.notifier).setTime('$hh:$mm');
  }

  @override
  Widget build(BuildContext context) {
    final reminderAsync = ref.watch(_reminderTimeProvider);
    final reminderTime = reminderAsync.asData?.value;
    final isEnabled = reminderTime != null && reminderTime.isNotEmpty;

    // Sync selected time from stored value
    if (reminderTime != null && reminderTime.isNotEmpty) {
      final parts = reminderTime.split(':');
      if (parts.length == 2) {
        final h = int.tryParse(parts[0]);
        final m = int.tryParse(parts[1]);
        if (h != null && m != null) {
          _selectedTime = TimeOfDay(hour: h, minute: m);
        }
      }
    }

    return Scaffold(
      backgroundColor: AppColors.zinc950,
      appBar: AppBar(
        backgroundColor: AppColors.zinc950,
        title: Text('Pengingat', style: AppTypography.h2),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.zinc900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SwitchListTile(
              value: isEnabled,
              onChanged: reminderAsync.isLoading
                  ? null
                  : (value) async {
                      if (value) {
                        final hh = _selectedTime.hour.toString().padLeft(
                          2,
                          '0',
                        );
                        final mm = _selectedTime.minute.toString().padLeft(
                          2,
                          '0',
                        );
                        await ref
                            .read(_reminderTimeProvider.notifier)
                            .setTime('$hh:$mm');
                      } else {
                        await ref
                            .read(_reminderTimeProvider.notifier)
                            .setTime(null);
                      }
                    },
              secondary: const Icon(LucideIcons.bell, color: AppColors.zinc400),
              title: Text('Aktifkan pengingat', style: AppTypography.body),
              subtitle: Text(
                'Notifikasi harian untuk journaling',
                style: AppTypography.caption.copyWith(color: AppColors.zinc500),
              ),
              activeThumbColor: AppColors.teal500,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
            ),
          ),
          if (isEnabled) ...[
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppColors.zinc900,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(
                  LucideIcons.clock,
                  color: AppColors.zinc400,
                ),
                title: Text('Waktu pengingat', style: AppTypography.body),
                trailing: Text(
                  _selectedTime.format(context),
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.teal400,
                  ),
                ),
                onTap: _pickTime,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
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
                children: [
                  const Icon(
                    LucideIcons.info,
                    size: 16,
                    color: AppColors.teal400,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Kamu akan diingatkan setiap hari pukul ${_selectedTime.format(context)}',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.teal300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
