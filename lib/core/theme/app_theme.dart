import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../design_system/app_colors.dart';

class AppTheme {
  // Backwards compatibility tokens
  static const Color mtnYellow = AppColors.monarchPurpleNeon;
  static const Color black = Colors.black;
  static const Color white = Colors.white;

  // Global Design Tokens
  static const double cardRadius = 20.0;
  static const double buttonRadius = 14.0;
  static const double inputRadius = 14.0;

  static ThemeData get darkTheme {
    final baseTextTheme = ThemeData.dark().textTheme;
    final jakartaTextTheme = GoogleFonts.plusJakartaSansTextTheme(baseTextTheme);

    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.monarchPurpleNeon,
      scaffoldBackgroundColor: AppColors.spotifyBlack,
      fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
      textTheme: jakartaTextTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.spotifyBlack,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.plusJakartaSans(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.monarchPurpleNeon,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(buttonRadius)),
          textStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.spotifyCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: const BorderSide(color: Color(0xFF282828), width: 0.8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: const BorderSide(color: Color(0xFF282828), width: 0.8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: const BorderSide(color: AppColors.monarchPurpleNeon, width: 1.5),
        ),
        hintStyle: const TextStyle(color: AppColors.spotifyGrey, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      ),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.monarchPurpleNeon,
        secondary: AppColors.monarchPurple,
        surface: AppColors.spotifyCard,
      ),
    );
  }

  static ThemeData get lightTheme => darkTheme; // Default to dark for Walliss
}
