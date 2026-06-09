/**
 * Application-wide constants.
 */

const TEMPLATE_IDS = [
  'traditional-kerala',
  'modern-minimal',
  'royal-gold',
  'floral-garden',
  'beach-wedding',
  'rustic-charm',
];

const SUPPORTED_LANGUAGES = [
  { code: 'en', label: 'English' },
  { code: 'ml', label: 'Malayalam' },
  { code: 'en_ml', label: 'English & Malayalam' },
];

const MAX_FILE_SIZES = {
  image: 5 * 1024 * 1024, // 5 MB
  avatar: 2 * 1024 * 1024, // 2 MB
};

const ALLOWED_IMAGE_TYPES = [
  'image/jpeg',
  'image/png',
  'image/webp',
  'image/gif',
];

const MAX_IMAGES_PER_UPLOAD = 20;

const CLOUDINARY_FOLDERS = {
  weddingPhotos: 'wedding-cards/weddings',
  avatars: 'wedding-cards/avatars',
  gallery: 'wedding-cards/gallery',
  engagement: 'wedding-cards/engagement',
};

const RSVP_STATUSES = ['attending', 'not_attending', 'maybe'];

const USER_PLANS = ['free', 'premium', 'pro'];

const PLAN_LIMITS = {
  free: {
    maxWeddings: 1,
    maxGalleryPhotos: 10,
    maxEngagementPhotos: 5,
  },
  premium: {
    maxWeddings: 3,
    maxGalleryPhotos: 50,
    maxEngagementPhotos: 20,
  },
  pro: {
    maxWeddings: 10,
    maxGalleryPhotos: 200,
    maxEngagementPhotos: 50,
  },
};

module.exports = {
  TEMPLATE_IDS,
  SUPPORTED_LANGUAGES,
  MAX_FILE_SIZES,
  ALLOWED_IMAGE_TYPES,
  MAX_IMAGES_PER_UPLOAD,
  CLOUDINARY_FOLDERS,
  RSVP_STATUSES,
  USER_PLANS,
  PLAN_LIMITS,
};
