import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wedding_cards/src/core/constants/api_constants.dart';
import 'package:wedding_cards/src/core/constants/app_constants.dart';
import 'package:wedding_cards/src/core/network/api_interceptors.dart';

class _MockSecureStorage extends Mock implements FlutterSecureStorage {}

class _MockDio extends Mock implements Dio {}

class _MockErrorHandler extends Mock implements ErrorInterceptorHandler {}

class _MockRequestHandler extends Mock implements RequestInterceptorHandler {}

class _FakeRequestOptions extends Fake implements RequestOptions {}

class _FakeDioException extends Fake implements DioException {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeRequestOptions());
    registerFallbackValue(_FakeDioException());
    registerFallbackValue(RequestOptions(path: '/test'));
  });

  group('AuthInterceptor', () {
    late _MockSecureStorage storage;
    late _MockDio mockDio;
    late AuthInterceptor interceptor;
    late _MockRequestHandler requestHandler;
    late _MockErrorHandler errorHandler;

    const testBaseUrl = 'https://api.example.com';

    setUp(() {
      storage = _MockSecureStorage();
      mockDio = _MockDio();
      requestHandler = _MockRequestHandler();
      errorHandler = _MockErrorHandler();
    });

    test('attaches Authorization header when token exists', () async {
      const token = 'fake-jwt-token-12345';
      when(() => storage.read(key: AppConstants.tokenKey))
          .thenAnswer((_) async => token);
      when(() => requestHandler.next(any())).thenAnswer((_) async {});

      final options = RequestOptions(path: '/test');
      interceptor = AuthInterceptor(
        secureStorage: storage,
        dio: mockDio,
        baseUrl: testBaseUrl,
      );

      interceptor.onRequest(options, requestHandler);
      await Future<void>.delayed(Duration.zero);

      expect(
        options.headers[ApiConstants.authorizationHeader],
        '${ApiConstants.bearerPrefix} $token',
      );
      verify(() => requestHandler.next(options)).called(1);
    });

    test('does not attach header when token is null', () async {
      when(() => storage.read(key: AppConstants.tokenKey))
          .thenAnswer((_) async => null);
      when(() => requestHandler.next(any())).thenAnswer((_) async {});

      final options = RequestOptions(path: '/test');
      interceptor = AuthInterceptor(
        secureStorage: storage,
        dio: mockDio,
        baseUrl: testBaseUrl,
      );

      interceptor.onRequest(options, requestHandler);
      await Future<void>.delayed(Duration.zero);

      expect(options.headers.containsKey(ApiConstants.authorizationHeader), false);
      verify(() => requestHandler.next(options)).called(1);
    });

    test('does not attach header when token is empty', () async {
      when(() => storage.read(key: AppConstants.tokenKey))
          .thenAnswer((_) async => '');
      when(() => requestHandler.next(any())).thenAnswer((_) async {});

      final options = RequestOptions(path: '/test');
      interceptor = AuthInterceptor(
        secureStorage: storage,
        dio: mockDio,
        baseUrl: testBaseUrl,
      );

      interceptor.onRequest(options, requestHandler);
      await Future<void>.delayed(Duration.zero);

      expect(options.headers.containsKey(ApiConstants.authorizationHeader), false);
      verify(() => requestHandler.next(options)).called(1);
    });

    test('storage read failure does not throw', () async {
      when(() => storage.read(key: AppConstants.tokenKey))
          .thenThrow(Exception('storage corrupted'));
      when(() => requestHandler.next(any())).thenAnswer((_) async {});

      final options = RequestOptions(path: '/test');
      interceptor = AuthInterceptor(
        secureStorage: storage,
        dio: mockDio,
        baseUrl: testBaseUrl,
      );

      // Should not throw
      interceptor.onRequest(options, requestHandler);
      await Future<void>.delayed(Duration.zero);

      expect(options.headers.containsKey(ApiConstants.authorizationHeader), false);
      verify(() => requestHandler.next(options)).called(1);
    });

    test('onError 401 clears all auth-related keys and fires callback', () async {
      when(() => storage.delete(key: AppConstants.tokenKey))
          .thenAnswer((_) async {});
      when(() => storage.delete(key: AppConstants.refreshTokenKey))
          .thenAnswer((_) async {});
      when(() => storage.delete(key: AppConstants.userKey))
          .thenAnswer((_) async {});

      var callbackFired = false;
      final interceptorWithCallback = AuthInterceptor(
        secureStorage: storage,
        dio: mockDio,
        baseUrl: testBaseUrl,
        onUnauthorized: () => callbackFired = true,
      );

      final err = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 401,
        ),
        type: DioExceptionType.badResponse,
      );

      // Mock the refresh to fail (no refresh token stored)
      when(() => storage.read(key: AppConstants.refreshTokenKey))
          .thenAnswer((_) async => null);

      interceptorWithCallback.onError(err, errorHandler);
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      verify(() => storage.delete(key: AppConstants.tokenKey)).called(1);
      verify(() => storage.delete(key: AppConstants.refreshTokenKey)).called(1);
      verify(() => storage.delete(key: AppConstants.userKey)).called(1);
      expect(callbackFired, true);
    });

    test('onError non-401 does NOT clear storage or fire callback', () async {
      final err = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 500,
        ),
        type: DioExceptionType.badResponse,
      );

      interceptor = AuthInterceptor(
        secureStorage: storage,
        dio: mockDio,
        baseUrl: testBaseUrl,
      );

      when(() => errorHandler.next(any())).thenAnswer((_) async {});
      interceptor.onError(err, errorHandler);
      await Future<void>.delayed(Duration.zero);

      verifyNever(() => storage.delete(key: AppConstants.tokenKey));
      verifyNever(() => storage.delete(key: AppConstants.refreshTokenKey));
      verifyNever(() => storage.delete(key: AppConstants.userKey));
    });

    test('onError 401 - storage delete failure does not throw', () async {
      // Mock refresh token exists but delete will fail
      when(() => storage.read(key: AppConstants.refreshTokenKey))
          .thenAnswer((_) async => 'some-token');
      when(() => storage.delete(key: AppConstants.tokenKey))
          .thenThrow(Exception('storage read-only'));
      when(() => storage.delete(key: AppConstants.refreshTokenKey))
          .thenThrow(Exception('storage read-only'));

      final err = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 401,
        ),
        type: DioExceptionType.badResponse,
      );

      interceptor = AuthInterceptor(
        secureStorage: storage,
        dio: mockDio,
        baseUrl: testBaseUrl,
      );

      // Should not throw even when storage delete fails
      // The refresh will fail (due to network) but delete failures are caught
      expect(
        () => interceptor.onError(err, errorHandler),
        returnsNormally,
      );
    });
  });
}
