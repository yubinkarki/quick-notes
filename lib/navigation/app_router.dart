import 'package:flutter/material.dart';

import 'package:okaychata/constants/routes.dart';
import 'package:okaychata/views/auth/home_view.dart';
import 'package:okaychata/views/note/notes_view.dart';
import 'package:okaychata/views/auth/login_view.dart';
import 'package:okaychata/views/auth/register_view.dart';
import 'package:okaychata/views/note/new_note_view.dart';
import 'package:okaychata/views/auth/verify_email_view.dart';
import 'package:okaychata/views/invalid/page_not_found_view.dart';

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

      case newNoteRoute:
        return MaterialPageRoute(builder: (context) => const NewNoteView());

      case verifyEmailRoute:
        return MaterialPageRoute(builder: (context) => const VerifyEmailView());

      default:
        return MaterialPageRoute(builder: (context) => const PageNotFoundView());
    }
  }
}
