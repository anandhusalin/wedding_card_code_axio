const express = require('express');
const router = express.Router();
const authController = require('../controllers/auth.controller');
const authMiddleware = require('../middlewares/auth.middleware');
const { authLimiter } = require('../middlewares/rateLimiter');
const { registerSchema, loginSchema, validate } = require('../validators/auth.validator');

// POST /api/v1/auth/register
router.post('/register', authLimiter, validate(registerSchema), authController.register);

// POST /api/v1/auth/login
router.post('/login', authLimiter, validate(loginSchema), authController.login);

// GET /api/v1/auth/me
router.get('/me', authMiddleware, authController.getProfile);

// PUT /api/v1/auth/profile
router.put('/profile', authMiddleware, authController.updateProfile);

module.exports = router;
