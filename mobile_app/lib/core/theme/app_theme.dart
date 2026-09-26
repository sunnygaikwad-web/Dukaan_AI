import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── ShilpSetu AI Logo-Inspired Heritage Color Palette ────────────────────────
// Directly derived from the authentic Indian Craft & Dukan Storefront Logo:
// 1. Terracotta / Sunset Rust (#C04E1D) - Earthen pottery, artisan hand & awning
// 2. Herbal Forest Green (#2E7D32) - Botanical leaf, natural organic dyes
// 3. Marigold Amber (#D97706) - Auspicious Indian marigold & brass craft
// 4. Warm Ivory Khadi (#FAF7F2) - Handmade silk & parchment canvas
class AppColors {
  // 🏺 Primary: Warm Terracotta & Saffron (#C04E1D) → Core Brand & Action Elements
  static const Color primary = Color(0xFFC04E1D);
  static const Color primaryDark = Color(0xFF943912);
  static const Color primaryLight = Color(0xFFDC6B3A);
  static const Color primaryFixed = Color(0xFFFFECE5); // Soft Terracotta Tint
  static const Color primaryContainer = Color(0xFFFFECE5);

  // 🌿 Secondary: Herbal Leaf Green (#2E7D32) → Nature, Authenticity & Verification
  static const Color secondary = Color(0xFF2E7D32);
  static const Color secondaryDark = Color(0xFF1B5E20);
  static const Color secondaryLight = Color(0xFF4CAF50);
  static const Color secondaryFixed = Color(0xFFE8F5E9); // Fresh Mint/Leaf Tint
  static const Color secondaryContainer = Color(0xFFE8F5E9);

  // 🌼 Tertiary: Marigold & Clay Pottery (#D97706) → Festivities, Profits & GI Badges
  static const Color tertiary = Color(0xFFD97706);
  static const Color tertiaryDark = Color(0xFFB45309);
  static const Color tertiaryLight = Color(0xFFF59E0B);
  static const Color tertiaryFixed = Color(0xFFFEF3C7);
  static const Color tertiaryContainer = Color(0xFFFEF3C7);

  // 🟤 Earthy Sand & Clay Matka
  static const Color sand = Color(0xFFF5EDE0);
  static const Color sandLight = Color(0xFFFAF6EE);
  static const Color sandDark = Color(0xFFDFCBB5);
  static const Color clay = Color(0xFFA0522D);

  // 🤍 Background & Surfaces: Warm Ivory Khadi Silk (#FAF7F2)
  static const Color background = Color(0xFFFAF7F2);
  static const Color surface = Color(0xFFFAF7F2);
  static const Color surfaceContainer = Color(0xFFFFECE5);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5EDE0);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Backward-compatibility aliases for existing views
  static const Color lavender = Color(0xFFFFECE5);
  static const Color lavenderLight = Color(0xFFFFF6F2);

  // ☕ Text Colors: Warm Roasted Espresso Charcoal (#1C1917)
  static const Color textPrimary = Color(0xFF1C1917);
  static const Color textSecondary = Color(0xFF44403C);
  static const Color textLight = Color(0xFF78716C);
  static const Color textHint = Color(0xFFA8A29E);

  // Status & Notifications
  static const Color error = Color(0xFFDC2626);
  static const Color errorContainer = Color(0xFFFEE2E2);
  static const Color success = Color(0xFF16A34A);
  static const Color successContainer = Color(0xFFDCFCE7);

  // Dividers, Outlines & Tactile Shadows
  static const Color outline = Color(0xFFEAE2D5);
  static const Color outlineVariant = Color(0xFFF2ECE1);
  static const Color divider = Color(0xFFF0EAE0);
  static const Color cardShadow = Color(0x14C04E1D); // Warm terracotta ambient glow

  // Semantic Shortcuts
  static const Color verifiedBadge = Color(0xFF2E7D32);
  static const Color masterBadge = Color(0xFFC04E1D);
  static const Color aiAssist = Color(0xFFC04E1D);
  static const Color heritageSand = Color(0xFFF5EDE0);
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

      // ─── Dual Typography Pairing (Outfit for Display/Headers, Plus Jakarta Sans for Body) ───
      textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
        displayLarge: GoogleFonts.outfit(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w800,
          fontSize: 44,
          height: 1.15,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.outfit(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 34,
          height: 1.2,
          letterSpacing: -0.3,
        ),
        headlineLarge: GoogleFonts.outfit(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 28,
          height: 1.25,
        ),
        headlineMedium: GoogleFonts.outfit(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 24,
          height: 1.25,
        ),
        headlineSmall: GoogleFonts.outfit(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 20,
          height: 1.3,
        ),
        titleLarge: GoogleFonts.outfit(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 19,
          height: 1.3,
        ),
        titleMedium: GoogleFonts.outfit(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 16.5,
          height: 1.35,
        ),
        titleSmall: GoogleFonts.plusJakartaSans(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 15,
          height: 1.4,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w400,
          fontSize: 16,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w400,
          fontSize: 14.5,
          height: 1.45,
        ),
        bodySmall: GoogleFonts.plusJakartaSans(
          color: AppColors.textLight,
          fontWeight: FontWeight.w400,
          fontSize: 12.5,
          height: 1.4,
        ),
        labelLarge: GoogleFonts.plusJakartaSans(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 14,
          height: 1.3,
        ),
        labelMedium: GoogleFonts.plusJakartaSans(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 12.5,
          height: 1.3,
        ),
        labelSmall: GoogleFonts.plusJakartaSans(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 11,
          height: 1.3,
          letterSpacing: 0.2,
        ),
      ),

      // ─── Interactive Buttons (Polished tactile feedback) ──────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(64, 50),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: GoogleFonts.outfit(fontSize: 15.5, fontWeight: FontWeight.w700),
          elevation: 2,
          shadowColor: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.6),
          minimumSize: const Size(64, 50),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),

      // ─── Floating Action Button ──────────────────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),

      // ─── Card Theme (Warm subtle borders & shadows) ──────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.surfaceContainerLowest,
        elevation: 0,
        shadowColor: AppColors.cardShadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.outlineVariant, width: 1),
        ),
      ),

      // ─── Input Fields (Modern Rounded Containers) ────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        hintStyle: GoogleFonts.plusJakartaSans(color: AppColors.textHint, fontSize: 13.5),
        labelStyle: GoogleFonts.plusJakartaSans(color: AppColors.textSecondary, fontSize: 13.5),
      ),

      // ─── App Bar Theme (Clean Ivory with Outfit title) ────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: GoogleFonts.outfit(
          color: AppColors.textPrimary,
          fontSize: 21,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.2,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),

      // ─── Bottom Navigation Bar ───────────────────────────────────────────────
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceContainerLowest,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textLight,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // ─── Interactive Chips & Pills ───────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceContainerLowest,
        selectedColor: AppColors.primaryFixed,
        labelStyle: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
        side: const BorderSide(color: AppColors.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),

      // ─── Dialogs & Bottom Sheets ─────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 6,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),

      // ─── Interactive Floating Snackbars ──────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w600),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),
    );
  }
}
