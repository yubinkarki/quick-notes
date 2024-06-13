import 'package:okaychata/imports/flutter_imports.dart' show ThemeData, BuildContext, AppBarTheme, ColorScheme;

import 'package:okaychata/imports/first_party_imports.dart' show CustomColors, darkTextTheme;

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
