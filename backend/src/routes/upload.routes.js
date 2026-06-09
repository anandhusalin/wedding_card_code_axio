const express = require('express');
const multer = require('multer');
const router = express.Router();
const uploadController = require('../controllers/upload.controller');
const authMiddleware = require('../middlewares/auth.middleware');
const { MAX_FILE_SIZES, MAX_IMAGES_PER_UPLOAD } = require('../utils/constants');

// Multer memory storage (no disk writes — buffers go straight to Cloudinary)
const storage = multer.memoryStorage();

const upload = multer({
  storage,
  limits: {
    fileSize: MAX_FILE_SIZES.image,
    files: MAX_IMAGES_PER_UPLOAD,
  },
  fileFilter: (req, file, cb) => {
    const allowed = ['image/jpeg', 'image/png', 'image/webp', 'image/gif'];
    if (allowed.includes(file.mimetype)) {
      cb(null, true);
    } else {
      cb(new Error(`Invalid file type: ${file.mimetype}. Only JPEG, PNG, WebP, and GIF are allowed.`), false);
    }
  },
});

// POST /api/v1/upload — Upload images (authenticated)
router.post(
  '/',
  authMiddleware,
  upload.array('images', MAX_IMAGES_PER_UPLOAD),
  uploadController.upload
);

// DELETE /api/v1/upload/* — Delete image by publicId (authenticated)
// Using wildcard because Cloudinary publicIds contain slashes (e.g. "wedding-cards/weddings/abc123")
router.delete('/*', authMiddleware, uploadController.delete);

module.exports = router;
