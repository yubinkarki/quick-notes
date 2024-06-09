import 'package:flutter/material.dart' show ThemeData, BuildContext, AppBarTheme, ColorScheme;

import 'package:okaychata/constants/colors.dart' show CustomColors;
import 'package:okaychata/themes/dark_text_theme.dart' show darkTextTheme;

ThemeData darkTheme(BuildContext context) {
  final base = ThemeData.dark();

  return base.copyWith(
    appBarTheme: const AppBarTheme(color: CustomColors.dark),
    colorScheme: const ColorScheme.dark(
      error: CustomColors.red,
      outline: CustomColors.teal,
      surface: CustomColors.slightlyDark,
      primary: CustomColors.slightlyWhite,
    ),
    textTheme: darkTextTheme(base.textTheme),
  );
}
