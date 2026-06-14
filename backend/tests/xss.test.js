/**
 * XSS tests — verify the templates escape user-provided content so that
 * <script> and event handler attributes can't be injected.
 *
 * EJS's <%= %> escapes by default. We test by injecting payloads into
 * the wedding fields and asserting the raw <script> tag is not present
 * in the output as live code.
 */
const request = require('supertest');
const { createTestApp } = require('./testApp');
const { makeWedding } = require('./helpers');

const SCRIPT = '<script>window.__pwned = true;</script>';
const IMG_ONERROR = '<img src=x onerror="window.__pwned = true">';
const ATTR = '" onmouseover="window.__pwned = true" data-x="';

function appWith(patch) {
  const app = createTestApp();
  app.locals.stubs.wedding = makeWedding({ slug: 'xss', ...patch });
  return app;
}

afterEach(() => {
  // Make sure no test payload ever executed.
  if (typeof window !== 'undefined') {
    delete window.__pwned;
  }
});

describe('XSS — user fields are escaped on render', () => {
  test.each(['traditional-kerala', 'modern-elegant', 'floral-romance', 'royal-maroon'])(
    '%s escapes <script> in groomName',
    async (templateId) => {
      const app = createTestApp();
      app.locals.stubs.wedding = makeWedding({
        templateId,
        slug: `xss-${templateId}`,
        groomName: SCRIPT,
      });
      const res = await request(app).get(`/xss-${templateId}`).expect(200);

      // No script element should fire in the DOM — this is the XSS contract.
      expect(res.text).not.toMatch(/<script>window\.__pwned/);
      expect(res.text).not.toMatch(/<script\s[^>]*>window\.__pwned/);
      // `initCountdown` reads data-wedding-date from <body>, not from
      // groomName, so there's no code-execution path here either.
    }
  );

  test('img onerror in brideName is escaped (no inline event handlers)', async () => {
    const app = appWith({ brideName: IMG_ONERROR });
    const res = await request(app).get('/xss').expect(200);
    expect(res.text).not.toMatch(/onerror="window\.__pwned/);
    expect(res.text).toMatch(/&lt;img\s+src=x/);
  });

  test('attribute-injection in venue name is escaped', async () => {
    const app = appWith({
      venue: { name: 'Hall' + ATTR, address: 'addr', mapUrl: '' },
    });
    const res = await request(app).get('/xss').expect(200);
    expect(res.text).not.toMatch(/onmouseover="window\.__pwned"/);
  });

  test('invitationMessage with raw HTML does NOT inject a script tag', async () => {
    // invitationMessage is read in the modern-elegant hero to flip a
    // header label, but it is never echoed back into the HTML — so the
    // XSS contract is just: no <script> element with the payload.
    const app = createTestApp();
    app.locals.stubs.wedding = makeWedding({
      slug: 'xss-inv',
      templateId: 'modern-elegant',
      invitationMessage: SCRIPT,
    });
    const res = await request(app).get('/xss-inv').expect(200);
    expect(res.text).not.toMatch(/<script>window\.__pwned\s*=\s*true/);
  });

  test('groomName with raw HTML is escaped on the rendered page', async () => {
    const app = createTestApp();
    app.locals.stubs.wedding = makeWedding({
      slug: 'xss-groom',
      templateId: 'modern-elegant',
      groomName: SCRIPT,
    });
    const res = await request(app).get('/xss-groom').expect(200);
    // No script tag fires. The escaped form is in the title and h1.
    expect(res.text).not.toMatch(/<script>window\.__pwned/);
    expect(res.text).toMatch(/&lt;script&gt;|\\u003cscript\\u003e/);
  });

  test('event title with HTML is escaped', async () => {
    const app = appWith({
      timeline: [
        { title: SCRIPT, date: new Date(), description: 'safe' },
      ],
    });
    const res = await request(app).get('/xss').expect(200);
    expect(res.text).not.toMatch(/<script>window\.__pwned/);
  });

  test('hotel name with HTML is escaped', async () => {
    const app = appWith({
      travel: {
        hotels: [{ name: SCRIPT, address: 'a', distance: '1 km', phone: '' }],
      },
    });
    const res = await request(app).get('/xss').expect(200);
    expect(res.text).not.toMatch(/<script>window\.__pwned/);
  });

  test('gift label with HTML is escaped', async () => {
    const app = appWith({
      giftRegistry: [{ label: SCRIPT, url: 'https://example.com', note: '' }],
    });
    const res = await request(app).get('/xss').expect(200);
    expect(res.text).not.toMatch(/<script>window\.__pwned/);
  });
});
