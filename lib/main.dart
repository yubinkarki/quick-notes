import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import "dart:developer" as devtools show log;

import 'package:okaychata/firebase_options.dart';
import 'package:okaychata/views/login_view.dart';
import 'package:okaychata/views/register_view.dart';
import 'package:okaychata/views/verify_email_view.dart';

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
        "/login/": (context) => const LoginView(),
        "/register/": (context) => const RegisterView(),
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
                print("Email is verified.");
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }

            return const NotesView();

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

enum MenuAction { logout, nothing }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main UI"),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogoutDialog(context);

                  devtools.log(shouldLogout.toString());
                  break;

                case MenuAction.nothing:
                  devtools.log("This is nothing.");
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text("Log Out"),
                ),
                PopupMenuItem<MenuAction>(
                  value: MenuAction.nothing,
                  child: Text("Nothing"),
                ),
              ];
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.green[200],
        alignment: Alignment.center,
        child: const Text(
          "Hello World",
          style: TextStyle(
            fontSize: 40,
          ),
        ),
      ),
    );
  }
}

Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Log Out"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text("Log Out"),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
