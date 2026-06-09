const cloudinary = require('../config/cloudinary');

/**
 * Upload a single image buffer to Cloudinary.
 * @param {Buffer} buffer - Image file buffer
 * @param {string} folder - Cloudinary folder path
 * @returns {Promise<{ url: string, publicId: string, width: number, height: number, format: string }>}
 */
const uploadImage = (buffer, folder = 'wedding-cards/uploads') => {
  return new Promise((resolve, reject) => {
    const uploadStream = cloudinary.uploader.upload_stream(
      {
        folder,
        resource_type: 'image',
        transformation: [
          { quality: 'auto', fetch_format: 'auto' },
        ],
        allowed_formats: ['jpg', 'jpeg', 'png', 'webp', 'gif'],
      },
      (error, result) => {
        if (error) {
          return reject(error);
        }
        resolve({
          url: result.secure_url,
          publicId: result.public_id,
          width: result.width,
          height: result.height,
          format: result.format,
        });
      }
    );

    uploadStream.end(buffer);
  });
};

/**
 * Upload multiple images in parallel.
 * @param {Array<{ buffer: Buffer }>} files - Array of file objects with buffer property
 * @param {string} folder - Cloudinary folder path
 * @returns {Promise<Array>} Array of upload results
 */
const uploadMultiple = async (files, folder = 'wedding-cards/uploads') => {
  const uploadPromises = files.map((file) => uploadImage(file.buffer, folder));
  const results = await Promise.all(uploadPromises);
  return results;
};

/**
 * Delete an image from Cloudinary by public ID.
 * @param {string} publicId - Cloudinary public ID
 * @returns {Promise<object>} Cloudinary deletion result
 */
const deleteImage = async (publicId) => {
  const result = await cloudinary.uploader.destroy(publicId);

  if (result.result !== 'ok' && result.result !== 'not found') {
    const error = new Error('Failed to delete image from Cloudinary');
    error.statusCode = 500;
    throw error;
  }

  return result;
};

module.exports = {
  uploadImage,
  uploadMultiple,
  deleteImage,
};
