import 'package:flutter/material.dart';

/// Kerala-inspired color palette for the Wedding Cards app.
/// Features deep gold, rich maroon, and emerald green as the primary triad.
class AppColors {
  AppColors._();

  // ─── Primary Colors ──────────────────────────────────────────────
  static const Color primary = Color(0xFFB8860B);
  static const Color primaryLight = Color(0xFFDAA520);
  static const Color primaryDark = Color(0xFF8B6508);
  static const Color primarySurface = Color(0xFFFFF3D6);

  // ─── Secondary Colors ────────────────────────────────────────────
  static const Color secondary = Color(0xFF800020);
  static const Color secondaryLight = Color(0xFFA3244A);
  static const Color secondaryDark = Color(0xFF5C0017);
  static const Color secondarySurface = Color(0xFFFFE4EC);

  // ─── Accent Colors ───────────────────────────────────────────────
  static const Color accent = Color(0xFF046307);
  static const Color accentLight = Color(0xFF2E8B31);
  static const Color accentDark = Color(0xFF024A05);
  static const Color accentSurface = Color(0xFFE8F5E9);

  // ─── Background Colors ───────────────────────────────────────────
  static const Color backgroundLight = Color(0xFFFFF8F0);
  static const Color backgroundDark = Color(0xFF1A1A2E);

  // ─── Surface Colors ──────────────────────────────────────────────
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF16213E);

  // ─── Error Colors ────────────────────────────────────────────────
  static const Color error = Color(0xFFD32F2F);
  static const Color errorLight = Color(0xFFEF5350);
  static const Color errorDark = Color(0xFFC62828);
  static const Color errorSurface = Color(0xFFFFEBEE);
  static const Color onError = Color(0xFFFFFFFF);

  // ─── Success Colors ──────────────────────────────────────────────
  static const Color success = Color(0xFF2E7D32);
  static const Color successLight = Color(0xFF4CAF50);
  static const Color successSurface = Color(0xFFE8F5E9);

  // ─── Warning Colors ──────────────────────────────────────────────
  static const Color warning = Color(0xFFF57F17);
  static const Color warningLight = Color(0xFFFFC107);
  static const Color warningSurface = Color(0xFFFFF8E1);

  // ─── Gold Shades ─────────────────────────────────────────────────
  static const Color gold50 = Color(0xFFFFF8E1);
  static const Color gold100 = Color(0xFFFFECB3);
  static const Color gold200 = Color(0xFFFFE082);
  static const Color gold300 = Color(0xFFFFD54F);
  static const Color gold400 = Color(0xFFDAA520);
  static const Color gold500 = Color(0xFFB8860B);
  static const Color gold600 = Color(0xFF9A7209);
  static const Color gold700 = Color(0xFF8B6508);
  static const Color gold800 = Color(0xFF6B4E06);
  static const Color gold900 = Color(0xFF4A3504);

  // ─── Text Colors ─────────────────────────────────────────────────
  static const Color textPrimaryLight = Color(0xFF1A1A1A);
  static const Color textSecondaryLight = Color(0xFF5A5A5A);
  static const Color textTertiaryLight = Color(0xFF9E9E9E);
  static const Color textDisabledLight = Color(0xFFBDBDBD);

  static const Color textPrimaryDark = Color(0xFFF5F5F5);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  static const Color textTertiaryDark = Color(0xFF757575);
  static const Color textDisabledDark = Color(0xFF616161);

  // ─── Neutral Colors ──────────────────────────────────────────────
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral200 = Color(0xFFEEEEEE);
  static const Color neutral300 = Color(0xFFE0E0E0);
  static const Color neutral400 = Color(0xFFBDBDBD);
  static const Color neutral500 = Color(0xFF9E9E9E);
  static const Color neutral600 = Color(0xFF757575);
  static const Color neutral700 = Color(0xFF616161);
  static const Color neutral800 = Color(0xFF424242);
  static const Color neutral900 = Color(0xFF212121);

  // ─── Overlay Colors ──────────────────────────────────────────────
  static const Color overlayLight = Color(0x1A000000);
  static const Color overlayMedium = Color(0x4D000000);
  static const Color overlayDark = Color(0x80000000);
  static const Color overlayWhite = Color(0x80FFFFFF);

  // ─── Divider Colors ──────────────────────────────────────────────
  static const Color dividerLight = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF2C2C4A);

  // ─── Shadow Colors ───────────────────────────────────────────────
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowGold = Color(0x33B8860B);

  // ─── Gradients ───────────────────────────────────────────────────
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFB8860B), Color(0xFFDAA520)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient goldVerticalGradient = LinearGradient(
    colors: [Color(0xFFDAA520), Color(0xFFB8860B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient goldShimmerGradient = LinearGradient(
    colors: [Color(0xFFB8860B), Color(0xFFFFD700), Color(0xFFB8860B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient maroonGradient = LinearGradient(
    colors: [Color(0xFF800020), Color(0xFFA3244A)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient warmBackgroundGradient = LinearGradient(
    colors: [Color(0xFFFFF8F0), Color(0xFFFFF3E0)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient heroCardGradient = LinearGradient(
    colors: [Color(0xFFB8860B), Color(0xFFDAA520), Color(0xFFB8860B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const RadialGradient goldRadialGradient = RadialGradient(
    colors: [Color(0xFFDAA520), Color(0xFFB8860B)],
    center: Alignment.center,
    radius: 0.8,
  );
}
