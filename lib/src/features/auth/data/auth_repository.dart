import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../domain/user_model.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  AuthRepository(this._dio, this._storage);

  final Dio _dio;
  final FlutterSecureStorage _storage;
  final _authStateController = StreamController<User?>.broadcast();

  Future<User> register(String email, String password, String name) async {
    try {
      final response = await _dio.post(
        ApiConstants.register,
        data: {
          'email': email,
          'password': password,
          'displayName': name,
        },
      );
      return await _handleAuthResponse(response.data);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<User> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );
      return await _handleAuthResponse(response.data);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<void> logout() async {
    await _clearSession();
    _authStateController.add(null);
  }

  Future<User?> getCurrentUser() async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      return null;
    }

    try {
      final response = await _dio.get(ApiConstants.currentUser);
      final user = _parseUser(response.data);
      await _persistUser(user);
      _authStateController.add(user);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return null;
      }
      throw _mapDioError(e);
    }
  }

  Future<String?> getToken() => _storage.read(key: AppConstants.tokenKey);

  Stream<User?> get authStateChanges => _authStateController.stream;

  Future<User> _handleAuthResponse(dynamic data) async {
    final user = _parseUser(data);
    final token = data['data']['token'] as String;
    await _persistSession(user, token);
    _authStateController.add(user);
    return user;
  }

  User _parseUser(dynamic data) {
    final userJson = data['data']['user'] as Map<String, dynamic>;
    return User.fromJson(userJson);
  }

  Future<void> _persistSession(User user, String token) async {
    await _storage.write(key: AppConstants.tokenKey, value: token);
    await _persistUser(user);
  }

  Future<void> _persistUser(User user) async {
    await _storage.write(
      key: AppConstants.userKey,
      value: jsonEncode(user.toJson()),
    );
  }

  Future<void> _clearSession() async {
    await _storage.delete(key: AppConstants.tokenKey);
    await _storage.delete(key: AppConstants.refreshTokenKey);
    await _storage.delete(key: AppConstants.userKey);
  }

  ApiException _mapDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;
    String? message;

    // Extract Railway's "Application not found" message for 404s
    if (data is Map<String, dynamic>) {
      if (data.containsKey('message') && data['message'] == 'Application not found') {
        return ApiException.unknown(
          'Wedding Cards API is currently down. This usually means:\n'
          '• The Railway deployment failed (check dashboard logs)\n'
          '• The backend needs redeployment\n'
          '• Railway environment variables missing (MONGODB_URI, etc)',
        );
      }

      final error = data['error'];
      if (error is Map<String, dynamic>) {
        message = error['message'] as String?;
      }
    }

    // Railway's deployment failure response
    if (statusCode == 404 && data is Map<String, dynamic> && data['status'] == 'error') {
      return ApiException.unknown(
        'Wedding Cards API is unavailable.\n'
        'Status: ${data['code']}\n'
        'Reason: ${data['message'] ?? 'Unknown'}\n'
        'Check Railway dashboard at railway.app for deployment status.',
      );
    }

    if (statusCode != null) {
      return ApiException.fromStatusCode(statusCode, message);
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException.timeout(
          message ?? 'The server took too long to respond. Check if the backend is running at railway.app.',
        );
      case DioExceptionType.connectionError:
        return ApiException.network(
          message ?? 'Could not connect to the Wedding Cards API.\n'
          'The backend might be down or the URL is incorrect.',
        );
      case DioExceptionType.cancel:
        return ApiException.cancelled(message);
      default:
        return ApiException.unknown(
          message ?? e.message ?? 'An unexpected error occurred while connecting to the API.',
        );
    }
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(
    ref.watch(dioProvider),
    ref.watch(secureStorageProvider),
  );
}
