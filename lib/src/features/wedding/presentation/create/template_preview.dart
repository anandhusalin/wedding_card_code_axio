import 'package:flutter/material.dart';
import '../../domain/wedding_model.dart';

/// A miniature, faithful rendering of each of the 4 wedding-template
/// pages. Used inside step_5_template so users can preview exactly
/// what their live page will look like — with their real data —
/// before committing to a template.
///
/// Every section (Hero, Couple, Our Story, Family, Events, Gallery,
/// Travel, Gift, Wishes) renders inline; the user scrolls the
/// bottom-sheet to see the full vertical layout.

/// Visual identity of each template. Mirrors the colors used in the
/// real EJS templates (see backend/src/views/templates/*.ejs).
class TemplateTheme {
  final String id;
  final String name;
  final String tagline;
  final Color bg; // page background
  final Color surface; // card / section surface
  final Color primary; // display accents
  final Color accent; // dividers, hover
  final Color ink; // primary text on bg
  final Color muted; // secondary text
  final String displayFont; // script / display font family
  final String bodyFont; // serif body font family
  final bool dark; // for modern-elegant: dark background
  final IconData icon;

  const TemplateTheme({
    required this.id,
    required this.name,
    required this.tagline,
    required this.bg,
    required this.surface,
    required this.primary,
    required this.accent,
    required this.ink,
    required this.muted,
    required this.displayFont,
    required this.bodyFont,
    required this.dark,
    required this.icon,
  });
}

const _themes = <String, TemplateTheme>{
  'floral-romance': TemplateTheme(
    id: 'floral-romance',
    name: 'Floral Romance',
    tagline: 'Soft & romantic',
    bg: Color(0xFFFFF8F4),
    surface: Color(0xFFFFFFFF),
    primary: Color(0xFFB7628A),
    accent: Color(0xFFE6B3C2),
    ink: Color(0xFF3A2030),
    muted: Color(0xFF8B6A78),
    displayFont: 'Dancing Script',
    bodyFont: 'Cormorant Garamond',
    dark: false,
    icon: Icons.local_florist,
  ),
  'royal-maroon': TemplateTheme(
    id: 'royal-maroon',
    name: 'Royal Maroon',
    tagline: 'Regal & ornate',
    bg: Color(0xFFFAF1E0),
    surface: Color(0xFFF5E6C8),
    primary: Color(0xFF5C0015),
    accent: Color(0xFFC9A95E),
    ink: Color(0xFF2A0A0F),
    muted: Color(0xFF8B6B47),
    displayFont: 'Cinzel',
    bodyFont: 'Cormorant Garamond',
    dark: false,
    icon: Icons.castle_outlined,
  ),
  'modern-elegant': TemplateTheme(
    id: 'modern-elegant',
    name: 'Modern Elegant',
    tagline: 'Clean & minimal',
    bg: Color(0xFFFAF7F2),
    surface: Color(0xFFF1EAE0),
    primary: Color(0xFF1F2937),
    accent: Color(0xFFBFA987),
    ink: Color(0xFF1F2937),
    muted: Color(0xFF8A8079),
    displayFont: 'Fraunces',
    bodyFont: 'Fraunces',
    dark: false,
    icon: Icons.diamond_outlined,
  ),
  'traditional-kerala': TemplateTheme(
    id: 'traditional-kerala',
    name: 'Traditional Kerala',
    tagline: 'Classic Kerala style',
    bg: Color(0xFFFAF3E7),
    surface: Color(0xFFFFFAEC),
    primary: Color(0xFF7B2D26),
    accent: Color(0xFFC9A95E),
    ink: Color(0xFF2A1810),
    muted: Color(0xFF8B6F4E),
    displayFont: 'Cormorant Garamond',
    bodyFont: 'Cormorant Garamond',
    dark: false,
    icon: Icons.temple_hindu,
  ),
};

TemplateTheme themeFor(String id) =>
    _themes[id] ?? _themes['traditional-kerala']!;

class TemplatePreview extends StatelessWidget {
  final String templateId;
  final Map<String, dynamic> data;
  final bool isPhone; // narrow viewport (preview-in-sheet)

  const TemplatePreview({
    super.key,
    required this.templateId,
    required this.data,
    this.isPhone = true,
  });

