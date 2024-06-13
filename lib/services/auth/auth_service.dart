import 'package:okaychata/imports/first_party_imports.dart' show AuthUser, AuthProvider, FirebaseAuthProvider;

class AuthService implements AuthProvider {
  final AuthProvider provider;

  const AuthService(this.provider);

  // This factory constructor is calling the default constructor above.
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
      provider.logIn(email: email, password: password);

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<AuthUser> signUp({
    required String email,
    required String password,
  }) =>
      provider.signUp(email: email, password: password);

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> passwordReset({required String email}) => provider.passwordReset(email: email);
}
