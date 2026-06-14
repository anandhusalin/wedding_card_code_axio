/**
 * Test fixtures — a complete wedding record suitable for rendering,
 * plus variants for "missing fields" / "edge case" tests.
 *
 * This file does NOT import mongoose — that would drag in bson ESM
 * which Jest can't parse without Babel. ObjectId is faked for tests.
 */

/** Minimal ObjectId mock — tests only ever call .toString() or .toString() */
function ObjectId(id = '') {
  if (id) return { toString: () => id, valueOf: () => id };
  const hex = Math.random().toString(16).slice(2) + Math.random().toString(16).slice(2);
  return { toString: () => hex, valueOf: () => hex };
}
ObjectId.prototype = ObjectId.prototype || {};

function makeWedding(overrides = {}) {
  const now = new Date();
  const future = new Date(now.getTime() + 1000 * 60 * 60 * 24 * 60); // 60 days out
  return {
    _id: new ObjectId(),
    slug: 'arun-and-priya',
    groomName: 'Arun Kumar',
    brideName: 'Priya Nair',
    weddingDate: future,
    weddingTime: '10:30 AM',
    venue: {
      name: 'Sree Krishna Temple Hall',
      address: 'MG Road, Kochi, Kerala 682001',
      mapUrl: 'https://maps.google.com/?q=Sree+Krishna+Temple+Kochi',
    },
    couplePhoto: 'https://res.cloudinary.com/test/image/upload/v1/couple.jpg',
    engagementPhotos: [
      { url: 'https://res.cloudinary.com/test/image/upload/v1/eng1.jpg', caption: 'First look' },
      { url: 'https://res.cloudinary.com/test/image/upload/v1/eng2.jpg', caption: '' },
    ],
    galleryPhotos: [
      { url: 'https://res.cloudinary.com/test/image/upload/v1/g1.jpg', caption: 'Pre-wedding' },
      { url: 'https://res.cloudinary.com/test/image/upload/v1/g2.jpg', caption: 'Family' },
      { url: 'https://res.cloudinary.com/test/image/upload/v1/g3.jpg', caption: '' },
    ],
    invitationMessage: 'Together with their families, we invite you to celebrate our wedding.',
    story: 'We met at a music festival in Bangalore and have been inseparable since.',
    brideParents: { fatherName: 'Raghavan Nair', motherName: 'Lakshmi Nair' },
    groomParents: { fatherName: 'Suresh Kumar', motherName: 'Vasanthi Kumari' },
    family: {
      bride: { fatherName: 'Raghavan Nair', motherName: 'Lakshmi Nair', photo: 'https://res.cloudinary.com/test/image/upload/v1/bride-family.jpg' },
      groom: { fatherName: 'Suresh Kumar', motherName: 'Vasanthi Kumari', photo: 'https://res.cloudinary.com/test/image/upload/v1/groom-family.jpg' },
    },
    timeline: [
      { title: 'Wedding Ceremony', date: future, description: 'Join us for the traditional Kerala wedding ceremony.' },
      { title: 'Reception',        date: new Date(future.getTime() + 86400000), description: 'Dinner, music, and dancing.' },
    ],
    travel: {
      venueMapEmbed: 'https://www.google.com/maps/embed?pb=test',
      notes: 'Free parking available at the venue.',
      hotels: [
        { name: 'Hotel Abad Plaza', address: 'MG Road, Kochi', distance: '1.2 km', phone: '+914842345678' },
        { name: 'The Avenue Center', address: 'Marine Drive, Kochi', distance: '2.5 km', phone: '+914846677889' },
      ],
    },
    giftRegistry: [
      { label: 'UPI / GPay', url: 'arunpriya@upi', note: 'UPI ID' },
      { label: 'Amazon Wedding List', url: 'https://amazon.in/wedding/arun-priya', note: '' },
      { label: 'Wedsite Honeymoon Fund', url: 'https://wedsite.com/arun-priya', note: '' },
    ],
    musicUrl: 'https://res.cloudinary.com/test/audio/upload/v1/song.mp3',
    isRsvpEnabled: true,
    isPublished: true,
    language: 'en',
    templateId: 'traditional-kerala',
    theme: { primaryColor: '#D4A574', mode: 'light', fontFamily: 'Cormorant Garamond' },
    metaTitle: 'Arun & Priya — Wedding Invitation',
    metaDescription: 'Join us for the wedding of Arun & Priya on ' + future.toDateString(),
    ogImage: 'https://res.cloudinary.com/test/image/upload/v1/og.jpg',
    rsvps: [],
    userId: { _id: new ObjectId(), plan: 'pro' },
    createdAt: now,
    updatedAt: now,
    ...overrides,
  };
}

/** A minimal wedding — only the required-by-template fields. */
function makeMinimalWedding(overrides = {}) {
  return makeWedding({
    weddingTime: undefined,
    venue: undefined,
    couplePhoto: undefined,
    engagementPhotos: undefined,
    galleryPhotos: undefined,
    invitationMessage: undefined,
    story: undefined,
    brideParents: undefined,
    groomParents: undefined,
    family: undefined,
    timeline: undefined,
    travel: undefined,
    giftRegistry: undefined,
    musicUrl: undefined,
    isRsvpEnabled: false,
    metaTitle: undefined,
    metaDescription: undefined,
    ogImage: undefined,
    userId: undefined,
    ...overrides,
  });
}

module.exports = { makeWedding, makeMinimalWedding };