  @override
  Widget build(BuildContext context) {
    final t = themeFor(templateId);
    final wedding = _materialize(data);

    return DefaultTextStyle(
      style: TextStyle(
        fontFamily: t.bodyFont,
        color: t.ink,
        fontSize: 13,
        height: 1.5,
      ),
      child: Container(
        color: t.bg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _HeroSection(t: t, w: wedding),
            _CoupleSection(t: t, w: wedding),
            if (wedding.coupleStory != null && wedding.coupleStory!.isNotEmpty)
              _OurStorySection(t: t, w: wedding),
            _FamilySection(t: t, w: wedding),
            _EventsSection(t: t, w: wedding),
            _GallerySection(t: t, w: wedding),
            _TravelSection(t: t, w: wedding),
            _GiftSection(t: t, w: wedding),
            _WishesSection(t: t, w: wedding),
            _FooterSection(t: t, w: wedding),
          ],
        ),
      ),
    );
  }

  /// Build a [Wedding] model from the in-flight create-wizard Map.
  /// Converts a raw `Map<String, dynamic>` from the wedding wizard into
  /// typed objects. The wizard stores everything as raw Maps for flexibility
  /// between steps, but the preview needs typed instances.
  Venue? _safeVenue(Map? m) {
    if (m == null) return null;
    try {
      return Venue(
        name: m['name'] as String? ?? '',
        address: m['address'] as String? ?? '',
        mapUrl: m['mapUrl'] as String? ?? '',
      );
    } catch (_) {
      return null; // Preview should never crash on partial data
    }
  }

  FamilyInfo? _safeFamily(Map? m) {
    if (m == null) return null;
    try {
      return FamilyInfo(
        fatherName: m['fatherName'] as String? ?? '',
        motherName: m['motherName'] as String? ?? '',
        address: m['address'] as String? ?? '',
      );
    } catch (_) {
      return null;
    }
  }

  List<GalleryPhoto> _safeGallery(List? l) {
    if (l == null) return [];
    try {
      return (l.cast<Map<String, dynamic>>())
          .map((m) => GalleryPhoto(
                url: m['url'] as String,
                order: (m['order'] as int?) ?? 0,
              ))
          .toList();
    } catch (_) {
      return []; // Empty gallery is better than a crash
    }
  }

  List<TimelineEvent> _safeTimeline(List? l) {
    if (l == null) return [];
    try {
      return (l.cast<Map<String, dynamic>>())
          .map((m) => TimelineEvent(
                title: m['title'] as String? ?? '',
                date: (m['date'] as DateTime?) ?? DateTime.now(),
                description: m['description'] as String? ?? '',
              ))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Falls back to placeholder text for any field the user hasn't
  /// filled in yet so the preview is still useful.
  ///
  /// This safely converts raw Maps from the wizard into typed objects before
  /// passing them to the [Wedding] constructor. If conversion fails, we
  /// return null or empty values so the preview always renders.
  Wedding _materialize(Map<String, dynamic> d) {
    return Wedding(
      id: 'preview',
      userId: 'preview',
      slug: (d['slug'] as String?) ?? 'your-wedding',
      groomName: (d['groomName'] as String?) ?? 'Aarav',
      brideName: (d['brideName'] as String?) ?? 'Diya',
      groomPhoto: d['groomPhoto'] as String?,
      bridePhoto: d['bridePhoto'] as String?,
      couplePhoto: d['couplePhoto'] as String?,
      weddingDate: (d['weddingDate'] as DateTime?) ??
          DateTime.now().add(const Duration(days: 90)),
      weddingTime: (d['weddingTime'] as String?) ?? '10:00 AM',
      venue: _safeVenue(d['venue'] as Map?),
      invitationMessage: d['invitationMessage'] as String?,
      coupleStory: d['coupleStory'] as String?,
      timeline: _safeTimeline(d['timeline'] as List?),
      galleryPhotos: _safeGallery(d['galleryPhotos'] as List?),
      engagementPhotos: _safeGallery(d['engagementPhotos'] as List?),
      brideFamily: _safeFamily(d['brideFamily'] as Map?),
      groomFamily: _safeFamily(d['groomFamily'] as Map?),
      templateId: templateId,
      isPublished: false,
      isDraft: true,
      isRsvpEnabled: true,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// SHARED HELPERS
// ═══════════════════════════════════════════════════════════════════

class _SectionWrap extends StatelessWidget {
  final TemplateTheme t;
  final Color? bg;
  final Widget child;
  const _SectionWrap({
    required this.t,
    required this.child,
    this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: bg ?? t.bg,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      child: child,
    );
  }
}

class _Eyebrow extends StatelessWidget {
  final TemplateTheme t;
  final String text;
  const _Eyebrow(this.t, this.text);
  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Inter',
        color: t.muted,
        fontSize: 9,
        letterSpacing: 3,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  final TemplateTheme t;
  final String text;
  final double size;
  const _Heading(this.t, this.text, {this.size = 22});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: t.displayFont,
        fontSize: size,
        color: t.ink,
        height: 1.15,
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final TemplateTheme t;
  const _Divider(this.t);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Expanded(child: Container(height: 1, color: t.accent.withValues(alpha: 0.5))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('◆', style: TextStyle(color: t.primary, fontSize: 11)),
          ),
          Expanded(child: Container(height: 1, color: t.accent.withValues(alpha: 0.5))),
        ],
      ),
    );
  }
}

