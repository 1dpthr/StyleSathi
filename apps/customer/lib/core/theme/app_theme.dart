import 'package:flutter/material.dart';

import 'app_colors.dart';

/// App theme derived from the Style Sathi Figma designs.
///
/// The designs use a serif typeface throughout. No font files ship with the
/// designs, so the platform serif face is requested by family name and a small
/// fallback list keeps the intent intact across Android, iOS and desktop.
abstract final class AppTheme {
  static const String fontFamily = 'serif';

  static const List<String> fontFamilyFallback = <String>[
    'Georgia',
    'Noto Serif',
    'Times New Roman',
  ];

  static ThemeData get light {
    final base = ThemeData(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.gold,
        onPrimary: AppColors.ink,
        surface: AppColors.background,
        onSurface: AppColors.ink,
        outline: AppColors.divider,
      ),
      textTheme: _textTheme(base.textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          color: AppColors.ink,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: AppColors.ink),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.ink,
        contentTextStyle: const TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          color: Colors.white,
          fontSize: 14,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.ink,
          minimumSize: const Size.fromHeight(52),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontFamilyFallback: fontFamilyFallback,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink,
          minimumSize: const Size.fromHeight(52),
          side: const BorderSide(color: AppColors.outline, width: 1.2),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontFamilyFallback: fontFamilyFallback,
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.fieldGrey,
        hintStyle: const TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          color: AppColors.inkMuted,
          fontSize: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.gold, width: 1.4),
        ),
      ),
    );
  }

  static TextTheme _textTheme(TextTheme base) {
    TextStyle style(double size, FontWeight weight, {Color color = AppColors.ink}) =>
        TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontSize: size,
          fontWeight: weight,
          color: color,
          height: 1.35,
        );

    return base.copyWith(
      displaySmall: style(32, FontWeight.bold),
      headlineMedium: style(26, FontWeight.bold),
      headlineSmall: style(22, FontWeight.bold),
      titleLarge: style(20, FontWeight.bold),
      titleMedium: style(17, FontWeight.bold),
      titleSmall: style(15, FontWeight.w600),
      bodyLarge: style(16, FontWeight.normal),
      bodyMedium: style(14, FontWeight.normal),
      bodySmall: style(12, FontWeight.normal, color: AppColors.inkMuted),
      labelLarge: style(14, FontWeight.w600),
    );
  }
}