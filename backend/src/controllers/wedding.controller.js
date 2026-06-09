const weddingService = require('../services/wedding.service');

/**
 * POST /api/v1/weddings
 */
const create = async (req, res, next) => {
  try {
    const wedding = await weddingService.create(req.user.userId, req.body);

    res.status(201).json({
      success: true,
      data: { wedding },
    });
  } catch (err) {
    next(err);
  }
};

/**
 * GET /api/v1/weddings
 */
const getAll = async (req, res, next) => {
  try {
    const weddings = await weddingService.getAll(req.user.userId);

    res.status(200).json({
      success: true,
      data: { weddings },
    });
  } catch (err) {
    next(err);
  }
};

/**
 * GET /api/v1/weddings/:id
 */
const getById = async (req, res, next) => {
  try {
    const wedding = await weddingService.getById(req.params.id, req.user.userId);

    res.status(200).json({
      success: true,
      data: { wedding },
    });
  } catch (err) {
    next(err);
  }
};

/**
 * PUT /api/v1/weddings/:id
 */
const update = async (req, res, next) => {
  try {
    const wedding = await weddingService.update(req.params.id, req.user.userId, req.body);

    res.status(200).json({
      success: true,
      data: { wedding },
    });
  } catch (err) {
    next(err);
  }
};

/**
 * PATCH /api/v1/weddings/:id/publish
 */
const publish = async (req, res, next) => {
  try {
    const { isPublished } = req.body;
    const wedding = await weddingService.publish(
      req.params.id,
      req.user.userId,
      isPublished !== undefined ? isPublished : true
    );

    res.status(200).json({
      success: true,
      data: { wedding },
    });
  } catch (err) {
    next(err);
  }
};

/**
 * DELETE /api/v1/weddings/:id
 */
const deleteWedding = async (req, res, next) => {
  try {
    await weddingService.delete(req.params.id, req.user.userId);

    res.status(200).json({
      success: true,
      data: { message: 'Wedding deleted successfully' },
    });
  } catch (err) {
    next(err);
  }
};

module.exports = {
  create,
  getAll,
  getById,
  update,
  publish,
  delete: deleteWedding,
};
