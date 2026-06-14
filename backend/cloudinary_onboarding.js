// Cloudinary Onboarding Script
// This script demonstrates the full flow: upload, fetch metadata, and transform.
// Replace the three placeholder values below with your real Cloudinary credentials.

const cloudinary = require('cloudinary').v2;

// ─── Step 1: Configure Cloudinary (inline, no .env) ─────────────────
cloudinary.config({
  cloud_name: 'dze4a0i3z',  // ← replace this
  api_key: '423371994515144',        // ← replace this
  api_secret: 'KkeqzFko-VjeY8g7ANeZ5eeWkZc',  // ← replace this
});

(async () => {
  try {
    // ─── Step 2: Upload a sample image from Cloudinary's demo domain ─
    // We use a remote upload (URL) — no local file needed.
    console.log('Uploading sample image from Cloudinary demo domain...');
    const uploadResult = await cloudinary.uploader.upload(
      'https://res.cloudinary.com/demo/image/upload/sample.jpg',
      { folder: 'wedding-cards/onboarding' }
    );

    console.log('\n✅ Upload successful!');
    console.log('   Secure URL :', uploadResult.secure_url);
    console.log('   Public ID  :', uploadResult.public_id);

    // ─── Step 3: Get image details (metadata) ────────────────────────
    // Use the resources API to fetch the same image's metadata.
    console.log('\nFetching image metadata...');
    const resource = await cloudinary.api.resource(uploadResult.public_id);

    console.log('\n📊 Image Details:');
    console.log('   Width       :', resource.width, 'px');
    console.log('   Height      :', resource.height, 'px');
    console.log('   Format      :', resource.format);
    console.log('   File size   :', resource.bytes, 'bytes');
    console.log('   Resource ID :', resource.asset_id);

    // ─── Step 4: Transform the image URL ─────────────────────────────
    // f_auto = Cloudinary picks the best format for the viewer's browser
    //          (e.g. WebP for Chrome, AVIF for modern browsers, JPEG fallback).
    // q_auto = Cloudinary adjusts compression so the image looks good
    //          at the smallest possible size (lossy optimization).
    const transformedUrl = cloudinary.url(uploadResult.public_id, {
      transformation: [
        { fetch_format: 'auto' }, // f_auto
        { quality: 'auto' },      // q_auto
      ],
      secure: true,
    });

    console.log('\n🎨 Transformed Image URL:');
    console.log('   ', transformedUrl);
    console.log('\n✅ Done! Click the link above to see the optimized version of the image.');
    console.log('   Check the file size and the format served to your browser.');
  } catch (err) {
    console.error('\n❌ Error:', err.message || err);
    process.exit(1);
  }
})();
