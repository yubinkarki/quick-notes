import "package:flutter/foundation.dart" show immutable;
import "package:firebase_auth/firebase_auth.dart" show User;

@immutable
class AuthUser {
  final bool isEmailVerified;

  const AuthUser({required this.isEmailVerified});

  // Defining a factory constructor called firebaseCheck.
  factory AuthUser.firebaseCheck(User user) => AuthUser(isEmailVerified: user.emailVerified);
}
