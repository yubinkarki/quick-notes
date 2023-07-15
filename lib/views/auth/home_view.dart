import 'package:flutter/material.dart';

import 'login_view.dart';
import 'verify_email_view.dart';
import '../note/notes_view.dart';
import 'package:okaychata/services/auth/auth_service.dart' show AuthService;

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.factoryFirebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.factoryFirebase().currentUser;

            if (user != null) {
              if (!user.isEmailVerified) {
                return const VerifyEmailView();
              } else {
                return const NotesView();
              }
            } else {
              return const LoginView();
            }

          default:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
        }
      },
    );
  }
}
