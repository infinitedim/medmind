import 'package:flutter/material.dart';
import 'package:medmind/app/theme/app_colors.dart';
import 'package:medmind/app/theme/app_typography.dart';

class JournalEntryPage extends StatelessWidget {
  const JournalEntryPage({this.entryId, super.key});

  final String? entryId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.zinc950,
      appBar: AppBar(
        title: Text(
          entryId == null ? 'New Entry' : 'Edit Entry',
          style: AppTypography.h2,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Text('Journal Entry Form', style: AppTypography.body),
        ),
      ),
    );
  }
}
