const uploadService = require('../services/upload.service');
const { ALLOWED_IMAGE_TYPES, MAX_FILE_SIZES } = require('../utils/constants');

/**
 * POST /api/v1/upload
 * Upload one or more images. Files come from multer (memoryStorage).
 */
const upload = async (req, res, next) => {
  try {
    if (!req.files || req.files.length === 0) {
      return res.status(400).json({
        success: false,
        error: {
          message: 'No files uploaded',
          statusCode: 400,
        },
      });
    }

    // Validate file types and sizes
    for (const file of req.files) {
      if (!ALLOWED_IMAGE_TYPES.includes(file.mimetype)) {
        return res.status(400).json({
          success: false,
          error: {
            message: `Invalid file type: ${file.originalname}. Allowed: JPEG, PNG, WebP, GIF.`,
            statusCode: 400,
          },
        });
      }

      if (file.size > MAX_FILE_SIZES.image) {
        return res.status(400).json({
          success: false,
          error: {
            message: `File too large: ${file.originalname}. Maximum size is 5MB.`,
            statusCode: 400,
          },
        });
      }
    }

    const folder = req.body.folder || 'wedding-cards/uploads';
    const results = await uploadService.uploadMultiple(req.files, folder);

    res.status(200).json({
      success: true,
      data: {
        images: results,
        urls: results.map((img) => img.url),
        count: results.length,
      },
    });
  } catch (err) {
    next(err);
  }
};

/**
 * DELETE /api/v1/upload/:publicId
 * Delete an image from Cloudinary.
 * Note: publicId may contain slashes, so we reconstruct from the full param.
 */
const deleteImage = async (req, res, next) => {
  try {
    const publicId = req.params[0] || req.params.publicId;

    if (!publicId) {
      return res.status(400).json({
        success: false,
        error: {
          message: 'Public ID is required',
          statusCode: 400,
        },
      });
    }

    await uploadService.deleteImage(publicId);

    res.status(200).json({
      success: true,
      data: { message: 'Image deleted successfully' },
    });
  } catch (err) {
    next(err);
  }
};

module.exports = {
  upload,
  delete: deleteImage,
};
