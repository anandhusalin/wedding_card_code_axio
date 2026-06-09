/// Application-wide constants for the Wedding Cards app.
class AppConstants {
  AppConstants._();

  // ─── App Info ────────────────────────────────────────────────────
  static const String appName = 'Wedding Cards';
  static const String appTagline = 'Create Beautiful Wedding Websites';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // ─── Storage Keys ────────────────────────────────────────────────
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'app_language';
  static const String onboardingKey = 'onboarding_complete';

  // ─── Template IDs ────────────────────────────────────────────────
  static const String templateTraditionalKerala = 'tmpl_traditional_kerala';
  static const String templateModernElegant = 'tmpl_modern_elegant';
  static const String templateFloralDreams = 'tmpl_floral_dreams';
  static const String templateRoyalGold = 'tmpl_royal_gold';
  static const String templateMinimalist = 'tmpl_minimalist';
  static const String templateRusticCharm = 'tmpl_rustic_charm';

  static const List<String> allTemplateIds = [
    templateTraditionalKerala,
    templateModernElegant,
    templateFloralDreams,
    templateRoyalGold,
    templateMinimalist,
    templateRusticCharm,
  ];

  static const Map<String, String> templateNames = {
    templateTraditionalKerala: 'Traditional Kerala',
    templateModernElegant: 'Modern Elegant',
    templateFloralDreams: 'Floral Dreams',
    templateRoyalGold: 'Royal Gold',
    templateMinimalist: 'Minimalist',
    templateRusticCharm: 'Rustic Charm',
  };

  // ─── Upload Limits ──────────────────────────────────────────────
  /// Maximum image file size: 10 MB
  static const int maxImageSizeBytes = 10 * 1024 * 1024;

  /// Maximum number of gallery images per wedding
  static const int maxGalleryImages = 50;

  /// Maximum avatar file size: 5 MB
  static const int maxAvatarSizeBytes = 5 * 1024 * 1024;

  /// Thumbnail max dimension
  static const int thumbnailMaxDimension = 400;

  // ─── Supported Image Formats ─────────────────────────────────────
  static const List<String> supportedImageFormats = [
    'jpg',
    'jpeg',
    'png',
    'webp',
    'heic',
    'heif',
  ];

  static const List<String> supportedImageMimeTypes = [
    'image/jpeg',
    'image/png',
    'image/webp',
    'image/heic',
    'image/heif',
  ];

  // ─── Pagination ──────────────────────────────────────────────────
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // ─── Animation Durations ─────────────────────────────────────────
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 350);
  static const Duration animationSlow = Duration(milliseconds: 500);
  static const Duration animationVerySlow = Duration(milliseconds: 800);

  // ─── Spacing ─────────────────────────────────────────────────────
  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 16.0;
  static const double spacingLG = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // ─── Border Radius ───────────────────────────────────────────────
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusRound = 100.0;

  // ─── Plan Limits ─────────────────────────────────────────────────
  static const int freeMaxWeddings = 1;
  static const int premiumMaxWeddings = 5;
  static const int proMaxWeddings = -1; // unlimited

  static const int freeMaxGalleryImages = 10;
  static const int premiumMaxGalleryImages = 50;
  static const int proMaxGalleryImages = -1; // unlimited
}

/// Supported languages in the Wedding Cards app.
enum AppLanguage {
  english('en', 'English', 'English'),
  malayalam('ml', 'മലയാളം', 'Malayalam');

  const AppLanguage(this.code, this.nativeName, this.englishName);

  final String code;
  final String nativeName;
  final String englishName;
}

/// User subscription plans.
enum UserPlan {
  free('free', 'Free'),
  premium('premium', 'Premium'),
  pro('pro', 'Pro');

  const UserPlan(this.value, this.displayName);

  final String value;
  final String displayName;

  static UserPlan fromString(String value) {
    return UserPlan.values.firstWhere(
      (plan) => plan.value == value.toLowerCase(),
      orElse: () => UserPlan.free,
    );
  }
}
