import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_cards/src/features/profile/presentation/profile_screen.dart';

void main() {
  group('ProfileScreen', () {
    testWidgets('renders profile screen with sign out button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );

      await tester.pump();

      // App bar should be present
      expect(find.byType(AppBar), findsOneWidget);

      // Should render a sign-out action (button text)
      expect(find.text('Sign out'), findsWidgets);
    });

    testWidgets('shows guest fallback when no user is signed in',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );

      await tester.pump();

      // Settings list should still render even with no user
      expect(find.text('Preferences'), findsOneWidget);
      expect(find.text('Support'), findsOneWidget);
    });
  });
}
