import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wedding_cards/src/core/constants/api_constants.dart';
import 'package:wedding_cards/src/core/constants/app_constants.dart';
import 'package:wedding_cards/src/core/network/api_interceptors.dart';

class _MockSecureStorage extends Mock implements FlutterSecureStorage {}

class _MockErrorHandler extends Mock implements ErrorInterceptorHandler {}

class _MockRequestHandler extends Mock implements RequestInterceptorHandler {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeRequestOptions());
  });

  group('AuthInterceptor', () {
    late _MockSecureStorage storage;
    late AuthInterceptor interceptor;
    late _MockRequestHandler requestHandler;
    late _MockErrorHandler errorHandler;

    setUp(() {
      storage = _MockSecureStorage();
      interceptor = AuthInterceptor(secureStorage: storage);
      requestHandler = _MockRequestHandler();
      errorHandler = _MockErrorHandler();
    });

    test('attaches Authorization header when token exists', () async {
      const token = 'fake-jwt-token-12345';
      when(() => storage.read(key: AppConstants.tokenKey))
          .thenAnswer((_) async => token);

      final options = RequestOptions(path: '/test');
      interceptor.onRequest(options, requestHandler);

      // The interceptor modifies headers async before calling handler.next.
      // We need to wait for the read to complete.
      await Future<void>.delayed(Duration.zero);
      expect(
        options.headers[ApiConstants.authorizationHeader],
        '${ApiConstants.bearerPrefix} $token',
      );
    });

    test('does not attach header when token is null', () async {
      when(() => storage.read(key: AppConstants.tokenKey))
          .thenAnswer((_) async => null);

      final options = RequestOptions(path: '/test');
      interceptor.onRequest(options, requestHandler);
      await Future<void>.delayed(Duration.zero);
      expect(options.headers.containsKey(ApiConstants.authorizationHeader), false);
    });

    test('does not attach header when token is empty', () async {
      when(() => storage.read(key: AppConstants.tokenKey))
          .thenAnswer((_) async => '');

      final options = RequestOptions(path: '/test');
      interceptor.onRequest(options, requestHandler);
      await Future<void>.delayed(Duration.zero);
      expect(options.headers.containsKey(ApiConstants.authorizationHeader), false);
    });

    test('storage read failure does not throw', () async {
      when(() => storage.read(key: AppConstants.tokenKey))
          .thenThrow(Exception('storage corrupted'));

      final options = RequestOptions(path: '/test');
      interceptor.onRequest(options, requestHandler);
      await Future<void>.delayed(Duration.zero);
      expect(options.headers.containsKey(ApiConstants.authorizationHeader), false);
    });

    test('onError 401 clears all auth-related keys and fires callback', () async {
      when(() => storage.delete(key: any(named: 'key')))
          .thenAnswer((_) async {});

      var callbackFired = false;
      final interceptorWithCallback = AuthInterceptor(
        secureStorage: storage,
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
      var callbackFired = false;
      final interceptorWithCallback = AuthInterceptor(
        secureStorage: storage,
        onUnauthorized: () => callbackFired = true,
      );
      interceptorWithCallback.onError(err, errorHandler);
      await Future<void>.delayed(Duration.zero);

      verifyNever(() => storage.delete(key: any(named: 'key')));
      expect(callbackFired, false);
    });

    test('onError 401 - storage delete failure does not throw', () async {
      when(() => storage.delete(key: any(named: 'key')))
          .thenThrow(Exception('storage read-only'));

      final err = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 401,
        ),
        type: DioExceptionType.badResponse,
      );
      // Should not throw
      interceptor.onError(err, errorHandler);
      await Future<void>.delayed(Duration.zero);
    });
  });
}

class _FakeRequestOptions extends Fake implements RequestOptions {}
