import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:medmind/app/routes/route_names.dart';
import 'package:medmind/app/theme/app_colors.dart';
import 'package:medmind/app/theme/app_typography.dart';
import 'package:medmind/core/enum/enum_collection.dart';
import 'package:medmind/domain/entities/journal_entry.dart';
import 'package:medmind/presentation/providers/journal_providers.dart';
import 'package:medmind/presentation/shared/loading_indicator.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static String _greeting() {
    final h = DateTime.now().hour;
    if (h >= 5 && h < 12) return 'Selamat pagi';
    if (h >= 12 && h < 18) return 'Selamat siang';
    if (h >= 18 && h < 21) return 'Selamat sore';
    return 'Selamat malam';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayEntry = ref.watch(todayJournalEntryProvider);
    final streak = ref.watch(journalStreakProvider);
    final count = ref.watch(journalEntriesCountProvider);
    final recentAsync = ref.watch(journalEntriesProvider((null, null)));

    return Scaffold(
      backgroundColor: AppColors.zinc950,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _greeting(),
                      style: AppTypography.caption.copyWith(
                        color: AppColors.zinc500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('MedMind', style: AppTypography.h1),
                    const SizedBox(height: 24),
                    // Today card
                    _TodayCard(entry: todayEntry),
                    const SizedBox(height: 16),
                    // Stats row
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            icon: LucideIcons.flame,
                            iconColor: AppColors.orange400,
                            value: '$streak',
                            label: 'Hari berturut-turut',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            icon: LucideIcons.bookOpen,
                            iconColor: AppColors.teal400,
                            value: '$count',
                            label: 'Total entri',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Entri terbaru', style: AppTypography.h3),
                        GestureDetector(
                          onTap: () => context.go(RouteNames.journal),
                          child: Text(
                            'Lihat semua',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.teal400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            recentAsync.when(
              loading: () => const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: LoadingIndicator(),
                ),
              ),
              error: (_, _) =>
                  const SliverToBoxAdapter(child: SizedBox.shrink()),
              data: (entries) {
                final sorted = [...entries]
                  ..sort((a, b) => b.date.compareTo(a.date));
                final recent = sorted.take(5).toList();
                if (recent.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 32,
                      ),
                      child: Text(
                        'Belum ada entri. Tap tombol + untuk mulai journaling.',
                        style: AppTypography.body.copyWith(
                          color: AppColors.zinc600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                      child: _RecentEntryTile(
                        entry: recent[i],
                        onTap: () => context.push(
                          '${RouteNames.journalEntry}?id=${recent[i].id}',
                        ),
                      ),
                    ),
                    childCount: recent.length,
                  ),
                );
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.teal600,
        onPressed: () => context.push(RouteNames.journalNew),
        child: const Icon(LucideIcons.plus, color: Colors.white),
      ),
    );
  }
}

class _TodayCard extends StatelessWidget {
  const _TodayCard({required this.entry});

  final JournalEntry? entry;

  static const _moodEmoji = {
    Mood.great: '😊',
    Mood.good: '🙂',
    Mood.okay: '😐',
    Mood.bad: '😟',
    Mood.terrible: '😰',
  };

  static const _moodLabel = {
    Mood.great: 'Luar biasa',
    Mood.good: 'Baik',
    Mood.okay: 'Biasa',
    Mood.bad: 'Buruk',
    Mood.terrible: 'Sangat buruk',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.zinc900,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.zinc800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                DateFormat('EEEE, d MMM').format(DateTime.now()),
                style: AppTypography.caption.copyWith(color: AppColors.zinc500),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: entry != null
                      ? AppColors.emerald900_30
                      : AppColors.zinc800,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  entry != null ? 'Sudah dicatat' : 'Belum dicatat',
                  style: AppTypography.micro.copyWith(
                    color: entry != null
                        ? AppColors.emerald400
                        : AppColors.zinc500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (entry != null) ...[
            Row(
              children: [
                if (entry!.mood != null)
                  Text(
                    _moodEmoji[entry!.mood] ?? '•',
                    style: const TextStyle(fontSize: 32),
                  ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (entry!.mood != null)
                      Text(
                        _moodLabel[entry!.mood] ?? '',
                        style: AppTypography.h3,
                      ),
                    if (entry!.sleepRecord != null) ...[
                      const SizedBox(height: 2),
                      Builder(
                        builder: (context) {
                          final sleep = entry!.sleepRecord!;
                          final dur = sleep.wakeTime.difference(sleep.bedTime);
                          final h = dur.inHours;
                          final m = dur.inMinutes % 60;
                          return Row(
                            children: [
                              const Icon(
                                LucideIcons.moon,
                                size: 12,
                                color: AppColors.zinc500,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                m > 0 ? '${h}j ${m}m tidur' : '${h}j tidur',
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.zinc500,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ],
                ),
                if (entry!.symptoms.isNotEmpty) ...[
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${entry!.symptoms.length}',
                        style: AppTypography.h2.copyWith(
                          color: AppColors.amber400,
                        ),
                      ),
                      Text(
                        'gejala',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.zinc500,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ] else ...[
            Text(
              'Belum ada catatan hari ini',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.zinc400,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.push(RouteNames.journalNew),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.teal600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(LucideIcons.plus, size: 18),
                label: Text(
                  'Log hari ini',
                  style: AppTypography.bodyMedium.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.zinc900,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.zinc800),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: iconColor),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTypography.h2.copyWith(color: AppColors.zinc50),
              ),
              Text(
                label,
                style: AppTypography.micro.copyWith(color: AppColors.zinc500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecentEntryTile extends StatelessWidget {
  const _RecentEntryTile({required this.entry, required this.onTap});

  final JournalEntry entry;
  final VoidCallback onTap;

  static const _moodEmoji = {
    Mood.great: '😊',
    Mood.good: '🙂',
    Mood.okay: '😐',
    Mood.bad: '😟',
    Mood.terrible: '😰',
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.zinc900,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.zinc800),
        ),
        child: Row(
          children: [
            Text(
              _moodEmoji[entry.mood] ?? '📓',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('EEEE, d MMM yyyy').format(entry.date),
                    style: AppTypography.bodyMedium,
                  ),
                  if (entry.freeText != null)
                    Text(
                      entry.freeText!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.zinc500,
                      ),
                    ),
                ],
              ),
            ),
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
