const slugify = require('slugify');
const { nanoid } = require('nanoid');
const Wedding = require('../models/Wedding');

/**
 * Generate a wedding slug from groom and bride names.
 * Format: groomname-and-bridename-abc123
 * @param {string} groomName
 * @param {string} brideName
 * @returns {string}
 */
const generateWeddingSlug = (groomName, brideName) => {
  const base = `${groomName} and ${brideName}`;
  const slug = slugify(base, {
    lower: true,
    strict: true,
    trim: true,
  });
  const uniqueId = nanoid(6);
  return `${slug}-${uniqueId}`;
};

/**
 * Generate a unique slug, checking the DB for collisions.
 * Retries up to 5 times if a collision is found.
 * @param {string} groomName
 * @param {string} brideName
 * @returns {Promise<string>}
 */
const createUniqueSlug = async (groomName, brideName) => {
  const maxAttempts = 5;

  for (let i = 0; i < maxAttempts; i++) {
    const slug = generateWeddingSlug(groomName, brideName);
    const existing = await Wedding.findOne({ slug }).lean();

    if (!existing) {
      return slug;
    }
  }

  // Fallback: use a longer nanoid to virtually guarantee uniqueness
  const base = slugify(`${groomName} and ${brideName}`, {
    lower: true,
    strict: true,
    trim: true,
  });
  return `${base}-${nanoid(12)}`;
};

module.exports = {
  generateWeddingSlug,
  createUniqueSlug,
};
