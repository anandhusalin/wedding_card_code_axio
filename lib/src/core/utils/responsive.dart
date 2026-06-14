import 'package:flutter/material.dart';

/// Responsive design helpers for adapting layouts to any screen size.
///
/// Use [Responsive.value] to pick different values per breakpoint, or
/// [Responsive.isCompact] / [isMedium] / [isExpanded] for boolean checks.
///
/// Breakpoints follow Material 3 window size classes:
///   compact:   width < 600  (phones in portrait)
///   medium:    600 ≤ w < 840 (small tablets, phones in landscape)
///   expanded:  840 ≤ w < 1200 (tablets, small desktops)
///   large:     1200 ≤ w < 1600 (desktops)
///   extraLarge: w ≥ 1600 (large desktops)
class Responsive {
  Responsive._();

  /// The current screen's width.
  static double width(BuildContext context) => MediaQuery.sizeOf(context).width;

  /// The current screen's height.
  static double height(BuildContext context) => MediaQuery.sizeOf(context).height;

  /// Whether the screen is in a compact window class (phones).
  static bool isCompact(BuildContext context) => width(context) < 600;

  /// Whether the screen is in a medium window class (tablets).
  static bool isMedium(BuildContext context) {
    final w = width(context);
    return w >= 600 && w < 840;
  }

  /// Whether the screen is in an expanded window class (large tablets).
  static bool isExpanded(BuildContext context) {
    final w = width(context);
    return w >= 840 && w < 1200;
  }

  /// Whether the screen is large (desktop) or larger.
  static bool isLarge(BuildContext context) => width(context) >= 1200;

  /// The current window size class.
  static WindowSizeClass sizeClass(BuildContext context) {
    final w = width(context);
    if (w < 600) return WindowSizeClass.compact;
    if (w < 840) return WindowSizeClass.medium;
    if (w < 1200) return WindowSizeClass.expanded;
    if (w < 1600) return WindowSizeClass.large;
    return WindowSizeClass.extraLarge;
  }

  /// Picks a value based on screen width.
  ///
  /// [compact]  - used for phones (< 600)
  /// [medium]   - used for small tablets (600-839)
  /// [expanded] - used for large tablets (840-1199)
  /// [large]    - used for desktops (≥ 1200)
  ///
  /// Each argument is optional. If a value is omitted, the next-defined
  /// smaller value is used as a fallback (so a single value scales everywhere).
  static T value<T>(
    BuildContext context, {
    required T compact,
    T? medium,
    T? expanded,
    T? large,
  }) {
    final w = width(context);
    if (w >= 1200) return large ?? expanded ?? medium ?? compact;
    if (w >= 840) return expanded ?? medium ?? compact;
    if (w >= 600) return medium ?? compact;
    return compact;
  }

  /// Content max width — caps the body on large screens so it doesn't stretch.
  /// 600 for phones, up to 720 for tablets/desktops.
  static double contentMaxWidth(BuildContext context) {
    return value<double>(
      context,
      compact: double.infinity,
      medium: 720,
      expanded: 840,
      large: 1080,
    );
  }

  /// Horizontal padding for page content.
  static double pagePadding(BuildContext context) {
    return value<double>(
      context,
      compact: 20,
      medium: 32,
      expanded: 48,
      large: 64,
    );
  }

  /// Spacing between vertically-stacked elements.
  static double verticalGap(BuildContext context) {
    return value<double>(
      context,
      compact: 16,
      medium: 20,
      expanded: 24,
      large: 28,
    );
  }

  /// Number of grid columns for a card grid (e.g. weddings list).
  static int gridColumns(BuildContext context) {
    return value<int>(
      context,
      compact: 1,
      medium: 2,
      expanded: 3,
      large: 4,
    );
  }
}

enum WindowSizeClass {
  compact,
  medium,
  expanded,
  large,
  extraLarge,
}
