import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app.dart';
import 'src/core/config/app_config.dart';

void main() {
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      debugPrint('FlutterError: ${details.exceptionAsString()}');
    };

    // Build the flavor-aware config once. `AppConfig.current()` reads
    // --dart-define=FLAVOR (default 'prod') and --dart-define=API_BASE_URL.
    final config = AppConfig.current();
    debugPrint('Starting app: ${config.toString()}');

    runApp(
      ProviderScope(
        overrides: [
          appConfigProvider.overrideWithValue(config),
        ],
        child: const MyApp(),
      ),
    );
  }, (error, stack) {
    debugPrint('Uncaught zone error: $error\n$stack');
  });
}
