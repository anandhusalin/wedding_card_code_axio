const { z } = require('zod');

const registerSchema = z.object({
  email: z
    .string({ required_error: 'Email is required' })
    .email('Please provide a valid email address')
    .toLowerCase()
    .trim(),
  password: z
    .string({ required_error: 'Password is required' })
    .min(6, 'Password must be at least 6 characters'),
  displayName: z
    .string({ required_error: 'Display name is required' })
    .min(1, 'Display name is required')
    .max(100, 'Display name cannot exceed 100 characters')
    .trim(),
});

const loginSchema = z.object({
  email: z
    .string({ required_error: 'Email is required' })
    .email('Please provide a valid email address')
    .toLowerCase()
    .trim(),
  password: z
    .string({ required_error: 'Password is required' })
    .min(1, 'Password is required'),
});

/**
 * Generic Zod validation middleware factory.
 * @param {z.ZodSchema} schema - Zod schema to validate against
 * @returns Express middleware
 */
const validate = (schema) => (req, res, next) => {
  try {
    const result = schema.parse(req.body);
    req.body = result; // Replace body with parsed/transformed values
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
  registerSchema,
  loginSchema,
  validate,
};
