import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medmind/app/theme/app_colors.dart';
import 'package:medmind/app/theme/app_typography.dart';
import 'package:medmind/core/enum/enum_collection.dart';
import 'package:medmind/domain/entities/lifestyle_factor.dart';
import 'package:medmind/presentation/providers/journal_providers.dart';

class LifestyleInput extends ConsumerWidget {
  const LifestyleInput({
    required this.entryId,
    required this.factors,
    super.key,
  });

  final String? entryId;
  final List<LifestyleFactor> factors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formAsync = ref.watch(journalFormProvider(entryId));
    final notifier = ref.read(journalFormProvider(entryId).notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Lifestyle Factors', style: AppTypography.h3),
        const SizedBox(height: 12),
        if (factors.isEmpty)
          Text(
            'No lifestyle factors tracked. Add some in onboarding or settings.',
            style: AppTypography.body.copyWith(color: AppColors.zinc500),
          )
        else
          formAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, e) => const SizedBox.shrink(),
            data: (form) => ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: factors.length,
              separatorBuilder: (_, i) =>
                  const Divider(color: AppColors.zinc800, height: 1),
              itemBuilder: (_, idx) {
                final factor = factors[idx];
                final log = form.lifestyleFactors
                    .where((l) => l.factorId == factor.id)
                    .firstOrNull;
                return _LifestyleFactorTile(
                  factor: factor,
                  log: log,
                  onChanged: (updated) =>
                      notifier.addLifestyleFactorLog(updated),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _LifestyleFactorTile extends StatelessWidget {
  const _LifestyleFactorTile({
    required this.factor,
    required this.log,
    required this.onChanged,
  });

  final LifestyleFactor factor;
  final LifestyleFactorLog? log;
  final ValueChanged<LifestyleFactorLog> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: switch (factor.type) {
        FactorType.boolean => _BooleanTile(
          factor: factor,
          log: log,
          onChanged: onChanged,
        ),
        FactorType.numeric => _NumericTile(
          factor: factor,
          log: log,
          onChanged: onChanged,
        ),
        FactorType.scale => _ScaleTile(
          factor: factor,
          log: log,
          onChanged: onChanged,
        ),
      },
    );
  }
}

class _BooleanTile extends StatelessWidget {
  const _BooleanTile({
    required this.factor,
    required this.log,
    required this.onChanged,
  });

  final LifestyleFactor factor;
  final LifestyleFactorLog? log;
  final ValueChanged<LifestyleFactorLog> onChanged;

  @override
  Widget build(BuildContext context) {
    final value = log?.boolValue ?? false;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(factor.name, style: AppTypography.bodyMedium)),
        Switch(
          value: value,
          onChanged: (v) =>
              onChanged(LifestyleFactorLog(factorId: factor.id, boolValue: v)),
          activeThumbColor: AppColors.teal400,
          activeTrackColor: AppColors.teal700,
          inactiveThumbColor: AppColors.zinc600,
          inactiveTrackColor: AppColors.zinc800,
        ),
      ],
    );
  }
}

class _NumericTile extends StatefulWidget {
  const _NumericTile({
    required this.factor,
    required this.log,
    required this.onChanged,
  });

  final LifestyleFactor factor;
  final LifestyleFactorLog? log;
  final ValueChanged<LifestyleFactorLog> onChanged;

  @override
  State<_NumericTile> createState() => _NumericTileState();
}

class _NumericTileState extends State<_NumericTile> {
  late final TextEditingController _ctrl;
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(
      text: widget.log?.numericValue?.toString() ?? '',
    );
  }

  @override
  void didUpdateWidget(_NumericTile old) {
    super.didUpdateWidget(old);
    // Avoid disrupting user while typing; only sync external/programmatic changes.
    if (_focus.hasFocus) return;
    final incoming = widget.log?.numericValue?.toString() ?? '';
    if (_ctrl.text != incoming) _ctrl.text = incoming;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.factor.name, style: AppTypography.bodyMedium),
              if (widget.factor.unit != null)
                Text(
                  widget.factor.unit!,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.zinc500,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          width: 80,
          child: TextField(
            controller: _ctrl,
            focusNode: _focus,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            style: AppTypography.bodyMedium,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: '0',
              hintStyle: AppTypography.bodyMedium.copyWith(
                color: AppColors.zinc600,
              ),
              filled: true,
              fillColor: AppColors.zinc800,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 10,
              ),
              isDense: true,
            ),
            onChanged: (v) {
              final parsed = double.tryParse(v);
              if (parsed != null) {
                widget.onChanged(
                  LifestyleFactorLog(
                    factorId: widget.factor.id,
                    numericValue: parsed,
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class _ScaleTile extends StatelessWidget {
  const _ScaleTile({
    required this.factor,
    required this.log,
    required this.onChanged,
  });

  final LifestyleFactor factor;
  final LifestyleFactorLog? log;
  final ValueChanged<LifestyleFactorLog> onChanged;

  @override
  Widget build(BuildContext context) {
    final value = log?.scaleValue ?? 5;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(factor.name, style: AppTypography.bodyMedium),
            Text(
              '$value/10',
              style: AppTypography.captionMedium.copyWith(
                color: AppColors.teal400,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.teal500,
            inactiveTrackColor: AppColors.zinc800,
            thumbColor: AppColors.teal400,
            overlayColor: AppColors.teal500_20,
            trackHeight: 4,
          ),
          child: Slider(
            value: value.toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            onChanged: (v) => onChanged(
              LifestyleFactorLog(factorId: factor.id, scaleValue: v.round()),
            ),
          ),
        ),
      ],
    );
  }
}
