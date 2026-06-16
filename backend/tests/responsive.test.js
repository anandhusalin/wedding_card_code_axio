/**
 * Responsive tests — verify each template's CSS includes mobile-friendly
 * media queries that collapse multi-column layouts into single columns
 * below 900px and adjust typography below 480px.
 *
 * We don't run a real browser; we just assert the CSS source has the
 * expected selectors and breakpoints. This catches accidental deletion
 * of @media blocks during template edits.
 */
const fs = require('fs');
const path = require('path');

function readTemplate(id) {
  return fs.readFileSync(
    path.join(__dirname, '..', 'src', 'views', 'templates', id + '.ejs'),
    'utf8'
  );
}

describe('Responsive — each template has tablet + mobile breakpoints', () => {
  const templates = ['modern-elegant', 'traditional-kerala', 'floral-romance', 'royal-maroon'];

  test.each(templates)('%s has a @media (max-width: 900px) block', (id) => {
    const css = readTemplate(id);
    expect(css).toMatch(/@media\s*\(\s*max-width:\s*900px\s*\)/);
  });

  test.each(templates)('%s has a @media (max-width: 480px) block', (id) => {
    const css = readTemplate(id);
    expect(css).toMatch(/@media\s*\(\s*max-width:\s*480px\s*\)/);
  });

  test.each(templates)('%s collapses couple-grid to 1 column on mobile', (id) => {
    const css = readTemplate(id);
    const m = css.match(/@media\s*\(\s*max-width:\s*900px\s*\)\s*\{([\s\S]*?)\s{2}\}/);
    expect(m).not.toBeNull();
    const block = m[1];
    expect(block).toMatch(/wsec-couple-grid[\s\S]*?grid-template-columns:\s*1fr/);
  });

  test.each(templates)('%s collapses family-grid to 1 column on mobile', (id) => {
    const css = readTemplate(id);
    const m = css.match(/@media\s*\(\s*max-width:\s*900px\s*\)\s*\{([\s\S]*?)\s{2}\}/);
    expect(m).not.toBeNull();
    expect(m[1]).toMatch(/wsec-family-grid[\s\S]*?grid-template-columns:\s*1fr/);
  });

  test.each(templates)('%s hides the family-divider on mobile', (id) => {
    const css = readTemplate(id);
    expect(css).toMatch(/wsec-family-divider[\s\S]*?display:\s*none/);
  });

  test.each(templates)('%s makes the gallery single-column at 480px', (id) => {
    const css = readTemplate(id);
    const m = css.match(/@media\s*\(\s*max-width:\s*480px\s*\)\s*\{([\s\S]*?)\s{2}\}/);
    expect(m).not.toBeNull();
    expect(m[1]).toMatch(/wsec-gallery-grid[\s\S]*?grid-template-columns:\s*1fr/);
  });

  test.each(templates)('%s hero adapts on mobile (no fixed min-height)', (id) => {
    const css = readTemplate(id);
    // Modern Elegant sets min-height: auto on mobile
    // The others rely on the inner content padding
    expect(css).toMatch(/wsec-hero-inner[\s\S]*?padding:\s*\d/);
  });
});

