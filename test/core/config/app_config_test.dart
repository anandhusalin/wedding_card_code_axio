import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_cards/src/core/config/app_config.dart';

void main() {
  group('AppFlavor', () {
    test('parses "dev" to AppFlavor.dev', () {
      expect(AppFlavor.fromString('dev'), AppFlavor.dev);
    });

    test('parses "prod" to AppFlavor.prod', () {
      expect(AppFlavor.fromString('prod'), AppFlavor.prod);
    });

    test('defaults to AppFlavor.prod for null and unknown values', () {
      expect(AppFlavor.fromString(null), AppFlavor.prod);
      expect(AppFlavor.fromString('staging'), AppFlavor.prod);
      expect(AppFlavor.fromString(''), AppFlavor.prod);
    });
  });

  group('AppConfig', () {
    test('default (prod) has production flags', () {
      const config = AppConfig(
        flavor: AppFlavor.prod,
        appName: 'Wedding Cards',
        apiBaseUrl: 'https://api.example.com',
        publicBaseUrl: 'https://wedding.example.com',
        enableDevPrefill: false,
        showDevBanner: false,
      );
      expect(config.flavor, AppFlavor.prod);
      expect(config.flavor.isProd, isTrue);
      expect(config.flavor.isDev, isFalse);
      expect(config.enableDevPrefill, isFalse);
      expect(config.showDevBanner, isFalse);
    });

    test('dev config enables prefill and banner', () {
      const config = AppConfig(
        flavor: AppFlavor.dev,
        appName: 'Wedding Cards Dev',
        apiBaseUrl: 'http://10.0.2.2:3000',
        publicBaseUrl: 'http://10.0.2.2:3000',
        enableDevPrefill: true,
        showDevBanner: true,
      );
      expect(config.flavor.isDev, isTrue);
      expect(config.enableDevPrefill, isTrue);
      expect(config.showDevBanner, isTrue);
    });

    test('toString includes the flavor and api base', () {
      const config = AppConfig(
        flavor: AppFlavor.dev,
        appName: 'Dev',
        apiBaseUrl: 'http://x',
        publicBaseUrl: 'http://x',
        enableDevPrefill: true,
        showDevBanner: true,
      );
      final s = config.toString();
      expect(s, contains('dev'));
      expect(s, contains('http://x'));
    });
  });
}
