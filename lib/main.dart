import 'package:okaychata/imports/flutter_imports.dart';

import 'package:okaychata/imports/third_party_imports.dart' show FlutterNativeSplash, MultiBlocProvider, BlocProvider;

import 'package:okaychata/imports/first_party_imports.dart'
    show AuthBloc, AppRouter, lightTheme, darkTheme, GlobalMediaQuery, FirebaseAuthProvider, homeRoute, CustomColors;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(systemNavigationBarColor: CustomColors.black),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(FirebaseAuthProvider()),
        ),
      ],
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          GlobalMediaQuery.init(context);

          return MaterialApp(
            title: 'Nice',
            initialRoute: homeRoute,
            theme: lightTheme(context),
            themeMode: ThemeMode.system,
            darkTheme: darkTheme(context),
            debugShowCheckedModeBanner: false,
            onGenerateRoute: AppRouter.generateRoute,
          );
        },
      ),
    );
  }
}
