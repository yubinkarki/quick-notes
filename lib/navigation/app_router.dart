import "package:okaychata/imports/flutter_imports.dart"
    show Route, RouteSettings, MaterialPageRoute, PageRouteBuilder, FadeTransition;

import "package:okaychata/imports/first_party_imports.dart"
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
        return MaterialPageRoute(builder: (context) => const HomeView());

      case loginRoute:
        return MaterialPageRoute(builder: (context) => const LoginView());

      case registerRoute:
        return MaterialPageRoute(builder: (context) => const RegisterView());

      case notesRoute:
        return MaterialPageRoute(builder: (context) => const NotesView());

      // Using a fade animation for this view.
      case addNewNoteRoute:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const AddNewNoteView(),
          settings: settings,
          transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
            opacity: animation,
            child: child,
          ),
        );

      case verifyEmailRoute:
        return MaterialPageRoute(builder: (context) => const VerifyEmailView());

      default:
        return MaterialPageRoute(builder: (context) => const PageNotFoundView());
    }
  }
}
