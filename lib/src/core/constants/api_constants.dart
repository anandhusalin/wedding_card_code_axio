/// API endpoint constants for the Wedding Cards backend.
/// The base URL defaults to the Android emulator's localhost alias.
class ApiConstants {
  ApiConstants._();

  // ─── Base URL ────────────────────────────────────────────────────
  /// Default base URL for the Android emulator.
  /// Override via environment variable or build config for other platforms.
  static const String defaultBaseUrl = 'http://10.0.2.2:3000';

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
  static const int sendTimeoutMs = 60000;

  // ─── Headers ─────────────────────────────────────────────────────
  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer';
  static const String contentTypeJson = 'application/json';
  static const String contentTypeMultipart = 'multipart/form-data';
}
