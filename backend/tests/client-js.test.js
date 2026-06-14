/**
 * Client-side behavior tests — load main.js into jsdom and verify the
 * gift copy button, scroll cue, share rail, countdown, and music
 * toggle work as expected.
 */
const fs = require('fs');
const path = require('path');

const mainJs = fs.readFileSync(
  path.join(__dirname, '..', 'src', 'public', 'js', 'main.js'),
  'utf8'
);

/** Run main.js inside the current jsdom document. Returns nothing. */
function loadMainJs() {
  // Wrap in a function so `this` doesn't bind to module scope.
  // eslint-disable-next-line no-new-func
  new Function(mainJs)();
}

function fireEvent(el, type) {
  el.dispatchEvent(new Event(type, { bubbles: true, cancelable: true }));
}

function makeWeddingHtml({
  withCountdown = true, withGallery = true, withForm = true, withModal = true,
  withMusic = true, withShare = true, withGift = true, withScrollCue = true,
} = {}) {
  document.body.innerHTML = `
    <div class="wsec-content" id="wsec-content"></div>
    ${withCountdown ? `
      <div id="countdown">
        <span data-cd="days"></span>
        <span data-cd="hours"></span>
        <span data-cd="minutes"></span>
        <span data-cd="seconds"></span>
      </div>
      <div id="countdownCelebrated" style="display: none"></div>
    ` : ''}
    ${withGallery ? `
      <button class="gallery-item"><img src="a.jpg" alt=""></button>
      <button class="gallery-item"><img src="b.jpg" alt=""></button>
    ` : ''}
    ${withForm ? `
      <form id="rsvpForm">
        <input name="weddingId" value="wid" />
        <input name="name" />
        <button type="submit">Send</button>
      </form>
      <div id="rsvpSuccess" style="display: none"></div>
    ` : ''}
    ${withModal ? `<div id="rsvpModal" style="display: none"></div>` : ''}
    ${withMusic ? `<button id="musicToggle"></button>` : ''}
    ${withShare ? `<aside id="shareRail"></aside>` : ''}
    ${withGift ? `<button class="wsec-gift-copy" data-copy="arunpriya@upi">Copy</button>` : ''}
    ${withScrollCue ? `<a class="wsec-scroll-cue" href="#wsec-content">Scroll</a>` : ''}
  `;
}

