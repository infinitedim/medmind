import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:medmind/app/theme/app_colors.dart';
import 'package:medmind/app/theme/app_typography.dart';

enum _DateRange { last30, last90, custom }

enum _ExportFormat { pdf, csv }

class ExportPage extends StatefulWidget {
  const ExportPage({super.key});

  @override
  State<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  _DateRange _range = _DateRange.last30;
  _ExportFormat _format = _ExportFormat.csv;
  bool _isGenerating = false;

  DateTimeRange? _customRange;

  Future<void> _pickCustomRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 2)),
      lastDate: DateTime.now(),
      initialDateRange: _customRange,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.teal500,
            onPrimary: AppColors.zinc950,
            surface: AppColors.zinc900,
            onSurface: AppColors.zinc50,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _customRange = picked;
        _range = _DateRange.custom;
      });
    }
  }

  Future<void> _generate() async {
    setState(() => _isGenerating = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isGenerating = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fitur ekspor akan segera tersedia')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.zinc950,
      appBar: AppBar(
        backgroundColor: AppColors.zinc950,
        title: Text('Ekspor Data', style: AppTypography.h2),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          Text(
            'RENTANG WAKTU',
            style: AppTypography.overline.copyWith(color: AppColors.zinc500),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _RangeChip(
                label: '30 hari',
                isSelected: _range == _DateRange.last30,
                onTap: () => setState(() => _range = _DateRange.last30),
              ),
              _RangeChip(
                label: '90 hari',
                isSelected: _range == _DateRange.last90,
                onTap: () => setState(() => _range = _DateRange.last90),
              ),
              _RangeChip(
                label: _customRange != null
                    ? '${_formatDate(_customRange!.start)} – ${_formatDate(_customRange!.end)}'
                    : 'Kustom',
                isSelected: _range == _DateRange.custom,
                onTap: _pickCustomRange,
                icon: LucideIcons.calendar,
              ),
            ],
          ),
          const SizedBox(height: 28),
          Text(
            'FORMAT',
            style: AppTypography.overline.copyWith(color: AppColors.zinc500),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.zinc900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _FormatTile(
                  icon: LucideIcons.fileText,
                  label: 'CSV',
                  subtitle: 'Spreadsheet — Excel, Google Sheets',
                  isSelected: _format == _ExportFormat.csv,
                  onTap: () => setState(() => _format = _ExportFormat.csv),
                ),
                Divider(height: 1, color: AppColors.zinc800),
                _FormatTile(
                  icon: LucideIcons.file,
                  label: 'PDF',
                  subtitle: 'Laporan yang siap cetak',
                  isSelected: _format == _ExportFormat.pdf,
                  onTap: () => setState(() => _format = _ExportFormat.pdf),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isGenerating ? null : _generate,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.teal600,
                disabledBackgroundColor: AppColors.teal600.withAlpha(120),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: _isGenerating
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(LucideIcons.download, size: 18),
              label: Text(
                _isGenerating ? 'Menyiapkan...' : 'Ekspor',
                style: AppTypography.bodyMedium.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatDate(DateTime d) => '${d.day}/${d.month}/${d.year}';
}

class _RangeChip extends StatelessWidget {
  const _RangeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.teal500_20 : AppColors.zinc900,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.teal500 : AppColors.zinc700,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: isSelected ? AppColors.teal400 : AppColors.zinc400,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: AppTypography.caption.copyWith(
                color: isSelected ? AppColors.teal400 : AppColors.zinc300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormatTile extends StatelessWidget {
  const _FormatTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.teal400 : AppColors.zinc400,
        size: 20,
      ),
      title: Text(label, style: AppTypography.body),
      subtitle: Text(
        subtitle,
        style: AppTypography.caption.copyWith(color: AppColors.zinc500),
      ),
      trailing: isSelected
          ? const Icon(
              LucideIcons.checkCircle,
              color: AppColors.teal500,
              size: 20,
            )
          : null,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
