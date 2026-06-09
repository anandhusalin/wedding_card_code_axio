const RSVP = require('../models/RSVP');
const Wedding = require('../models/Wedding');

/**
 * Submit an RSVP response for a wedding (public).
 * @param {string} weddingId
 * @param {object} data - { guestName, phone, numberOfGuests, status, message }
 * @returns {object} Created RSVP document
 */
const submit = async (weddingId, data) => {
  // Verify the wedding exists and RSVP is enabled
  const wedding = await Wedding.findById(weddingId).lean();

  if (!wedding) {
    const error = new Error('Wedding not found');
    error.statusCode = 404;
    throw error;
  }

  if (!wedding.isPublished) {
    const error = new Error('This wedding page is not yet published');
    error.statusCode = 400;
    throw error;
  }

  if (!wedding.isRsvpEnabled) {
    const error = new Error('RSVP is not enabled for this wedding');
    error.statusCode = 400;
    throw error;
  }

  const rsvp = await RSVP.create({
    weddingId,
    ...data,
  });

  return rsvp;
};

/**
 * Get all RSVPs for a wedding (authenticated, verifies ownership).
 * @param {string} weddingId
 * @param {string} userId
 * @returns {Array} List of RSVP documents
 */
const getAll = async (weddingId, userId) => {
  // Verify ownership
  const wedding = await Wedding.findById(weddingId).lean();

  if (!wedding) {
    const error = new Error('Wedding not found');
    error.statusCode = 404;
    throw error;
  }

  if (wedding.userId.toString() !== userId) {
    const error = new Error('Not authorized to view RSVPs for this wedding');
    error.statusCode = 403;
    throw error;
  }

  const rsvps = await RSVP.find({ weddingId })
    .sort({ createdAt: -1 })
    .lean();

  return rsvps;
};

/**
 * Get RSVP statistics for a wedding.
 * @param {string} weddingId
 * @returns {object} { total, attending, notAttending, maybe, totalGuests }
 */
const getStats = async (weddingId) => {
  const stats = await RSVP.aggregate([
    { $match: { weddingId: require('mongoose').Types.ObjectId.createFromHexString(weddingId) } },
    {
      $group: {
        _id: '$status',
        count: { $sum: 1 },
        totalGuests: { $sum: '$numberOfGuests' },
      },
    },
  ]);

  const result = {
    total: 0,
    attending: 0,
    notAttending: 0,
    maybe: 0,
    totalGuests: 0,
  };

  stats.forEach((item) => {
    result.total += item.count;
    result.totalGuests += item.totalGuests;

    switch (item._id) {
      case 'attending':
        result.attending = item.count;
        break;
      case 'not_attending':
        result.notAttending = item.count;
        break;
      case 'maybe':
        result.maybe = item.count;
        break;
    }
  });

  return result;
};

module.exports = {
  submit,
  getAll,
  getStats,
};