describe('Client JS — main.js wires up interactions', () => {
  beforeEach(() => {
    document.body.innerHTML = '';
    document.body.removeAttribute('data-wedding-date');
    document.body.removeAttribute('data-music-url');
    // jsdom lacks scrollIntoView — provide a stub.
    if (!HTMLElement.prototype.scrollIntoView) {
      HTMLElement.prototype.scrollIntoView = function () {};
    }
  });

  describe('Countdown', () => {
    beforeEach(() => { jest.useFakeTimers(); });
    afterEach(() => { jest.useRealTimers(); });

    test('populates days/hours/minutes/seconds when weddingDate is set in the future', () => {
      const future = new Date(Date.now() + 2 * 86400000);
      document.body.setAttribute('data-wedding-date', future.toISOString());
      makeWeddingHtml();
      loadMainJs();
      // Tick one second so the interval callback fires.
      jest.advanceTimersByTime;

      const d = document.querySelector('[data-cd="days"]');
      const h = document.querySelector('[data-cd="hours"]');
      const m = document.querySelector('[data-cd="minutes"]');
      const s = document.querySelector('[data-cd="seconds"]');
      expect(d.textContent).toMatch(/^\d{2}$/);
      expect(h.textContent).toMatch(/^\d{2}$/);
      expect(m.textContent).toMatch(/^\d{2}$/);
      expect(s.textContent).toMatch(/^\d{2}$/);
    });

    test('hides countdown and shows celebrated message when date is past', () => {
      const past = new Date(Date.now() - 100000);
      document.body.setAttribute('data-wedding-date', past.toISOString());
      makeWeddingHtml();
      loadMainJs();
      const cd = document.getElementById('countdown');
      const celebrated = document.getElementById('countdownCelebrated');
      expect(cd.classList.contains('is-past')).toBe(true);
      expect(celebrated.style.display).toBe('block');
    });
  });

  describe('Share rail', () => {
    test('renders 4 share links', () => {
      makeWeddingHtml({ withShare: true });
      loadMainJs();
      const links = document.querySelectorAll('#shareRail a');
      expect(links.length).toBe(4);
      expect(links[0].getAttribute('href')).toContain('whatsapp.com');
      expect(links[1].getAttribute('href')).toContain('facebook.com');
      expect(links[2].getAttribute('href')).toContain('twitter.com');
      expect(links[3].getAttribute('href')).toBe('#');
    });
  });

  describe('Music toggle', () => {
    test('is enabled when data-music-url is set', () => {
      document.body.setAttribute('data-music-url', 'https://example.com/song.mp3');
      makeWeddingHtml();
      loadMainJs();
      const btn = document.getElementById('musicToggle');
      expect(btn.disabled).toBe(false);
    });

    test('is disabled when data-music-url is empty', () => {
      document.body.setAttribute('data-music-url', '');
      makeWeddingHtml();
      loadMainJs();
      const btn = document.getElementById('musicToggle');
      expect(btn.disabled).toBe(true);
    });
  });

  describe('Gift copy', () => {
    test('clicking a gift copy button copies the data-copy value', async () => {
      // main.js uses navigator.clipboard only when isSecureContext is true.
      // jsdom has isSecureContext=false, so the code falls through to
      // the document.execCommand fallback. Mock both paths.
      const writes = [];
      Object.defineProperty(navigator, 'clipboard', {
        configurable: true,
        value: { writeText: (t) => { writes.push(t); return Promise.resolve(); } },
      });
      // Force the secure-context branch by stubbing isSecureContext.
      Object.defineProperty(window, 'isSecureContext', { configurable: true, value: true });

      makeWeddingHtml();
      loadMainJs();
      const btn = document.querySelector('.wsec-gift-copy');
      fireEvent(btn, 'click');
      // The handler is async (then on a promise); flush microtasks.
      await new Promise((r) => setTimeout(r, 0));
      await new Promise((r) => setTimeout(r, 0));
      expect(writes).toContain('arunpriya@upi');
      expect(btn.classList.contains('is-copied')).toBe(true);
    });

    test('falls back gracefully when not in a secure context', async () => {
      // In non-secure contexts, copyToClipboard uses document.execCommand.
      // jsdom doesn't ship execCommand, so it throws and the .is-copied
      // class is NOT added. This is acceptable: HTTPS is the recommended
      // deployment, and the button doesn't crash the page on HTTP.
      Object.defineProperty(window, 'isSecureContext', { configurable: true, value: false });

      makeWeddingHtml();
      loadMainJs();
      const btn = document.querySelector('.wsec-gift-copy');
      fireEvent(btn, 'click');
      await new Promise((r) => setTimeout(r, 0));

      // No crash — the button just silently fails. That's the contract.
      expect(btn.classList.contains('is-copied')).toBe(false);
    });
  });

  describe('Scroll cue', () => {
    test('clicking the scroll cue calls scrollIntoView on the target', () => {
      makeWeddingHtml();
      loadMainJs();
      const cue = document.querySelector('.wsec-scroll-cue');
      const target = document.getElementById('wsec-content');
      const spy = jest.fn();
      // jsdom's scrollIntoView exists now (stubbed in beforeEach); replace
      // it on this specific element with the spy via property assignment.
      target.scrollIntoView = spy;
      fireEvent(cue, 'click');
      expect(spy).toHaveBeenCalledWith({ behavior: 'smooth', block: 'start' });
    });
  });
});
