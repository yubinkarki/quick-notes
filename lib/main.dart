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
        WidgetsBinding,
        BoxConstraints,
        StatelessWidget,
        GlobalMediaQuery,
        MultiBlocProvider,
        FlutterNativeSplash,
        SystemUiOverlayStyle,
        FirebaseAuthProvider,
        WidgetsFlutterBinding;

void main() async {
  // To call native code by Firebase before running application.
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(systemNavigationBarColor: CustomColors.black),
  );

  runApp(const MyApp());

  await Future.delayed(const Duration(seconds: 1));

  FlutterNativeSplash.remove();
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
