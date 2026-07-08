import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// "Chill & Minimal" design system per spec 03.
/// Muted tones. Vibrant accent ONLY on completion moment.
class AppTheme {
  AppTheme._();

  // ── Palette ──────────────────────────────────────────────────────────────
  static const Color sageGreen = Color(0xFF9CAF88);
  static const Color warmGray = Color(0xFFB8B0A8);
  static const Color softCream = Color(0xFFF5F0EB);
  static const Color deepCharcoal = Color(0xFF2D2D2D);
  static const Color mutedLavender = Color(0xFFC4B5D4);
  static const Color paleBlush = Color(0xFFE8D5D0);
  static const Color completionGreen = Color(0xFF4ADE80);
  static const Color completionGlow = Color(0xFF22C55E);
  static const Color skipAmber = Color(0xFFFBBF24);
  static const Color overdueRose = Color(0xFFFB7185);
  static const Color surface = Color(0xFFFAF8F5);
  static const Color surfaceVariant = Color(0xFFF0ECE6);

  // ── Glassmorphism helper ─────────────────────────────────────────────────
  static BoxDecoration get glassmorphism => BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 24,
            spreadRadius: 0,
          ),
        ],
      );

  static BoxDecoration get glassmorphismDark => BoxDecoration(
        color: deepCharcoal.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(24),
        border:
            Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 32,
            spreadRadius: 0,
          ),
        ],
      );

  // ── Theme Data ───────────────────────────────────────────────────────────
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: surface,
        colorScheme: ColorScheme.fromSeed(
          seedColor: sageGreen,
          brightness: Brightness.light,
          surface: surface,
          primary: sageGreen,
          secondary: mutedLavender,
          error: overdueRose,
        ),
        textTheme: GoogleFonts.nunitoTextTheme().copyWith(
          headlineLarge: GoogleFonts.nunito(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: deepCharcoal,
            height: 1.3,
          ),
          headlineMedium: GoogleFonts.nunito(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: deepCharcoal,
            height: 1.3,
          ),
          titleLarge: GoogleFonts.nunito(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: deepCharcoal,
          ),
          titleMedium: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: deepCharcoal,
          ),
          bodyLarge: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: deepCharcoal,
            height: 1.6,
          ),
          bodyMedium: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: warmGray,
            height: 1.5,
          ),
          labelLarge: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: sageGreen,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surfaceVariant,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: sageGreen, width: 1.5),
          ),
          hintStyle: GoogleFonts.nunito(
            color: warmGray.withValues(alpha: 0.6),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        ),
      );
}
