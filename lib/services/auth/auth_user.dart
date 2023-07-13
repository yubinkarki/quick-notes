import "package:flutter/foundation.dart" show immutable;

import "package:firebase_auth/firebase_auth.dart" show User;

@immutable
class AuthUser {
  final String? email;
  final bool isEmailVerified;

  const AuthUser({required this.email, required this.isEmailVerified});

  // Defining a factory constructor called firebaseCheck.
  factory AuthUser.firebaseCheck(User user) => AuthUser(
        email: user.email,
        isEmailVerified: user.emailVerified,
      );
}
