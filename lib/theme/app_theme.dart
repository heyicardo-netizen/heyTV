import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Vibrant, Harmonious Dark Mode Palette
  static const Color primaryViolet = Color(0xFF7C4DFF);
  static const Color secondaryCyan = Color(0xFF00E5FF);
  static const Color accentPink = Color(0xFFFF4081);
  static const Color bgDark = Color(0xFF0A0C14);
  static const Color cardDark = Color(0xFF141824);
  static const Color cardGlass = Color(0x2AFFFFFF);
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: bgDark,
      primaryColor: primaryViolet,
      colorScheme: const ColorScheme.dark(
        primary: primaryViolet,
        secondary: secondaryCyan,
        surface: cardDark,
        onSurface: textPrimary,
      ),
      textTheme: GoogleFonts.outfitTextTheme().apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
      cardTheme: CardThemeData(
        color: cardDark,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: cardDark,
        selectedItemColor: secondaryCyan,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 12,
      ),
    );
  }

  // Smooth Glassmorphism Container Decoration
  static BoxDecoration glassDecoration({double radius = 16}) {
    return BoxDecoration(
      color: cardDark.withValues(alpha: 0.7),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.12),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.4),
          blurRadius: 16,
          spreadRadius: 2,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }
}
