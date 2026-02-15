import 'package:flutter/material.dart';

class AppColors {
  // MTN Branding
  static const Color primary = Color(0xFFFFCC00); // MTN Yellow
  static const Color secondary = Color(0xFF000000); // Black
  static const Color accent = Color(0xFF0069B3); // MTN Blue (secondary accent)

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF757575);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF424242);

  // Status Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFFBC02D);

  // Backgrounds
  static const Color scaffoldBackground = white;
  static const Color cardBackground = white;

  // Premium Shadows
  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.02),
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ];

  // Premium Gradients
  static Gradient get primaryGradient => LinearGradient(
        colors: [primary, primary.withValues(alpha: 0.8)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
}
