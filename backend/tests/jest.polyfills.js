/**
 * Polyfills for Node < 19 — jsdom expects them globally.
 * Loads before any test file.
 */
const { TextEncoder, TextDecoder } = require('util');
Object.defineProperty(global, 'TextEncoder', { value: TextEncoder });
Object.defineProperty(global, 'TextDecoder', { value: TextDecoder });
