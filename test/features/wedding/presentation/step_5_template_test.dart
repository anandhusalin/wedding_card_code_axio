import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
  });
}
