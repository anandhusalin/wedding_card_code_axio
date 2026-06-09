const rsvpService = require('../services/rsvp.service');

/**
 * POST /api/v1/rsvp/:weddingId
 * Public endpoint — no auth required.
 */
const submit = async (req, res, next) => {
  try {
    const rsvp = await rsvpService.submit(req.params.weddingId, req.body);

    res.status(201).json({
      success: true,
      data: { rsvp },
    });
  } catch (err) {
    next(err);
  }
};

/**
 * GET /api/v1/rsvp/:weddingId
 * Authenticated — wedding owner only.
 */
const getAll = async (req, res, next) => {
  try {
    const rsvps = await rsvpService.getAll(req.params.weddingId, req.user.userId);

    res.status(200).json({
      success: true,
      data: { rsvps },
    });
  } catch (err) {
    next(err);
  }
};

/**
 * GET /api/v1/rsvp/:weddingId/stats
 * Authenticated — wedding owner only.
 */
const getStats = async (req, res, next) => {
  try {
    const stats = await rsvpService.getStats(req.params.weddingId);

    res.status(200).json({
      success: true,
      data: { stats },
    });
  } catch (err) {
    next(err);
  }
};

module.exports = {
  submit,
  getAll,
  getStats,
};
