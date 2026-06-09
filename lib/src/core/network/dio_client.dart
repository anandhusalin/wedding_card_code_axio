import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/api_constants.dart';
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
      baseUrl: ApiConstants.defaultBaseUrl,
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

  // Add auth interceptor
  dio.interceptors.add(
    AuthInterceptor(secureStorage: storage),
  );

  // Add logging interceptor only in debug mode
  if (kDebugMode) {
    dio.interceptors.add(AppLogInterceptor());
  }

  return dio;
}
