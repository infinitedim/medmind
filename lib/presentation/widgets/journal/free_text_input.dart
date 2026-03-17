import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medmind/app/theme/app_colors.dart';
import 'package:medmind/app/theme/app_typography.dart';
import 'package:medmind/presentation/providers/journal_providers.dart';

class FreeTextInput extends ConsumerStatefulWidget {
  const FreeTextInput({required this.entryId, super.key});

  final String? entryId;

  @override
  ConsumerState<FreeTextInput> createState() => _FreeTextInputState();
}

class _FreeTextInputState extends ConsumerState<FreeTextInput> {
  late final TextEditingController _ctrl;
  int _wordCount = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final form = ref.read(journalFormProvider(widget.entryId)).asData?.value;
      if (form?.freeText != null) {
        _ctrl.text = form!.freeText!;
        setState(() => _wordCount = _countWords(form.freeText!));
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  int _countWords(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return 0;
    return trimmed.split(RegExp(r'\s+')).length;
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(journalFormProvider(widget.entryId).notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Notes', style: AppTypography.h3),
        const SizedBox(height: 12),
        TextField(
          controller: _ctrl,
          maxLines: 6,
          style: AppTypography.body,
          decoration: InputDecoration(
            hintText: 'How are you feeling today? Any triggers you noticed?',
            hintStyle: AppTypography.body.copyWith(color: AppColors.zinc600),
            filled: true,
            fillColor: AppColors.zinc900,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.zinc800),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.zinc800),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.teal500),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          onChanged: (v) {
            notifier.setFreeText(v);
            setState(() => _wordCount = _countWords(v));
          },
        ),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '$_wordCount ${_wordCount == 1 ? 'word' : 'words'}',
            style: AppTypography.micro,
          ),
        ),
      ],
    );
  }
}
