import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medmind/app/theme/app_colors.dart';
import 'package:medmind/app/theme/app_typography.dart';

abstract final class AppTheme {
  static const ColorScheme _colorScheme = ColorScheme(
    brightness: Brightness.dark,
    surface: AppColors.zinc950,
    surfaceContainerHighest: AppColors.zinc900,
    surfaceContainer: AppColors.zinc900,
    surfaceContainerHigh: AppColors.zinc800,
    surfaceContainerLow: AppColors.zinc900,
    surfaceContainerLowest: AppColors.zinc950,
    surfaceDim: AppColors.zinc950,
    surfaceBright: AppColors.zinc800,
    primary: AppColors.teal500,
    onPrimary: AppColors.zinc950,
    primaryContainer: AppColors.teal500_20,
    onPrimaryContainer: AppColors.teal300,
    secondary: AppColors.zinc700,
    onSecondary: AppColors.zinc50,
    secondaryContainer: AppColors.zinc800,
    onSecondaryContainer: AppColors.zinc300,
    tertiary: AppColors.cyan400,
    onTertiary: AppColors.zinc950,
    tertiaryContainer: AppColors.teal500_10,
    onTertiaryContainer: AppColors.cyan300,
    error: AppColors.red500,
    onError: AppColors.zinc50,
    errorContainer: AppColors.red900_20,
    onErrorContainer: AppColors.red400,
    onSurface: AppColors.zinc50,
    onSurfaceVariant: AppColors.zinc400,
    outline: AppColors.zinc800,
    outlineVariant: AppColors.zinc700,
    scrim: AppColors.black,
    inverseSurface: AppColors.zinc50,
    onInverseSurface: AppColors.zinc950,
    inversePrimary: AppColors.teal700,
    shadow: AppColors.black,
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: _colorScheme,
    scaffoldBackgroundColor: AppColors.zinc950,
    textTheme: AppTypography.textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.zinc950,
      surfaceTintColor: AppColors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: AppTypography.h2,
      iconTheme: const IconThemeData(color: AppColors.zinc400, size: 20),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.zinc950,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.zinc950,
      elevation: 0,
      selectedItemColor: AppColors.teal400,
      unselectedItemColor: AppColors.zinc500,
      selectedLabelStyle: AppTypography.micro.copyWith(
        color: AppColors.teal400,
      ),
      unselectedLabelStyle: AppTypography.micro.copyWith(
        color: AppColors.zinc500,
      ),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.zinc950,
      surfaceTintColor: AppColors.transparent,
      indicatorColor: AppColors.teal500_20,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColors.teal400, size: 22);
        }
        return const IconThemeData(color: AppColors.zinc500, size: 22);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppTypography.micro.copyWith(color: AppColors.teal400);
        }
        return AppTypography.micro.copyWith(color: AppColors.zinc500);
      }),
      height: 72,
    ),
    cardTheme: CardThemeData(
      color: AppColors.zinc900,
      surfaceTintColor: AppColors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.zinc800),
      ),
      margin: EdgeInsets.zero,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.teal500,
        foregroundColor: AppColors.zinc950,
        disabledBackgroundColor: AppColors.zinc700,
        disabledForegroundColor: AppColors.zinc500,
        minimumSize: const Size(double.infinity, 48),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        elevation: 0,
        textStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.zinc950,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.zinc50,
        side: const BorderSide(color: AppColors.zinc800),
        minimumSize: const Size(double.infinity, 48),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        textStyle: AppTypography.bodyMedium,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.zinc400,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        textStyle: AppTypography.bodyMedium,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.teal500,
        foregroundColor: AppColors.zinc950,
        minimumSize: const Size(double.infinity, 48),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        textStyle: AppTypography.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: AppColors.zinc400,
        highlightColor: AppColors.zinc800,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.zinc900,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.zinc800),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.zinc800),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.teal500),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.red500),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.red500),
      ),
      hintStyle: AppTypography.body.copyWith(color: AppColors.zinc600),
      labelStyle: AppTypography.caption.copyWith(color: AppColors.zinc400),
      floatingLabelStyle: AppTypography.caption.copyWith(
        color: AppColors.teal400,
      ),
      errorStyle: AppTypography.caption.copyWith(color: AppColors.red400),
      prefixIconColor: AppColors.zinc500,
      suffixIconColor: AppColors.zinc500,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.zinc800,
      thickness: 1,
      space: 1,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.zinc800,
      selectedColor: AppColors.teal500_20,
      disabledColor: AppColors.zinc900,
      side: const BorderSide(color: AppColors.zinc700),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      labelStyle: AppTypography.caption.copyWith(color: AppColors.zinc300),
      secondaryLabelStyle: AppTypography.caption.copyWith(
        color: AppColors.teal300,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      checkmarkColor: AppColors.teal400,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.teal500,
      inactiveTrackColor: AppColors.zinc700,
      thumbColor: AppColors.white,
      overlayColor: AppColors.teal500_10,
      valueIndicatorColor: AppColors.teal500,
      valueIndicatorTextStyle: AppTypography.caption.copyWith(
        color: AppColors.zinc950,
      ),
      trackHeight: 6,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.white;
        return AppColors.zinc500;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.teal500;
        }
        return AppColors.zinc700;
      }),
      trackOutlineColor: WidgetStateProperty.all(AppColors.transparent),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.teal500;
        }
        return AppColors.transparent;
      }),
      checkColor: WidgetStateProperty.all(AppColors.zinc950),
      side: const BorderSide(color: AppColors.zinc600, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.teal500;
        }
        return AppColors.zinc600;
      }),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.teal500,
      linearTrackColor: AppColors.zinc800,
      circularTrackColor: AppColors.zinc800,
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: AppColors.teal400,
      unselectedLabelColor: AppColors.zinc500,
      indicatorColor: AppColors.teal500,
      indicatorSize: TabBarIndicatorSize.label,
      dividerColor: AppColors.zinc800,
      labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.teal400),
      unselectedLabelStyle: AppTypography.bodyMedium.copyWith(
        color: AppColors.zinc500,
      ),
      overlayColor: WidgetStateProperty.all(AppColors.teal500_10),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.zinc900,
      surfaceTintColor: AppColors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.zinc800),
      ),
      titleTextStyle: AppTypography.h2,
      contentTextStyle: AppTypography.body.copyWith(color: AppColors.zinc400),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.zinc900,
      surfaceTintColor: AppColors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      showDragHandle: true,
      dragHandleColor: AppColors.zinc700,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.zinc800,
      contentTextStyle: AppTypography.body.copyWith(color: AppColors.zinc50),
      actionTextColor: AppColors.teal400,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      behavior: SnackBarBehavior.floating,
    ),
    listTileTheme: ListTileThemeData(
      tileColor: AppColors.transparent,
      iconColor: AppColors.zinc400,
      textColor: AppColors.zinc50,
      subtitleTextStyle: AppTypography.caption.copyWith(
        color: AppColors.zinc400,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      minLeadingWidth: 20,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: AppColors.zinc900,
      surfaceTintColor: AppColors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.zinc800),
      ),
      textStyle: AppTypography.body,
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: AppColors.zinc800,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.zinc700),
      ),
      textStyle: AppTypography.caption.copyWith(color: AppColors.zinc50),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
    iconTheme: const IconThemeData(color: AppColors.zinc400, size: 20),
    primaryIconTheme: const IconThemeData(color: AppColors.teal400, size: 20),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.teal500,
      foregroundColor: AppColors.zinc950,
      elevation: 0,
      shape: CircleBorder(),
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: AppColors.zinc900,
      surfaceTintColor: AppColors.transparent,
      headerBackgroundColor: AppColors.zinc900,
      headerForegroundColor: AppColors.zinc50,
      dayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.zinc950;
        }
        return AppColors.zinc300;
      }),
      dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.teal500;
        }
        return AppColors.transparent;
      }),
      todayForegroundColor: WidgetStateProperty.all(AppColors.teal400),
      todayBorder: const BorderSide(color: AppColors.teal500),
    ),
  );
}
