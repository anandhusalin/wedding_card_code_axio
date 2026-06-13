const { z } = require('zod');

const photoSchema = z.object({
  url: z.string().url('Invalid photo URL'),
  publicId: z.string().optional(),
  caption: z.string().max(200).optional().default(''),
  order: z.number().int().min(0).optional().default(0),
});

const timelineItemSchema = z.object({
  title: z.string().max(200).optional(),
  date: z.string().or(z.date()).optional(),
  description: z.string().max(1000).optional(),
});

const coordinatesSchema = z.object({
  lat: z.number().min(-90).max(90).optional(),
  lng: z.number().min(-180).max(180).optional(),
});

const venueSchema = z.object({
  name: z.string().max(200).optional(),
  address: z.string().max(500).optional(),
  // Accept empty strings, valid URLs, or omit the field entirely. Bare
  // non-URL text (e.g. "df") is rejected with a clear field-level error.
  mapUrl: z
    .string()
    .optional()
    .refine(
      (v) => v == null || v === '' || /^https?:\/\//i.test(v),
      { message: 'Must be a URL (http:// or https://) or empty' },
    ),
  coordinates: coordinatesSchema.optional(),
});

const familySchema = z.object({
  fatherName: z.string().max(100).optional(),
  motherName: z.string().max(100).optional(),
  address: z.string().max(500).optional(),
});

const themeSchema = z.object({
  primaryColor: z.string().max(20).optional(),
  fontFamily: z.string().max(100).optional(),
  coverImage: z.string().optional(),
});

// Hardcoded list of valid template IDs. All are admin-defined. Frontend could
// eventually include user-uploaded templates, but for now this enforces only
// the 4 approved free templates.
const TEMPLATE_IDS = [
  'traditional-kerala',
  'modern-elegant',
  'floral-romance',
  'royal-maroon',
];

const createWeddingSchema = z.object({
  groomName: z
    .string({ required_error: 'Groom name is required' })
    .min(1, 'Groom name is required')
    .max(100)
    .trim(),
  brideName: z
    .string({ required_error: 'Bride name is required' })
    .min(1, 'Bride name is required')
    .max(100)
    .trim(),
  weddingDate: z
    .string({ required_error: 'Wedding date is required' })
    .or(z.date()),
  weddingTime: z.string().max(20).optional(),
  groomPhoto: z.string().optional(),
  bridePhoto: z.string().optional(),
  couplePhoto: z.string().optional(),
  venue: venueSchema.optional(),
  invitationMessage: z.string().max(2000).optional(),
  additionalNotes: z.string().max(2000).optional(),
  brideFamily: familySchema.optional(),
  groomFamily: familySchema.optional(),
  coupleStory: z.string().max(5000).optional(),
  engagementDate: z.string().or(z.date()).optional(),
  timeline: z.array(timelineItemSchema).max(20).optional(),
  engagementPhotos: z.array(photoSchema).max(50).optional(),
  galleryPhotos: z.array(photoSchema).max(100).optional(),
  templateId: z
    .enum(TEMPLATE_IDS, {
      errorMap: () => ({
        message: `templateId must be one of: ${TEMPLATE_IDS.join(', ')}`,
      }),
    })
    .optional(),
  language: z.enum(['en', 'ml', 'en_ml']).optional(),
  theme: themeSchema.optional(),
  isPublished: z.boolean().optional(),
  isDraft: z.boolean().optional(),
  isRsvpEnabled: z.boolean().optional(),
  metaTitle: z.string().max(200).optional(),
  metaDescription: z.string().max(500).optional(),
  ogImage: z.string().optional(),
});

const updateWeddingSchema = createWeddingSchema.partial();

/**
 * Generic Zod validation middleware factory.
 * @param {z.ZodSchema} schema - Zod schema to validate against
 * @returns Express middleware
 */
const validate = (schema) => (req, res, next) => {
  try {
    const result = schema.parse(req.body);
    req.body = result;
    next();
  } catch (err) {
    if (err instanceof z.ZodError) {
      const messages = err.errors.map((e) => e.message).join('. ');
      return res.status(400).json({
        success: false,
        error: {
          message: messages,
          statusCode: 400,
          details: err.errors.map((e) => ({
            field: e.path.join('.'),
            message: e.message,
          })),
        },
      });
    }
    next(err);
  }
};

module.exports = {
  createWeddingSchema,
  updateWeddingSchema,
  validate,
  TEMPLATE_IDS,
};
