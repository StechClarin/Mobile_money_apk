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

  // Walliss Dark & Sung Jin-woo (Shadow Monarch) Palette
  static const Color monarchPurple = Color(0xFF8B5CF6); // Electric Shadow Purple
  static const Color monarchPurpleNeon = Color(0xFFA855F7); // High-voltage Violet
  static const Color monarchPurpleDeep = Color(0xFF6D28D9); // Deep Monarch Purple
  static const Color monarchPurpleAura = Color(0xFF7C3AED); // Radiant Shadow Aura
  static const Color monarchCyan = Color(0xFF38BDF8); // Spectral Eye Glow

  // Dark Surface & Backgrounds
  static const Color darkScaffold = Color(0xFF0A0912); // Void / Abyss Black
  static const Color darkCard = Color(0xFF131122); // Dark Velvet Obsidian
  static const Color darkElevated = Color(0xFF1C1833); // Elevated Dock Surface
  static const Color darkBorder = Color(0xFF282347); // Subtle Shadow Rift Border
  static const Color textMutedDark = Color(0xFF7A7893); // Sleek Inactive Grey
  static const Color textLight = Color(0xFFF1F0F7);

  // Sung Jin-woo Shadow Glow
  static List<BoxShadow> get monarchGlow => [
        BoxShadow(
          color: monarchPurple.withValues(alpha: 0.35),
          blurRadius: 24,
          offset: const Offset(0, 6),
          spreadRadius: -2,
        ),
      ];

  static List<BoxShadow> get navBarDarkShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.65),
          blurRadius: 30,
          offset: const Offset(0, -8),
        ),
        BoxShadow(
          color: monarchPurple.withValues(alpha: 0.18),
          blurRadius: 20,
          offset: const Offset(0, -2),
        ),
      ];

  static Gradient get monarchPurpleGradient => const LinearGradient(
        colors: [monarchPurpleNeon, monarchPurpleDeep],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
}
