const rateLimit = require('express-rate-limit');

/**
 * Global rate limiter: 100 requests per 15 minutes.
 */
const globalLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100,
  standardHeaders: true,
  legacyHeaders: false,
  message: {
    success: false,
    error: {
      message: 'Too many requests. Please try again later.',
      statusCode: 429,
    },
  },
});

/**
 * Auth rate limiter: 10 requests per 15 minutes.
 */
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 10,
  standardHeaders: true,
  legacyHeaders: false,
  message: {
    success: false,
    error: {
      message: 'Too many authentication attempts. Please try again later.',
      statusCode: 429,
    },
  },
});

/**
 * RSVP rate limiter: 20 requests per hour.
 */
const rsvpLimiter = rateLimit({
  windowMs: 60 * 60 * 1000, // 1 hour
  max: 20,
  standardHeaders: true,
  legacyHeaders: false,
  message: {
    success: false,
    error: {
      message: 'Too many RSVP submissions. Please try again later.',
      statusCode: 429,
    },
  },
});

/**
 * Public page rate limiter: 60 requests per 15 minutes per IP.
 * Prevents slug enumeration brute-force on the public route.
 */
const publicLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 60,
  standardHeaders: true,
  legacyHeaders: false,
  message: {
    success: false,
    error: {
      message: 'Too many requests. Please slow down.',
      statusCode: 429,
    },
  },
});

module.exports = {
  globalLimiter,
  authLimiter,
  rsvpLimiter,
  publicLimiter,
};
