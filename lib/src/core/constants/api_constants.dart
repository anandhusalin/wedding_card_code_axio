/// API endpoint constants for the Wedding Cards backend.
/// The base URL defaults to the Android emulator's localhost alias.
class ApiConstants {
  ApiConstants._();

  // ─── Base URLs ───────────────────────────────────────────────────
  // The backend is hosted on Railway and serves BOTH the JSON API and the
  // public wedding pages (EJS at /:slug). Override at runtime with
  // --dart-define=API_BASE_URL=https://your.host if you redeploy.
  static const String defaultBaseUrl =
      'https://wedding-cards-api-production.up.railway.app';

  /// Base URL for human-visible public wedding pages. Same host as the API
  /// (Express renders EJS at /:slug) but kept as a separate constant in
  /// case the public site is later moved to a CDN/edge frontend.
  static const String publicBaseUrl = defaultBaseUrl;

  /// Localhost base URL for Android emulator (10.0.2.2 maps to host's localhost).
  static const String localhostBaseUrl = 'http://10.0.2.2:3000';

  /// Set to true to bypass the deployed URL and use a local backend.
  /// Run `cd backend && npm start` in a separate terminal to host locally.
  /// True for local-only dev (10.0.2.2 from the Android emulator).
  static const bool kIsLocalApi = true;

  /// Resolved base URL for the JSON API based on the kIsLocalApi toggle.
  /// Can be overridden at build time with --dart-define=API_BASE_URL=...
  static String get resolvedBaseUrl {
    const override = String.fromEnvironment('API_BASE_URL');
    if (override.isNotEmpty) return override;
    return kIsLocalApi ? localhostBaseUrl : defaultBaseUrl;
  }

  /// Resolved base URL for public-facing wedding pages. Can be overridden
  /// independently with --dart-define=PUBLIC_BASE_URL=...
  static String get resolvedPublicBaseUrl {
    const override = String.fromEnvironment('PUBLIC_BASE_URL');
    if (override.isNotEmpty) return override;
    return kIsLocalApi ? localhostBaseUrl : publicBaseUrl;
  }

  /// Full public URL for a single wedding (what guests open in a browser).
  static String publicWeddingUrl(String slug) =>
      '$resolvedPublicBaseUrl/$slug';

  /// API version prefix for all endpoints.
  static const String apiPrefix = '/api/v1';

  // ─── Auth Endpoints ──────────────────────────────────────────────
  static const String authBase = '$apiPrefix/auth';
  static const String login = '$authBase/login';
  static const String register = '$authBase/register';
  static const String logout = '$authBase/logout';
  static const String currentUser = '$authBase/me';
  static const String refreshToken = '$authBase/refresh';
  static const String forgotPassword = '$authBase/forgot-password';
  static const String resetPassword = '$authBase/reset-password';

  // ─── Wedding Endpoints ───────────────────────────────────────────
  static const String weddingsBase = '$apiPrefix/weddings';

  static String weddingById(String id) => '$weddingsBase/$id';
  static String weddingPublish(String id) => '$weddingsBase/$id/publish';
  static String weddingUnpublish(String id) => '$weddingsBase/$id/unpublish';
  static String weddingDuplicate(String id) => '$weddingsBase/$id/duplicate';
  static String weddingPreview(String id) => '$weddingsBase/$id/preview';
  static String weddingStats(String id) => '$weddingsBase/$id/stats';

  // ─── Template Endpoints ──────────────────────────────────────────
  static const String templatesBase = '$apiPrefix/templates';

  static String templateById(String id) => '$templatesBase/$id';

  // ─── RSVP Endpoints ─────────────────────────────────────────────
  static const String rsvpBase = '$apiPrefix/rsvp';

  static String rsvpByWedding(String weddingId) =>
      '$weddingsBase/$weddingId/rsvp';
  static String rsvpById(String id) => '$rsvpBase/$id';
  static String rsvpRespond(String weddingId) =>
      '$weddingsBase/$weddingId/rsvp/respond';
  static String rsvpExport(String weddingId) =>
      '$weddingsBase/$weddingId/rsvp/export';

  // ─── Gallery / Upload Endpoints ─────────────────────────────────
  static const String uploadBase = '$apiPrefix/upload';
  static const String uploadImage = '$uploadBase/image';
  static const String uploadMultiple = '$uploadBase/multiple';

  static String galleryByWedding(String weddingId) =>
      '$weddingsBase/$weddingId/gallery';
  static String galleryImageDelete(String weddingId, String imageId) =>
      '$weddingsBase/$weddingId/gallery/$imageId';

  // ─── Venue Endpoints ─────────────────────────────────────────────
  static String venueByWedding(String weddingId) =>
      '$weddingsBase/$weddingId/venue';

  // ─── Timeouts ────────────────────────────────────────────────────
  static const int connectionTimeoutMs = 30000;
  static const int receiveTimeoutMs = 30000;
  static const int sendTimeoutMs = 30000;

  // ─── Headers ─────────────────────────────────────────────────────
  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer';
  static const String contentTypeJson = 'application/json';
  static const String contentTypeMultipart = 'multipart/form-data';
}
