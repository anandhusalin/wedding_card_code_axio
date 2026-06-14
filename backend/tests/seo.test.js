/**
 * SEO tests — verify the rendered HTML has the right title, description,
 * Open Graph, and language attributes.
 */
const request = require('supertest');
const { createTestApp } = require('./testApp');
const { makeWedding } = require('./helpers');

describe('SEO — title, description, Open Graph', () => {
  let app;
  beforeAll(() => { app = createTestApp(); });

  test('uses metaTitle when provided', async () => {
    app.locals.stubs.wedding = makeWedding({
      slug: 'seo-title',
      metaTitle: 'A & B — 2026 Wedding',
    });
    const res = await request(app).get('/seo-title').expect(200);
    // HTML escapes & and ', so "A & B" becomes "A &amp; B".
    expect(res.text).toMatch(/<title>\s*A &amp; B — 2026 Wedding\s*<\/title>/);
  });

  test('falls back to "<Groom> & <Bride>\'s Wedding" when metaTitle is missing', async () => {
    app.locals.stubs.wedding = makeWedding({
      slug: 'seo-fallback',
      metaTitle: undefined,
      groomName: 'Vikram',
      brideName: 'Anjali',
    });
    const res = await request(app).get('/seo-fallback').expect(200);
    expect(res.text).toMatch(/<title>\s*Vikram &amp; Anjali&#39;s Wedding\s*<\/title>/);
  });

  test('uses metaDescription when provided', async () => {
    app.locals.stubs.wedding = makeWedding({
      slug: 'seo-desc',
      metaDescription: 'A celebration of love on the Malabar coast',
    });
    const res = await request(app).get('/seo-desc').expect(200);
    expect(res.text).toMatch(/<meta\s+name="description"\s+content="A celebration of love on the Malabar coast"/);
  });

  test('falls back to invitationMessage when metaDescription is missing', async () => {
    app.locals.stubs.wedding = makeWedding({
      slug: 'seo-fb',
      metaDescription: undefined,
      invitationMessage: 'Join us for our wedding celebration',
    });
    const res = await request(app).get('/seo-fb').expect(200);
    expect(res.text).toMatch(/<meta\s+name="description"\s+content="Join us for our wedding celebration"/);
  });

  test('Open Graph tags are present with absolute URLs', async () => {
    app.locals.stubs.wedding = makeWedding({
      slug: 'seo-og',
      ogImage: 'https://cdn.example.com/og.jpg',
    });
    const res = await request(app).get('/seo-og').expect(200);
    expect(res.text).toMatch(/<meta\s+property="og:title"/);
    expect(res.text).toMatch(/<meta\s+property="og:image"\s+content="https:\/\/cdn\.example\.com\/og\.jpg"/);
    expect(res.text).toMatch(/<meta\s+property="og:url"\s+content="http:\/\/localhost:3000\/seo-og"/);
  });

  test('html lang attribute reflects the configured language', async () => {
    app.locals.stubs.wedding = makeWedding({ slug: 'seo-ml', language: 'ml' });
    const res = await request(app).get('/seo-ml').expect(200);
    expect(res.text).toMatch(/<html\s+lang="ml"/);
  });

  test('default language is "en"', async () => {
    app.locals.stubs.wedding = makeWedding({ slug: 'seo-en', language: undefined });
    const res = await request(app).get('/seo-en').expect(200);
    expect(res.text).toMatch(/<html\s+lang="en"/);
  });
});
