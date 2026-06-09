const express = require('express');
const router = express.Router();
const rsvpController = require('../controllers/rsvp.controller');
const authMiddleware = require('../middlewares/auth.middleware');
const { rsvpLimiter } = require('../middlewares/rateLimiter');

// POST /api/v1/rsvp/:weddingId — Public endpoint, rate limited
router.post('/:weddingId', rsvpLimiter, rsvpController.submit);

// GET /api/v1/rsvp/:weddingId — Authenticated (wedding owner)
router.get('/:weddingId', authMiddleware, rsvpController.getAll);

// GET /api/v1/rsvp/:weddingId/stats — Authenticated (wedding owner)
router.get('/:weddingId/stats', authMiddleware, rsvpController.getStats);

module.exports = router;
