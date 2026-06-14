/**
 * Test setup — connects to an in-memory MongoDB, sets required env vars,
 * and exports helpers for tearing down between tests.
 *
 * Use this in beforeAll/afterAll hooks:
 *
 *   const { setupDb, teardownDb, clearDb } = require('./setup');
 *   beforeAll(async () => await setupDb());
 *   afterAll(async () => await teardownDb());
 *   afterEach(async () => await clearDb());
 */
const { MongoMemoryServer } = require('mongodb-memory-server');
const mongoose = require('mongoose');

let mongod;

process.env.NODE_ENV = 'test';
process.env.JWT_SECRET = process.env.JWT_SECRET || 'test-jwt-secret-for-jest-only';
process.env.JWT_EXPIRES_IN = '7d';
process.env.MONGODB_URI = process.env.MONGODB_URI || 'mongodb://placeholder/wedding_test';
process.env.CLOUDINARY_CLOUD_NAME = 'test';
process.env.CLOUDINARY_API_KEY = 'test';
process.env.CLOUDINARY_API_SECRET = 'test';
process.env.PORT = '0';
process.env.BASE_URL = 'http://localhost:3000';

async function setupDb() {
  mongod = await MongoMemoryServer.create();
  const uri = mongod.getUri();
  // Apply the URI for the app under test (it reads .env at require time, but
  // tests use a getter that re-reads env, so we just set the process var).
  process.env.MONGODB_URI = uri;
  if (mongoose.connection.readyState === 0) {
    await mongoose.connect(uri);
  }
}

async function teardownDb() {
  try {
    if (mongoose.connection.readyState !== 0) {
      await mongoose.disconnect();
    }
  } catch (_) { /* ignore */ }
  if (mongod) {
    await mongod.stop();
    mongod = undefined;
  }
}

async function clearDb() {
  if (mongoose.connection.readyState !== 0 && mongoose.connection.db) {
    const collections = await mongoose.connection.db.collections();
    for (const c of collections) await c.deleteMany({});
  }
}

module.exports = { setupDb, teardownDb, clearDb };
