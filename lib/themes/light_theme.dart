import 'package:flutter/material.dart';

import 'package:okaychata/constants/colors.dart';
import 'package:okaychata/themes/light_text_theme.dart';

ThemeData lightTheme(BuildContext context) {
  final base = ThemeData.light();

  return base.copyWith(
    appBarTheme: const AppBarTheme(color: CustomColors.teal),
    colorScheme: const ColorScheme.light(
      primary: CustomColors.teal,
      background: CustomColors.lightTeal,
    ),
    textTheme: lightTextTheme(base.textTheme),
  );
}
