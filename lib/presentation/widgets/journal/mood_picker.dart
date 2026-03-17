import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medmind/app/theme/app_colors.dart';
import 'package:medmind/app/theme/app_typography.dart';
import 'package:medmind/core/enum/enum_collection.dart';
import 'package:medmind/presentation/providers/journal_providers.dart';

class MoodPicker extends ConsumerWidget {
  const MoodPicker({required this.entryId, super.key});

  final String? entryId;

  static const _moods = [
    (mood: Mood.great, emoji: '😊', label: 'Great'),
    (mood: Mood.good, emoji: '🙂', label: 'Good'),
    (mood: Mood.okay, emoji: '😐', label: 'Okay'),
    (mood: Mood.bad, emoji: '😟', label: 'Bad'),
    (mood: Mood.terrible, emoji: '😰', label: 'Terrible'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formAsync = ref.watch(journalFormProvider(entryId));
    final notifier = ref.read(journalFormProvider(entryId).notifier);

    return formAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, e) => const SizedBox.shrink(),
      data: (form) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('How are you feeling?', style: AppTypography.h3),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _moods.map((item) {
              final isSelected = form.mood == item.mood;
              return _MoodButton(
                emoji: item.emoji,
                label: item.label,
                isSelected: isSelected,
                onTap: () => notifier.setMood(item.mood),
              );
            }).toList(),
          ),
          if (form.mood != null)
            ...[
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Intensity', style: AppTypography.bodyMedium),
                  Text(
                    '${form.moodIntensity ?? 5}',
                    style: AppTypography.h3.copyWith(color: AppColors.teal400),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.teal500,
                  inactiveTrackColor: AppColors.zinc800,
                  thumbColor: AppColors.teal400,
                  overlayColor: AppColors.teal500_20,
                  trackHeight: 4,
                ),
                child: Slider(
                  value: (form.moodIntensity ?? 5).toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  onChanged: (v) => notifier.setMoodIntensity(v.round()),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mild',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.zinc500,
                    ),
                  ),
                  Text(
                    'Intense',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.zinc500,
                    ),
                  ),
                ],
              ),
            ].animate().fadeIn(duration: 200.ms).slideY(begin: -0.1, end: 0),
        ],
      ),
    );
  }
}

class _MoodButton extends StatelessWidget {
  const _MoodButton({
    required this.emoji,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.teal500_20 : AppColors.zinc900,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.teal500 : AppColors.zinc800,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                color: isSelected ? AppColors.teal300 : AppColors.zinc500,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
