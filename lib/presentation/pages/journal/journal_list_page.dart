import 'dart:async';

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
import 'package:medmind/domain/usecases/journal/delete_journal_entry.dart';
import 'package:medmind/presentation/providers/core_providers.dart';
import 'package:medmind/presentation/providers/journal_providers.dart';
import 'package:medmind/presentation/shared/error_widget.dart';
import 'package:medmind/presentation/shared/loading_indicator.dart';

class JournalListPage extends ConsumerStatefulWidget {
  const JournalListPage({super.key});

  @override
  ConsumerState<JournalListPage> createState() => _JournalListPageState();
}

class _JournalListPageState extends ConsumerState<JournalListPage> {
  bool _isSearching = false;
  final _searchController = TextEditingController();
  String _query = '';
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) setState(() => _query = value.trim());
    });
  }

  Future<void> _deleteEntry(JournalEntry entry) async {
    final repo = ref.read(journalRepositoryProvider);
    final result = await DeleteJournalEntry(repo)(entry.id);
    if (!mounted) return;
    result.fold(
      (_) => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menghapus entri'),
          backgroundColor: AppColors.red500,
        ),
      ),
      (_) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Entri ${DateFormat('d MMM').format(entry.date)} dihapus',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entriesAsync = ref.watch(journalEntriesProvider((null, null)));
    final searchAsync = ref.watch(journalSearchProvider(_query));

    return Scaffold(
      backgroundColor: AppColors.zinc950,
      appBar: AppBar(
        backgroundColor: AppColors.zinc950,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: AppTypography.body.copyWith(color: AppColors.zinc50),
                decoration: InputDecoration(
                  hintText: 'Cari entri...',
                  hintStyle: AppTypography.body.copyWith(
                    color: AppColors.zinc500,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: _onSearchChanged,
              )
            : Text('Journal', style: AppTypography.h2),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? LucideIcons.x : LucideIcons.search,
              color: AppColors.zinc400,
            ),
            onPressed: () => setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) {
                _searchController.clear();
                _query = '';
              }
            }),
          ),
        ],
      ),
      body: _isSearching && _query.isNotEmpty
          ? searchAsync.when(
              loading: () => const LoadingIndicator(),
              error: (e, _) => AppErrorWidget(message: 'Gagal mencari: $e'),
              data: (entries) => _buildList(entries),
            )
          : entriesAsync.when(
              loading: () => const LoadingIndicator(),
              error: (e, _) => AppErrorWidget(
                message: 'Gagal memuat entri',
                onRetry: () =>
                    ref.invalidate(journalEntriesProvider((null, null))),
              ),
              data: (entries) => _buildList(entries),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.teal600,
        onPressed: () => context.push(RouteNames.journalNew),
        child: const Icon(LucideIcons.plus, color: Colors.white),
      ),
    );
  }

  Widget _buildList(List<JournalEntry> entries) {
    if (entries.isEmpty) {
      return _EmptyState(isSearch: _isSearching && _query.isNotEmpty);
    }
    final sorted = [...entries]..sort((a, b) => b.date.compareTo(a.date));
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: sorted.length,
      itemBuilder: (context, i) {
        final entry = sorted[i];
        return Dismissible(
          key: ValueKey(entry.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            decoration: BoxDecoration(
              color: AppColors.red500,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              LucideIcons.trash2,
              color: Colors.white,
              size: 22,
            ),
          ),
          confirmDismiss: (_) async {
            return await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                backgroundColor: AppColors.zinc900,
                title: Text('Hapus entri?', style: AppTypography.h3),
                content: Text(
                  'Entri ${DateFormat('d MMM yyyy').format(entry.date)} akan dihapus.',
                  style: AppTypography.body.copyWith(color: AppColors.zinc400),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      'Batal',
                      style: AppTypography.body.copyWith(
                        color: AppColors.zinc400,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(
                      'Hapus',
                      style: AppTypography.body.copyWith(
                        color: AppColors.red400,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          onDismissed: (_) => _deleteEntry(entry),
          child: _EntryCard(
            entry: entry,
            onTap: () =>
                context.push('${RouteNames.journalEntry}?id=${entry.id}'),
          ),
        );
      },
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({required this.entry, required this.onTap});

  final JournalEntry entry;
  final VoidCallback onTap;

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
    final sleep = entry.sleepRecord;
    String? sleepSnippet;
    if (sleep != null) {
      final dur = sleep.wakeTime.difference(sleep.bedTime);
      final h = dur.inHours;
      final m = dur.inMinutes % 60;
      sleepSnippet = m > 0 ? '${h}j ${m}m' : '${h}j';
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.zinc900,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.zinc800),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date column
            SizedBox(
              width: 44,
              child: Column(
                children: [
                  Text(
                    DateFormat('d').format(entry.date),
                    style: AppTypography.h2.copyWith(color: AppColors.teal400),
                  ),
                  Text(
                    DateFormat('MMM').format(entry.date),
                    style: AppTypography.caption.copyWith(
                      color: AppColors.zinc500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 60,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              color: AppColors.zinc800,
            ),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (entry.mood != null) ...[
                        Text(
                          _moodEmoji[entry.mood] ?? '•',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _moodLabel[entry.mood] ?? '',
                          style: AppTypography.bodyMedium,
                        ),
                      ] else
                        Text(
                          'Tanpa mood',
                          style: AppTypography.body.copyWith(
                            color: AppColors.zinc500,
                          ),
                        ),
                      const Spacer(),
                      if (entry.symptoms.isNotEmpty)
                        _Badge(label: '${entry.symptoms.length} gejala'),
                    ],
                  ),
                  if (sleepSnippet != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          LucideIcons.moon,
                          size: 12,
                          color: AppColors.zinc500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          sleepSnippet,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.zinc500,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (entry.freeText != null && entry.freeText!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      entry.freeText!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.zinc400,
                      ),
                    ),
                  ],
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

class _Badge extends StatelessWidget {
  const _Badge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.teal500_10,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.teal500_20),
      ),
      child: Text(
        label,
        style: AppTypography.micro.copyWith(color: AppColors.teal400),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({this.isSearch = false});
  final bool isSearch;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSearch ? LucideIcons.searchX : LucideIcons.bookOpen,
              size: 56,
              color: AppColors.zinc700,
            ),
            const SizedBox(height: 16),
            Text(
              isSearch ? 'Tidak ada hasil ditemukan' : 'Belum ada entri',
              style: AppTypography.h3.copyWith(color: AppColors.zinc400),
              textAlign: TextAlign.center,
            ),
            if (!isSearch) ...[
              const SizedBox(height: 8),
              Text(
                'Mulai journaling hari ini!',
                style: AppTypography.body.copyWith(color: AppColors.zinc600),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
