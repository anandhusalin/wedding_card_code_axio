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

/**
 * PATCH /api/v1/weddings/:id/unpublish
 */
const unpublish = async (req, res, next) => {
  try {
    const wedding = await weddingService.unpublish(req.params.id, req.user.userId);
    res.status(200).json({ success: true, data: { wedding } });
  } catch (err) {
    next(err);
  }
};

/**
 * POST /api/v1/weddings/:id/duplicate
 */
const duplicate = async (req, res, next) => {
  try {
    const wedding = await weddingService.duplicate(req.params.id, req.user.userId);
    res.status(201).json({ success: true, data: { wedding } });
  } catch (err) {
    next(err);
  }
};

/**
 * GET /api/v1/weddings/:id/stats
 */
const stats = async (req, res, next) => {
  try {
    const data = await weddingService.getStats(req.params.id, req.user.userId);
    res.status(200).json({ success: true, data });
  } catch (err) {
    next(err);
  }
};

/**
 * GET /api/v1/weddings/:id/preview
 * Renders the public template for the owner (allows drafts).
 */
const preview = async (req, res, next) => {
  try {
    const wedding = await weddingService.getById(req.params.id, req.user.userId);
    res.render('layouts/base', {
      wedding,
      title: wedding.metaTitle || `${wedding.groomName} & ${wedding.brideName}'s Wedding (Preview)`,
      description: wedding.metaDescription || wedding.invitationMessage || '',
      ogImage: wedding.ogImage || wedding.couplePhoto || '',
      baseUrl: require('../config/env').baseUrl,
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
  unpublish,
  duplicate,
  stats,
  preview,
  delete: deleteWedding,
};