class _PlaceholderPhoto extends StatelessWidget {
  final double size;
  final IconData icon;
  final TemplateTheme t;
  const _PlaceholderPhoto({required this.size, required this.icon, required this.t});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: t.surface,
        shape: BoxShape.circle,
        border: Border.all(color: t.accent, width: 2),
      ),
      child: Icon(icon, color: t.primary.withValues(alpha: 0.4), size: size * 0.35),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// SECTIONS
// ═══════════════════════════════════════════════════════════════════

class _HeroSection extends StatelessWidget {
  final TemplateTheme t;
  final Wedding w;
  const _HeroSection({required this.t, required this.w});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [t.surface, t.bg],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        children: [
          Text(
            'TOGETHER WITH THEIR FAMILIES',
            style: TextStyle(
              fontFamily: 'Inter',
              color: t.muted,
              fontSize: 9,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            w.groomName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: t.displayFont,
              fontSize: 32,
              color: t.ink,
              height: 1.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              '&',
              style: TextStyle(
                fontFamily: t.displayFont,
                fontSize: 22,
                color: t.primary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Text(
            w.brideName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: t.displayFont,
              fontSize: 32,
              color: t.ink,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'are getting married',
            style: TextStyle(
              fontFamily: t.bodyFont,
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: t.muted,
            ),
          ),
          const SizedBox(height: 14),
          _Divider(t),
          const SizedBox(height: 10),
          Text(
            _formatDate(w.weddingDate),
            style: TextStyle(
              fontFamily: t.bodyFont,
              color: t.ink,
              fontSize: 14,
              letterSpacing: 1.5,
            ),
          ),
          if (w.weddingTime != null) ...[
            const SizedBox(height: 4),
            Text(
              w.weddingTime!,
              style: TextStyle(fontFamily: t.bodyFont, color: t.muted, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}

class _CoupleSection extends StatelessWidget {
  final TemplateTheme t;
  final Wedding w;
  const _CoupleSection({required this.t, required this.w});

  @override
  Widget build(BuildContext context) {
    return _SectionWrap(
      t: t,
      bg: t.bg,
      child: Column(
        children: [
          _Eyebrow(t, 'The Couple'),
          const SizedBox(height: 8),
          _Heading(t, 'Bride & Groom', size: 24),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(child: _Person(t: t, name: w.groomName, photo: w.groomPhoto, side: 'groom')),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text('&', style: TextStyle(fontFamily: t.displayFont, fontSize: 22, color: t.primary)),
              ),
              Expanded(child: _Person(t: t, name: w.brideName, photo: w.bridePhoto, side: 'bride')),
            ],
          ),
        ],
      ),
    );
  }
}

class _Person extends StatelessWidget {
  final TemplateTheme t;
  final String name;
  final String? photo;
  final String side;
  const _Person({required this.t, required this.name, required this.photo, required this.side});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (photo != null && photo!.isNotEmpty)
          ClipOval(
            child: Image.network(
              photo!,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _PlaceholderPhoto(size: 80, icon: Icons.person_outline, t: t),
            ),
          )
        else
          _PlaceholderPhoto(size: 80, icon: side == 'groom' ? Icons.person_outline : Icons.face_3_outlined, t: t),
        const SizedBox(height: 10),
        Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: t.bodyFont,
            fontWeight: FontWeight.w500,
            color: t.ink,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _OurStorySection extends StatelessWidget {
  final TemplateTheme t;
  final Wedding w;
  const _OurStorySection({required this.t, required this.w});
  @override
  Widget build(BuildContext context) {
    return _SectionWrap(
      t: t,
      bg: t.surface,
      child: Column(
        children: [
          _Eyebrow(t, 'Our Story'),
          const SizedBox(height: 8),
          _Heading(t, 'How we met', size: 22),
          const SizedBox(height: 14),
          Text(
            w.coupleStory!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: t.bodyFont,
              color: t.ink,
              fontSize: 13,
              fontStyle: FontStyle.italic,
              height: 1.65,
            ),
          ),
          _Divider(t),
          Text(
            'with love, ${w.groomName} & ${w.brideName}',
            style: TextStyle(
              fontFamily: t.bodyFont,
              fontStyle: FontStyle.italic,
              color: t.muted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _FamilySection extends StatelessWidget {
  final TemplateTheme t;
  final Wedding w;
  const _FamilySection({required this.t, required this.w});

  @override
  Widget build(BuildContext context) {
    final hasGroom = w.groomFamily != null;
    final hasBride = w.brideFamily != null;
    if (!hasGroom && !hasBride) {
      return _SectionWrap(
        t: t,
        child: Column(
          children: [
            _Eyebrow(t, 'Family'),
            const SizedBox(height: 8),
            _Heading(t, 'Our Families', size: 20),
            const SizedBox(height: 12),
            Text(
              'Add family details to see this section come alive.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: t.bodyFont,
                color: t.muted,
                fontStyle: FontStyle.italic,
                fontSize: 11,
              ),
            ),
          ],
        ),
      );
    }
    return _SectionWrap(
      t: t,
      child: Column(
        children: [
          _Eyebrow(t, 'Family'),
          const SizedBox(height: 8),
          _Heading(t, 'Our Families', size: 22),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasGroom)
                Expanded(
                  child: _FamilyCol(
                    t: t,
                    label: 'Groom',
                    family: w.groomFamily!,
                    photo: w.groomPhoto,
                  ),
                ),
              if (hasBride)
                Expanded(
                  child: _FamilyCol(
                    t: t,
                    label: 'Bride',
                    family: w.brideFamily!,
                    photo: w.bridePhoto,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FamilyCol extends StatelessWidget {
  final TemplateTheme t;
  final String label;
  final FamilyInfo family;
  final String? photo;
  const _FamilyCol({required this.t, required this.label, required this.family, required this.photo});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (photo != null && photo!.isNotEmpty)
          ClipOval(
            child: Image.network(
              photo!,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _PlaceholderPhoto(size: 60, icon: Icons.person_outline, t: t),
            ),
          )
        else
          _PlaceholderPhoto(size: 60, icon: Icons.person_outline, t: t),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontFamily: t.displayFont,
            fontSize: 11,
            letterSpacing: 2,
            color: t.muted,
          ),
        ),
        if (family.fatherName != null || family.motherName != null) ...[
          const SizedBox(height: 4),
          Text(
            [family.fatherName, family.motherName].whereType<String>().join(' & '),
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: t.bodyFont, color: t.ink, fontSize: 12),
          ),
        ],
      ],
    );
  }
}

class _EventsSection extends StatelessWidget {
  final TemplateTheme t;
  final Wedding w;
  const _EventsSection({required this.t, required this.w});

  @override
  Widget build(BuildContext context) {
    final events = w.timeline.isNotEmpty
        ? w.timeline
        : [
            TimelineEvent(
              title: 'Muhurtham',
              date: w.weddingDate,
              
            ),
          ];
    return _SectionWrap(
      t: t,
      bg: t.surface,
      child: Column(
        children: [
          _Eyebrow(t, 'Schedule'),
          const SizedBox(height: 8),
          _Heading(t, 'Events', size: 22),
          const SizedBox(height: 18),
          for (final e in events.take(3)) _EventRow(t: t, event: e, w: w),
        ],
      ),
    );
  }
}

class _EventRow extends StatelessWidget {
  final TemplateTheme t;
  final TimelineEvent event;
  final Wedding w;
  const _EventRow({required this.t, required this.event, required this.w});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: t.bg,
        border: Border(left: BorderSide(color: t.primary, width: 3)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.title,
            style: TextStyle(
              fontFamily: t.displayFont,
              color: t.ink,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.calendar_today_rounded, size: 10, color: t.muted),
              const SizedBox(width: 4),
              Text(
                _formatDate(event.date),
                style: TextStyle(color: t.muted, fontSize: 10),
              ),
              if (w.venue?.name != null) ...[
                const SizedBox(width: 10),
                Icon(Icons.place_outlined, size: 10, color: t.muted),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    w.venue!.name!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: t.muted, fontSize: 10),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _GallerySection extends StatelessWidget {
  final TemplateTheme t;
  final Wedding w;
  const _GallerySection({required this.t, required this.w});

  @override
  Widget build(BuildContext context) {
    return _SectionWrap(
      t: t,
      child: Column(
        children: [
          _Eyebrow(t, 'Memories'),
          const SizedBox(height: 8),
          _Heading(t, 'Gallery', size: 22),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            children: List.generate(6, (i) {
              return Container(
                color: t.surface,
                child: Icon(Icons.image_outlined, color: t.accent, size: 18),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _TravelSection extends StatelessWidget {
  final TemplateTheme t;
  final Wedding w;
  const _TravelSection({required this.t, required this.w});
  @override
  Widget build(BuildContext context) {
    return _SectionWrap(
      t: t,
      bg: t.surface,
      child: Column(
        children: [
          _Eyebrow(t, 'Getting There'),
          const SizedBox(height: 8),
          _Heading(t, 'Travel & Venue', size: 22),
          const SizedBox(height: 14),
          if (w.venue?.name != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: t.bg,
                border: Border.all(color: t.accent),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.place_outlined, color: t.primary, size: 14),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          w.venue!.name!,
                          style: TextStyle(
                            fontFamily: t.bodyFont,
                            color: t.ink,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (w.venue?.address != null) ...[
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        w.venue!.address!,
                        style: TextStyle(color: t.muted, fontSize: 11),
                      ),
                    ),
                  ],
                ],
              ),
            )
          else
            Text(
              'Add a venue to see it here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: t.muted, fontSize: 11, fontStyle: FontStyle.italic),
            ),
        ],
      ),
    );
  }
}

class _GiftSection extends StatelessWidget {
  final TemplateTheme t;
  final Wedding w;
  const _GiftSection({required this.t, required this.w});
  @override
  Widget build(BuildContext context) {
    return _SectionWrap(
      t: t,
      child: Column(
        children: [
          _Eyebrow(t, 'Wedding Gift'),
          const SizedBox(height: 8),
          _Heading(t, 'Gift Registry', size: 22),
          const SizedBox(height: 12),
          Text(
            'Your presence is the greatest gift. If you wish to give, a small contribution toward our new beginning is warmly welcomed.',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: t.bodyFont, color: t.ink, fontSize: 12, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _WishesSection extends StatelessWidget {
  final TemplateTheme t;
  final Wedding w;
  const _WishesSection({required this.t, required this.w});
  @override
  Widget build(BuildContext context) {
    return _SectionWrap(
      t: t,
      bg: t.surface,
      child: Column(
        children: [
          _Eyebrow(t, 'Wishes'),
          const SizedBox(height: 8),
          _Heading(t, 'Leave a Wish', size: 22),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: t.bg,
              border: Border.all(color: t.accent),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _miniField(t, 'Your name'),
                const SizedBox(height: 8),
                _miniField(t, 'Your message', lines: 3),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: t.primary,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    'Send Wish',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: t.bg,
                      fontFamily: t.displayFont,
                      fontSize: 11,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniField(TemplateTheme t, String placeholder, {int lines = 1}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: lines > 1 ? 8 : 10),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: t.accent.withValues(alpha: 0.4)),
      ),
      child: Text(
        placeholder,
        style: TextStyle(
          fontFamily: t.bodyFont,
          color: t.muted,
          fontStyle: FontStyle.italic,
          fontSize: 11,
        ),
        maxLines: lines,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _FooterSection extends StatelessWidget {
  final TemplateTheme t;
  final Wedding w;
  const _FooterSection({required this.t, required this.w});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: t.bg,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Column(
        children: [
          Text(
            '— Thank you —',
            style: TextStyle(
              fontFamily: t.bodyFont,
              color: t.muted,
              fontSize: 10,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${w.groomName} & ${w.brideName}',
            style: TextStyle(
              fontFamily: t.displayFont,
              color: t.primary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// HELPERS
// ═══════════════════════════════════════════════════════════════════

String _formatDate(DateTime? d) {
  if (d == null) return 'Saturday, December 12, 2026';
  const months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  return '${days[d.weekday - 1]}, ${months[d.month - 1]} ${d.day}, ${d.year}';
}
