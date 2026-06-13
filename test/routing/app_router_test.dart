import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_cards/src/routing/app_router.dart';
import 'package:wedding_cards/l10n/app_localizations.dart';

void main() {
  group('AppRouter', () {
    testWidgets('unauthenticated user is redirected to /login', (WidgetTester tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: container.read(appRouterProvider),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should redirect to login
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('renders without crashing', (WidgetTester tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: container.read(appRouterProvider),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should render some screen
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('router can be instantiated', (WidgetTester tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final router = container.read(appRouterProvider);
      expect(router, isNotNull);
    });
  });
}