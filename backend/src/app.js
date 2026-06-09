const express = require('express');
const path = require('path');
const helmet = require('helmet');
const cors = require('cors');
const compression = require('compression');
const morgan = require('morgan');
const mongoSanitize = require('express-mongo-sanitize');
const hpp = require('hpp');

const { globalLimiter } = require('./middlewares/rateLimiter');
const errorHandler = require('./middlewares/errorHandler');

// Route imports
const authRoutes = require('./routes/auth.routes');
const weddingRoutes = require('./routes/wedding.routes');
const rsvpRoutes = require('./routes/rsvp.routes');
const uploadRoutes = require('./routes/upload.routes');

// Wedding service for public slug route
const weddingService = require('./services/wedding.service');

const app = express();

// ────────────────────────────────────────────
// Security
// ────────────────────────────────────────────

// Helmet — disable CSP so EJS templates can load external resources
app.use(
  helmet({
    contentSecurityPolicy: false,
    crossOriginEmbedderPolicy: false,
  })
);

// CORS — allow all origins in dev, !origin check for mobile apps
app.use(
  cors({
    origin: (origin, callback) => {
      // Allow requests with no origin (mobile apps, curl, Postman)
      if (!origin) return callback(null, true);
      // In development, allow all origins
      return callback(null, true);
    },
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization'],
  })
);

// ────────────────────────────────────────────
// Body parsing & compression
// ────────────────────────────────────────────

app.use(compression());
app.use(morgan('dev'));
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// ────────────────────────────────────────────
// Data sanitization & protection
// ────────────────────────────────────────────

// Prevent NoSQL injection
app.use(mongoSanitize());

// Prevent HTTP parameter pollution
app.use(hpp());

// Global rate limiter
app.use(globalLimiter);

// ────────────────────────────────────────────
// Static files & view engine
// ────────────────────────────────────────────

app.use(express.static(path.join(__dirname, 'public')));

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// ────────────────────────────────────────────
// Health check
// ────────────────────────────────────────────

app.get('/api/v1/health', (req, res) => {
  res.status(200).json({
    success: true,
    data: {
      status: 'ok',
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
    },
  });
});

// ────────────────────────────────────────────
// API Routes
// ────────────────────────────────────────────

app.use('/api/v1/auth', authRoutes);
app.use('/api/v1/weddings', weddingRoutes);
app.use('/api/v1/rsvp', rsvpRoutes);
app.use('/api/v1/upload', uploadRoutes);

// ────────────────────────────────────────────
// Public wedding page — GET /:slug
// ────────────────────────────────────────────

app.get('/:slug', async (req, res, next) => {
  try {
    const { slug } = req.params;

    // Ignore slugs that look like API paths or static files
    if (
      slug.startsWith('api') ||
      slug.includes('.') ||
      slug === 'favicon.ico'
    ) {
      return next();
    }

    const wedding = await weddingService.getBySlug(slug);

    res.render('layouts/base', {
      wedding,
      title: wedding.metaTitle || `${wedding.groomName} & ${wedding.brideName}'s Wedding`,
      description: wedding.metaDescription || wedding.invitationMessage || '',
      ogImage: wedding.ogImage || wedding.couplePhoto || '',
      baseUrl: require('./config/env').baseUrl,
    });
  } catch (err) {
    if (err.statusCode === 404) {
      return res.status(404).render('404', {
        title: 'Page Not Found',
      });
    }
    next(err);
  }
});

// ────────────────────────────────────────────
// 404 handler for unmatched routes
// ────────────────────────────────────────────

app.use((req, res) => {
  res.status(404).json({
    success: false,
    error: {
      message: `Route ${req.originalUrl} not found`,
      statusCode: 404,
    },
  });
});

// ────────────────────────────────────────────
// Global error handler
// ────────────────────────────────────────────

app.use(errorHandler);

module.exports = app;
