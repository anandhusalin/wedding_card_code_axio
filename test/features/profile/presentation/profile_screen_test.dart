import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_cards/src/features/profile/presentation/profile_screen.dart';

void main() {
  group('ProfileScreen', () {
    testWidgets('renders profile screen with logout button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should render an app bar
      expect(find.byType(AppBar), findsOneWidget);

      // Should render logout button
      expect(find.text('Logout'), findsOneWidget);

      // Should have a logout ElevatedButton
      expect(find.widgetWithText(ElevatedButton, 'Logout'), findsOneWidget);
    });
  });
}