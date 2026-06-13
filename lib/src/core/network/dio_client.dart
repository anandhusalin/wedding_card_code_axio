import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/api_constants.dart';
import '../constants/app_constants.dart';
import 'api_interceptors.dart';

part 'dio_client.g.dart';

/// Provider for FlutterSecureStorage instance.
@riverpod
FlutterSecureStorage secureStorage(Ref ref) {
  const androidOptions = AndroidOptions(encryptedSharedPreferences: true);
  const iOSOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock_this_device,
  );
  return const FlutterSecureStorage(
    aOptions: androidOptions,
    iOptions: iOSOptions,
  );
}

/// Provider for the configured Dio HTTP client instance.
/// Includes JWT auth interceptor, logging interceptor (debug only),
/// appropriate timeouts, and JSON content type.
@riverpod
Dio dio(Ref ref) {
  final storage = ref.watch(secureStorageProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.resolvedBaseUrl,
      connectTimeout:
          const Duration(milliseconds: ApiConstants.connectionTimeoutMs),
      receiveTimeout:
          const Duration(milliseconds: ApiConstants.receiveTimeoutMs),
      sendTimeout:
          const Duration(milliseconds: ApiConstants.sendTimeoutMs),
      contentType: ApiConstants.contentTypeJson,
      responseType: ResponseType.json,
      headers: {
        'Accept': ApiConstants.contentTypeJson,
      },
    ),
  );

  // Add auth interceptor with auto-logout on 401
  dio.interceptors.add(
    AuthInterceptor(
      secureStorage: storage,
      onUnauthorized: () {
        // The interceptor can't await inside Dio's error chain. We use a
        // microtask so the storage clear (which is async) is queued up
        // before the auth controller's logout() runs. The router's
        // refreshListenable (wired in app_router.dart) then picks up the
        // auth state change and redirects to /login.
        Future.microtask(() async {
          try {
            await storage.delete(key: AppConstants.tokenKey);
            await storage.delete(key: AppConstants.refreshTokenKey);
            await storage.delete(key: AppConstants.userKey);
          } catch (_) {
            // Storage already cleared or unavailable — ignore.
          }
        });
      },
    ),
  );

  // Add logging interceptor only in debug mode
  if (kDebugMode) {
    dio.interceptors.add(AppLogInterceptor());
  }

  return dio;
}
