import 'package:okaychata/services/auth/auth_user.dart';
import 'package:okaychata/services/auth/auth_provider.dart';
import 'package:okaychata/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;

  const AuthService(this.provider);

  factory AuthService.factoryFirebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<void> initialize() => provider.initialize();

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<AuthUser> signUp({
    required String email,
    required String password,
  }) =>
      provider.signUp(
        email: email,
        password: password,
      );

  @override
  Future<void> logOut() => provider.logOut();
}
