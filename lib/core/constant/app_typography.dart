import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_color.dart';
import '../responsive/breakpoints.dart';

class AppTypography {
  AppTypography._();

  static bool _isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= AppBreakpoints.mobile;
  }

  static TextTheme getTextTheme(BuildContext context) {
    final isTablet = _isTablet(context);

    return TextTheme(
      /// DISPLAY
      displayLarge: GoogleFonts.poppins(
        fontSize: isTablet ? 36 : 32,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
      ),

      /// HEADLINE
      headlineMedium: GoogleFonts.poppins(
        fontSize: isTablet ? 28 : 24,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),

      /// TITLE
      titleLarge: GoogleFonts.poppins(
        fontSize: isTablet ? 22 : 20,
        fontWeight: FontWeight.w700,
        color: AppColors.black,
      ),

      titleMedium: GoogleFonts.poppins(
        fontSize: isTablet ? 20 : 18,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      ),

      titleSmall: GoogleFonts.poppins(
        fontSize: isTablet ? 18 : 15,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      ),

      /// BODY
      bodyLarge: GoogleFonts.poppins(
        fontSize: isTablet ? 18 : 16,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      ),

      bodyMedium: GoogleFonts.poppins(
        fontSize: isTablet ? 16 : 14,
        fontWeight: FontWeight.w400,
        color: AppColors.grey,
      ),

      /// LABEL (Buttons)
      labelLarge: GoogleFonts.poppins(
        fontSize: isTablet ? 18 : 16,
        fontWeight: FontWeight.w600,
        color: AppColors.grey,
      ),

      labelMedium: GoogleFonts.poppins(
        fontSize: isTablet ? 16 : 14,
        fontWeight: FontWeight.w400,
        color: AppColors.grey,
      ),
    );
  }
}
