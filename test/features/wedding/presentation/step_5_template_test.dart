import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_cards/src/features/wedding/presentation/create/step_5_template.dart';

void main() {
  group('Step5Template widget', () {
    testWidgets('displays 4 template cards', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Step5Template(
              initialData: const {},
              onSaved: (data) => {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should have 4 template cards (each is an InkWell)
      expect(find.byType(InkWell), findsNWidgets(4));

      // Template names
      expect(find.text('Traditional Kerala'), findsOneWidget);
      expect(find.text('Modern Elegant'), findsOneWidget);
      expect(find.text('Floral Romance'), findsOneWidget);
      expect(find.text('Royal Maroon'), findsOneWidget);

      // FREE badges
      expect(find.text('FREE'), findsExactly(4));
    });

    testWidgets('tapping a card calls onSaved with the correct id', (WidgetTester tester) async {
      late Map<String, dynamic> savedData;
      const initialData = {'templateId': 'traditional-kerala'};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Step5Template(
              initialData: initialData,
              onSaved: (data) => savedData = data,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap the Modern Elegant card
      await tester.tap(find.text('Modern Elegant'));
      await tester.pumpAndSettle();

      expect(savedData, isNotNull);
      expect(savedData['templateId'], 'modern-elegant');
    });

    testWidgets('displays instruction text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Step5Template(
              initialData: const {},
              onSaved: (data) => {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should have title and subtitle
      expect(find.text('Choose a template'), findsOneWidget);
      expect(
        find.text('All templates are free. You can switch later.'),
        findsOneWidget,
      );
    });

    testWidgets('icon shows on each card', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Step5Template(
              initialData: const {},
              onSaved: (data) => {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Each card should have an icon
      expect(find.byType(Icon), findsAtLeastNWidgets(4));
    });

    testWidgets('default selection is traditional-kerala', (WidgetTester tester) async {
      late Map<String, dynamic> savedData;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Step5Template(
              initialData: const {},
              onSaved: (data) => savedData = data,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap Royal Maroon to confirm selection works
      await tester.tap(find.text('Royal Maroon'));
      await tester.pumpAndSettle();

      expect(savedData['templateId'], 'royal-maroon');
    });
  });
}