import 'package:okaychata/imports/flutter_imports.dart' show immutable;

import 'package:okaychata/imports/third_party_imports.dart' show User;

@immutable
class AuthUser {
  final String id;
  final String email;
  final bool isEmailVerified;

  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
  });

  // Defining a factory constructor called firebaseCheck.
  factory AuthUser.firebaseCheck(User user) =>
      AuthUser(id: user.uid, email: user.email!, isEmailVerified: user.emailVerified,);
}
