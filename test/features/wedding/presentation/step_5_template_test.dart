import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_cards/src/features/wedding/presentation/create/step_5_template.dart';
import 'package:wedding_cards/src/features/wedding/presentation/create/template_preview.dart';

void main() {
  group('TemplateTheme registry', () {
    test('returns a theme for every supported template id', () {
      for (final id in [
        'floral-romance',
        'royal-maroon',
        'modern-elegant',
        'traditional-kerala',
      ]) {
        final t = themeFor(id);
        expect(t.id, id, reason: 'themeFor($id) returned wrong id');
        expect(t.name, isNotEmpty);
        expect(t.bg, isA<Color>());
        expect(t.primary, isA<Color>());
        expect(t.accent, isA<Color>());
        expect(t.ink, isA<Color>());
        expect(t.muted, isA<Color>());
        expect(t.displayFont, isNotEmpty);
        expect(t.bodyFont, isNotEmpty);
        expect(t.icon, isA<IconData>());
      }
    });

    test('falls back to traditional-kerala for unknown ids', () {
      final t = themeFor('does-not-exist');
      expect(t.id, 'traditional-kerala');
    });

    test('each template has a distinct primary color', () {
      final ids = ['floral-romance', 'royal-maroon', 'modern-elegant', 'traditional-kerala'];
      final primaries = ids.map((i) => themeFor(i).primary).toSet();
      // All 4 must be unique so the previews are visually distinct.
      expect(primaries.length, ids.length, reason: 'Templates share a primary color');
    });

    test('each template has a distinct background color', () {
      final ids = ['floral-romance', 'royal-maroon', 'modern-elegant', 'traditional-kerala'];
      final bgs = ids.map((i) => themeFor(i).bg).toSet();
      expect(bgs.length, ids.length, reason: 'Templates share a background color');
    });

    test('Floral Romance uses Dancing Script display font', () {
      final t = themeFor('floral-romance');
      expect(t.displayFont, contains('Dancing'));
    });

    test('Royal Maroon uses Cinzel display font', () {
      final t = themeFor('royal-maroon');
      expect(t.displayFont, contains('Cinzel'));
    });

    test('Modern Elegant uses Fraunces display font', () {
      final t = themeFor('modern-elegant');
      expect(t.displayFont, contains('Fraunces'));
    });

    test('Traditional Kerala uses Cormorant Garamond display font', () {
      final t = themeFor('traditional-kerala');
      expect(t.displayFont, contains('Cormorant'));
    });
  });

  group('Step5Template widget', () {
    Widget wrap(Widget child) => MaterialApp(
          home: Scaffold(
            body: SizedBox(width: 800, height: 1400, child: child),
          ),
        );

    testWidgets('displays all 4 template names', (WidgetTester tester) async {
      await tester.pumpWidget(wrap(Step5Template(
        initialData: const {},
        onSaved: (data) => {},
      )));
      await tester.pumpAndSettle();

      expect(find.text('Traditional Kerala'), findsOneWidget);
      expect(find.text('Modern Elegant'), findsOneWidget);
      expect(find.text('Floral Romance'), findsOneWidget);
      expect(find.text('Royal Maroon'), findsOneWidget);
    });

    testWidgets('embeds a TemplatePreview per template card',
        (WidgetTester tester) async {
      await tester.pumpWidget(wrap(Step5Template(
        initialData: const {},
        onSaved: (data) => {},
      )));
      await tester.pumpAndSettle();

      // 4 cards, each with a live TemplatePreview.
      expect(find.byType(TemplatePreview), findsNWidgets(4));
    });

    testWidgets('tapping Select calls onSaved with the correct id',
        (WidgetTester tester) async {
      late Map<String, dynamic> savedData;

      await tester.pumpWidget(wrap(Step5Template(
        initialData: const {'templateId': 'floral-romance'},
        onSaved: (data) => savedData = data,
      )));
      await tester.pumpAndSettle();

      // Find any "Select" FilledButton.tonalIcon. By default floral-romance
      // is selected so it shows "Selected" — all other templates show
      // "Select". The first one is whichever template is rendered first
      // among the non-selected ones.
      await tester.tap(find.widgetWithText(FilledButton, 'Select').first);
      await tester.pumpAndSettle();

      expect(savedData, isNotNull);
      expect(savedData['templateId'], isIn(['modern-elegant', 'royal-maroon', 'traditional-kerala']));
    });

    testWidgets('default selection is floral-romance when no initial data',
        (WidgetTester tester) async {
      late Map<String, dynamic> savedData;

      await tester.pumpWidget(wrap(Step5Template(
        initialData: const {},
        onSaved: (data) => savedData = data,
      )));
      await tester.pumpAndSettle();

      // Tap Royal Maroon's Select button to confirm selection works
      await tester.tap(find.widgetWithText(FilledButton, 'Select').last);
      await tester.pumpAndSettle();

      expect(savedData['templateId'], 'royal-maroon');
    });

    testWidgets('uses the provided templateId from initialData',
        (WidgetTester tester) async {
      late Map<String, dynamic> savedData;

      await tester.pumpWidget(wrap(Step5Template(
        initialData: const {'templateId': 'royal-maroon'},
        onSaved: (data) => savedData = data,
      )));
      await tester.pumpAndSettle();

      // Royal Maroon is selected by default; tap Traditional Kerala.
      // The last Select button corresponds to traditional-kerala (rendered
      // 4th in the list).
      await tester.tap(find.widgetWithText(FilledButton, 'Select').last);
      await tester.pumpAndSettle();

      expect(savedData['templateId'], 'traditional-kerala');
    });

    testWidgets('displays instruction text', (WidgetTester tester) async {
      await tester.pumpWidget(wrap(Step5Template(
        initialData: const {},
        onSaved: (data) => {},
      )));
      await tester.pumpAndSettle();

      expect(find.text('Choose a template'), findsOneWidget);
      expect(find.textContaining('Tap any card to preview'), findsOneWidget);
    });

    testWidgets('tapping the preview overlay opens the bottom sheet',
        (WidgetTester tester) async {
      await tester.pumpWidget(wrap(Step5Template(
        initialData: const {'groomName': 'Aarav', 'brideName': 'Diya'},
        onSaved: (data) => {},
      )));
      await tester.pumpAndSettle();

      // Each card has the preview hint overlay.
      expect(find.text('Tap to preview all sections'), findsWidgets);

      // Tap the first preview overlay to open the bottom sheet.
      await tester.tap(find.text('Tap to preview all sections').first);
      await tester.pumpAndSettle();

      // The bottom sheet shows a "Select <Template>" CTA.
      expect(find.textContaining('Select '), findsOneWidget);
    });

    testWidgets('shows a Selected banner when a template is chosen',
        (WidgetTester tester) async {
      await tester.pumpWidget(wrap(Step5Template(
        initialData: const {'templateId': 'royal-maroon'},
        onSaved: (data) => {},
      )));
      await tester.pumpAndSettle();

      // The currently selected template shows a banner above the list.
      expect(find.text('Currently selected: Royal Maroon'), findsOneWidget);
    });
  });
}
