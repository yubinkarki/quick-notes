import 'package:flutter/material.dart';

import 'package:okaychata/constants/routes.dart';
import 'package:okaychata/services/auth/auth_exceptions.dart';
import 'package:okaychata/constants/static_strings.dart' show AppStrings;
import 'package:okaychata/services/auth/auth_service.dart' show AuthService;
import 'package:okaychata/constants/value_manager.dart' show AppPadding, AppMargin;
import 'package:okaychata/utilities/dialogs/show_error_dialog.dart' show showErrorDialog;

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
          AppStrings.login,
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
            padding: const EdgeInsets.only(
              left: AppPadding.p20,
              top: AppPadding.p20,
              right: AppPadding.p20,
              bottom: AppPadding.p20,
            ),
            child: Column(
              children: [
                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    hintText: AppStrings.enterEmail,
                  ),
                ),
                TextField(
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    hintText: AppStrings.enterPassword,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: AppMargin.m50),
                  child: TextButton(
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus(); // Removing input focus to dismiss keyboard.

                      final email = _email.text;
                      final password = _password.text;

                      await Future.delayed(const Duration(milliseconds: 300));

                      if (!mounted) return;

                      try {
                        final firebaseAuthService = AuthService.factoryFirebase();

                        await firebaseAuthService.logIn(
                          email: email,
                          password: password,
                        );

                        final user = firebaseAuthService.currentUser;

                        if (!mounted) return;

                        if (user?.isEmailVerified ?? false) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            notesRoute,
                            (route) => false,
                          );
                        } else {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            verifyEmailRoute,
                            (route) => false,
                          );
                        }
                      } on UserNotFoundAuthException {
                        await showErrorDialog(
                          context,
                          AppStrings.noUser,
                        );
                      } on WrongPasswordAuthException {
                        await showErrorDialog(
                          context,
                          AppStrings.incorrectPassword,
                        );
                      } on GenericAuthException {
                        await showErrorDialog(
                          context,
                          AppStrings.authError,
                        );
                      }
                    },
                    child: Text(
                      AppStrings.login,
                      style: textTheme.labelMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      registerRoute,
                      (route) => false,
                    );
                  },
                  child: Text(
                    AppStrings.goToRegister,
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
