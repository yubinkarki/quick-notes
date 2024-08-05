import 'package:okaychata/imports/flutter_imports.dart'
    show
        ThemeData,
        EdgeInsets,
        BorderSide,
        AppBarTheme,
        ColorScheme,
        BuildContext,
        BorderRadius,
        OutlineInputBorder,
        InputDecorationTheme;

import 'package:okaychata/imports/first_party_imports.dart' show CustomColors, lightTextTheme, AppPadding, AppSize;

ThemeData lightTheme(BuildContext context) {
  final ThemeData base = ThemeData.light();

  return base.copyWith(
    scaffoldBackgroundColor: CustomColors.lightTeal,
    appBarTheme: const AppBarTheme(color: CustomColors.teal),
    colorScheme: const ColorScheme.light(
      error: CustomColors.red,
      primary: CustomColors.teal,
      outline: CustomColors.darkTeal,
      surface: CustomColors.lightTeal,
    ),
    textTheme: lightTextTheme(base.textTheme),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(horizontal: AppPadding.p16, vertical: AppPadding.p16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSize.s10),
        borderSide: const BorderSide(width: 1, color: CustomColors.gray),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSize.s10),
        borderSide: const BorderSide(width: 1, color: CustomColors.darkTeal),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSize.s10),
        borderSide: const BorderSide(width: 1, color: CustomColors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSize.s10),
        borderSide: const BorderSide(width: 1, color: CustomColors.red),
      ),
    ),
  );
}
