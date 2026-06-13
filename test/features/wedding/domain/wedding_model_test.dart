import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_cards/src/features/wedding/domain/wedding_model.dart';

void main() {
  group('Wedding model', () {
    test('fromJson parses full wedding', () {
      final json = {
        '_id': 'wedding-123',
        'userId': 'user-456',
        'slug': 'john-and-jane-2027',
        'groomName': 'John',
        'brideName': 'Jane',
        'weddingDate': '2027-06-15T10:00:00.000Z',
        'isPublished': true,
        'viewCount': 42,
        'venue': {
          'name': 'Grand Hall',
          'address': '123 Main St',
        },
        'templateId': 'modern-elegant',
      };
      final wedding = Wedding.fromJson(json);

      expect(wedding.id, 'wedding-123');
      expect(wedding.groomName, 'John');
      expect(wedding.brideName, 'Jane');
      expect(wedding.slug, 'john-and-jane-2027');
      expect(wedding.isPublished, true);
      expect(wedding.viewCount, 42);
      expect(wedding.venue?.name, 'Grand Hall');
      expect(wedding.templateId, 'modern-elegant');
    });

    test('fromJson - missing optional fields use defaults', () {
      final json = {
        'id': 'wedding-789',
        'userId': 'user-abc',
        'slug': 'a-and-b',
        'groomName': 'A',
        'brideName': 'B',
        'weddingDate': '2027-01-01T00:00:00.000Z',
      };
      final wedding = Wedding.fromJson(json);

      expect(wedding.templateId, 'traditional-kerala');
      expect(wedding.language, 'en');
      expect(wedding.isPublished, false);
      expect(wedding.isDraft, true);
      expect(wedding.isRsvpEnabled, true);
      expect(wedding.viewCount, 0);
      expect(wedding.timeline, isEmpty);
      expect(wedding.galleryPhotos, isEmpty);
    });

    test('toJson roundtrips', () {
      final wedding = Wedding(
        id: 'w-1',
        userId: 'u-1',
        slug: 's-1',
        groomName: 'Groom',
        brideName: 'Bride',
        weddingDate: DateTime(2027, 1, 1),
      );
      final json = wedding.toJson();
      expect(json['groomName'], 'Groom');
      expect(json['templateId'], 'traditional-kerala');
    });
  });

  group('Venue', () {
    test('fromJson with all fields', () {
      final json = {
        'name': 'Beach Resort',
        'address': 'Kovalam, Kerala',
        'mapUrl': 'https://maps.google.com/...',
        'coordinates': {'lat': 8.5, 'lng': 76.9},
      };
      final venue = Venue.fromJson(json);
      expect(venue.name, 'Beach Resort');
      expect(venue.coordinates?.lat, 8.5);
      expect(venue.coordinates?.lng, 76.9);
    });
  });

  group('ThemeConfig', () {
    test('fromJson - default primary color', () {
      final theme = ThemeConfig.fromJson({});
      expect(theme.primaryColor, '#D4A574');
      expect(theme.fontFamily, 'Playfair Display');
    });
  });

  group('GalleryPhoto', () {
    test('fromJson - order defaults to 0', () {
      final photo = GalleryPhoto.fromJson({'url': 'https://example.com/p.jpg'});
      expect(photo.url, 'https://example.com/p.jpg');
      expect(photo.order, 0);
    });
  });
}