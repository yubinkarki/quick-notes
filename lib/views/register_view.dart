import 'package:flutter/material.dart';

import 'package:okaychata/constants/routes.dart';
import 'package:okaychata/services/auth/auth_exceptions.dart';
import 'package:okaychata/services/auth/auth_service.dart';
import 'package:okaychata/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Container(
        color: Colors.teal[50],
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: "Enter your email",
                ),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: "Enter your password",
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: TextButton(
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus(); // Removing input focus to dismiss keyboard.

                    final email = _email.text;
                    final password = _password.text;

                    try {
                      final firebaseAuthService = AuthService.factoryFirebase();

                      await firebaseAuthService.signUp(
                        email: email,
                        password: password,
                      );

                      await firebaseAuthService.sendEmailVerification();

                      // Idk about this. Just satisfying a linter error.
                      if (!mounted) return;

                      // Don't use 'BuildContext's across async gaps.
                      Navigator.of(context).pushNamed(verifyEmailRoute);
                    } on WeakPasswordAuthException {
                      await showErrorDialog(
                        context,
                        "Weak password",
                      );
                    } on EmailAlreadyUsedAuthException {
                      await showErrorDialog(
                        context,
                        "Email is already used",
                      );
                    } on InvalidEmailAuthException {
                      await showErrorDialog(
                        context,
                        "Invalid email",
                      );
                    } on GenericAuthException {
                      await showErrorDialog(
                        context,
                        "Failed to register",
                      );
                    }
                  },
                  child: const Text("Register"),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,
                    (route) => false,
                  );
                },
                child: const Text("Go to Login"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
