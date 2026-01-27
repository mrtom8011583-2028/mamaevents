import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

/// MAMA EVENTS Premium Theme Configuration
/// Monochromatic + Gold accent system
class AppTheme {
  AppTheme._();

  /// Main Light Theme (Default)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // PRIMARY COLORS
      primaryColor: AppColors.logoCharcoalGrey,
      scaffoldBackgroundColor: AppColors.softWhite,
      canvasColor: AppColors.pureWhite,

      // COLOR SCHEME - Premium Palette
      colorScheme: ColorScheme.light(
        primary: AppColors.logoDeepBlack,
        primaryContainer: AppColors.logoCharcoalGrey,
        secondary: AppColors.premiumGoldMedium,
        secondaryContainer: AppColors.premiumGoldLight,
        surface: AppColors.pureWhite,
        error: AppColors.error,
        onPrimary: AppColors.pureWhite,
        onSecondary: AppColors.logoDeepBlack,
        onSurface: AppColors.logoDeepBlack,
        onError: AppColors.pureWhite,
        outline: AppColors.lightGrey,
      ),

      // APP BAR THEME
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.logoDeepBlack,
        foregroundColor: AppColors.logoSilverWhite,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.logoSilverWhite),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.logoSilverWhite,
        ),
      ),

      // TYPOGRAPHY
      textTheme: TextTheme(
        displayLarge: GoogleFonts.inter(
          fontSize: 64,
          fontWeight: FontWeight.w900,
          color: AppColors.logoDeepBlack,
          letterSpacing: -1.5,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 48,
          fontWeight: FontWeight.w800,
          color: AppColors.logoDeepBlack,
        ),
        displaySmall: GoogleFonts.inter(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: AppColors.logoDeepBlack,
        ),
        headlineLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.logoDeepBlack,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: AppColors.logoDeepBlack,
        ),
        headlineSmall: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.logoDeepBlack,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.logoDeepBlack,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.logoDeepBlack,
        ),
        titleSmall: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.logoDeepBlack,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.darkGrey,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.darkGrey,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.mediumGrey,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.logoDeepBlack,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.darkGrey,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.mediumGrey,
          letterSpacing: 1.5,
        ),
      ),

      // ELEVATED BUTTON THEME - Gold
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.premiumGoldMedium,
          foregroundColor: AppColors.logoDeepBlack,
          elevation: 4,
          shadowColor: AppColors.premiumGoldMedium.withOpacity(0.4),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
      ),

      // OUTLINED BUTTON THEME - Gold Border
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.premiumGoldMedium,
          side: BorderSide(color: AppColors.premiumGoldMedium, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
      ),

      // TEXT BUTTON THEME
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.logoDeepBlack,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // INPUT DECORATION THEME - Gold Focus
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.softWhite,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.lightGrey, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.lightGrey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.premiumGoldMedium, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.error, width: 1),
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.mediumGrey,
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.darkGrey,
        ),
      ),

      // CARD THEME
      cardTheme: CardThemeData(
        color: AppColors.pureWhite,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(8),
      ),

      // ICON THEME - Monochromatic Default
      iconTheme: IconThemeData(
        color: AppColors.mediumGrey,
        size: 24,
      ),

      // DIVIDER THEME
      dividerTheme: DividerThemeData(
        color: AppColors.lightGrey,
        thickness: 1,
        space: 24,
      ),

      // PROGRESS INDICATOR THEME - Gold
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.premiumGoldMedium,
        linearTrackColor: AppColors.lightGrey,
        circularTrackColor: AppColors.lightGrey,
      ),

      // FLOATING ACTION BUTTON THEME - Gold
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.premiumGoldMedium,
        foregroundColor: AppColors.logoDeepBlack,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // SNACKBAR THEME
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.logoCharcoalGrey,
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.pureWhite,
        ),
        actionTextColor: AppColors.premiumGoldMedium,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}