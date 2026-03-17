import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:medmind/app/theme/app_colors.dart';
import 'package:medmind/app/theme/app_typography.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({this.message, this.onRetry, super.key});

  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.alertTriangle, size: 40, color: AppColors.red400),
            const SizedBox(height: 16),
            Text(
              message ?? 'Terjadi kesalahan.',
              style: AppTypography.body.copyWith(color: AppColors.zinc400),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(LucideIcons.refreshCw, size: 16),
                label: const Text('Coba lagi'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.teal400,
                  side: const BorderSide(color: AppColors.teal700),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
