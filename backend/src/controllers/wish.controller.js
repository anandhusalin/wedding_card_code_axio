const wishService = require('../services/wish.service');

/**
 * POST /api/v1/wishes/:weddingId — Public, rate limited
 */
const submit = async (req, res, next) => {
  try {
    const wish = await wishService.submit(req.params.weddingId, req.body);
    res.status(201).json({ success: true, data: { wish } });
  } catch (err) {
    err.statusCode = err.statusCode || 500;
    next(err);
  }
};

/**
 * GET /api/v1/wishes/:weddingId — Public
 */
const list = async (req, res, next) => {
  try {
    const wishes = await wishService.listRecent(req.params.weddingId, req.query.limit);
    res.status(200).json({ success: true, data: { wishes } });
  } catch (err) {
    err.statusCode = err.statusCode || 500;
    next(err);
  }
};

module.exports = { submit, list };
