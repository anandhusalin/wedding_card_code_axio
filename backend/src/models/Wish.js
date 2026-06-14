const mongoose = require('mongoose');

/**
 * Wish — short public message left by a guest for the couple.
 * Distinct from RSVP (which is a structured attending/not_attending
 * response with phone + guest count). A wish is purely a note.
 */
const wishSchema = new mongoose.Schema(
  {
    weddingId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Wedding',
      required: [true, 'Wedding ID is required'],
      index: true,
    },
    guestName: {
      type: String,
      required: [true, 'Your name is required'],
      trim: true,
      maxlength: [60, 'Name cannot exceed 60 characters'],
    },
    message: {
      type: String,
      required: [true, 'Please leave a message'],
      trim: true,
      maxlength: [300, 'Message cannot exceed 300 characters'],
      minlength: [2, 'Message is too short'],
    },
  },
  {
    timestamps: true,
  }
);

// Public listings only ever return the most recent N; index for fast sort.
wishSchema.index({ weddingId: 1, createdAt: -1 });

module.exports = mongoose.model('Wish', wishSchema);
