import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'app_colors.dart';

abstract class AppTypography {
  // Title 28/34 (w600)
  static TextStyle get title => GoogleFonts.inter(
        fontSize: 28,
        height: 34 / 28,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  // H1 24/32 (w600)
  static TextStyle get h1 => GoogleFonts.inter(
        fontSize: 24,
        height: 32 / 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  // H2 20/28 (w600)
  static TextStyle get h2 => GoogleFonts.inter(
        fontSize: 20,
        height: 28 / 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  // H3 18/26 (w600)
  static TextStyle get h3 => GoogleFonts.inter(
        fontSize: 18,
        height: 26 / 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  // Body 16/24 (w400)
  static TextStyle get body => GoogleFonts.inter(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );

  // Body Medium 16/24 (w500)
  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  // Small 14/20 (w400)
  static TextStyle get small => GoogleFonts.inter(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
      );

  // Small Medium 14/20 (w500)
  static TextStyle get smallMedium => GoogleFonts.inter(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  // Caption 12/16 (w400)
  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
      );

  // Caption Medium 12/16 (w500)
  static TextStyle get captionMedium => GoogleFonts.inter(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );
}
