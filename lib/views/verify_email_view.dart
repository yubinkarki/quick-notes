import 'package:flutter/material.dart';

import 'package:okaychata/constants/routes.dart';
import 'package:okaychata/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify your email"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 50, right: 50),
            margin: const EdgeInsets.only(bottom: 20),
            child: const Text(
              "We've sent you an email verification. Please open it to verify your account.",
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: const Text(
              "If you haven't received a verification email yet, press the button below.",
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 30),
            child: TextButton(
              onPressed: () async {
                AuthService.factoryFirebase().sendEmailVerification();
              },
              child: const Text("Send email verification"),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: TextButton(
              onPressed: () async {
                AuthService.factoryFirebase().logOut();

                if (!mounted) return;

                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              },
              child: const Text("Go to Login screen"),
            ),
          )
        ],
      ),
    );
  }
}
