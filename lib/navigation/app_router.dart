import 'package:okaychata/imports/flutter_imports.dart'
    show
        Route,
        Cubic,
        Tween,
        Widget,
        Offset,
        Curves,
        Animation,
        Animatable,
        CurveTween,
        BuildContext,
        RouteSettings,
        SlideTransition,
        PageRouteBuilder,
        MaterialPageRoute;

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

      // Using a slide up animation for this view.
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
          ) {
            const Offset end = Offset.zero;
            const Cubic curve = Curves.ease;
            const Offset begin = Offset(0.0, 1.0);

            Animatable<Offset> tween = Tween<Offset>(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(position: animation.drive(tween), child: child);
          },
        );

      case verifyEmailRoute:
        return MaterialPageRoute<Widget>(builder: (BuildContext context) => const VerifyEmailView());

      default:
        return MaterialPageRoute<Widget>(builder: (BuildContext context) => const PageNotFoundView());
    }
  }
}
