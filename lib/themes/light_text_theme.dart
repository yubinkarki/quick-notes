import "package:okaychata/imports/flutter_imports.dart" show TextTheme, FontWeight;

import "package:okaychata/imports/third_party_imports.dart" show GoogleFonts;

import "package:okaychata/imports/first_party_imports.dart" show CustomColors;

TextTheme lightTextTheme(TextTheme base) {
  final baseStyle = GoogleFonts.quicksand(
    letterSpacing: 0.5,
    fontWeight: FontWeight.w600,
    color: CustomColors.darkTeal,
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
