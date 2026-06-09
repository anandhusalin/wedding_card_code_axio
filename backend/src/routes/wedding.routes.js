const express = require('express');
const router = express.Router();
const weddingController = require('../controllers/wedding.controller');
const authMiddleware = require('../middlewares/auth.middleware');
const { createWeddingSchema, updateWeddingSchema, validate } = require('../validators/wedding.validator');

// All wedding routes require authentication
router.use(authMiddleware);

// POST /api/v1/weddings
router.post('/', validate(createWeddingSchema), weddingController.create);

// GET /api/v1/weddings
router.get('/', weddingController.getAll);

// GET /api/v1/weddings/:id
router.get('/:id', weddingController.getById);

// PUT /api/v1/weddings/:id
router.put('/:id', validate(updateWeddingSchema), weddingController.update);

// PATCH /api/v1/weddings/:id/publish
router.patch('/:id/publish', weddingController.publish);

// DELETE /api/v1/weddings/:id
router.delete('/:id', weddingController.delete);

module.exports = router;
