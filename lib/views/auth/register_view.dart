import 'package:flutter/material.dart';

import 'package:okaychata/constants/routes.dart';
import 'package:okaychata/services/auth/auth_exceptions.dart';
import 'package:okaychata/services/auth/auth_service.dart' show AuthService;
import 'package:okaychata/utilities/dialogs/show_error_dialog.dart' show showErrorDialog;

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
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Register",
          style: textTheme.titleLarge,
        ),
      ),
      body: GestureDetector(
        // This is to dismiss keyboard when tapped anywhere on the screen.
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: Container(
          color: Theme.of(context).colorScheme.background,
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
                  margin: const EdgeInsets.only(top: 50),
                  child: TextButton(
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus(); // Removing input focus to dismiss keyboard.

                      final email = _email.text;
                      final password = _password.text;

                      await Future.delayed(const Duration(milliseconds: 300));

                      if (!mounted) return;

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
                    child: Text(
                      "Register",
                      style: textTheme.labelMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (route) => false,
                    );
                  },
                  child: Text(
                    "Go to Login",
                    style: textTheme.labelMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
