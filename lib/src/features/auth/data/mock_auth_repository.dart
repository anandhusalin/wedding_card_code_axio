import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../domain/user_model.dart';
import 'auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  final AuthRepositoryRef ref;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final _authStateController = StreamController<User?>.broadcast();
  
  static const _tokenKey = 'jwt_token';

  MockAuthRepository(this.ref) {
    _init();
  }

  Future<void> _init() async {
    try {
      final user = await getCurrentUser();
      _authStateController.add(user);
    } catch (_) {
      _authStateController.add(null);
    }
  }

  @override
  Stream<User?> get authStateChanges => _authStateController.stream;

  @override
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  @override
  Future<User> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (password.length < 6) throw Exception('Password too short');
    final token = 'mock_jwt_token_123';
    await _storage.write(key: _tokenKey, value: token);
    final user = User(
      id: 'usr_123',
      email: email,
      displayName: 'Mock User',
      plan: 'free',
      isActive: true,
      createdAt: DateTime.now(),
    );
    _authStateController.add(user);
    return user;
  }

  @override
  Future<User> register(String email, String password, String name) async {
    await Future.delayed(const Duration(seconds: 1));
    final token = 'mock_jwt_token_123';
    await _storage.write(key: _tokenKey, value: token);
    final user = User(
      id: 'usr_123',
      email: email,
      displayName: name,
      plan: 'free',
      isActive: true,
      createdAt: DateTime.now(),
    );
    _authStateController.add(user);
    return user;
  }

  @override
  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    _authStateController.add(null);
  }

  @override
  Future<User?> getCurrentUser() async {
    final token = await getToken();
    if (token == null) return null;
    await Future.delayed(const Duration(milliseconds: 500));
    return User(
      id: 'usr_123',
      email: 'anandhu@gmail.com',
      displayName: 'Mock User',
      plan: 'free',
      isActive: true,
      createdAt: DateTime.now(),
    );
  }
}
