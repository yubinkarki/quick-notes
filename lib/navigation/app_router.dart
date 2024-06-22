import 'package:okaychata/imports/flutter_imports.dart'
    show Route, RouteSettings, MaterialPageRoute, PageRouteBuilder, FadeTransition, BuildContext, Animation, Widget;

import 'package:okaychata/imports/first_party_imports.dart'
    show
        HomeView,
        LoginView,
        homeRoute,
        NotesView,
        loginRoute,
        notesRoute,
        RegisterView,
        registerRoute,
        AddNewNoteView,
        VerifyEmailView,
        addNewNoteRoute,
        verifyEmailRoute,
        PageNotFoundView;

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute<Widget>(builder: (BuildContext context) => const HomeView());

      case loginRoute:
        return MaterialPageRoute<Widget>(builder: (BuildContext context) => const LoginView());

      case notesRoute:
        return MaterialPageRoute<Widget>(builder: (BuildContext context) => const NotesView());

      case registerRoute:
        return MaterialPageRoute<Widget>(builder: (BuildContext context) => const RegisterView());

      // Using a fade animation for this view.
      case addNewNoteRoute:
        return PageRouteBuilder<Widget>(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              const AddNewNoteView(),
          settings: settings,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(opacity: animation, child: child),
        );

      case verifyEmailRoute:
        return MaterialPageRoute<Widget>(builder: (BuildContext context) => const VerifyEmailView());

      default:
        return MaterialPageRoute<Widget>(builder: (BuildContext context) => const PageNotFoundView());
    }
  }
}
