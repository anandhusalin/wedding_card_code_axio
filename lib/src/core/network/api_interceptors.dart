import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/api_constants.dart';
import '../constants/app_constants.dart';

/// Dio interceptor that handles JWT authentication.
/// Automatically attaches the Bearer token to every outgoing request.
///
/// On a 401 response, attempts a single token refresh via the refresh token
/// endpoint before falling back to clearing stored credentials and calling
/// [onUnauthorized]. Concurrent 401s share a single refresh attempt so we
/// don't hammer the server with parallel refresh requests.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.secureStorage,
    required this.dio,
    required this.baseUrl,
    this.onUnauthorized,
  });

  final FlutterSecureStorage secureStorage;
  final Dio dio;
  final String baseUrl;

  /// Callback invoked when a 401 response is received and refresh also fails.
  /// Typically used to redirect the user to the login screen.
  final VoidCallback? onUnauthorized;

  /// Guards concurrent refresh attempts — only one in-flight at a time.
  bool _isRefreshing = false;

  /// Requests that arrived while a refresh was in progress, waiting to be
  /// retried with the new token.
  final List<_PendingRequest> _pendingRequests = [];

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
      debugPrint('AuthInterceptor: Received 401 – attempting token refresh');

      // If a refresh is already in flight, queue this request and return.
      // It will be retried once the refresh completes.
      if (_isRefreshing) {
        debugPrint(
          'AuthInterceptor: Refresh already in progress — queuing request',
        );
        _pendingRequests.add(
          _PendingRequest(
            requestOptions: err.requestOptions,
            errorHandler: handler,
          ),
        );
        return;
      }

      // First 401 triggers the refresh.
      _isRefreshing = true;

      try {
        final newToken = await _doRefresh();

        if (newToken != null) {
          debugPrint(
            'AuthInterceptor: Token refresh succeeded — retrying '
            '${_pendingRequests.length + 1} request(s)',
          );

          // Retry the original request that triggered this 401
          await _retryRequest(err.requestOptions, handler, newToken);

          // Retry all queued requests
          while (_pendingRequests.isNotEmpty) {
            final pending = _pendingRequests.removeAt(0);
            await _retryRequest(
              pending.requestOptions,
              pending.errorHandler,
              newToken,
            );
          }
          return;
        }
      } catch (e) {
        debugPrint('AuthInterceptor: Token refresh failed – $e');
      } finally {
        _isRefreshing = false;
      }

      // Refresh failed — reject all queued requests with 401 and clear tokens
      debugPrint(
        'AuthInterceptor: Token refresh failed — clearing stored token',
      );

      // Best-effort: even if delete fails, the redirect to login still happens.
      try {
        await secureStorage.delete(key: AppConstants.tokenKey);
        await secureStorage.delete(key: AppConstants.refreshTokenKey);
        await secureStorage.delete(key: AppConstants.userKey);
      } catch (_) {
        // Storage already cleared or unavailable — ignore.
      }

      // Reject the original request
      handler.reject(err);

      // Reject all queued requests
      while (_pendingRequests.isNotEmpty) {
        final pending = _pendingRequests.removeAt(0);
        pending.errorHandler.reject(
          DioException(
            requestOptions: pending.requestOptions,
            response: err.response,
            type: DioExceptionType.badResponse,
          ),
        );
      }

      onUnauthorized?.call();
      return;
    }

    handler.next(err);
  }

  /// Calls POST /auth/refresh with the stored refresh token.
  /// Returns the new access token, or null if refresh fails.
  Future<String?> _doRefresh() async {
    final storedRefreshToken =
        await secureStorage.read(key: AppConstants.refreshTokenKey);
    if (storedRefreshToken == null || storedRefreshToken.isEmpty) {
      return null;
    }

    try {
      // Use a separate Dio instance (no auth interceptor) to avoid recursion.
      final refreshDio = Dio(BaseOptions(
        baseUrl: baseUrl,
        contentType: ApiConstants.contentTypeJson,
      ));
      final response = await refreshDio.post(
        ApiConstants.refreshToken,
        data: {'refreshToken': storedRefreshToken},
      );
      final newToken = response.data['data']['token'] as String?;
      final newRefreshToken = response.data['data']['refreshToken'] as String?;

      if (newToken != null) {
        await secureStorage.write(key: AppConstants.tokenKey, value: newToken);
        if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
          await secureStorage.write(
            key: AppConstants.refreshTokenKey,
            value: newRefreshToken,
          );
        }
        return newToken;
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        await secureStorage.delete(key: AppConstants.tokenKey);
        await secureStorage.delete(key: AppConstants.refreshTokenKey);
        await secureStorage.delete(key: AppConstants.userKey);
      }
      return null;
    }
  }

  /// Re-executes the given request with a fresh access token.
  Future<void> _retryRequest(
    RequestOptions requestOptions,
    ErrorInterceptorHandler handler,
    String newToken,
  ) async {
    final headers = Map<String, dynamic>.from(requestOptions.headers);
    headers[ApiConstants.authorizationHeader] =
        '${ApiConstants.bearerPrefix} $newToken';

    final retryOptions = requestOptions.copyWith(
      headers: headers,
    );

    try {
      final response = await dio.request(
        retryOptions.path,
        data: retryOptions.data,
        queryParameters: retryOptions.queryParameters,
        options: Options(
          method: requestOptions.method,
          headers: headers,
          contentType: requestOptions.contentType,
          responseType: requestOptions.responseType,
        ),
      );
      handler.resolve(response);
    } catch (e) {
      handler.reject(
        e is DioException
            ? e
            : DioException(
                requestOptions: requestOptions,
                error: e,
              ),
      );
    }
  }
}

/// Holds a request that arrived while a token refresh was in progress.
class _PendingRequest {
  _PendingRequest({
    required this.requestOptions,
    required this.errorHandler,
  });

  final RequestOptions requestOptions;
  final ErrorInterceptorHandler errorHandler;
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
