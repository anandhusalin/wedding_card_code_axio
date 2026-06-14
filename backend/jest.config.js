/**
 * Jest config — runs in jsdom environment (DOM tests need it; supertest
 * tests work either way but jsdom doesn't hurt).
 */
module.exports = {
  testEnvironment: 'jsdom',
  testMatch: ['**/tests/**/*.test.js'],
  testTimeout: 60000,
  // MongoMemoryServer downloads a binary on first use; allow plenty of time.
  maxWorkers: 1, // serial — avoids port conflicts when many suites spin up Express
  verbose: true,
  // Polyfills for util.TextEncoder / util.TextDecoder (needed by supertest
  // transitively through @noble/hashes / formidable in jsdom).
  setupFiles: ['<rootDir>/tests/jest.polyfills.js'],
  // Force CJS entry for nanoid (used by slug util) so Jest's ESM-bypass
  // resolver doesn't pick the index.browser.js.
  moduleNameMapper: {
    '^nanoid$': '<rootDir>/node_modules/nanoid/index.cjs',
  },
};
