import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:medmind/app/theme/app_colors.dart';
import 'package:medmind/app/theme/app_typography.dart';
// enums not directly required here
import 'package:medmind/presentation/pages/insights/widgets/health_score_ring.dart';
import 'package:medmind/presentation/pages/insights/widgets/insight_card.dart';
import 'package:medmind/presentation/providers/journal_providers.dart';
import 'package:medmind/presentation/providers/core_providers.dart';
import 'package:medmind/presentation/providers/insight_providers.dart';
import 'package:medmind/presentation/shared/error_widget.dart';
import 'package:medmind/domain/services/insight_engine.dart';

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

class _InsightsView extends ConsumerWidget {
  const _InsightsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(latestInsightReportProvider);

    return reportAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => AppErrorWidget(message: e.toString()),
      data: (report) {
        if (report == null) return const _NotEnoughDataView(count: 0);

        return DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Text('Insights', style: AppTypography.h1),
              ),
              // Anomaly banner
              if (report.anomalies.isNotEmpty) _AnomalyBanner(report: report),
              // Health score ring
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    HealthScoreRing(
                      score: report.currentScore != null
                          ? (report.currentScore!.overallScore.round())
                          : 0,
                    ),
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
                child: RefreshIndicator(
                  onRefresh: () =>
                      ref.read(insightsProvider.notifier).runAnalysis(),
                  child: TabBarView(
                    children: [
                      _InsightsTab(report: report),
                      _HeatmapTab(report: report),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InsightsTab extends ConsumerWidget {
  const _InsightsTab({required this.report});

  final InsightReport report;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insights = report.anomalies; // anomalies are Insight objects

    if (insights.isEmpty) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          Center(
            child: Column(
              children: [
                const Icon(
                  LucideIcons.barChart2,
                  size: 48,
                  color: AppColors.zinc700,
                ),
                const SizedBox(height: 12),
                Text('Belum ada insights', style: AppTypography.h3),
                const SizedBox(height: 8),
                Text(
                  'Terus isi journal harianmu',
                  style: AppTypography.body.copyWith(color: AppColors.zinc400),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      itemCount: insights.length,
      itemBuilder: (context, idx) {
        final insight = insights[idx];
        return Opacity(
          opacity: insight.isRead ? 0.6 : 1.0,
          child: InsightCard(
            title: insight.title,
            description: insight.description,
            type: insight.type,
            onTap: () async {
              // mark as read via repository – best-effort (method must exist)
              try {
                final repo = ref.read(insightRepositoryProvider);
                try {
                  await repo.markAsRead(insight.id);
                } catch (_) {}
              } catch (_) {}
            },
          ),
        );
      },
    );
  }
}

class _AnomalyBanner extends StatefulWidget {
  const _AnomalyBanner({required this.report, super.key});

  final InsightReport report;

  @override
  State<_AnomalyBanner> createState() => _AnomalyBannerState();
}

class _AnomalyBannerState extends State<_AnomalyBanner> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();
    final first = widget.report.anomalies.first;
    return Dismissible(
      key: ValueKey('anomaly-banner'),
      direction: DismissDirection.up,
      onDismissed: (_) => setState(() => _visible = false),
      child: GestureDetector(
        onTap: () => showModalBottomSheet(
          context: context,
          builder: (_) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(first.title, style: AppTypography.h2),
                const SizedBox(height: 8),
                Text(first.description, style: AppTypography.body),
              ],
            ),
          ),
        ),
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.red500,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(LucideIcons.alertTriangle, color: AppColors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Anomali terdeteksi — ${first.title}',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${first.generatedAt.toLocal().toIso8601String().split("T")[0]} · Pertimbangkan konsultasi',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => setState(() => _visible = false),
                icon: const Icon(LucideIcons.x, color: AppColors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeatmapTab extends StatelessWidget {
  const _HeatmapTab({required this.report});

  final InsightReport report;

  @override
  Widget build(BuildContext context) {
    // Simplified two-section heatmap: correlation matrix and calendar grid
    final topCorrelations = report.correlations
        .where((c) => c.isSignificant)
        .toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Symptom Correlation Heatmap', style: AppTypography.h3),
        const SizedBox(height: 12),
        if (topCorrelations.isEmpty)
          Text(
            'Tidak ada korelasi signifikan.',
            style: AppTypography.body.copyWith(color: AppColors.zinc400),
          )
        else
          SizedBox(
            height: 240,
            child: GridView.count(
              crossAxisCount: 4,
              childAspectRatio: 1,
              children: topCorrelations.take(16).map((c) {
                final color = c.correlationCoefficient > 0
                    ? AppColors.teal500
                    : AppColors.red500;
                return GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${c.variableA} ↔ ${c.variableB}',
                              style: AppTypography.h2,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Korelasi: r = ${c.correlationCoefficient.toStringAsFixed(2)}',
                            ),
                            Text(
                              'P-value: ${c.pValue.toStringAsExponential(2)}',
                            ),
                            Text('Sample size: ${c.sampleSize}'),
                            Text('Lag: ${c.lag}'),
                            Text(
                              'Status: ${c.isSignificant ? 'Signifikan ✓' : 'Tidak signifikan'}',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: color.withOpacity(
                        (c.correlationCoefficient.abs()).clamp(0.2, 1.0),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${c.variableA}\n${c.variableB}',
                        textAlign: TextAlign.center,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.zinc50,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        const SizedBox(height: 20),
        Text('Calendar Heatmap (30 hari)', style: AppTypography.h3),
        const SizedBox(height: 12),
        // Simple calendar placeholder showing counts from anomalies
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: List.generate(30, (i) {
            final count = report.anomalies
                .where(
                  (a) => a.generatedAt.isAfter(
                    DateTime.now().subtract(Duration(days: 30 - i)),
                  ),
                )
                .length;
            final color = count == 0
                ? AppColors.zinc900
                : (count < 3
                      ? AppColors.teal700
                      : (count < 5 ? AppColors.teal700 : AppColors.teal500));
            return GestureDetector(
              onTap: () {
                // detail bottom sheet (simplified)
                showModalBottomSheet(
                  context: context,
                  builder: (_) => Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hari: ${DateTime.now().subtract(Duration(days: 29 - i)).toLocal().toIso8601String().split("T")[0]}',
                          style: AppTypography.h3,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Insights: ${report.anomalies.where((a) => a.generatedAt.isAfter(DateTime.now().subtract(Duration(days: 30 - i)))).length}',
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Text(
          'Legend: Sedikit → Banyak',
          style: AppTypography.caption.copyWith(color: AppColors.zinc400),
        ),
      ],
    );
  }
}
