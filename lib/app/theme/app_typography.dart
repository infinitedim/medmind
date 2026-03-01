import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medmind/app/theme/app_colors.dart';

abstract final class AppTypography {
  static TextStyle _inter({
    required double size,
    required FontWeight weight,
    Color color = AppColors.zinc50,
    double? height,
    double? letterSpacing,
  }) => GoogleFonts.inter(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
  );

  static TextStyle _mono({
    required double size,
    required FontWeight weight,
    Color color = AppColors.zinc50,
  }) => GoogleFonts.jetBrainsMono(
    fontSize: size,
    fontWeight: weight,
    color: color,
  );

  static TextStyle get display => _inter(size: 32, weight: FontWeight.w700);

  static TextStyle get h1 => _inter(size: 24, weight: FontWeight.w600);
  static TextStyle get h2 => _inter(size: 18, weight: FontWeight.w600);
  static TextStyle get h3 => _inter(size: 16, weight: FontWeight.w600);

  static TextStyle get bodyMedium => _inter(size: 14, weight: FontWeight.w500);
  static TextStyle get body =>
      _inter(size: 14, weight: FontWeight.w400, height: 1.5);
  static TextStyle get small =>
      _inter(size: 13, weight: FontWeight.w400, height: 1.6);
  static TextStyle get caption =>
      _inter(size: 12, weight: FontWeight.w400, height: 1.4);
  static TextStyle get captionMedium =>
      _inter(size: 12, weight: FontWeight.w500);
  static TextStyle get micro =>
      _inter(size: 11, weight: FontWeight.w400, color: AppColors.zinc500);

  static TextStyle get overline => _inter(
    size: 12,
    weight: FontWeight.w500,
    color: AppColors.zinc400,
    letterSpacing: 0.8,
  );

  static TextStyle get monoLarge => _mono(size: 36, weight: FontWeight.w700);
  static TextStyle get monoMedium => _mono(size: 24, weight: FontWeight.w700);
  static TextStyle get mono => _mono(size: 14, weight: FontWeight.w400);
  static TextStyle get monoSmall =>
      _mono(size: 12, weight: FontWeight.w400, color: AppColors.zinc500);

  static TextStyle get muted =>
      _inter(size: 14, weight: FontWeight.w400, color: AppColors.zinc400);
  static TextStyle get mutedSmall =>
      _inter(size: 13, weight: FontWeight.w400, color: AppColors.zinc400);
  static TextStyle get mutedCaption =>
      _inter(size: 12, weight: FontWeight.w400, color: AppColors.zinc500);

  static TextStyle get accent =>
      _inter(size: 14, weight: FontWeight.w500, color: AppColors.teal400);
  static TextStyle get accentSmall =>
      _inter(size: 12, weight: FontWeight.w500, color: AppColors.teal400);

  static TextStyle get destructive =>
      _inter(size: 14, weight: FontWeight.w500, color: AppColors.red500);

  static TextTheme get textTheme => TextTheme(
    displayLarge: _inter(size: 32, weight: FontWeight.w700),
    displayMedium: _inter(size: 28, weight: FontWeight.w700),
    displaySmall: _inter(size: 24, weight: FontWeight.w600),
    headlineLarge: h1,
    headlineMedium: h2,
    headlineSmall: h3,
    titleLarge: _inter(size: 16, weight: FontWeight.w600),
    titleMedium: _inter(size: 15, weight: FontWeight.w500),
    titleSmall: _inter(size: 14, weight: FontWeight.w500),
    bodyLarge: body,
    bodyMedium: _inter(size: 14, weight: FontWeight.w400),
    bodySmall: small,
    labelLarge: _inter(size: 14, weight: FontWeight.w500),
    labelMedium: captionMedium,
    labelSmall: micro,
  );
}
