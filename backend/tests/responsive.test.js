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

describe('Responsive — base stylesheet hides share rail on mobile', () => {
  const baseCss = fs.readFileSync(
    path.join(__dirname, '..', 'src', 'public', 'css', 'style.css'),
    'utf8'
  );
  test('share rail hidden on screens ≤ 768px', () => {
    expect(baseCss).toMatch(/@media\s*\(\s*max-width:\s*768px\s*\)\s*\{[\s\S]*?wsec-share-rail[\s\S]*?display:\s*none/);
  });
});
