import 'package:flutter/material.dart';
import 'package:medmind/app/theme/app_colors.dart';
import 'package:medmind/app/theme/app_typography.dart';

/// A polished settings row with a two-state [Switch].
///
/// When [value] is true:
///   - track: [AppColors.teal500]
///   - thumb: white (high contrast against the teal track)
///   - leading icon: [AppColors.teal400]
///
/// When [value] is false:
///   - track: [AppColors.zinc700]
///   - thumb: [AppColors.zinc400]
///   - leading icon: [AppColors.zinc500]
class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.loading = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  /// When true the switch is replaced by a small progress indicator.
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Icon(
          icon,
          key: ValueKey(value),
          color: value ? AppColors.teal400 : AppColors.zinc500,
          size: 20,
        ),
      ),
      title: Text(title, style: AppTypography.body),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTypography.caption.copyWith(color: AppColors.zinc500),
            )
          : null,
      trailing: loading
          ? const SizedBox(
              width: 44,
              height: 24,
              child: Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.teal400,
                  ),
                ),
              ),
            )
          : Switch(
              value: value,
              onChanged: onChanged,
              thumbColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.zinc50;
                }
                return AppColors.zinc500;
              }),
              trackColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.teal500;
                }
                return AppColors.zinc700;
              }),
              trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
            ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
