import 'package:okaychata/imports/flutter_imports.dart' show ThemeData, BuildContext, AppBarTheme, ColorScheme;

import 'package:okaychata/imports/first_party_imports.dart' show CustomColors, lightTextTheme;

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
