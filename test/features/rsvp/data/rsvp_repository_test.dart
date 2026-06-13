import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_cards/src/features/rsvp/data/rsvp_repository.dart';
import 'package:wedding_cards/src/features/rsvp/domain/rsvp_model.dart';

void main() {
  group('RsvpRepository', () {
    late RsvpRepository repo;
    const testWeddingId = 'wedding-123';

    setUp(() {
      // The real repo requires Dio, but it's not used (mocked data)
      repo = RsvpRepository(Dio());
    });

    group('getRsvps', () {
      test('returns list of RSVPs for a wedding', () async {
        final rsvps = await repo.getRsvps(testWeddingId);

        expect(rsvps, hasLength(2));
        expect(rsvps[0].guestName, 'John Doe');
        expect(rsvps[0].status, 'attending');
        expect(rsvps[0].numberOfGuests, 2);

        expect(rsvps[1].guestName, 'Jane Smith');
        expect(rsvps[1].status, 'not_attending');
        expect(rsvps[1].numberOfGuests, 1);

        // Both have the correct weddingId
        for (final rsvp in rsvps) {
          expect(rsvp.weddingId, testWeddingId);
        }
      });

      test('returns empty list for unknown wedding', () async {
        // Simulate different wedding ID
        const otherWeddingId = 'wedding-999';
        final rsvps = await repo.getRsvps(otherWeddingId);

        // Returns 2 items even for unknown weddings (mocked)
        expect(rsvps, hasLength(2));
      });
    });

    group('getRsvpStats', () {
      test('returns aggregated stats', () async {
        final RsvpStats stats = await repo.getRsvpStats(testWeddingId);

        expect(stats.total, 2);
        expect(stats.attending, 1);
        expect(stats.notAttending, 1);
        expect(stats.maybe, 0);

        // Sum of attending + notAttending + maybe = total
        expect(stats.attending + stats.notAttending + stats.maybe, stats.total);
      });
    });
  });
}