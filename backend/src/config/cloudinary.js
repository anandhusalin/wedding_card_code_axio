const cloudinary = require('cloudinary').v2;
const env = require('./env');

// Validate cloudinary credentials at startup
const required = ['CLOUDINARY_CLOUD_NAME', 'CLOUDINARY_API_KEY', 'CLOUDINARY_API_SECRET'];
const placeholders = ['demo', '', undefined];
for (const key of required) {
  if (!process.env[key] || placeholders.includes(process.env[key])) {
    console.error(`[Cloudinary] ${key} is missing or still a placeholder. Set a real value in .env / Railway.`);
    process.exit(1);
  }
}

cloudinary.config({
  cloud_name: env.cloudinary.cloudName,
  api_key: env.cloudinary.apiKey,
  api_secret: env.cloudinary.apiSecret,
  secure: true,
});

module.exports = cloudinary;
