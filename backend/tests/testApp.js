/**
 * Test app — a small Express app that mirrors the public slug route in
 * src/app.js but lets us inject the wedding record directly instead of
 * going through MongoDB. Used for render/SEO/XSS tests.
 *
 * We mount the same `views/` directory and same `public/` directory the
 * real app uses, so the templates are byte-for-byte identical.
 */
const express = require('express');
const path = require('path');

function createTestApp() {
  const app = express();
  app.set('view engine', 'ejs');
  app.set('views', path.join(__dirname, '..', 'src', 'views'));
  app.use(express.static(path.join(__dirname, '..', 'src', 'public')));

  // Stub the wedding service so we don't need MongoDB for render tests.
  const stubs = { wedding: null, error: null };
  app.locals.stubs = stubs;

  app.get('/:slug', async (req, res, next) => {
    const { slug } = req.params;
    if (stubs.error) return next(stubs.error);
    if (!stubs.wedding || stubs.wedding.slug !== slug) {
      const err = new Error('Wedding page not found');
      err.statusCode = 404;
      return next(err);
    }
    const wedding = stubs.wedding;
    return res.render('layouts/base', {
      wedding,
      title: wedding.metaTitle || `${wedding.groomName} & ${wedding.brideName}'s Wedding`,
      description: wedding.metaDescription || wedding.invitationMessage || '',
      ogImage: wedding.ogImage || wedding.couplePhoto || '',
      baseUrl: 'http://localhost:3000',
    });
  });

  // 404 page
  app.use((err, req, res, next) => {
    if (err && err.statusCode === 404) {
      return res.status(404).render('404', { title: 'Page Not Found' });
    }
    return res.status(500).send(err.message);
  });

  return app;
}

module.exports = { createTestApp };
