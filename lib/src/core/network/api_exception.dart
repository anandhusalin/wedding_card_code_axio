/// Types of API errors that can occur during network requests.
enum ApiErrorType {
  /// No internet connection or DNS failure.
  network,

  /// Request timed out.
  timeout,

  /// Authentication failed or token expired (HTTP 401).
  unauthorized,

  /// Forbidden access (HTTP 403).
  forbidden,

  /// Resource not found (HTTP 404).
  notFound,

  /// Validation error (HTTP 422).
  validation,

  /// Server-side error (HTTP 5xx).
  serverError,

  /// Request was cancelled.
  cancelled,

  /// Bad request (HTTP 400).
  badRequest,

  /// Rate limited (HTTP 429).
  rateLimited,

  /// Unknown or unhandled error.
  unknown,
}

/// Custom exception class for API errors.
/// Provides structured error information for proper error handling and display.
class ApiException implements Exception {
  const ApiException({
    required this.message,
    this.statusCode,
    this.errorType = ApiErrorType.unknown,
    this.errors,
    this.stackTrace,
  });

  /// Human-readable error message.
  final String message;

  /// HTTP status code, if available.
  final int? statusCode;

  /// Categorized error type for programmatic handling.
  final ApiErrorType errorType;

  /// Field-level validation errors, if any.
  final Map<String, List<String>>? errors;

  /// Original stack trace for debugging.
  final StackTrace? stackTrace;

  /// Factory constructors for common error types.

  factory ApiException.network([String? message]) {
    return ApiException(
      message: message ?? 'No internet connection. Please check your network.',
      errorType: ApiErrorType.network,
    );
  }

  factory ApiException.timeout([String? message]) {
    return ApiException(
      message:
          message ?? 'Request timed out. Please try again.',
      errorType: ApiErrorType.timeout,
    );
  }

  factory ApiException.unauthorized([String? message]) {
    return ApiException(
      message: message ?? 'Session expired. Please login again.',
      statusCode: 401,
      errorType: ApiErrorType.unauthorized,
    );
  }

  factory ApiException.forbidden([String? message]) {
    return ApiException(
      message:
          message ?? 'You do not have permission to perform this action.',
      statusCode: 403,
      errorType: ApiErrorType.forbidden,
    );
  }

  factory ApiException.notFound([String? message]) {
    return ApiException(
      message: message ?? 'The requested resource was not found.',
      statusCode: 404,
      errorType: ApiErrorType.notFound,
    );
  }

  factory ApiException.validation({
    String? message,
    Map<String, List<String>>? errors,
  }) {
    return ApiException(
      message: message ?? 'Please check your input and try again.',
      statusCode: 422,
      errorType: ApiErrorType.validation,
      errors: errors,
    );
  }

  factory ApiException.serverError([String? message]) {
    return ApiException(
      message: message ??
          'Something went wrong on our end. Please try again later.',
      statusCode: 500,
      errorType: ApiErrorType.serverError,
    );
  }

  factory ApiException.cancelled([String? message]) {
    return ApiException(
      message: message ?? 'Request was cancelled.',
      errorType: ApiErrorType.cancelled,
    );
  }

  factory ApiException.badRequest([String? message]) {
    return ApiException(
      message: message ?? 'Invalid request. Please try again.',
      statusCode: 400,
      errorType: ApiErrorType.badRequest,
    );
  }

  factory ApiException.rateLimited([String? message]) {
    return ApiException(
      message:
          message ?? 'Too many requests. Please wait a moment and try again.',
      statusCode: 429,
      errorType: ApiErrorType.rateLimited,
    );
  }

  factory ApiException.unknown([String? message]) {
    return ApiException(
      message: message ?? 'An unexpected error occurred. Please try again.',
      errorType: ApiErrorType.unknown,
    );
  }

  /// Creates an ApiException from an HTTP status code.
  factory ApiException.fromStatusCode(int statusCode, [String? message]) {
    switch (statusCode) {
      case 400:
        return ApiException.badRequest(message);
      case 401:
        return ApiException.unauthorized(message);
      case 403:
        return ApiException.forbidden(message);
      case 404:
        return ApiException.notFound(message);
      case 422:
        return ApiException.validation(message: message);
      case 429:
        return ApiException.rateLimited(message);
      default:
        if (statusCode >= 500) {
          return ApiException.serverError(message);
        }
        return ApiException.unknown(message);
    }
  }

  @override
  String toString() =>
      'ApiException(type: $errorType, status: $statusCode, message: $message)';
}
