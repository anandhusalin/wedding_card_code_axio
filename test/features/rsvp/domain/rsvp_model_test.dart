import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_cards/src/features/rsvp/domain/rsvp_model.dart';

void main() {
  group('Rsvp model', () {
    test('fromJson parses full RSVP', () {
      final json = {
        '_id': 'rsvp-123',
        'weddingId': 'wedding-456',
        'guestName': 'Alice',
        'phone': '+1234567890',
        'numberOfGuests': 2,
        'status': 'attending',
        'message': 'Congratulations!',
        'createdAt': '2026-06-01T10:00:00.000Z',
      };

      final rsvp = Rsvp.fromJson(json);

      expect(rsvp.id, 'rsvp-123');
      expect(rsvp.weddingId, 'wedding-456');
      expect(rsvp.guestName, 'Alice');
      expect(rsvp.phone, '+1234567890');
      expect(rsvp.numberOfGuests, 2);
      expect(rsvp.status, 'attending');
      expect(rsvp.message, 'Congratulations!');
      expect(rsvp.createdAt, isA<DateTime>());
    });

    test('fromJson - missing optional fields use defaults', () {
      final json = {
        'id': 'rsvp-789',
        'weddingId': 'wedding-abc',
        'guestName': 'Bob',
        'status': 'pending',
      };

      final rsvp = Rsvp.fromJson(json);

      expect(rsvp.id, 'rsvp-789');
      expect(rsvp.guestName, 'Bob');
      expect(rsvp.numberOfGuests, 1); // default
      expect(rsvp.phone, null);
      expect(rsvp.message, null);
      expect(rsvp.createdAt, null);
    });

    test('toJson roundtrips', () {
      const rsvp = Rsvp(
        id: 'r-1',
        weddingId: 'w-1',
        guestName: 'Charlie',
        status: 'attending',
      );
      final json = rsvp.toJson();
      expect(json['guestName'], 'Charlie');
      expect(json['status'], 'attending');
      expect(json['numberOfGuests'], 1);
    });
  });

  group('RsvpStats model', () {
    test('fromJson with all counts', () {
      final json = {
        'total': 50,
        'attending': 30,
        'notAttending': 10,
        'maybe': 10,
      };

      final stats = RsvpStats.fromJson(json);

      expect(stats.total, 50);
      expect(stats.attending, 30);
      expect(stats.notAttending, 10);
      expect(stats.maybe, 10);
    });

    test('fromJson - all defaults to 0', () {
      final stats = RsvpStats.fromJson({});
      expect(stats.total, 0);
      expect(stats.attending, 0);
      expect(stats.notAttending, 0);
      expect(stats.maybe, 0);
    });

    test('toJson roundtrips', () {
      const stats = RsvpStats(
        total: 10,
        attending: 5,
        notAttending: 3,
        maybe: 2,
      );
      final json = stats.toJson();
      expect(json['total'], 10);
      expect(json['attending'], 5);
    });
  });
}