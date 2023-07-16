import 'package:flutter/material.dart';

import 'package:okaychata/constants/colors.dart';
import 'package:okaychata/themes/dark_text_theme.dart';

ThemeData darkTheme(BuildContext context) {
  final base = ThemeData.dark();

  return base.copyWith(
    appBarTheme: const AppBarTheme(color: CustomColors.dark),
    colorScheme: const ColorScheme.dark(
      primary: CustomColors.slightlyWhite,
      background: CustomColors.slightlyDark,
    ),
    textTheme: darkTextTheme(base.textTheme),
  );
}
