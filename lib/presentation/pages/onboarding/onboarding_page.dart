import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:medmind/app/routes/route_names.dart';
import 'package:medmind/app/theme/app_colors.dart';
import 'package:medmind/app/theme/app_typography.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.zinc950,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/icon/medmind-logo.png'),
                    fit: BoxFit.fill,
                  ),
                  shape: BoxShape.rectangle,
                  color: AppColors.teal500_10,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.teal500.withValues(alpha: 0.3),
                      blurRadius: 40,
                      spreadRadius: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('MedMind', style: AppTypography.display),
              const SizedBox(height: 12),
              Text(
                'Track symptoms. Discover patterns.\nOwn your health data.',
                style: AppTypography.body.copyWith(color: AppColors.zinc400),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _FeaturePill(icon: LucideIcons.brain, label: 'On-device AI'),
                  const SizedBox(width: 8),
                  _FeaturePill(icon: LucideIcons.shield, label: '100% Private'),
                  const SizedBox(width: 8),
                  _FeaturePill(
                    icon: LucideIcons.wifiOff,
                    label: 'Offline-first',
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => context.go(RouteNames.symptomSetup),
                  child: const Text('Get Started'),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go(RouteNames.home),
                child: Text(
                  'Already have data? Import backup',
                  style: AppTypography.body.copyWith(color: AppColors.zinc400),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    LucideIcons.shield,
                    size: 14,
                    color: AppColors.zinc500,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Your data never leaves your device.',
                    style: AppTypography.mutedCaption,
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  const _FeaturePill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.zinc900,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.zinc700),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.zinc400),
          const SizedBox(width: 5),
          Text(
            label,
            style: AppTypography.micro.copyWith(color: AppColors.zinc300),
          ),
        ],
      ),
    );
  }
}
