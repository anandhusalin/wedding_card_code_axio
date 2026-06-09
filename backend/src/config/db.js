const mongoose = require('mongoose');
const env = require('./env');

const MAX_RETRIES = 5;
const RETRY_DELAY_MS = 5000;

let retryCount = 0;

const connectDB = async () => {
  try {
    const conn = await mongoose.connect(env.mongodbUri, {
      maxPoolSize: 10,
      serverSelectionTimeoutMS: 5000,
      socketTimeoutMS: 45000,
    });

    console.log(`[MongoDB] Connected: ${conn.connection.host}/${conn.connection.name}`);
    retryCount = 0;
  } catch (err) {
    retryCount += 1;
    console.error(`[MongoDB] Connection attempt ${retryCount} failed: ${err.message}`);

    if (retryCount < MAX_RETRIES) {
      console.log(`[MongoDB] Retrying in ${RETRY_DELAY_MS / 1000}s...`);
      await new Promise((resolve) => setTimeout(resolve, RETRY_DELAY_MS));
      return connectDB();
    }

    console.error('[MongoDB] Max retries reached. Exiting.');
    process.exit(1);
  }
};

// Connection event handlers
mongoose.connection.on('connected', () => {
  console.log('[MongoDB] Mongoose connected to DB');
});

mongoose.connection.on('error', (err) => {
  console.error(`[MongoDB] Mongoose connection error: ${err.message}`);
});

mongoose.connection.on('disconnected', () => {
  console.warn('[MongoDB] Mongoose disconnected from DB');
});

module.exports = connectDB;
