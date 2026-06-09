const { verifyToken } = require('../config/jwt');

/**
 * Authentication middleware.
 * Extracts Bearer token from Authorization header, verifies it,
 * and attaches decoded user payload to req.user.
 */
const authMiddleware = (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        success: false,
        error: {
          message: 'Access denied. No token provided.',
          statusCode: 401,
        },
      });
    }

    const token = authHeader.split(' ')[1];

    if (!token) {
      return res.status(401).json({
        success: false,
        error: {
          message: 'Access denied. Invalid token format.',
          statusCode: 401,
        },
      });
    }

    const decoded = verifyToken(token);
    req.user = decoded;
    next();
  } catch (err) {
    if (err.name === 'TokenExpiredError') {
      return res.status(401).json({
        success: false,
        error: {
          message: 'Token has expired. Please log in again.',
          statusCode: 401,
        },
      });
    }

    if (err.name === 'JsonWebTokenError') {
      return res.status(401).json({
        success: false,
        error: {
          message: 'Invalid token.',
          statusCode: 401,
        },
      });
    }

    return res.status(401).json({
      success: false,
      error: {
        message: 'Authentication failed.',
        statusCode: 401,
      },
    });
  }
};

module.exports = authMiddleware;
