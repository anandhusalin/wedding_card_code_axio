import 'dart:math';

/// Generates random prefill data for the wedding creation wizard.
///
/// Used **only in dev builds** to make it quick to exercise the full
/// 6-step flow without typing the same fake data by hand every time.
///
/// The output shape matches the in-memory `Map<String, dynamic>` that
/// the wizard accumulates in `_weddingData` (see create_wedding_screen.dart).
class DevDataGenerator {
  DevDataGenerator._();

  /// Name pools — Indian + Christian mix, common in the user base.
  static const List<String> _groomNames = [
    'Aarav', 'Vihaan', 'Aditya', 'Arjun', 'Rohan',
    'Karthik', 'Rahul', 'Anand', 'Nikhil', 'Manoj',
    'James', 'Daniel', 'Michael', 'David', 'Joseph',
  ];
  static const List<String> _brideNames = [
    'Diya', 'Ananya', 'Sneha', 'Priya', 'Meera',
    'Kavya', 'Riya', 'Pooja', 'Lakshmi', 'Aishwarya',
    'Sarah', 'Emily', 'Grace', 'Sophia', 'Isabella',
  ];
  static const List<String> _fatherNames = [
    'Rajesh', 'Suresh', 'Prakash', 'Ramesh', 'Mohan',
    'George', 'Thomas', 'Mathew', 'John', 'Samuel',
  ];
  static const List<String> _motherNames = [
    'Latha', 'Sunitha', 'Rekha', 'Geetha', 'Lakshmi',
    'Mary', 'Elizabeth', 'Anna', 'Susan', 'Helen',
  ];
  static const List<String> _venueNames = [
    'Leela Palace',
    'Taj Gateway',
    'Grand Hyatt',
    'Marriott Convention Hall',
    'Sree Krishna Auditorium',
    'St. Mary\'s Cathedral',
    'The Leela Kovalam',
    'Crown Plaza',
    'Hilton Garden Inn',
    'Royal Orchid Resort',
  ];
  static const List<String> _venuesByCity = [
    'Marine Drive, Kochi',
    'MG Road, Bengaluru',
    'Anna Nagar, Chennai',
    'Bandra West, Mumbai',
    'Sector 18, Noida',
    'Jubilee Hills, Hyderabad',
    'Salt Lake, Kolkata',
    'Kowdiar, Trivandrum',
  ];
  static const List<String> _invitationTemplates = [
    'Together with their families, you are warmly invited to celebrate the wedding of',
    'Join us as we begin our forever, the wedding celebration of',
    'With the blessing of our families, we request the pleasure of your company at the wedding of',
    'Two hearts, one love — please join us at the wedding of',
  ];
  static const List<String> _storyTemplates = [
    'We met on a rainy evening at a small coffee shop in the city, both reaching for the same book on the shelf. Five years, countless road trips, and one very opinionated puppy later, we are finally tying the knot.',
    'What started as a college study group quickly turned into late-night conversations, weekend hikes, and a love story we did not see coming. We cannot wait to start our next chapter with you.',
    'From strangers on a train to partners in everything — our journey has been full of laughter, learning, and the occasional burnt dinner. We would love for you to be part of the next big step.',
    'A right swipe turned into the best decision of our lives. Three years of adventures later, we are ready to say I do surrounded by the people we love most.',
  ];

  /// Build a [Random] instance. Tests can pass a seeded one to get
  /// deterministic output.
  static Random _rng([int? seed]) => Random(seed);

  /// Picks a random element from a list.
  static T _pick<T>(Random rng, List<T> items) =>
      items[rng.nextInt(items.length)];

  /// Generates a complete map of wizard data suitable for pre-filling the
  /// 6-step create-wedding flow. Returned map mirrors the shape the wizard
  /// accumulates in `_weddingData`.
  static Map<String, dynamic> randomWeddingWizardData({int? seed}) {
    final rng = _rng(seed);
    final daysFromNow = 60 + rng.nextInt(60); // 60–120 days
    final weddingDate =
        DateTime.now().add(Duration(days: daysFromNow, hours: 2));

    final groom = _pick(rng, _groomNames);
    final bride = _pick(rng, _brideNames);
    final hours = 9 + rng.nextInt(8); // 9 AM – 4 PM
    final minutes = rng.nextInt(2) == 0 ? '00' : '30';
    final timeHour = hours > 12 ? hours - 12 : hours;
    final ampm = hours >= 12 ? 'PM' : 'AM';
    // Pad to 2 digits so the time matches the form's "HH:MM AM/PM" format
    // — the wedding template renders "9:00 AM" with a thin space, looking
    // misaligned next to other rows. "09:00 AM" lines up consistently.
    final weddingTime =
        '${timeHour.toString().padLeft(2, '0')}:$minutes $ampm';

    final venueName = _pick(rng, _venueNames);
    final venueAddress = _pick(rng, _venuesByCity);

    return {
      // ── Step 1: Couple ─────────────────────────────────────
      'groomName': groom,
      'brideName': bride,
      'slug': '${groom.toLowerCase()}-${bride.toLowerCase()}-${rng.nextInt(900) + 100}',
      'groomPhoto': 'https://picsum.photos/seed/groom${rng.nextInt(1000)}/600/800',
      'bridePhoto': 'https://picsum.photos/seed/bride${rng.nextInt(1 << 31)}/600/800',
      'couplePhoto': 'https://picsum.photos/seed/couple${rng.nextInt(1 << 31)}/1200/800',

      // ── Step 2: Event details ──────────────────────────────
      'weddingDate': weddingDate,
      'weddingTime': weddingTime,
      'venue': {
        'name': venueName,
        'address': venueAddress,
        'mapUrl': '',
      },
      'invitationMessage':
          '${_pick(rng, _invitationTemplates)} $groom & $bride.',

      // ── Step 3: Family ─────────────────────────────────────
      'brideFamily': {
        'fatherName': _pick(rng, _fatherNames),
        'motherName': _pick(rng, _motherNames),
        'address': venueAddress,
      },
      'groomFamily': {
        'fatherName': _pick(rng, _fatherNames),
        'motherName': _pick(rng, _motherNames),
        'address': venueAddress,
      },

      // ── Step 4: Story + Gallery ────────────────────────────
      'coupleStory': _pick(rng, _storyTemplates),
      'galleryPhotos': _randomGalleryPhotos(4, rng: rng),
      'engagementPhotos': _randomGalleryPhotos(2, rng: rng, seedPrefix: 'eng'),

      // ── Step 5: Template (default) ─────────────────────────
      'templateId': 'floral-romance',
    };
  }

  /// Generates a list of [count] placeholder gallery photos using
  /// picsum.photos. The shape matches what the wizard stores:
  /// `[{'url': '...', 'order': 0}, ...]`.
  static List<Map<String, dynamic>> _randomGalleryPhotos(
    int count, {
    required Random rng,
    String seedPrefix = 'wedding',
  }) {
    return List.generate(count, (i) {
      return {
        'url': 'https://picsum.photos/seed/$seedPrefix${rng.nextInt(1 << 31)}/800/1000',
        'order': i,
      };
    });
  }

  /// Public version of [_randomGalleryPhotos] for tests / incremental adds.
  static List<Map<String, dynamic>> randomGalleryPhotos(
    int count, {
    int? seed,
    String seedPrefix = 'wedding',
  }) {
    return _randomGalleryPhotos(
      count,
      rng: _rng(seed),
      seedPrefix: seedPrefix,
    );
  }
}
