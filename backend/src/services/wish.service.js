const Wish = require('../models/Wish');
const Wedding = require('../models/Wedding');

/** Plain error with statusCode — matches the rsvp service convention. */
function httpError(message, statusCode) {
  const err = new Error(message);
  err.statusCode = statusCode;
  return err;
}

/**
 * Submit a new public wish. Public — no auth required.
 * Validates required fields and length limits (also enforced by schema).
 */
const submit = async (weddingId, body) => {
  const guestName = (body && body.guestName || '').trim();
  const message = (body && body.message || '').trim();
  if (!guestName) throw httpError('Please share your name', 400);
  if (!message) throw httpError('Please leave a message', 400);
  if (guestName.length > 60) throw httpError('Name is too long', 400);
  if (message.length > 300) throw httpError('Message is too long', 400);

  // Verify the wedding exists (and is published — don't accept wishes
  // for draft / private weddings even if someone has the ID).
  const wedding = await Wedding.findById(weddingId).select('isPublished').lean();
  if (!wedding) throw httpError('Wedding not found', 404);
  if (!wedding.isPublished) throw httpError('Wedding not found', 404);

  const wish = await Wish.create({ weddingId, guestName, message });
  return wish;
};

/**
 * Public list of recent wishes for a wedding. Capped to 50 entries.
 * No auth — guests viewing the wedding should be able to see what
 * other guests have written.
 */
const listRecent = async (weddingId, limit) => {
  const parsed = parseInt(limit, 10);
  const safeLimit = Math.min(Math.max(Number.isFinite(parsed) ? parsed : 50, 1), 100);
  const wishes = await Wish.find({ weddingId })
    .sort({ createdAt: -1 })
    .limit(safeLimit)
    .lean();
  return wishes;
};

module.exports = { submit, listRecent };
