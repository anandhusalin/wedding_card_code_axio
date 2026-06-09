const jwt = require('jsonwebtoken');
const env = require('./env');

const JWT_SECRET = env.jwtSecret;
const JWT_EXPIRES_IN = env.jwtExpiresIn;

/**
 * Generate a signed JWT token.
 * @param {string} userId - Mongo ObjectId as string
 * @param {string} email  - User's email address
 * @returns {string} Signed JWT
 */
const generateToken = (userId, email) => {
  return jwt.sign({ userId, email }, JWT_SECRET, { expiresIn: JWT_EXPIRES_IN });
};

/**
 * Verify and decode a JWT token.
 * @param {string} token - JWT string
 * @returns {object} Decoded payload { userId, email, iat, exp }
 * @throws {JsonWebTokenError|TokenExpiredError}
 */
const verifyToken = (token) => {
  return jwt.verify(token, JWT_SECRET);
};

module.exports = {
  JWT_SECRET,
  JWT_EXPIRES_IN,
  generateToken,
  verifyToken,
};
