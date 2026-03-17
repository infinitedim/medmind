import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:medmind/app/theme/app_colors.dart';
import 'package:medmind/app/theme/app_typography.dart';
import 'package:medmind/core/enum/enum_collection.dart';
import 'package:medmind/presentation/pages/insights/widgets/health_score_ring.dart';
import 'package:medmind/presentation/pages/insights/widgets/insight_card.dart';
import 'package:medmind/presentation/providers/journal_providers.dart';

const _kMinEntries = 14;

class InsightsPage extends ConsumerWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(journalEntriesCountProvider);

    return Scaffold(
      backgroundColor: AppColors.zinc950,
      body: SafeArea(
        child: count < _kMinEntries
            ? _NotEnoughDataView(count: count)
            : const _InsightsView(),
      ),
    );
  }
}

class _NotEnoughDataView extends StatelessWidget {
  const _NotEnoughDataView({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final remaining = _kMinEntries - count;
    final progress = count / _kMinEntries;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Insights', style: AppTypography.h1),
          const SizedBox(height: 48),
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.zinc900,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.barChart2,
                    size: 48,
                    color: AppColors.teal500,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Butuh lebih banyak data',
                  style: AppTypography.h2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Journal $remaining hari lagi untuk melihat insights kesehatanmu.',
                  style: AppTypography.body.copyWith(color: AppColors.zinc400),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Progress
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.zinc900,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.zinc800),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Progress', style: AppTypography.bodyMedium),
                          Text(
                            '$count / $_kMinEntries hari',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.teal400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: AppColors.zinc800,
                          valueColor: const AlwaysStoppedAnimation(
                            AppColors.teal500,
                          ),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightsView extends StatelessWidget {
  const _InsightsView();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Text('Insights', style: AppTypography.h1),
          ),
          // Health score ring
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Column(
              children: [
                // Score is 0 placeholder – will be wired to stats engine in Step 11
                const HealthScoreRing(score: 0),
                const SizedBox(height: 8),
                Text(
                  'Skor Kesehatan',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.zinc500,
                  ),
                ),
              ],
            ),
          ),
          TabBar(
            labelColor: AppColors.teal400,
            unselectedLabelColor: AppColors.zinc500,
            indicatorColor: AppColors.teal500,
            dividerColor: AppColors.zinc800,
            tabs: const [
              Tab(text: 'Insights'),
              Tab(text: 'Heatmap'),
            ],
          ),
          Expanded(
            child: TabBarView(children: [_InsightsTab(), _HeatmapTab()]),
          ),
        ],
      ),
    );
  }
}

class _InsightsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Placeholder insights – real data wired in Step 11
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: const [
        InsightCard(
          title: 'Tidur & Mood',
          description:
              'Kualitas tidur yang baik berkorelasi dengan mood positif keesokan harinya.',
          type: InsightType.correlation,
        ),
        InsightCard(
          title: 'Insight segera hadir',
          description:
              'Terus isi journal harianmu untuk mendapatkan analisis yang lebih mendalam.',
          type: InsightType.recommendation,
        ),
      ],
    );
  }
}

class _HeatmapTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              LucideIcons.calendar,
              size: 48,
              color: AppColors.zinc700,
            ),
            const SizedBox(height: 16),
            Text(
              'Heatmap kalender',
              style: AppTypography.h3.copyWith(color: AppColors.zinc400),
            ),
            const SizedBox(height: 8),
            Text(
              'Fitur ini akan tersedia segera.',
              style: AppTypography.body.copyWith(color: AppColors.zinc600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
