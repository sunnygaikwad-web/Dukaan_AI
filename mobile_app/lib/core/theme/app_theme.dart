import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── ShilpSetu AI Color Palette (Indigo + Lavender + Sand “Digital Heritage”) ───
class AppColors {
  // 🔵 Primary: Deep Indigo (#25204A) → Main brand, headers, primary buttons
  static const Color primary = Color(0xFF25204A);
  static const Color primaryDark = Color(0xFF191535);
  static const Color primaryLight = Color(0xFF3C356E);
  static const Color primaryFixed = Color(0xFFE9E3FF); // Soft Lavender

  // 🟣 Secondary: Royal Violet (#7657D9) → AI features, highlights, badges
  static const Color secondary = Color(0xFF7657D9);
  static const Color secondaryDark = Color(0xFF5A3CB5);
  static const Color secondaryLight = Color(0xFF9E84F5);
  static const Color secondaryFixed = Color(0xFFF0ECFF);

  // 🟤 Artisan & Craft Sections: Sand (#F3EBDD)
  static const Color sand = Color(0xFFF3EBDD);
  static const Color sandLight = Color(0xFFFAF6EE);
  static const Color sandDark = Color(0xFFD8C8B0);
  static const Color tertiary = Color(0xFFB08A4D);
  static const Color tertiaryDark = Color(0xFF8B6B34);
  static const Color tertiaryFixed = Color(0xFFF3EBDD);

  // 🤍 Background & Surfaces: Warm Off-White (#FCFAF6) & Soft Lavender (#E9E3FF)
  static const Color background = Color(0xFFFCFAF6);
  static const Color surface = Color(0xFFFCFAF6);
  static const Color surfaceContainer = Color(0xFFE9E3FF); // Soft Lavender
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF2EDFA);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color lavender = Color(0xFFE9E3FF);
  static const Color lavenderLight = Color(0xFFF5F2FF);

  // ⚫ Text Colors: Deep Charcoal (#24232A)
  static const Color textPrimary = Color(0xFF24232A);
  static const Color textSecondary = Color(0xFF4B4856);
  static const Color textLight = Color(0xFF757283);
  static const Color textHint = Color(0xFFA19EAF);

  // Status
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color success = Color(0xFF1B873F);
  static const Color successContainer = Color(0xFFDCF5DC);

  // Dividers & Outlines
  static const Color outline = Color(0xFFD6CEE5);
  static const Color outlineVariant = Color(0xFFE8E2F2);
  static const Color divider = Color(0xFFEFEBF5);
  static const Color cardShadow = Color(0x1225204A);

  // Semantic Shortcuts
  static const Color verifiedBadge = Color(0xFF25204A);
  static const Color masterBadge = Color(0xFF7657D9);
  static const Color aiAssist = Color(0xFF7657D9);
  static const Color heritageSand = Color(0xFFF3EBDD);
}

class AppTheme {
  static ThemeData get lightTheme {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.tertiary,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
      ),
      scaffoldBackgroundColor: AppColors.background,

      // Enhanced Typography Scale for High Readability (Devanagari & Latin)
      textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
        displayLarge: GoogleFonts.quicksand(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 48,
          height: 1.2,
        ),
        displayMedium: GoogleFonts.quicksand(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 34,
          height: 1.25,
        ),
        headlineLarge: GoogleFonts.quicksand(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 30,
          height: 1.3,
        ),
        headlineMedium: GoogleFonts.quicksand(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 26,
          height: 1.3,
        ),
        headlineSmall: GoogleFonts.quicksand(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 22,
          height: 1.35,
        ),
        titleLarge: GoogleFonts.quicksand(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 20,
          height: 1.35,
        ),
        titleMedium: GoogleFonts.quicksand(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 18,
          height: 1.35,
        ),
        titleSmall: GoogleFonts.plusJakartaSans(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 16,
          height: 1.4,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w400,
          fontSize: 17,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w400,
          fontSize: 15.5,
          height: 1.45,
        ),
        bodySmall: GoogleFonts.plusJakartaSans(
          color: AppColors.textLight,
          fontWeight: FontWeight.w400,
          fontSize: 13.5,
          height: 1.4,
        ),
        labelLarge: GoogleFonts.plusJakartaSans(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 15,
          height: 1.3,
        ),
        labelMedium: GoogleFonts.plusJakartaSans(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 13.5,
          height: 1.3,
        ),
        labelSmall: GoogleFonts.plusJakartaSans(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 12,
          height: 1.3,
          letterSpacing: 0.3,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(64, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700),
          elevation: 0,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.outline, width: 1.5),
          minimumSize: const Size(64, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.surfaceContainerLowest,
        elevation: 0,
        shadowColor: AppColors.cardShadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.divider, width: 1),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: GoogleFonts.plusJakartaSans(color: AppColors.textHint, fontSize: 14),
        labelStyle: GoogleFonts.plusJakartaSans(color: AppColors.textSecondary, fontSize: 14),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: GoogleFonts.playfairDisplay(
          color: AppColors.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceContainerLowest,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textLight,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceContainer,
        selectedColor: AppColors.primaryFixed,
        labelStyle: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
        side: const BorderSide(color: AppColors.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),
    );
  }
}
