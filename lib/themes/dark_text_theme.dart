import 'package:flutter/material.dart' show TextTheme, FontWeight;

import 'package:google_fonts/google_fonts.dart' show GoogleFonts;

import 'package:okaychata/constants/colors.dart' show CustomColors;

TextTheme darkTextTheme(TextTheme base) {
  final baseStyle = GoogleFonts.quicksand(
    letterSpacing: 0.5,
    fontWeight: FontWeight.w600,
    color: CustomColors.slightlyWhite,
  );

  return base.copyWith(
    labelSmall: baseStyle.copyWith(fontSize: 14),
    labelLarge: baseStyle.copyWith(fontSize: 22),
    titleSmall: baseStyle.copyWith(fontSize: 14),
    titleLarge: baseStyle.copyWith(fontSize: 22),
    labelMedium: baseStyle.copyWith(fontSize: 18),
    titleMedium: baseStyle.copyWith(fontSize: 18),
  );
}
