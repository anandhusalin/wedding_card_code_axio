const Wedding = require('../models/Wedding');
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
 * Also increments the view count.
 * @param {string} slug
 * @returns {object} Wedding document
 */
const getBySlug = async (slug) => {
  const wedding = await Wedding.findOneAndUpdate(
    { slug, isPublished: true },
    { $inc: { viewCount: 1 } },
    { new: true }
  ).lean();

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
  delete: deleteWedding,
};
