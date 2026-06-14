const express = require('express');
const router = express.Router();
const wishController = require('../controllers/wish.controller');
const { rsvpLimiter } = require('../middlewares/rateLimiter');

// Public endpoints — no auth. Rate limited to deter spam.
router.post('/:weddingId', rsvpLimiter, wishController.submit);
router.get('/:weddingId', wishController.list);

module.exports = router;
