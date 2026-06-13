import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wedding_cards/src/core/constants/api_constants.dart';
import 'package:wedding_cards/src/core/constants/app_constants.dart';
import 'package:wedding_cards/src/core/network/api_exception.dart';
import 'package:wedding_cards/src/features/auth/data/auth_repository.dart';
import 'package:wedding_cards/src/features/auth/domain/user_model.dart';

class _MockDio extends Mock implements Dio {}
class _MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late _MockDio dio;
  late _MockSecureStorage storage;
  late AuthRepository repo;

  setUp(() {
    dio = _MockDio();
    storage = _MockSecureStorage();
    repo = AuthRepository(dio, storage);
  });

  group('register', () {
    test('sends correct payload and returns user', () async {
      const email = 'test@example.com';
      const password = 'password123';
      const name = 'Test User';
      const token = 'jwt-token-456';

      final user = User(
        id: 'user-123',
        email: email,
        displayName: name,
      );

      when(() => dio.post(
        ApiConstants.register,
        data: {
          'email': email,
          'password': password,
          'displayName': name,
        },
      )).thenAnswer((_) async => Response(
        data: {
          'data': {
            'user': user.toJson(),
            'token': token,
          }
        },
        requestOptions: RequestOptions(path: ApiConstants.register),
      ));

      when(() => storage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      )).thenAnswer((_) async {});

      final result = await repo.register(email, password, name);

      expect(result.id, user.id);
      expect(result.email, user.email);
      expect(result.displayName, user.displayName);

      verify(() => dio.post(
        ApiConstants.register,
        data: {
          'email': email,
          'password': password,
          'displayName': name,
        },
      )).called(1);

      verify(() => storage.write(
        key: AppConstants.tokenKey,
        value: token,
      )).called(1);
    });

    test('throws ApiException on DioException', () async {
      when(() => dio.post(
        any(that: endsWith('register')),
        data: any(that: isA<Map<String, dynamic>>()),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/register'),
        type: DioExceptionType.connectionError,
      ));

      when(() => storage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      )).thenAnswer((_) async {});

      expect(
        () => repo.register('test@example.com', 'password', 'Test'),
        throwsA(isA<ApiException>()),
      );
    });

    test('throws friendly message on Railway 404', () async {
      when(() => dio.post(
        any(that: endsWith('register')),
        data: any(that: isA<Map<String, dynamic>>()),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ApiConstants.register),
        response: Response(
          data: {
            'success': false,
            'error': {'message': 'Application not found'},
            'status': 'error'
          },
          requestOptions: RequestOptions(path: ApiConstants.register),
          statusCode: 404,
        ),
        type: DioExceptionType.badResponse,
      ));

      when(() => storage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      )).thenAnswer((_) async {});

      expect(
        () => repo.register('test@example.com', 'password', 'Test'),
        throwsA(predicate<ApiException>((e) =>
          e.errorType == ApiErrorType.unknown &&
          e.message.contains('Wedding Cards API is currently down')
        )),
      );
    });
  });

  group('login', () {
    test('sends credentials and returns user', () async {
      const email = 'user@example.com';
      const password = 'password';
      const token = 'login-token-123';

      final user = User(
        id: 'user-456',
        email: email,
        displayName: 'User One',
      );

      when(() => dio.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      )).thenAnswer((_) async => Response(
        data: {
          'data': {
            'user': user.toJson(),
            'token': token,
          }
        },
        requestOptions: RequestOptions(path: ApiConstants.login),
      ));

      when(() => storage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      )).thenAnswer((_) async {});

      final result = await repo.login(email, password);

      expect(result, user);
      verify(() => storage.write(
        key: AppConstants.tokenKey,
        value: token,
      )).called(1);
    });

    test('throws unauthorized on 401', () async {
      when(() => dio.post(
        ApiConstants.login,
        data: any(named: 'data'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ApiConstants.login),
        response: Response(
          data: {'error': {'message': 'Invalid credentials'}},
          requestOptions: RequestOptions(path: ApiConstants.login),
          statusCode: 401,
        ),
        type: DioExceptionType.badResponse,
      ));

      when(() => storage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      )).thenAnswer((_) async {});

      expect(
        () => repo.login('user@example.com', 'wrong'),
        throwsA(predicate<ApiException>((e) => e.errorType == ApiErrorType.unauthorized)),
      );
    });
  });

  group('getCurrentUser', () {
    test('returns null when no token', () async {
      when(() => storage.read(key: AppConstants.tokenKey))
          .thenAnswer((_) async => null);

      final user = await repo.getCurrentUser();

      expect(user, null);
    });

    test('fetches and returns user with token', () async {
      const token = 'existing-token-789';
      const userId = 'user-abc';
      const userEmail = 'logged@example.com';
      const userName = 'Logged User';

      when(() => storage.read(key: AppConstants.tokenKey))
          .thenAnswer((_) async => token);

      final userJson = {
        '_id': userId,
        'email': userEmail,
        'displayName': userName,
      };

      when(() => dio.get(ApiConstants.currentUser)).thenAnswer((_) async => Response(
        data: {'data': {'user': userJson}},
        requestOptions: RequestOptions(path: ApiConstants.currentUser),
      ));

      when(() => storage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      )).thenAnswer((_) async {});

      final user = await repo.getCurrentUser();

      expect(user?.id, userId);
      expect(user?.email, userEmail);
      expect(user?.displayName, userName);

      verify(() => storage.write(
        key: AppConstants.userKey,
        value: jsonEncode(userJson),
      )).called(1);
    });

    test('returns null on 401', () async {
      const token = 'expired-token';

      when(() => storage.read(key: AppConstants.tokenKey))
          .thenAnswer((_) async => token);

      when(() => dio.get(ApiConstants.currentUser)).thenThrow(DioException(
        requestOptions: RequestOptions(path: ApiConstants.currentUser),
        response: Response(
          requestOptions: RequestOptions(path: ApiConstants.currentUser),
          statusCode: 401,
        ),
        type: DioExceptionType.badResponse,
      ));

      when(() => storage.delete(key: any(named: 'key'))).thenAnswer((_) async {});

      final user = await repo.getCurrentUser();

      expect(user, null);
    });

    test('throws on non-401 server error', () async {
      const token = 'valid-token';

      when(() => storage.read(key: AppConstants.tokenKey))
          .thenAnswer((_) async => token);

      when(() => dio.get(ApiConstants.currentUser)).thenThrow(DioException(
        requestOptions: RequestOptions(path: ApiConstants.currentUser),
        response: Response(
          data: {'error': {'message': 'Server down'}},
          requestOptions: RequestOptions(path: ApiConstants.currentUser),
          statusCode: 500,
        ),
        type: DioExceptionType.badResponse,
      ));

      when(() => storage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      )).thenAnswer((_) async {});

      expect(
        () => repo.getCurrentUser(),
        throwsA(isA<ApiException>()),
      );
    });
  });
}