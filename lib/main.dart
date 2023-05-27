import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:developer' as devtools show log;

import 'package:okaychata/constants/routes.dart';
import 'package:okaychata/firebase_options.dart';
import 'package:okaychata/views/login_view.dart';
import 'package:okaychata/views/register_view.dart';
import 'package:okaychata/views/verify_email_view.dart';
import 'package:okaychata/views/notes_view.dart';

void main() {
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
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;

            if (user != null) {
              if (user.emailVerified) {
                devtools.log("Email is verified.");
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }

            return const NotesView();

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
