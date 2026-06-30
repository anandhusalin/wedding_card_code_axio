import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/api_constants.dart';

/// Application build flavor.
///
/// The flavor is baked in at build time via `--dart-define=FLAVOR=dev|prod`.
/// Defaults to `prod` so that any normal build (including production APKs
/// that don't pass the define) is always production-safe.
enum AppFlavor {
  dev,
  prod;

  static AppFlavor fromString(String? value) {
    switch (value) {
      case 'dev':
        return AppFlavor.dev;
      case 'prod':
      default:
        return AppFlavor.prod;
    }
  }

  bool get isDev => this == AppFlavor.dev;
  bool get isProd => this == AppFlavor.prod;
}

/// Runtime configuration that depends on the build flavor.
///
/// Created once at app startup and exposed to the rest of the app via
/// [appConfigProvider]. The wizard, repositories, and UI can read
/// `enableDevPrefill`, `apiBaseUrl`, and `appName` to behave differently
/// in dev vs prod.
@immutable
class AppConfig {
  /// The build flavor this app was compiled with.
  final AppFlavor flavor;

  /// Display name for the app (matches the launcher label on each platform).
  final String appName;

  /// Base URL for the backend API.
  ///
  /// Dev builds default to the Android emulator's localhost alias
  /// (`10.0.2.2:3000`) so they can talk to a local backend.
  /// Prod builds use the deployed Railway URL.
  /// Can be overridden at build time with `--dart-define=API_BASE_URL=...`.
  final String apiBaseUrl;

  /// Public-facing base URL (used for the shareable wedding page link).
  final String publicBaseUrl;

  /// When `true`, the wedding creation wizard pre-fills all fields with
  /// random data. Only true for dev builds.
  final bool enableDevPrefill;

  /// When `true`, debug-only UI (e.g. the dev banner) is rendered.
  final bool showDevBanner;

  const AppConfig({
    required this.flavor,
    required this.appName,
    required this.apiBaseUrl,
    required this.publicBaseUrl,
    required this.enableDevPrefill,
    required this.showDevBanner,
  });

  /// Builds the config for the current build. Reads FLAVOR and
  /// API_BASE_URL from `String.fromEnvironment` (compile-time defines).
  factory AppConfig.current() {
    const flavorString =
        String.fromEnvironment('FLAVOR', defaultValue: 'prod');
    final flavor = AppFlavor.fromString(flavorString);

    // Pick a sensible default API URL per flavor, but let the user
    // override it with --dart-define=API_BASE_URL=...
    const baseOverride = String.fromEnvironment('API_BASE_URL');
    const publicOverride = String.fromEnvironment('PUBLIC_BASE_URL');

    final defaultApi = flavor.isDev
        ? ApiConstants.localhostBaseUrl
        : ApiConstants.defaultBaseUrl;
    final defaultPublic = flavor.isDev
        ? ApiConstants.localhostBaseUrl
        : ApiConstants.publicBaseUrl;

    return AppConfig(
      flavor: flavor,
      appName: flavor.isDev ? 'Wedding Cards Dev' : 'Wedding Cards',
      apiBaseUrl: baseOverride.isNotEmpty ? baseOverride : defaultApi,
      publicBaseUrl: publicOverride.isNotEmpty ? publicOverride : defaultPublic,
      enableDevPrefill: flavor.isDev,
      showDevBanner: flavor.isDev,
    );
  }

  @override
  String toString() =>
      'AppConfig(flavor: ${flavor.name}, apiBaseUrl: $apiBaseUrl, '
      'enableDevPrefill: $enableDevPrefill)';
}

/// Riverpod provider exposing the app's [AppConfig].
///
/// Override this in `main.dart` with `AppConfig.current()` so the rest
/// of the app can read the config synchronously.
final appConfigProvider = Provider<AppConfig>((ref) {
  throw UnimplementedError(
    'appConfigProvider must be overridden in main.dart with AppConfig.current()',
  );
});
