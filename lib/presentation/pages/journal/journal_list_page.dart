import 'package:flutter/material.dart';
import 'package:medmind/app/theme/app_colors.dart';
import 'package:medmind/app/theme/app_typography.dart';

class JournalListPage extends StatelessWidget {
  const JournalListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.zinc950,
      body: SafeArea(
        child: Center(child: Text('Journal', style: AppTypography.h1)),
      ),
    );
  }
}
