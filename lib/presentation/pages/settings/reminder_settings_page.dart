import 'package:flutter/material.dart';
import 'package:medmind/app/theme/app_colors.dart';
import 'package:medmind/app/theme/app_typography.dart';

class ReminderSettingsPage extends StatelessWidget {
  const ReminderSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.zinc950,
      appBar: AppBar(title: Text('Reminders', style: AppTypography.h2)),
      body: const SizedBox.shrink(),
    );
  }
}
