import 'package:flutter/material.dart' show ThemeData, BuildContext, AppBarTheme, ColorScheme;

import 'package:okaychata/constants/colors.dart' show CustomColors;
import 'package:okaychata/themes/light_text_theme.dart' show lightTextTheme;

ThemeData lightTheme(BuildContext context) {
  final base = ThemeData.light();

  return base.copyWith(
    appBarTheme: const AppBarTheme(color: CustomColors.teal),
    colorScheme: const ColorScheme.light(
      error: CustomColors.red,
      primary: CustomColors.teal,
      outline: CustomColors.darkTeal,
      surface: CustomColors.lightTeal,
    ),
    textTheme: lightTextTheme(base.textTheme),
  );
}
