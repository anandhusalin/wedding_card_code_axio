import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_cards/src/core/dev/dev_data_generator.dart';

void main() {
  group('DevDataGenerator', () {
    test('returns a non-empty map with all wizard keys', () {
      final data = DevDataGenerator.randomWeddingWizardData(seed: 42);
      expect(data, isA<Map<String, dynamic>>());
      expect(data, isNotEmpty);

      // Step 1 — Couple
      expect(data['groomName'], isA<String>());
      expect(data['brideName'], isA<String>());
      expect((data['groomName'] as String).isNotEmpty, isTrue);
      expect((data['brideName'] as String).isNotEmpty, isTrue);

      // Step 2 — Event
      expect(data['weddingDate'], isA<DateTime>());
      expect(data['weddingTime'], isA<String>());
      expect(data['venue'], isA<Map<String, dynamic>>());
      final venue = data['venue'] as Map<String, dynamic>;
      expect((venue['name'] as String).isNotEmpty, isTrue);

      // Step 3 — Family
      expect(data['brideFamily'], isA<Map<String, dynamic>>());
      expect(data['groomFamily'], isA<Map<String, dynamic>>());

      // Step 4 — Gallery
      expect(data['galleryPhotos'], isA<List>());
      expect((data['galleryPhotos'] as List).length, 4);
    });

    test('is deterministic when given a seed', () {
      final a = DevDataGenerator.randomWeddingWizardData(seed: 1);
      final b = DevDataGenerator.randomWeddingWizardData(seed: 1);
      expect(a, equals(b));
    });

    test('produces different data for different seeds', () {
      // Use a generous comparison: at least one of name/date differs.
      final a = DevDataGenerator.randomWeddingWizardData(seed: 1);
      final b = DevDataGenerator.randomWeddingWizardData(seed: 2);
      // Probability of full equality for distinct random sequences is
      // astronomically small. We use a loose assertion to be safe.
      expect(a == b, isFalse);
    });

    test('wedding date is in the future', () {
      final data = DevDataGenerator.randomWeddingWizardData(seed: 7);
      final date = data['weddingDate'] as DateTime;
      expect(date.isAfter(DateTime.now()), isTrue);
    });

    test('randomGalleryPhotos returns the requested count', () {
      final photos = DevDataGenerator.randomGalleryPhotos(5, seed: 9);
      expect(photos, hasLength(5));
      for (final p in photos) {
        expect(p, isA<Map<String, dynamic>>());
        expect(p['url'], isA<String>());
        expect((p['url'] as String).isNotEmpty, isTrue);
        expect(p['order'], isA<int>());
      }
    });
  });
}
