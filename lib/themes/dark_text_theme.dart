import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:okaychata/constants/colors.dart';

TextTheme darkTextTheme(TextTheme base) {
  return base.copyWith(
    labelSmall: GoogleFonts.quicksand(
      fontWeight: FontWeight.w600,
      fontSize: 14,
      color: CustomColors.slightlyWhite,
      letterSpacing: 0.5,
    ),
    labelMedium: GoogleFonts.quicksand(
      fontWeight: FontWeight.w600,
      fontSize: 18,
      color: CustomColors.slightlyWhite,
      letterSpacing: 0.5,
    ),
    labelLarge: GoogleFonts.quicksand(
      fontWeight: FontWeight.w600,
      fontSize: 22,
      color: CustomColors.slightlyWhite,
      letterSpacing: 0.5,
    ),
    // Used by input field text.
    titleSmall: GoogleFonts.quicksand(
      fontWeight: FontWeight.w600,
      fontSize: 14,
      color: CustomColors.slightlyWhite,
      letterSpacing: 0.5,
    ),
    titleMedium: GoogleFonts.quicksand(
      fontWeight: FontWeight.w600,
      fontSize: 18,
      color: CustomColors.slightlyWhite,
      letterSpacing: 0.5,
    ),
    // Appbar title.
    titleLarge: GoogleFonts.quicksand(
      fontWeight: FontWeight.w600,
      fontSize: 22,
      color: CustomColors.slightlyWhite,
      letterSpacing: 0.5,
    ),
  );
}
