import "package:flutter/foundation.dart" show immutable;

import "package:firebase_auth/firebase_auth.dart" show User;

@immutable
class AuthUser {
  final String id;
  final String email;
  final bool isEmailVerified;

  const AuthUser({
    required this.email,
    required this.isEmailVerified,
    required this.id,
  });

  // Defining a factory constructor called firebaseCheck.
  factory AuthUser.firebaseCheck(User user) => AuthUser(
        id: user.uid,
        email: user.email!,
        isEmailVerified: user.emailVerified,
      );
}
