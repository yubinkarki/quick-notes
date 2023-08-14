import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, SystemUiOverlayStyle;

import 'package:okaychata/constants/routes.dart';
import 'package:okaychata/themes/dark_theme.dart' show darkTheme;
import 'package:okaychata/themes/light_theme.dart' show lightTheme;
import 'package:okaychata/constants/colors.dart' show CustomColors;
import 'package:okaychata/navigation/app_router.dart' show AppRouter;

void main() {
  // To call native code by Firebase before running application.
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(systemNavigationBarColor: CustomColors.black),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nice',
      debugShowCheckedModeBanner: false,
      theme: lightTheme(context),
      darkTheme: darkTheme(context),
      themeMode: ThemeMode.system,
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: homeRoute,
    );
  }
}
