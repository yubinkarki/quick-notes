import 'package:flutter/material.dart';

import 'package:okaychata/constants/routes.dart';
import 'package:okaychata/services/auth/auth_service.dart' show AuthService;

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Verify your email",
          style: textTheme.titleLarge,
        ),
      ),
      body: ColoredBox(
        color: Theme.of(context).colorScheme.background,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      "We've sent you an email verification. Please open it to verify your account.",
                      textAlign: TextAlign.center,
                      style: textTheme.labelSmall,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    child: Text(
                      "If you haven't received a verification email yet, press the button below.",
                      textAlign: TextAlign.center,
                      style: textTheme.labelSmall,
                    ),
                  ),
                  Container(
                    width: 260.0,
                    height: 60.0,
                    margin: const EdgeInsets.only(top: 60),
                    child: OutlinedButton(
                      onPressed: () async {
                        AuthService.factoryFirebase().sendEmailVerification();
                      },
                      child: Text(
                        "Send email verification",
                        style: textTheme.labelMedium,
                      ),
                    ),
                  ),
                  Container(
                    width: 260.0,
                    height: 60.0,
                    margin: const EdgeInsets.only(top: 20),
                    child: OutlinedButton(
                      onPressed: () async {
                        AuthService.factoryFirebase().logOut();

                        if (!mounted) return;

                        Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRoute,
                          (route) => false,
                        );
                      },
                      child: Text(
                        "Go to Login screen",
                        style: textTheme.labelMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
