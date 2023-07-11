import 'package:flutter/material.dart';

import 'package:okaychata/views/home_view.dart';
import 'package:okaychata/constants/routes.dart';
import 'package:okaychata/views/login_view.dart';
import 'package:okaychata/views/notes_view.dart';
import 'package:okaychata/views/register_view.dart';
import 'package:okaychata/views/verify_email_view.dart';
import 'package:okaychata/views/page_not_found_view.dart';

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

      case verifyEmailRoute:
        return MaterialPageRoute(builder: (context) => const VerifyEmailView());

      default:
        return MaterialPageRoute(builder: (context) => const PageNotFoundView());
    }
  }
}
