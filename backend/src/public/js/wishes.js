/* ============================================================
   Wishes / Guestbook component
   - Reads .wsec-wishes[data-wedding-id]
   - POST /api/v1/wishes/:weddingId  (rate limited)
   - GET  /api/v1/wishes/:weddingId?limit=50
   - Renders the most recent wishes into .wsec-wishes-list
   ============================================================ */
(function () {
  'use strict';

  function ready(fn) {
    if (document.readyState !== 'loading') fn();
    else document.addEventListener('DOMContentLoaded', fn);
  }

  function escapeHtml(s) {
    return String(s == null ? '' : s)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;');
  }

  /** Render a single wish <li>. */
  function renderWish(wish) {
    var name = escapeHtml(wish.guestName || 'Anonymous');
    var msg = escapeHtml(wish.message || '');
    var when = wish.createdAt ? new Date(wish.createdAt) : null;
    var dateStr = when
      ? when.toLocaleDateString(undefined, { year: 'numeric', month: 'short', day: 'numeric' })
      : '';
    return (
      '<li class="wsec-wishes-item">' +
        '<div class="wsec-wishes-msg">' + msg + '</div>' +
        '<div class="wsec-wishes-meta">' +
          '<span class="wsec-wishes-name">' + name + '</span>' +
          (dateStr ? '<span class="wsec-wishes-date">' + escapeHtml(dateStr) + '</span>' : '') +
        '</div>' +
      '</li>'
    );
  }

  function initSection(section) {
    var weddingId = section.getAttribute('data-wedding-id');
    if (!weddingId) return;

    var form = section.querySelector('.wsec-wishes-form');
    var list = section.querySelector('.wsec-wishes-list');
    var status = section.querySelector('.wsec-wishes-status');
    var submitBtn = form ? form.querySelector('button[type="submit"]') : null;
    var msgField = form ? form.querySelector('textarea[name="message"]') : null;
    var counterEl = section.querySelector('.wsec-wishes-count');
    var msgMax = 300;

    function setStatus(message, kind) {
      if (!status) return;
      status.textContent = message || '';
      status.className = 'wsec-wishes-status' + (kind ? ' is-' + kind : '');
    }

    function setCounter() {
      if (!counterEl || !msgField) return;
      counterEl.textContent = String((msgField.value || '').length);
    }

    if (msgField) {
      msgField.addEventListener('input', setCounter);
      setCounter();
    }

    function renderList(wishes) {
      if (!list) return;
      if (!wishes || wishes.length === 0) {
        list.innerHTML = '<li class="wsec-wishes-empty">Be the first to leave a wish ✨</li>';
        return;
      }
      list.innerHTML = wishes.map(renderWish).join('');
    }

    function loadWishes() {
      fetch('/api/v1/wishes/' + encodeURIComponent(weddingId) + '?limit=50', {
        headers: { Accept: 'application/json' },
      })
        .then(function (res) {
          if (!res.ok) throw new Error('HTTP ' + res.status);
          return res.json();
        })
        .then(function (json) {
          if (json && json.success) renderList(json.data && json.data.wishes);
        })
        .catch(function () {
          // Silent: wishes are a nice-to-have; don't disrupt the page.
        });
    }

    if (form) {
      form.addEventListener('submit', function (e) {
        e.preventDefault();

        var fd = new FormData(form);
        var payload = {
          guestName: String(fd.get('guestName') || '').trim(),
          message: String(fd.get('message') || '').trim(),
        };

        if (!payload.guestName) {
          setStatus('Please share your name.', 'error');
          return;
        }
        if (payload.message.length < 2) {
          setStatus('Please leave a message.', 'error');
          return;
        }
        if (payload.message.length > msgMax) {
          setStatus('Message is too long (max ' + msgMax + ' characters).', 'error');
          return;
        }

        if (submitBtn) {
          submitBtn.disabled = true;
          submitBtn.dataset.label = submitBtn.textContent;
          submitBtn.textContent = 'Sending…';
        }
        setStatus('', null);

        fetch('/api/v1/wishes/' + encodeURIComponent(weddingId), {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            Accept: 'application/json',
          },
          body: JSON.stringify(payload),
        })
          .then(function (res) {
            return res.json().then(function (json) {
              return { ok: res.ok, json: json };
            });
          })
          .then(function (out) {
            if (out.ok && out.json && out.json.success) {
              form.reset();
              setCounter();
              setStatus('Thank you! Your wish has been sent.', 'success');
              // Prepend the new wish immediately for snappiness; a full
              // reload from the server will replace it with the canonical
              // list shortly.
              var list_ = section.querySelector('.wsec-wishes-list');
              if (list_) {
                var empty = list_.querySelector('.wsec-wishes-empty');
                if (empty) empty.remove();
                list_.insertAdjacentHTML('afterbegin', renderWish(out.json.data.wish));
              }
              setTimeout(loadWishes, 1500);
            } else {
              var msg =
                (out.json && out.json.error && out.json.error.message) ||
                'Could not send your wish. Please try again.';
              setStatus(msg, 'error');
            }
          })
          .catch(function () {
            setStatus('Network error. Please try again.', 'error');
          })
          .finally(function () {
            if (submitBtn) {
              submitBtn.disabled = false;
              submitBtn.textContent = submitBtn.dataset.label || 'Send your wish';
            }
          });
      });
    }

    loadWishes();
  }

  ready(function () {
    var sections = document.querySelectorAll('.wsec-wishes[data-wedding-id]');
    sections.forEach(initSection);
  });
})();
