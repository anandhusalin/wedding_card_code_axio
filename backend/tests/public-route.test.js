/**
 * Public-route tests — exercise the real Express app (src/app.js) end-to-end
 * against an in-memory MongoDB. These cover the public slug route's
 * full request lifecycle: lookup, increment viewCount, render layout.
 */
const request = require('supertest');
const { setupDb, teardownDb, clearDb } = require('./setup');
const { makeWedding } = require('./helpers');

/** Make a valid user — schema requires email, password, displayName. */
function makeUser(overrides = {}) {
  return { email: 'a@b.com', password: 'long-enough', displayName: 'Test User', ...overrides };
}

/** Build a Wedding record that mongoose@7 can save — uses a real user _id. */
function makeWeddingForDb(user, overrides = {}) {
  return {
    ...makeWedding(overrides),
    _id: undefined,            // let mongoose assign
    userId: user._id,         // real ObjectId, not the fake one in helpers
  };
}

let app, Wedding, User;

beforeAll(async () => {
  await setupDb();
  // Require the app first; app.js doesn't connect to mongo itself (it relies
  // on the connection setupDb just made), so no need to resetModules.
  app = require('../src/app');
  Wedding = require('../src/models/Wedding');
  User = require('../src/models/User');
});

afterAll(async () => { await teardownDb(); });
afterEach(async () => { await clearDb(); });

describe('Public route — GET /:slug', () => {
  test('published wedding renders 200 with the names', async () => {
    const user = await User.create(makeUser({ plan: 'pro' }));
    await Wedding.create(makeWeddingForDb(user, { slug: 'live' }));

    const res = await request(app).get('/live').expect(200);
    expect(res.text).toContain('Arun Kumar');
    expect(res.text).toContain('Priya Nair');
  });

  test('increments viewCount on each visit', async () => {
    const user = await User.create(makeUser({ plan: 'pro' }));
    const w = await Wedding.create(makeWeddingForDb(user, { slug: 'views' }));

    await request(app).get('/views');
    await request(app).get('/views');
    await request(app).get('/views');

    const fresh = await Wedding.findById(w._id);
    expect(fresh.viewCount).toBe(3);
  });

  test('unpublished wedding returns 404', async () => {
    const user = await User.create(makeUser({ plan: 'pro' }));
    await Wedding.create(makeWeddingForDb(user, { slug: 'draft', isPublished: false }));

    const res = await request(app).get('/draft').expect(404);
    expect(res.text).toMatch(/404/);
  });

  test('non-existent slug returns 404', async () => {
    const res = await request(app).get('/this-does-not-exist').expect(404);
  });

  test('free-tier user shows the free badge wrap', async () => {
    const user = await User.create(makeUser({ plan: 'free' }));
    await Wedding.create(makeWeddingForDb(user, { slug: 'free-tier' }));

    const res = await request(app).get('/free-tier').expect(200);
    expect(res.text).toMatch(/wsec-free-badge-wrap/);
  });

  test('pro user hides the free badge wrap', async () => {
    const user = await User.create(makeUser({ plan: 'pro' }));
    await Wedding.create(makeWeddingForDb(user, { slug: 'pro-tier' }));

    const res = await request(app).get('/pro-tier').expect(200);
    expect(res.text).not.toMatch(/wsec-free-badge-wrap/);
  });

  test('RSVP modal is included when isRsvpEnabled', async () => {
    const user = await User.create(makeUser({ plan: 'pro' }));
    await Wedding.create(makeWeddingForDb(user, { slug: 'rsvp-on', isRsvpEnabled: true }));
    const res = await request(app).get('/rsvp-on').expect(200);
    expect(res.text).toContain('id="rsvpModal"');
  });

  test('RSVP modal is omitted when isRsvpEnabled is false', async () => {
    const user = await User.create(makeUser({ plan: 'pro' }));
    await Wedding.create(makeWeddingForDb(user, { slug: 'rsvp-off', isRsvpEnabled: false }));
    const res = await request(app).get('/rsvp-off').expect(200);
    expect(res.text).not.toContain('id="rsvpModal"');
  });
});

describe('Public route — health & static', () => {
  test('GET /api/v1/health returns ok', async () => {
    const res = await request(app).get('/api/v1/health').expect(200);
    expect(res.body.success).toBe(true);
    expect(res.body.data.status).toBe('ok');
  });

  test('GET /css/style.css returns the base stylesheet', async () => {
    const res = await request(app).get('/css/style.css').expect(200);
    expect(res.headers['content-type']).toMatch(/css/);
    expect(res.text).toContain('Design tokens');
  });

  test('GET /js/main.js returns the client script', async () => {
    const res = await request(app).get('/js/main.js').expect(200);
    expect(res.headers['content-type']).toMatch(/javascript/);
    expect(res.text).toContain('Wedding Cards');
  });
});
