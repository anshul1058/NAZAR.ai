import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static const String serifFamily = 'PlayfairDisplay';
  static const String sansFamily = 'Inter';

  /// Editorial serif style for headings & big numbers.
  static TextStyle serif(
    double size, {
    FontWeight weight = FontWeight.w700,
    Color color = AppColors.textPrimary,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: serifFamily,
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  /// Small uppercase micro-label — the "journal" overline accent.
  static TextStyle overline(
    double size, {
    FontWeight weight = FontWeight.w700,
    Color color = AppColors.primary,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: sansFamily,
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing ?? 1.5,
    );
  }

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.buttonPrimary,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      error: AppColors.danger,
    );

    final baseTextTheme = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: sansFamily,
    ).textTheme;

    final textTheme = baseTextTheme.copyWith(
      displayLarge: baseTextTheme.displayLarge?.copyWith(
          fontFamily: serifFamily, fontWeight: FontWeight.w900),
      displayMedium: baseTextTheme.displayMedium?.copyWith(
          fontFamily: serifFamily, fontWeight: FontWeight.w800),
      displaySmall: baseTextTheme.displaySmall?.copyWith(
          fontFamily: serifFamily, fontWeight: FontWeight.w800),
      headlineLarge: baseTextTheme.headlineLarge?.copyWith(
          fontFamily: serifFamily, fontWeight: FontWeight.w800,
          height: 1.15, letterSpacing: -0.5),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          fontFamily: serifFamily, fontWeight: FontWeight.w800),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(
          fontFamily: serifFamily, fontWeight: FontWeight.w700),
      titleLarge: baseTextTheme.titleLarge?.copyWith(
          fontFamily: serifFamily, fontWeight: FontWeight.w700),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
          fontFamily: serifFamily, fontWeight: FontWeight.w700),
      titleSmall: baseTextTheme.titleSmall?.copyWith(
          fontFamily: serifFamily, fontWeight: FontWeight.w700),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
      bodySmall: baseTextTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
      labelLarge: baseTextTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700, color: AppColors.textPrimary),
      labelMedium: baseTextTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      labelSmall: baseTextTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.textMuted,
          letterSpacing: 1.2),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: sansFamily,
      textTheme: textTheme,
      scaffoldBackgroundColor: AppColors.background,

      // AppBar — warm surface, serif title
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTheme.serif(20, weight: FontWeight.w700),
      ),

      // Card — warm off-white, hairline border, soft rounding, no harsh shadow
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: AppColors.espresso.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.border),
        ),
      ),

      // Primary filled buttons — dark brown + cream text
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonPrimary,
          foregroundColor: AppColors.buttonPrimaryText,
          disabledBackgroundColor: AppColors.toggleOff,
          disabledForegroundColor: AppColors.textMuted,
          minimumSize: const Size(double.infinity, 52),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontFamily: sansFamily,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),

      // Secondary / outline buttons — cream bg, thin warm border, dark text
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.outline, width: 1),
          minimumSize: const Size(double.infinity, 48),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontFamily: sansFamily,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),

      // Tertiary text-only actions — muted warm brown
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
          textStyle: const TextStyle(
            fontFamily: sansFamily,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Toggle — ON sage track / white knob, OFF tan track / white knob
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => Colors.white,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.success
              : AppColors.toggleOff,
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.success
              : AppColors.toggleOff,
        ),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.primary
              : Colors.transparent,
        ),
        side: const BorderSide(color: AppColors.toggleOff, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // Input fields — warm parchment fill, tan borders, gold focus
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.6),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),

      // Dividers — thin warm hairline
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),

      // Bottom sheets
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),

      // Snackbars — warm espresso, no harsh shadow
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.espresso,
        contentTextStyle: const TextStyle(
          fontFamily: sansFamily,
          color: AppColors.buttonPrimaryText,
          fontSize: 14,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),

      // Progress indicators — gold accent
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.toggleOff,
        circularTrackColor: AppColors.toggleOff,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: AppTheme.serif(18, weight: FontWeight.w700),
        contentTextStyle: const TextStyle(
          fontFamily: sansFamily,
          fontSize: 14,
          color: AppColors.textSecondary,
          height: 1.5,
        ),
      ),
    );
  }
}