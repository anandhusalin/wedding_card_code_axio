import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/api_constants.dart';
import '../constants/app_constants.dart';

/// Dio interceptor that handles JWT authentication.
/// Automatically attaches the Bearer token to every outgoing request
/// and handles 401 responses by clearing stored credentials.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.secureStorage, this.onUnauthorized});

  final FlutterSecureStorage secureStorage;

  /// Callback invoked when a 401 response is received.
  /// Typically used to redirect the user to the login screen.
  final VoidCallback? onUnauthorized;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await secureStorage.read(key: AppConstants.tokenKey);
      if (token != null && token.isNotEmpty) {
        options.headers[ApiConstants.authorizationHeader] =
            '${ApiConstants.bearerPrefix} $token';
      }
    } catch (e) {
      debugPrint('AuthInterceptor: Failed to read token - $e');
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      debugPrint('AuthInterceptor: Received 401 – clearing stored token');
      try {
        await secureStorage.delete(key: AppConstants.tokenKey);
        await secureStorage.delete(key: AppConstants.refreshTokenKey);
        await secureStorage.delete(key: AppConstants.userKey);
      } catch (e) {
        debugPrint('AuthInterceptor: Failed to clear token - $e');
      }
      onUnauthorized?.call();
    }
    handler.next(err);
  }
}

/// Dio interceptor for logging network requests and responses.
/// Only active in debug mode to avoid leaking data in production.
class AppLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌──────────────────────────────────────────');
      debugPrint('│ REQUEST: ${options.method} ${options.uri}');
      debugPrint('│ Headers: ${options.headers}');
      if (options.data != null) {
        debugPrint('│ Body: ${options.data}');
      }
      if (options.queryParameters.isNotEmpty) {
        debugPrint('│ Query: ${options.queryParameters}');
      }
      debugPrint('└──────────────────────────────────────────');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌──────────────────────────────────────────');
      debugPrint(
          '│ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
      debugPrint('│ Data: ${response.data}');
      debugPrint('└──────────────────────────────────────────');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌──────────────────────────────────────────');
      debugPrint('│ ERROR: ${err.type} ${err.requestOptions.uri}');
      debugPrint('│ Message: ${err.message}');
      if (err.response != null) {
        debugPrint('│ Status: ${err.response?.statusCode}');
        debugPrint('│ Data: ${err.response?.data}');
      }
      debugPrint('└──────────────────────────────────────────');
    }
    handler.next(err);
  }
}
