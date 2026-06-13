/* ============================================================
   Wedding Cards – Public site behaviour
   ============================================================ */
(function () {
  'use strict';

  function ready(fn) {
    if (document.readyState !== 'loading') fn();
    else document.addEventListener('DOMContentLoaded', fn);
  }

  ready(function () {
    initScrollReveal();
    initCountdown();
    initGalleryLightbox();
    initRsvpForm();
    initRsvpModalA11y();
    initMusicToggle();
    initShareRail();
  });

  // ---------- Scroll reveal (IntersectionObserver) ----------
  function initScrollReveal() {
    var els = document.querySelectorAll('.gs-reveal');
    if (!els.length) return;

    if (!('IntersectionObserver' in window)) {
      els.forEach(function (el) { el.classList.add('gs-revealed'); });
      return;
    }

    var io = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          entry.target.classList.add('gs-revealed');
          io.unobserve(entry.target);
        }
      });
    }, { threshold: 0.12 });

    els.forEach(function (el) { io.observe(el); });
  }

  // ---------- Countdown ----------
  function initCountdown() {
    var el = document.getElementById('countdown');
    var celebrated = document.getElementById('countdownCelebrated');
    if (!el) return;

    var dateAttr = document.body.getAttribute('data-wedding-date');
    if (!dateAttr) { el.style.display = 'none'; return; }

    var target = new Date(dateAttr).getTime();
    if (isNaN(target)) { el.style.display = 'none'; return; }

    var days = el.querySelector('[data-cd="days"]');
    var hours = el.querySelector('[data-cd="hours"]');
    var minutes = el.querySelector('[data-cd="minutes"]');
    var seconds = el.querySelector('[data-cd="seconds"]');

    function pad(n) { return String(n < 0 ? 0 : n).padStart(2, '0'); }

    function tick() {
      var diff = target - Date.now();

      if (diff <= 0) {
        el.classList.add('is-past');
        if (celebrated) celebrated.style.display = 'block';
        return;
      }

      var d = Math.floor(diff / 86400000);
      var h = Math.floor((diff % 86400000) / 3600000);
      var m = Math.floor((diff % 3600000) / 60000);
      var s = Math.floor((diff % 60000) / 1000);

      if (days)    days.textContent    = pad(d);
      if (hours)   hours.textContent   = pad(h);
      if (minutes) minutes.textContent = pad(m);
      if (seconds) seconds.textContent = pad(s);
    }

    tick();
    setInterval(tick, 1000);
  }

  // ---------- Gallery lightbox ----------
  function initGalleryLightbox() {
    var items = Array.prototype.slice.call(document.querySelectorAll('.gallery-item'));
    if (!items.length) return;

    var dlg = document.createElement('dialog');
    dlg.className = 'lightbox';
    dlg.innerHTML = ''
      + '<button class="lightbox-close" type="button" aria-label="Close">×</button>'
      + '<button class="lightbox-nav lightbox-prev" type="button" aria-label="Previous">‹</button>'
      + '<img alt="" />'
      + '<button class="lightbox-nav lightbox-next" type="button" aria-label="Next">›</button>'
      + '<div class="lightbox-counter"></div>';
    document.body.appendChild(dlg);

    var imgEl = dlg.querySelector('img');
    var counter = dlg.querySelector('.lightbox-counter');
    var closeBtn = dlg.querySelector('.lightbox-close');
    var prevBtn = dlg.querySelector('.lightbox-prev');
    var nextBtn = dlg.querySelector('.lightbox-next');
    var current = 0;

    var sources = items.map(function (item) {
      var img = item.querySelector('img');
      return img ? img.getAttribute('src') : '';
    });

    function show(i) {
      current = (i + sources.length) % sources.length;
      imgEl.src = sources[current];
      counter.textContent = (current + 1) + ' / ' + sources.length;
    }

    function open(i) {
      show(i);
      if (typeof dlg.showModal === 'function') dlg.showModal();
      else dlg.setAttribute('open', '');
    }

    function close() {
      if (typeof dlg.close === 'function') dlg.close();
      else dlg.removeAttribute('open');
    }

    items.forEach(function (item, i) {
      item.addEventListener('click', function () { open(i); });
    });

    closeBtn.addEventListener('click', close);
    prevBtn.addEventListener('click', function () { show(current - 1); });
    nextBtn.addEventListener('click', function () { show(current + 1); });
    dlg.addEventListener('click', function (e) {
      if (e.target === dlg) close();
    });
    document.addEventListener('keydown', function (e) {
      if (!dlg.hasAttribute('open')) return;
      if (e.key === 'Escape')      { close(); e.preventDefault(); }
      if (e.key === 'ArrowLeft')   { show(current - 1); }
      if (e.key === 'ArrowRight')  { show(current + 1); }
    });
  }

  // ---------- RSVP form ----------
  function initRsvpForm() {
    var form = document.getElementById('rsvpForm');
    if (!form) return;

    form.addEventListener('submit', async function (e) {
      e.preventDefault();

      var data = Object.fromEntries(new FormData(form).entries());
      var weddingId = data.weddingId;
      delete data.weddingId;

      var btn = form.querySelector('button[type="submit"]');
      var original = btn ? btn.innerText : '';
      if (btn) { btn.innerText = 'Sending...'; btn.disabled = true; }

      try {
        var res = await fetch('/api/v1/rsvp/' + encodeURIComponent(weddingId), {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(data),
        });
        var result = await res.json();

        if (result && result.success) {
          form.style.display = 'none';
          var ok = document.getElementById('rsvpSuccess');
          if (ok) ok.style.display = 'block';
        } else {
          alert((result && result.error && result.error.message) || 'Failed to submit RSVP');
        }
      } catch (err) {
        alert('An error occurred. Please try again.');
      } finally {
        if (btn) { btn.innerText = original; btn.disabled = false; }
      }
    });
  }

  // ---------- RSVP modal accessibility (focus trap + ESC) ----------
  function initRsvpModalA11y() {
    var modal = document.getElementById('rsvpModal');
    if (!modal) return;

    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape' && modal.style.display !== 'none') {
        closeRsvpModal();
      }
    });

    var observer = new MutationObserver(function () {
      if (modal.style.display !== 'none') {
        var firstField = modal.querySelector('input, select, textarea, button');
        if (firstField) firstField.focus();
      }
    });
    observer.observe(modal, { attributes: true, attributeFilter: ['style'] });
  }

  // ---------- Music toggle ----------
  function initMusicToggle() {
    var btn = document.getElementById('musicToggle');
    if (!btn) return;

    var url = document.body.getAttribute('data-music-url');
    if (!url) {
      btn.disabled = true;
      btn.title = 'No music set';
      return;
    }

    var audio = new Audio(url);
    audio.loop = true;

    btn.addEventListener('click', function () {
      if (audio.paused) {
        audio.play().then(function () { btn.classList.add('is-playing'); }).catch(function () {});
      } else {
        audio.pause();
        btn.classList.remove('is-playing');
      }
    });
  }

  // ---------- Floating share rail ----------
  function initShareRail() {
    var rail = document.getElementById('shareRail');
    if (!rail) return;
    var url = encodeURIComponent(window.location.href);
    var text = encodeURIComponent(document.title);
    var wa = 'https://api.whatsapp.com/send?text=' + text + '%20' + url;
    var fb = 'https://www.facebook.com/sharer/sharer.php?u=' + url;
    var tw = 'https://twitter.com/intent/tweet?text=' + text + '&url=' + url;
    rail.innerHTML = ''
      + '<a href="' + wa + '" target="_blank" rel="noopener" aria-label="Share on WhatsApp" title="Share on WhatsApp">💬</a>'
      + '<a href="' + fb + '" target="_blank" rel="noopener" aria-label="Share on Facebook" title="Share on Facebook">f</a>'
      + '<a href="' + tw + '" target="_blank" rel="noopener" aria-label="Share on Twitter" title="Share on Twitter">𝕏</a>'
      + '<a href="#" data-share-copy aria-label="Copy link" title="Copy link">🔗</a>';

    var copyLink = rail.querySelector('[data-share-copy]');
    if (copyLink) {
      copyLink.addEventListener('click', function (e) {
        e.preventDefault();
        navigator.clipboard.writeText(window.location.href).then(function () {
          copyLink.textContent = '✓';
          setTimeout(function () { copyLink.textContent = '🔗'; }, 1500);
        });
      });
    }
  }
})();

// ---------- RSVP modal helpers (called from inline onclick) ----------
function openRsvpModal() {
  var modal = document.getElementById('rsvpModal');
  if (!modal) return;
  modal.style.display = 'flex';
  document.body.style.overflow = 'hidden';
}

function closeRsvpModal() {
  var modal = document.getElementById('rsvpModal');
  if (!modal) return;
  modal.style.display = 'none';
  document.body.style.overflow = '';
}
