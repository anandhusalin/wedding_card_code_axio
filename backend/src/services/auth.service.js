const User = require('../models/User');
const { generateToken } = require('../config/jwt');

/**
 * Register a new user.
 * @param {string} email
 * @param {string} password
 * @param {string} displayName
 * @returns {{ user: object, token: string }}
 */
const register = async (email, password, displayName) => {
  const existingUser = await User.findOne({ email: email.toLowerCase() });
  if (existingUser) {
    const error = new Error('Email is already registered');
    error.statusCode = 409;
    throw error;
  }

  const user = await User.create({ email, password, displayName });
  const token = generateToken(user._id.toString(), user.email);

  return { user, token };
};

/**
 * Log in with email and password.
 * @param {string} email
 * @param {string} password
 * @returns {{ user: object, token: string }}
 */
const login = async (email, password) => {
  // Explicitly select password field (it's hidden by default)
  const user = await User.findOne({ email: email.toLowerCase() }).select('+password');

  if (!user) {
    const error = new Error('Invalid email or password');
    error.statusCode = 401;
    throw error;
  }

  if (!user.isActive) {
    const error = new Error('Account is deactivated. Please contact support.');
    error.statusCode = 403;
    throw error;
  }

  const isMatch = await user.comparePassword(password);
  if (!isMatch) {
    const error = new Error('Invalid email or password');
    error.statusCode = 401;
    throw error;
  }

  const token = generateToken(user._id.toString(), user.email);

  return { user, token };
};

/**
 * Get user profile by ID.
 * @param {string} userId
 * @returns {object} User document
 */
const getProfile = async (userId) => {
  const user = await User.findById(userId);

  if (!user) {
    const error = new Error('User not found');
    error.statusCode = 404;
    throw error;
  }

  return user;
};

/**
 * Update user profile fields.
 * @param {string} userId
 * @param {object} updates - Fields to update (displayName, avatarUrl, etc.)
 * @returns {object} Updated user document
 */
const updateProfile = async (userId, updates) => {
  // Only allow specific fields to be updated
  const allowedUpdates = ['displayName', 'avatarUrl'];
  const sanitized = {};

  for (const key of allowedUpdates) {
    if (updates[key] !== undefined) {
      sanitized[key] = updates[key];
    }
  }

  const user = await User.findByIdAndUpdate(userId, sanitized, {
    new: true,
    runValidators: true,
  });

  if (!user) {
    const error = new Error('User not found');
    error.statusCode = 404;
    throw error;
  }

  return user;
};

module.exports = {
  register,
  login,
  getProfile,
  updateProfile,
};
