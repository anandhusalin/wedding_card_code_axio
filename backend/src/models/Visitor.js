const mongoose = require('mongoose');

const visitorSchema = new mongoose.Schema({
  weddingId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Wedding',
    required: [true, 'Wedding ID is required'],
    index: true,
  },
  ipHash: {
    type: String,
  },
  userAgent: {
    type: String,
  },
  device: {
    type: String,
    enum: ['mobile', 'desktop', 'tablet'],
  },
  visitedAt: {
    type: Date,
    default: Date.now,
  },
});

// TTL index: auto-delete documents after 90 days (7776000 seconds)
visitorSchema.index({ visitedAt: 1 }, { expireAfterSeconds: 7776000 });

// Compound index for analytics queries
visitorSchema.index({ weddingId: 1, visitedAt: -1 });

const Visitor = mongoose.model('Visitor', visitorSchema);

module.exports = Visitor;
