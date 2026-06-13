import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_cards/src/core/network/api_exception.dart';

void main() {
  group('ApiException factory constructors', () {
    test('network() - default message', () {
      final e = ApiException.network();
      expect(e.errorType, ApiErrorType.network);
      expect(e.statusCode, null);
      expect(e.message, 'No internet connection. Please check your network.');
    });

    test('network() - custom message', () {
      const message = 'Custom network message';
      final e = ApiException.network(message);
      expect(e.message, message);
    });

    test('timeout() - default message', () {
      final e = ApiException.timeout();
      expect(e.errorType, ApiErrorType.timeout);
      expect(e.statusCode, null);
      expect(e.message, 'Request timed out. Please try again.');
    });

    test('timeout() - custom message', () {
      const message = 'Custom timeout message';
      final e = ApiException.timeout(message);
      expect(e.message, message);
    });

    test('unauthorized() - default message, sets status', () {
      final e = ApiException.unauthorized();
      expect(e.errorType, ApiErrorType.unauthorized);
      expect(e.statusCode, 401);
      expect(e.message, 'Session expired. Please login again.');
    });

    test('unauthorized() - custom message', () {
      const message = 'Your token has expired';
      final e = ApiException.unauthorized(message);
      expect(e.message, message);
    });

    test('forbidden() - default message, sets status', () {
      final e = ApiException.forbidden();
      expect(e.errorType, ApiErrorType.forbidden);
      expect(e.statusCode, 403);
    });

    test('notFound() - default message, sets status', () {
      final e = ApiException.notFound();
      expect(e.errorType, ApiErrorType.notFound);
      expect(e.statusCode, 404);
    });

    test('validation() - default', () {
      final e = ApiException.validation();
      expect(e.errorType, ApiErrorType.validation);
      expect(e.statusCode, 422);
    });

    test('validation() - with errors', () {
      final errors = {
        'email': ['invalid format'],
        'password': ['too short']
      };
      final e = ApiException.validation(errors: errors);
      expect(e.errors, errors);
    });

    test('serverError() - default message, sets status', () {
      final e = ApiException.serverError();
      expect(e.errorType, ApiErrorType.serverError);
      expect(e.statusCode, 500);
    });

    test('cancelled() - default message', () {
      final e = ApiException.cancelled();
      expect(e.errorType, ApiErrorType.cancelled);
      expect(e.statusCode, null);
    });

    test('badRequest() - default message, sets status', () {
      final e = ApiException.badRequest();
      expect(e.errorType, ApiErrorType.badRequest);
      expect(e.statusCode, 400);
    });

    test('rateLimited() - default message, sets status', () {
      final e = ApiException.rateLimited();
      expect(e.errorType, ApiErrorType.rateLimited);
      expect(e.statusCode, 429);
    });

    test('unknown() - default message', () {
      final e = ApiException.unknown();
      expect(e.errorType, ApiErrorType.unknown);
      expect(e.statusCode, null);
    });

    group('fromStatusCode()', () {
      test('400 → badRequest', () {
        final e = ApiException.fromStatusCode(400);
        expect(e.errorType, ApiErrorType.badRequest);
        expect(e.statusCode, 400);
      });

      test('401 → unauthorized', () {
        final e = ApiException.fromStatusCode(401);
        expect(e.errorType, ApiErrorType.unauthorized);
      });

      test('403 → forbidden', () {
        final e = ApiException.fromStatusCode(403);
        expect(e.errorType, ApiErrorType.forbidden);
      });

      test('404 → notFound', () {
        final e = ApiException.fromStatusCode(404);
        expect(e.errorType, ApiErrorType.notFound);
      });

      test('422 → validation', () {
        final e = ApiException.fromStatusCode(422);
        expect(e.errorType, ApiErrorType.validation);
      });

      test('429 → rateLimited', () {
        final e = ApiException.fromStatusCode(429);
        expect(e.errorType, ApiErrorType.rateLimited);
      });

      test('500 → serverError', () {
        final e = ApiException.fromStatusCode(500);
        expect(e.errorType, ApiErrorType.serverError);
      });

      test('502 → unknown (server range)', () {
        final e = ApiException.fromStatusCode(502);
        expect(e.errorType, ApiErrorType.serverError);
      });

      test('200 → unknown (success is unknown error)', () {
        final e = ApiException.fromStatusCode(200);
        expect(e.errorType, ApiErrorType.unknown);
      });
    });

    test('toString() includes type and status', () {
      final e = ApiException.network('test');
      expect(e.toString(), contains(ApiErrorType.network.name));
      expect(e.toString(), contains('null'));
      expect(e.toString(), contains('test'));
    });
  });
}