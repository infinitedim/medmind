import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:medmind/app/theme/app_colors.dart';
import 'package:medmind/app/theme/app_typography.dart';
import 'package:medmind/core/enum/enum_collection.dart';

class InsightCard extends StatelessWidget {
  const InsightCard({
    required this.title,
    required this.description,
    required this.type,
    this.onTap,
    super.key,
  });

  final String title;
  final String description;
  final InsightType type;
  final VoidCallback? onTap;

  IconData get _icon => switch (type) {
    InsightType.correlation => LucideIcons.gitMerge,
    InsightType.anomaly => LucideIcons.alertTriangle,
    InsightType.trend => LucideIcons.trendingUp,
    InsightType.recommendation => LucideIcons.lightbulb,
  };

  Color get _accentColor => switch (type) {
    InsightType.correlation => AppColors.indigo400,
    InsightType.anomaly => AppColors.amber400,
    InsightType.trend => AppColors.teal400,
    InsightType.recommendation => AppColors.emerald400,
  };

  Color get _bgColor => switch (type) {
    InsightType.correlation => AppColors.indigo900_50,
    InsightType.anomaly => AppColors.amber900_20,
    InsightType.trend => AppColors.teal500_10,
    InsightType.recommendation => AppColors.emerald900_30,
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.zinc900,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.zinc800),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_icon, size: 20, color: _accentColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.bodyMedium),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.zinc400,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(
                LucideIcons.chevronRight,
                size: 16,
                color: AppColors.zinc600,
              ),
          ],
        ),
      ),
    );
  }
}
