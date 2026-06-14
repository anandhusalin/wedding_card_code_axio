const mongoose = require('mongoose');

const photoSchema = new mongoose.Schema(
  {
    url: { type: String, required: true },
    publicId: { type: String },
    caption: { type: String, default: '' },
    order: { type: Number, default: 0 },
  },
  { _id: true }
);

const timelineSchema = new mongoose.Schema(
  {
    title: { type: String },
    date: { type: Date },
    description: { type: String },
  },
  { _id: true }
);

const weddingSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: [true, 'User ID is required'],
      index: true,
    },
    slug: {
      type: String,
      required: [true, 'Slug is required'],
      unique: true,
      lowercase: true,
      index: true,
    },

    // Couple details
    groomName: {
      type: String,
      required: [true, 'Groom name is required'],
      trim: true,
    },
    brideName: {
      type: String,
      required: [true, 'Bride name is required'],
      trim: true,
    },
    groomPhoto: { type: String },
    bridePhoto: { type: String },
    couplePhoto: { type: String },

    // Event details
    weddingDate: {
      type: Date,
      required: [true, 'Wedding date is required'],
    },
    weddingTime: { type: String },

    // Venue
    venue: {
      name: { type: String },
      address: { type: String },
      mapUrl: { type: String },
      coordinates: {
        lat: { type: Number },
        lng: { type: Number },
      },
    },

    // Messages
    invitationMessage: { type: String },
    additionalNotes: { type: String },

    // Families
    brideFamily: {
      fatherName: { type: String },
      motherName: { type: String },
      address: { type: String },
    },
    groomFamily: {
      fatherName: { type: String },
      motherName: { type: String },
      address: { type: String },
    },

    // Story
    coupleStory: { type: String },
    engagementDate: { type: Date },

    // Family tree (extended — richer than brideFamily/groomFamily)
    family: {
      bride: {
        fatherName: { type: String },
        motherName: { type: String },
        photo: { type: String },
      },
      groom: {
        fatherName: { type: String },
        motherName: { type: String },
        photo: { type: String },
      },
    },

    // Travel & stay
    travel: {
      venueMapEmbed: { type: String },
      notes: { type: String },
      hotels: [
        {
          name: { type: String },
          address: { type: String },
          phone: { type: String },
          distance: { type: String },
        },
      ],
    },

    // Gift registry
    giftRegistry: [
      {
        label: { type: String },
        url: { type: String },
        icon: { type: String },
        note: { type: String },
      },
    ],

    // Timeline
    timeline: [timelineSchema],

    // Photos
    engagementPhotos: [photoSchema],
    galleryPhotos: [photoSchema],

    // Template & appearance
    templateId: {
      type: String,
      default: 'traditional-kerala',
    },
    language: {
      type: String,
      enum: ['en', 'ml', 'en_ml'],
      default: 'en',
    },
    theme: {
      primaryColor: { type: String, default: '#D4A574' },
      fontFamily: { type: String, default: 'Playfair Display' },
      coverImage: { type: String },
    },

    // Status
    isPublished: { type: Boolean, default: false },
    isDraft: { type: Boolean, default: true },
    isRsvpEnabled: { type: Boolean, default: true },

    // SEO
    metaTitle: { type: String },
    metaDescription: { type: String },
    ogImage: { type: String },

    // Analytics
    viewCount: { type: Number, default: 0 },
  },
  {
    timestamps: true,
  }
);

// Compound indexes
weddingSchema.index({ isPublished: 1, weddingDate: 1 });

const Wedding = mongoose.model('Wedding', weddingSchema);

module.exports = Wedding;
