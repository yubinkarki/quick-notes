import 'package:okaychata/imports/flutter_imports.dart'
    show
        ThemeData,
        BorderSide,
        EdgeInsets,
        AppBarTheme,
        ColorScheme,
        BuildContext,
        BorderRadius,
        OutlineInputBorder,
        InputDecorationTheme;

import 'package:okaychata/imports/first_party_imports.dart' show CustomColors, darkTextTheme, AppSize, AppPadding;

ThemeData darkTheme(BuildContext context) {
  final ThemeData base = ThemeData.dark();

  return base.copyWith(
    scaffoldBackgroundColor: CustomColors.slightlyDark,
    appBarTheme: const AppBarTheme(color: CustomColors.dark),
    colorScheme: const ColorScheme.dark(
      error: CustomColors.red,
      outline: CustomColors.teal,
      surface: CustomColors.slightlyDark,
      primary: CustomColors.slightlyWhite,
    ),
    textTheme: darkTextTheme(base.textTheme),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(horizontal: AppPadding.p16, vertical: AppPadding.p16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSize.s10),
        borderSide: const BorderSide(width: 1, color: CustomColors.gray),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSize.s10),
        borderSide: const BorderSide(width: 1, color: CustomColors.teal),
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
