const Wedding = require('../models/Wedding');
const RSVP = require('../models/RSVP');
const { createUniqueSlug } = require('../utils/slug');

/**
 * Create a new wedding.
 * @param {string} userId
 * @param {object} data - Wedding fields
 * @returns {object} Created wedding document
 */
const create = async (userId, data) => {
  const slug = await createUniqueSlug(data.groomName, data.brideName);

  const wedding = await Wedding.create({
    ...data,
    userId,
    slug,
  });

  return wedding;
};

/**
 * Get all weddings for a specific user.
 * @param {string} userId
 * @returns {Array} List of wedding documents
 */
const getAll = async (userId) => {
  const weddings = await Wedding.find({ userId })
    .sort({ createdAt: -1 })
    .lean();

  return weddings;
};

/**
 * Get a wedding by ID, verifying ownership.
 * @param {string} weddingId
 * @param {string} userId
 * @returns {object} Wedding document
 */
const getById = async (weddingId, userId) => {
  const wedding = await Wedding.findById(weddingId);

  if (!wedding) {
    const error = new Error('Wedding not found');
    error.statusCode = 404;
    throw error;
  }

  if (wedding.userId.toString() !== userId) {
    const error = new Error('Not authorized to access this wedding');
    error.statusCode = 403;
    throw error;
  }

  return wedding;
};

/**
 * Get a published wedding by its slug (public endpoint).
 * Also increments the view count and populates the owner's plan so the
 * public page can decide whether to show the "free tier" badge.
 * @param {string} slug
 * @returns {object} Wedding document
 */
const getBySlug = async (slug) => {
  const wedding = await Wedding.findOneAndUpdate(
    { slug, isPublished: true },
    { $inc: { viewCount: 1 } },
    { new: true }
  )
    .populate('userId', 'plan displayName')
    .lean();

  if (!wedding) {
    const error = new Error('Wedding page not found');
    error.statusCode = 404;
    throw error;
  }

  return wedding;
};

/**
 * Update a wedding, verifying ownership.
 * @param {string} weddingId
 * @param {string} userId
 * @param {object} data - Fields to update
 * @returns {object} Updated wedding document
 */
const update = async (weddingId, userId, data) => {
  const wedding = await Wedding.findById(weddingId);

  if (!wedding) {
    const error = new Error('Wedding not found');
    error.statusCode = 404;
    throw error;
  }

  if (wedding.userId.toString() !== userId) {
    const error = new Error('Not authorized to update this wedding');
    error.statusCode = 403;
    throw error;
  }

  // Prevent slug and userId from being changed
  delete data.slug;
  delete data.userId;

  Object.assign(wedding, data);
  await wedding.save();

  return wedding;
};

/**
 * Toggle publish status of a wedding.
 * @param {string} weddingId
 * @param {string} userId
 * @param {boolean} isPublished
 * @returns {object} Updated wedding document
 */
const publish = async (weddingId, userId, isPublished) => {
  const wedding = await Wedding.findById(weddingId);

  if (!wedding) {
    const error = new Error('Wedding not found');
    error.statusCode = 404;
    throw error;
  }

  if (wedding.userId.toString() !== userId) {
    const error = new Error('Not authorized to publish this wedding');
    error.statusCode = 403;
    throw error;
  }

  wedding.isPublished = isPublished;
  if (isPublished) {
    wedding.isDraft = false;
  }
  await wedding.save();

  return wedding;
};

/**
 * Unpublish a wedding (alias for publish with isPublished=false).
 * @param {string} weddingId
 * @param {string} userId
 * @returns {object} Updated wedding document
 */
const unpublish = async (weddingId, userId) => {
  return publish(weddingId, userId, false);
};

/**
 * Duplicate a wedding. Resets publish state, regenerates the slug,
 * zeroes out the view count, and clears any timestamps.
 * @param {string} weddingId
 * @param {string} userId
 * @returns {object} Newly created wedding document
 */
const duplicate = async (weddingId, userId) => {
  const original = await getById(weddingId, userId);
  const src = original.toObject ? original.toObject() : original;

  // Drop fields that should not be carried over
  delete src._id;
  delete src.id;
  delete src.slug;
  delete src.viewCount;
  delete src.createdAt;
  delete src.updatedAt;

  src.isPublished = false;
  src.isDraft = true;
  src.slug = await createUniqueSlug(src.groomName, src.brideName);

  const copy = await Wedding.create(src);
  return copy;
};

/**
 * Aggregate statistics for a wedding: view count and RSVP breakdown.
 * @param {string} weddingId
 * @param {string} userId
 * @returns {object} { viewCount, rsvpCount, rsvpAttending, rsvpDeclined, rsvpMaybe }
 */
const getStats = async (weddingId, userId) => {
  const wedding = await getById(weddingId, userId);
  const rsvps = await RSVP.find({ weddingId: wedding._id }).lean();

  return {
    viewCount: wedding.viewCount || 0,
    rsvpCount: rsvps.length,
    rsvpAttending: rsvps.filter((r) => r.status === 'attending').length,
    rsvpDeclined: rsvps.filter((r) => r.status === 'not_attending').length,
    rsvpMaybe: rsvps.filter((r) => r.status === 'maybe').length,
  };
};

/**
 * Delete a wedding, verifying ownership.
 * @param {string} weddingId
 * @param {string} userId
 * @returns {object} Deleted wedding document
 */
const deleteWedding = async (weddingId, userId) => {
  const wedding = await Wedding.findById(weddingId);

  if (!wedding) {
    const error = new Error('Wedding not found');
    error.statusCode = 404;
    throw error;
  }

  if (wedding.userId.toString() !== userId) {
    const error = new Error('Not authorized to delete this wedding');
    error.statusCode = 403;
    throw error;
  }

  await Wedding.findByIdAndDelete(weddingId);

  return wedding;
};

module.exports = {
  create,
  getAll,
  getById,
  getBySlug,
  update,
  publish,
  unpublish,
  duplicate,
  getStats,
  delete: deleteWedding,
};
