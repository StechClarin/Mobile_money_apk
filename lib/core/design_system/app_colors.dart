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

  // Authentic Spotify Dark Surfaces & Backgrounds
  static const Color spotifyBlack = Color(0xFF121212); // Spotify Base Black
  static const Color spotifyCard = Color(0xFF181818); // Spotify Surface / Tile
  static const Color spotifyElevated = Color(0xFF242424); // Spotify Elevated Surface
  static const Color spotifyHover = Color(0xFF2A2A2A); // Spotify Hover/Divider
  static const Color spotifyGrey = Color(0xFFB3B3B3); // Spotify Secondary Text
  static const Color spotifySubtle = Color(0xFF727272); // Spotify Muted / Timestamp
  static const Color spotifyWhite = Color(0xFFFFFFFF); // Spotify Primary Text

  // Dark Scheme Mappings
  static const Color darkScaffold = spotifyBlack;
  static const Color darkCard = spotifyCard;
  static const Color darkElevated = spotifyElevated;
  static const Color darkBorder = Color(0xFF222222);
  static const Color textMutedDark = spotifyGrey;
  static const Color textLight = spotifyWhite;

  // Spotify-style Smooth Shadows
  static List<BoxShadow> get monarchGlow => [
        BoxShadow(
          color: monarchPurple.withValues(alpha: 0.25),
          blurRadius: 20,
          offset: const Offset(0, 6),
        ),
      ];

  static List<BoxShadow> get navBarDarkShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.5),
          blurRadius: 16,
          offset: const Offset(0, -4),
        ),
      ];

  static const LinearGradient monarchGradient = LinearGradient(
        colors: [monarchPurpleNeon, monarchPurpleDeep],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static Gradient get monarchPurpleGradient => monarchGradient;

  // Spotify Hero Top Subtle Infusion Gradient
  static Gradient get spotifyHeroGradient => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          monarchPurpleDeep.withValues(alpha: 0.28),
          spotifyBlack,
        ],
      );
}
