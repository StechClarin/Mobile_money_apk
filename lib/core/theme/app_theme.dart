import 'package:flutter/material.dart';

class AppTheme {
  static const Color mtnYellow = Color(0xFFFFCC00);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  // Global Design Tokens
  static const double cardRadius = 24.0;
  static const double buttonRadius = 16.0;
  static const double inputRadius = 12.0;

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: mtnYellow,
      scaffoldBackgroundColor: white,
      fontFamily: 'Outfit',
      appBarTheme: const AppBarTheme(
        backgroundColor: mtnYellow,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: black),
        titleTextStyle: TextStyle(
          color: black,
          fontFamily: 'Outfit',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: mtnYellow,
          foregroundColor: black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(buttonRadius)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Outfit'),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: const BorderSide(color: mtnYellow, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      colorScheme: ColorScheme.light(
        primary: mtnYellow,
        secondary: black,
        surface: white,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: black, fontFamily: 'Outfit'),
        bodyMedium: TextStyle(color: black, fontFamily: 'Outfit'),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      primaryColor: mtnYellow,
      scaffoldBackgroundColor: const Color(0xFF121212),
      colorScheme: ColorScheme.dark(
         primary: mtnYellow,
         secondary: white,
         surface: const Color(0xFF1E1E1E),
      ),
      textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Outfit'),
    );
  }
}
