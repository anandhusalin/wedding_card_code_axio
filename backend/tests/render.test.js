/**
 * Render tests — verify each template renders to HTML without errors
 * and contains the expected structure for the given wedding record.
 *
 * Render tests don't need MongoDB — they use a stubbed wedding service
 * via tests/testApp.js. So we don't import setup.js here.
 */
const request = require('supertest');
const { createTestApp } = require('./testApp');
const { makeWedding } = require('./helpers');

const TEMPLATES = [
  'modern-elegant',
  'traditional-kerala',
  'floral-romance',
  'royal-maroon',
];

describe('Render — each template renders without error', () => {
  let app;
  beforeAll(() => { app = createTestApp(); });

  test.each(TEMPLATES)('%s renders 200 with the full wedding payload', async (templateId) => {
    const wedding = makeWedding({ templateId, slug: `slug-${templateId}` });
    app.locals.stubs.wedding = wedding;

    const res = await request(app).get('/' + wedding.slug).expect(200);
    expect(res.headers['content-type']).toMatch(/text\/html/);

    const html = res.text;
    // Names appear
    expect(html).toContain('Arun Kumar');
    expect(html).toContain('Priya Nair');
    // Hero names section
    expect(html).toMatch(/class="[^"]*wsec-names/);
    // Body section structure
    expect(html).toMatch(/<main[\s>]/);
    // Floating UI shell
    expect(html).toMatch(/wsec-share-rail|wsec-music-toggle/);
  });

  test('each template exposes a unique class on its wrapper', async () => {
    for (const t of TEMPLATES) {
      const w = makeWedding({ templateId: t, slug: `wrap-${t}` });
      app.locals.stubs.wedding = w;
      const res = await request(app).get('/' + w.slug).expect(200);
      expect(res.text).toMatch(new RegExp(`class="[^"]*${t}-template`));
    }
  });
});

describe('Render — section partials include all expected parts', () => {
  let app;
  beforeAll(() => { app = createTestApp(); });
  beforeEach(() => { app.locals.stubs.wedding = makeWedding({ slug: 'rich' }); });

  test('Couple section shows both names and their parents', async () => {
    const res = await request(app).get('/rich').expect(200);
    expect(res.text).toContain('Arun Kumar');
    expect(res.text).toContain('Priya Nair');
    expect(res.text).toContain('Raghavan Nair');
    expect(res.text).toContain('Suresh Kumar');
  });

  test('Family section shows parents and a divider', async () => {
    const res = await request(app).get('/rich').expect(200);
    expect(res.text).toMatch(/wsec-family/);
    expect(res.text).toMatch(/wsec-family-divider|wsec-family-list/);
  });

  test('Events/timeline shows event titles and dates', async () => {
    const res = await request(app).get('/rich').expect(200);
    expect(res.text).toContain('Wedding Ceremony');
    expect(res.text).toContain('Reception');
  });

  test('Gallery renders all photos with captions', async () => {
    const res = await request(app).get('/rich').expect(200);
    expect(res.text).toContain('g1.jpg');
    expect(res.text).toContain('Pre-wedding');
    expect(res.text).toContain('Family');
  });

  test('Travel section shows map embed and hotels', async () => {
    const res = await request(app).get('/rich').expect(200);
    expect(res.text).toContain('maps/embed');
    expect(res.text).toContain('Hotel Abad Plaza');
    expect(res.text).toContain('1.2 km');
  });

  test('Gift registry renders copy buttons for UPI-style values and links for URLs', async () => {
    const res = await request(app).get('/rich').expect(200);
    // UPI — no http(s), should be a copy button
    expect(res.text).toMatch(/data-copy="arunpriya@upi"/);
    // URLs should be anchor links
    expect(res.text).toContain('https://amazon.in/wedding/arun-priya');
  });

  test('RSVP CTA appears when isRsvpEnabled is true', async () => {
    const res = await request(app).get('/rich').expect(200);
    expect(res.text).toMatch(/wsec-rsvp/);
    expect(res.text).toContain('openRsvpModal');
  });

  test('Footer shows both names and the wedding year', async () => {
    const res = await request(app).get('/rich').expect(200);
    expect(res.text).toMatch(/wsec-footer/);
    expect(res.text).toMatch(/wsec-footer-amp/);
  });
});

describe('Render — unknown slug returns 404 page', () => {
  test('404 page is rendered for an unknown slug', async () => {
    const app = createTestApp();
    app.locals.stubs.wedding = null;
    const res = await request(app).get('/no-such-wedding').expect(404);
    expect(res.text).toContain('404');
  });
});
