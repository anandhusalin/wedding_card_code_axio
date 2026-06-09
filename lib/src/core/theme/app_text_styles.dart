import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Typography system for the Wedding Cards app.
/// Uses Playfair Display for elegant headings, Inter for clean body text,
/// and Noto Sans Malayalam for Malayalam language support.
class AppTextStyles {
  AppTextStyles._();

  // ─── Heading Styles (Playfair Display) ───────────────────────────

  static TextStyle h1 = GoogleFonts.playfairDisplay(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle h2 = GoogleFonts.playfairDisplay(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.25,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle h3 = GoogleFonts.playfairDisplay(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.3,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle h4 = GoogleFonts.playfairDisplay(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.35,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle h5 = GoogleFonts.playfairDisplay(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.4,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle h6 = GoogleFonts.playfairDisplay(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.4,
    color: AppColors.textPrimaryLight,
  );

  // ─── Body Styles (Inter) ─────────────────────────────────────────

  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle bodyLargeMedium = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.5,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle bodyLargeBold = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.15,
    height: 1.5,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle bodyRegular = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.5,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.25,
    height: 1.5,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle bodyBold = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.25,
    height: 1.5,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.5,
    color: AppColors.textSecondaryLight,
  );

  static TextStyle bodySmallMedium = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.4,
    height: 1.5,
    color: AppColors.textSecondaryLight,
  );

  // ─── Caption Styles ──────────────────────────────────────────────

  static TextStyle caption = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.4,
    color: AppColors.textTertiaryLight,
  );

  static TextStyle captionMedium = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.4,
    color: AppColors.textTertiaryLight,
  );

  static TextStyle overline = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
    height: 1.6,
    color: AppColors.textTertiaryLight,
  );

  // ─── Button Styles ───────────────────────────────────────────────

  static TextStyle buttonLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.25,
  );

  static TextStyle buttonMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.25,
  );

  static TextStyle buttonSmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.25,
  );

  // ─── Label Styles ────────────────────────────────────────────────

  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.4,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.4,
    color: AppColors.textSecondaryLight,
  );

  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.4,
    color: AppColors.textTertiaryLight,
  );

  // ─── Malayalam Styles (Noto Sans Malayalam) ───────────────────────

  static TextStyle malayalamHeading = GoogleFonts.notoSansMalayalam(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.4,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle malayalamSubheading = GoogleFonts.notoSansMalayalam(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle malayalamBody = GoogleFonts.notoSansMalayalam(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle malayalamBodyMedium = GoogleFonts.notoSansMalayalam(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.6,
    color: AppColors.textPrimaryLight,
  );

  static TextStyle malayalamSmall = GoogleFonts.notoSansMalayalam(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textSecondaryLight,
  );

  static TextStyle malayalamCaption = GoogleFonts.notoSansMalayalam(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textTertiaryLight,
  );

  // ─── Special / Decorative ────────────────────────────────────────

  static TextStyle weddingTitle = GoogleFonts.playfairDisplay(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.0,
    height: 1.2,
    color: AppColors.primary,
  );

  static TextStyle weddingSubtitle = GoogleFonts.playfairDisplay(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    letterSpacing: 2.0,
    height: 1.5,
    fontStyle: FontStyle.italic,
    color: AppColors.secondary,
  );

  static TextStyle goldAccent = GoogleFonts.playfairDisplay(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
    color: AppColors.primary,
  );

  static TextStyle linkStyle = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.25,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.primary,
  );
}
