import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_cards/src/features/home/presentation/home_screen.dart';

void main() {
  testWidgets('HomeScreen renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: HomeScreen()),
      ),
    );

    // Basic render check
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}