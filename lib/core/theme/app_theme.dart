import 'package:flutter/material.dart';

class AppTheme {
  // MTN Yellow
  static const Color mtnYellow = Color(0xFFFFCC00);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: mtnYellow,
      scaffoldBackgroundColor: white,
      appBarTheme: const AppBarTheme(
        backgroundColor: mtnYellow,
        elevation: 0,
        iconTheme: IconThemeData(color: black),
        titleTextStyle: TextStyle(
          color: black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      colorScheme: ColorScheme.light(
        primary: mtnYellow,
        secondary: black,
        surface: white,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: black),
        bodyMedium: TextStyle(color: black),
      ),
      // Add other theme properties as needed
    );
  }

  static ThemeData get darkTheme {
    // Placeholder for future implementation if needed
    // For now, sticking to the requested MTN Yellow and Black basic palette
    return ThemeData.dark().copyWith(
      primaryColor: mtnYellow,
      colorScheme: ColorScheme.dark(
         primary: mtnYellow,
         secondary: white,
      ),
    );
  }
}
