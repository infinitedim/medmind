import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medmind/app/routes/route_names.dart';
import 'package:medmind/app/theme/app_colors.dart';
import 'package:medmind/app/theme/app_typography.dart';

class SymptomSetupPage extends StatelessWidget {
  const SymptomSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.zinc950,
      appBar: AppBar(
        title: Text('Select Symptoms', style: AppTypography.h2),
        actions: [
          Text(
            '2 of 4',
            style: AppTypography.caption.copyWith(color: AppColors.zinc400),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('What would you like to track?', style: AppTypography.h1),
              const SizedBox(height: 8),
              Text(
                'Select symptoms to monitor. You can change this later.',
                style: AppTypography.muted,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => context.go(RouteNames.home),
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
