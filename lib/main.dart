import 'package:okaychata/constants/common_imports.dart'
    show
        Key,
        Widget,
        runApp,
        AuthBloc,
        darkTheme,
        ThemeMode,
        AppRouter,
        homeRoute,
        lightTheme,
        MaterialApp,
        CustomColors,
        BuildContext,
        SystemChrome,
        BlocProvider,
        LayoutBuilder,
        BoxConstraints,
        StatelessWidget,
        GlobalMediaQuery,
        MultiBlocProvider,
        SystemUiOverlayStyle,
        FirebaseAuthProvider,
        WidgetsFlutterBinding;

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
            debugShowCheckedModeBanner: false,
            theme: lightTheme(context),
            darkTheme: darkTheme(context),
            themeMode: ThemeMode.system,
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: homeRoute,
          );
        },
      ),
    );
  }
}
