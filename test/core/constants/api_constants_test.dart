import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_cards/src/core/constants/api_constants.dart';

void main() {
  group('ApiConstants', () {
    group('defaultBaseUrl and localhostBaseUrl', () {
      test('defaultBaseUrl is Railway URL', () {
        expect(
          ApiConstants.defaultBaseUrl,
          'https://wedding-cards-api-production.up.railway.app',
        );
      });

      test('localhostBaseUrl is local dev', () {
        expect(
          ApiConstants.localhostBaseUrl,
          'http://10.0.2.2:3000',
        );
      });
    });

    group('kIsLocalApi', () {
      test('kIsLocalApi defaults to false (uses Railway)', () {
        expect(ApiConstants.kIsLocalApi, false);
      });
    });

    group('resolvedBaseUrl', () {
      test('kIsLocalApi=false → defaultBaseUrl (Railway)', () {
        expect(ApiConstants.resolvedBaseUrl, ApiConstants.defaultBaseUrl);
      });
    });

    group('resolvedPublicBaseUrl', () {
      test('kIsLocalApi=false → publicBaseUrl (Railway)', () {
        expect(ApiConstants.resolvedPublicBaseUrl, ApiConstants.publicBaseUrl);
      });

      test('matches resolvedBaseUrl', () {
        expect(
          ApiConstants.resolvedPublicBaseUrl,
          ApiConstants.resolvedBaseUrl,
        );
      });
    });

    group('publicWeddingUrl', () {
      test('generates URL with prefix and slug', () {
        const slug = 'test-wedding-slug';
        final url = ApiConstants.publicWeddingUrl(slug);
        expect(url, '${ApiConstants.resolvedPublicBaseUrl}/$slug');
      });

      test('handles slug with special characters', () {
        const slug = 'mashu-&-mashu-2';
        final url = ApiConstants.publicWeddingUrl(slug);
        expect(url, '${ApiConstants.resolvedPublicBaseUrl}/$slug');
      });
    });
  });
}