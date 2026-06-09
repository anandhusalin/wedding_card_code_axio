const mongoose = require('mongoose');

const rsvpSchema = new mongoose.Schema(
  {
    weddingId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Wedding',
      required: [true, 'Wedding ID is required'],
      index: true,
    },
    guestName: {
      type: String,
      required: [true, 'Guest name is required'],
      trim: true,
      maxlength: [100, 'Guest name cannot exceed 100 characters'],
    },
    phone: {
      type: String,
      trim: true,
    },
    numberOfGuests: {
      type: Number,
      default: 1,
      min: [1, 'At least 1 guest required'],
      max: [10, 'Maximum 10 guests allowed'],
    },
    status: {
      type: String,
      enum: {
        values: ['attending', 'not_attending', 'maybe'],
        message: '{VALUE} is not a valid RSVP status',
      },
      required: [true, 'RSVP status is required'],
    },
    message: {
      type: String,
      maxlength: [500, 'Message cannot exceed 500 characters'],
    },
  },
  {
    timestamps: true,
  }
);

// Compound index for querying RSVPs by wedding and status
rsvpSchema.index({ weddingId: 1, status: 1 });

const RSVP = mongoose.model('RSVP', rsvpSchema);

module.exports = RSVP;
