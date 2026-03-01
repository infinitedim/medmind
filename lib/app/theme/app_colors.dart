import 'package:flutter/material.dart';

abstract final class AppColors {
  static const zinc950 = Color(0xFF09090B);
  static const zinc900 = Color(0xFF18181B);
  static const zinc800 = Color(0xFF27272A);
  static const zinc700 = Color(0xFF3F3F46);
  static const zinc600 = Color(0xFF52525B);
  static const zinc500 = Color(0xFF71717A);
  static const zinc400 = Color(0xFFA1A1AA);
  static const zinc300 = Color(0xFFD4D4D8);
  static const zinc200 = Color(0xFFE4E4E7);
  static const zinc50 = Color(0xFFFAFAFA);

  static const teal700 = Color(0xFF0F766E);
  static const teal600 = Color(0xFF0D9488);
  static const teal500 = Color(0xFF14B8A6);
  static const teal400 = Color(0xFF2DD4BF);
  static const teal300 = Color(0xFF5EEAD4);
  static const teal500_10 = Color(0x1A14B8A6);
  static const teal500_20 = Color(0x3314B8A6);

  static const cyan300 = Color(0xFF67E8F9);
  static const cyan400 = Color(0xFF22D3EE);

  static const red500 = Color(0xFFEF4444);
  static const red400 = Color(0xFFF87171);
  static const red900_20 = Color(0x337F1D1D);

  static const amber500 = Color(0xFFF59E0B);
  static const amber400 = Color(0xFFFBBF24);
  static const amber900_20 = Color(0x3378350F);

  static const emerald500 = Color(0xFF10B981);
  static const emerald400 = Color(0xFF34D399);
  static const emerald300 = Color(0xFF6EE7B7);
  static const emerald900_30 = Color(0x4D064E39);

  static const orange500 = Color(0xFFF97316);
  static const orange400 = Color(0xFFFB923C);
  static const orange900_30 = Color(0x4D431407);

  static const indigo500 = Color(0xFF6366F1);
  static const indigo400 = Color(0xFF818CF8);
  static const indigo900_50 = Color(0x801E1B4B);

  static const purple500 = Color(0xFFA855F7);
  static const purple400 = Color(0xFFC084FC);
  static const purple900_50 = Color(0x803B0764);

  static const transparent = Colors.transparent;
  static const black = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);

  static const severityLow = emerald400;
  static const severityLowBg = emerald900_30;

  static const severityModerate = Color(0xFFFBBF24);
  static const severityModerateBg = Color(0x3378350F);

  static const severityHigh = orange400;
  static const severityHighBg = orange900_30;

  static const severitySevere = red400;
  static const severitySevereBg = red900_20;

  static const List<Color> scoreGradientCritical = [red500, orange500];
  static const List<Color> scoreGradientPoor = [orange500, Color(0xFFFACC15)];
  static const List<Color> scoreGradientGood = [teal400, cyan300];
  static const List<Color> scoreGradientExcellent = [teal400, emerald300];
}