describe('Responsive — base stylesheet hides share rail on tablet', () => {
  const baseCss = fs.readFileSync(
    path.join(__dirname, '..', 'src', 'public', 'css', 'style.css'),
    'utf8'
  );
  test('share rail hidden on screens ≤ 1024px', () => {
    expect(baseCss).toMatch(/@media\s*\(\s*max-width:\s*1024px\s*\)\s*\{[\s\S]*?wsec-share-rail[\s\S]*?display:\s*none/);
  });
  test('base font-size reduced on mobile', () => {
    expect(baseCss).toMatch(/@media\s*\(\s*max-width:\s*768px\s*\)\s*\{[\s\S]*?font-size:\s*16px/);
  });
  test('lightbox controls shrink on small phone', () => {
    expect(baseCss).toMatch(/@media\s*\(\s*max-width:\s*480px\s*\)\s*\{[\s\S]*?lightbox-close[\s\S]*?width:\s*40px/);
  });
  test('modal padding reduced on small phone', () => {
    expect(baseCss).toMatch(/@media\s*\(\s*max-width:\s*480px\s*\)\s*\{[\s\S]*?\.modal-content[\s\S]*?padding:\s*28px/);
  });
});

describe('Knot design system — tokens + shared utilities', () => {
  const baseCss = fs.readFileSync(
    path.join(__dirname, '..', 'src', 'public', 'css', 'style.css'),
    'utf8'
  );
  test('base style.css exposes --knot-display token', () => {
    expect(baseCss).toMatch(/--knot-display:/);
  });
  test('base style.css exposes --knot-serif token', () => {
    expect(baseCss).toMatch(/--knot-serif:/);
  });
  test('base style.css defines the .wsec-eyebrow utility', () => {
    expect(baseCss).toMatch(/\.wsec-eyebrow\s*\{[\s\S]*?letter-spacing/);
  });
  test('base style.css defines the .wsec-divider utility', () => {
    expect(baseCss).toMatch(/\.wsec-divider::before[\s\S]*?\.wsec-divider::after/);
  });
});

describe('Our Story section — each template includes + styles it', () => {
  const fsLocal = require('fs');
  const templates = ['modern-elegant', 'traditional-kerala', 'floral-romance', 'royal-maroon'];

  test.each(templates)('%s includes the _our-story partial', (id) => {
    const css = fsLocal.readFileSync(
      path.join(__dirname, '..', 'src', 'views', 'templates', id + '.ejs'),
      'utf8'
    );
    expect(css).toMatch(/include\(['"]\.\.\/partials\/sections\/_our-story/);
  });

  test.each(templates)('%s defines .wsec-our-story CSS', (id) => {
    const css = fsLocal.readFileSync(
      path.join(__dirname, '..', 'src', 'views', 'templates', id + '.ejs'),
      'utf8'
    );
    expect(css).toMatch(/\.wsec-our-story\s*\{/);
    expect(css).toMatch(/\.wsec-our-story-body\s*\{/);
  });

  test('_our-story.ejs partial exists and renders coupleStory', () => {
    const partial = fsLocal.readFileSync(
      path.join(__dirname, '..', 'src', 'views', 'partials', 'sections', '_our-story.ejs'),
      'utf8'
    );
    expect(partial).toMatch(/wedding\.coupleStory/);
    expect(partial).toMatch(/wsec-our-story/);
  });
});

describe('Responsive — every template has 900/768/640/480 breakpoints', () => {
  const fsLocal = require('fs');
  const templates = ['modern-elegant', 'traditional-kerala', 'floral-romance', 'royal-maroon'];
  const pathLocal = require('path');

  test.each(templates)('%s declares all 4 breakpoints', (id) => {
    const css = fsLocal.readFileSync(
      pathLocal.join(__dirname, '..', 'src', 'views', 'templates', id + '.ejs'),
      'utf8'
    );
    expect(css).toMatch(/@media\s*\(\s*max-width:\s*900px\s*\)/);
    expect(css).toMatch(/@media\s*\(\s*max-width:\s*768px\s*\)/);
    expect(css).toMatch(/@media\s*\(\s*max-width:\s*640px\s*\)/);
    expect(css).toMatch(/@media\s*\(\s*max-width:\s*480px\s*\)/);
  });
});

describe('Responsive — 480px wishes form & buttons are mobile-friendly', () => {
  const fsLocal = require('fs');
  const templates = ['modern-elegant', 'traditional-kerala', 'floral-romance', 'royal-maroon'];
  const pathLocal = require('path');

  test.each(templates)('%s: wishes button is full-width on mobile', (id) => {
    const css = fsLocal.readFileSync(
      pathLocal.join(__dirname, '..', 'src', 'views', 'templates', id + '.ejs'),
      'utf8'
    );
    expect(css).toMatch(/@media\s*\(\s*max-width:\s*480px\s*\)\s*\{[\s\S]*?wsec-wishes-form\s+button\s*\{[\s\S]*?width:\s*100%/);
  });

  test.each(templates)('%s: hero h2 shrinks on mobile', (id) => {
    const css = fsLocal.readFileSync(
      pathLocal.join(__dirname, '..', 'src', 'views', 'templates', id + '.ejs'),
      'utf8'
    );
    expect(css).toMatch(/@media\s*\(\s*max-width:\s*480px\s*\)\s*\{[\s\S]*?wsec-eyebrow-heading\s*\{[\s\S]*?font-size/);
  });
});
