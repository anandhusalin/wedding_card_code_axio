import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/user_model.dart';
import 'mock_auth_repository.dart';

part 'auth_repository.g.dart';

abstract class AuthRepository {
  Future<User> register(String email, String password, String name);
  Future<User> login(String email, String password);
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<String?> getToken();
  Stream<User?> get authStateChanges;
}

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return MockAuthRepository(ref);
}
