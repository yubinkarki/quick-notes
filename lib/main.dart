import 'package:flutter/material.dart';

import 'package:okaychata/constants/routes.dart';
import 'package:okaychata/views/login_view.dart' show LoginView;
import 'package:okaychata/views/notes_view.dart' show NotesView;
import 'package:okaychata/views/register_view.dart' show RegisterView;
import 'package:okaychata/services/auth/auth_service.dart' show AuthService;
import 'package:okaychata/views/verify_email_view.dart' show VerifyEmailView;

void main() {
  // To call native code by Firebase before running application.
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      title: 'Nice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
