// Load environment variables first — must be before any other imports that use env
const env = require('./config/env');
const connectDB = require('./config/db');
const app = require('./app');

const PORT = env.port;

const startServer = async () => {
  try {
    // Connect to MongoDB
    await connectDB();

    // Start HTTP server
    const server = app.listen(PORT, () => {
      console.log(`[Server] Running in ${env.nodeEnv} mode on port ${PORT}`);
      console.log(`[Server] API:    ${env.baseUrl}/api/v1`);
      console.log(`[Server] Health: ${env.baseUrl}/api/v1/health`);
    });

    // ── Graceful shutdown ──────────────────────────────
    const shutdown = async (signal) => {
      console.log(`\n[Server] ${signal} received. Shutting down gracefully...`);

      server.close(async () => {
        console.log('[Server] HTTP server closed');

        try {
          const mongoose = require('mongoose');
          await mongoose.connection.close();
          console.log('[MongoDB] Connection closed');
        } catch (err) {
          console.error('[MongoDB] Error closing connection:', err.message);
        }

        process.exit(0);
      });

      // Force shutdown after 10 seconds if graceful shutdown fails
      setTimeout(() => {
        console.error('[Server] Forced shutdown after timeout');
        process.exit(1);
      }, 10000);
    };

    process.on('SIGTERM', () => shutdown('SIGTERM'));
    process.on('SIGINT', () => shutdown('SIGINT'));

    // Handle unhandled promise rejections
    process.on('unhandledRejection', (reason, promise) => {
      console.error('[Server] Unhandled Rejection at:', promise, 'reason:', reason);
    });

    // Handle uncaught exceptions
    process.on('uncaughtException', (err) => {
      console.error('[Server] Uncaught Exception:', err.message);
      console.error(err.stack);
      process.exit(1);
    });
  } catch (err) {
    console.error('[Server] Failed to start:', err.message);
    process.exit(1);
  }
};

startServer();
