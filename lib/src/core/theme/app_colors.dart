import 'package:flutter/material.dart';

/// Modern, premium color palette for the Wedding Cards app.
/// Built around a soft rose-plum duo with warm peach accents —
/// romantic without being dated, elegant without being heavy.
class AppColors {
  AppColors._();

  // ═══════════════════════════════════════════════════════════════════
  // BRAND COLORS
  // ═══════════════════════════════════════════════════════════════════

  // ─── Primary: Rose ────────────────────────────────────────────────
  static const Color primary = Color(0xFFE11D48);
  static const Color primaryLight = Color(0xFFF43F5E);
  static const Color primaryDark = Color(0xFFBE123C);
  static const Color primarySurface = Color(0xFFFFF1F2);
  static const Color primarySurfaceDark = Color(0xFF4C0519);

  // ─── Secondary: Plum ──────────────────────────────────────────────
  static const Color secondary = Color(0xFF7C3AED);
  static const Color secondaryLight = Color(0xFFA78BFA);
  static const Color secondaryDark = Color(0xFF5B21B6);
  static const Color secondarySurface = Color(0xFFF5F3FF);
  static const Color secondarySurfaceDark = Color(0xFF2E1065);

  // ─── Tertiary: Peach ──────────────────────────────────────────────
  static const Color tertiary = Color(0xFFFB923C);
  static const Color tertiaryLight = Color(0xFFFDBA74);
  static const Color tertiaryDark = Color(0xFFEA580C);
  static const Color tertiarySurface = Color(0xFFFFF7ED);
  static const Color tertiarySurfaceDark = Color(0xFF7C2D12);

  // ═══════════════════════════════════════════════════════════════════
  // NEUTRAL SCALE (Slate-based for a modern, calm feel)
  // ═══════════════════════════════════════════════════════════════════
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate900 = Color(0xFF0F172A);
  static const Color slate950 = Color(0xFF020617);

  // ═══════════════════════════════════════════════════════════════════
  // SEMANTIC COLORS
  // ═══════════════════════════════════════════════════════════════════
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF34D399);
  static const Color successDark = Color(0xFF047857);
  static const Color successSurface = Color(0xFFECFDF5);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningDark = Color(0xFFB45309);
  static const Color warningSurface = Color(0xFFFFFBEB);

  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFF60A5FA);
  static const Color infoDark = Color(0xFF1D4ED8);
  static const Color infoSurface = Color(0xFFEFF6FF);

  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFF87171);
  static const Color errorDark = Color(0xFFDC2626);
  static const Color errorSurface = Color(0xFFFEF2F2);
  static const Color onError = Color(0xFFFFFFFF);

  // ═══════════════════════════════════════════════════════════════════
  // SURFACES & BACKGROUNDS
  // ═══════════════════════════════════════════════════════════════════
  static const Color backgroundLight = Color(0xFFFAFAF9);
  static const Color backgroundDark = Color(0xFF0F172A);

  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E293B);

  static const Color surfaceVariantLight = Color(0xFFF1F5F9);
  static const Color surfaceVariantDark = Color(0xFF334155);

  static const Color surfaceElevatedLight = Color(0xFFFFFFFF);
  static const Color surfaceElevatedDark = Color(0xFF334155);

  // ═══════════════════════════════════════════════════════════════════
  // TEXT
  // ═══════════════════════════════════════════════════════════════════
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF475569);
  static const Color textTertiaryLight = Color(0xFF94A3B8);
  static const Color textDisabledLight = Color(0xFFCBD5E1);

  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFFCBD5E1);
  static const Color textTertiaryDark = Color(0xFF94A3B8);
  static const Color textDisabledDark = Color(0xFF475569);

  // Legacy aliases — keep so other files still compile during migration.
  static const Color textPrimary = textPrimaryLight;
  static const Color textSecondary = textSecondaryLight;
  static const Color textTertiary = textTertiaryLight;

  // ═══════════════════════════════════════════════════════════════════
  // OVERLAYS & SHADOWS
  // ═══════════════════════════════════════════════════════════════════
  static const Color overlayLight = Color(0x14000000);
  static const Color overlayMedium = Color(0x33000000);
  static const Color overlayDark = Color(0x66000000);
  static const Color overlayWhite = Color(0x80FFFFFF);

  static const Color shadowLight = Color(0x0F000000);
  static const Color shadowMedium = Color(0x1A000000);
  static const Color shadowDark = Color(0x33000000);

  static const Color dividerLight = Color(0xFFE2E8F0);
  static const Color dividerDark = Color(0xFF334155);

  // ═══════════════════════════════════════════════════════════════════
  // GRADIENTS — modern, soft, romantic
  // ═══════════════════════════════════════════════════════════════════

  /// Primary brand gradient: rose → plum
  static const LinearGradient brandGradient = LinearGradient(
    colors: [Color(0xFFE11D48), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Soft warm gradient for hero sections: peach → rose
  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFFFB923C), Color(0xFFE11D48)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Sunset gradient: peach → rose → plum
  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [Color(0xFFFDBA74), Color(0xFFF43F5E), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Cool gradient: sky → plum
  static const LinearGradient coolGradient = LinearGradient(
    colors: [Color(0xFF60A5FA), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Subtle background gradient for light theme
  static const LinearGradient lightBackgroundGradient = LinearGradient(
    colors: [Color(0xFFFAFAF9), Color(0xFFF1F5F9)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Subtle background gradient for dark theme
  static const LinearGradient darkBackgroundGradient = LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Subtle hero card gradient for light theme
  static const LinearGradient heroCardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Subtle hero card gradient for dark theme
  static const LinearGradient heroCardGradientDark = LinearGradient(
    colors: [Color(0xFF1E293B), Color(0xFF334155)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Success gradient: emerald → teal
  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Warning gradient: amber → orange
  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Info gradient: sky blue
  static const LinearGradient infoGradient = LinearGradient(
    colors: [Color(0xFF60A5FA), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Legacy aliases (used by older code we haven't migrated yet)
  static const LinearGradient goldGradient = brandGradient;
  static const LinearGradient goldVerticalGradient = LinearGradient(
    colors: [Color(0xFFE11D48), Color(0xFF7C3AED)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const LinearGradient goldShimmerGradient = sunsetGradient;
  static const LinearGradient maroonGradient = brandGradient;
  static const LinearGradient darkGradient = darkBackgroundGradient;
  static const LinearGradient warmBackgroundGradient = lightBackgroundGradient;
  static const RadialGradient goldRadialGradient = RadialGradient(
    colors: [Color(0xFFF43F5E), Color(0xFFE11D48)],
    center: Alignment.center,
    radius: 0.8,
  );
}
