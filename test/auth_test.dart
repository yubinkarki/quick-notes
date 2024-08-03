import 'package:test/test.dart';

import 'package:okaychata/services/auth/auth_exceptions.dart';
import 'package:okaychata/services/auth/auth_user.dart' show AuthUser;
import 'package:okaychata/services/auth/auth_provider.dart' show AuthProvider;

void main() {
  // 8 tests in total.
  group('Mock Authentication -', () {
    final MockAuthProvider provider = MockAuthProvider();

    test('Should not be initialized at the start', () {
      expect(provider.isInitialized, false);
    });

    test('Can not logout if not initialized', () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    test('Should be initialized', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('User should be null after initialization', () {
      expect(provider.currentUser, null);
    });

    // Testing a function that should complete in 2 seconds.
    test(
      'Should initialize in < 2 seconds',
      () async {
        await provider.initialize(); // This takes 1 second.
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test('Signup should delegate to login function', () async {
      // Including await on this signUp function will break this test.
      final Future<AuthUser> badEmail = provider.signUp(email: 'foo@bar.com', password: 'password');

      expect(
        badEmail,
        throwsA(const TypeMatcher<UserNotFoundAuthException>()),
      );

      // Same as above.
      final Future<AuthUser> badPassword = provider.signUp(email: 'email@bar.com', password: 'foobar');

      expect(
        badPassword,
        throwsA(const TypeMatcher<WrongPasswordAuthException>()),
      );

      final AuthUser goodUser = await provider.signUp(email: 'foo@gmail.com', password: 'foobar@123');

      expect(provider.currentUser, goodUser);
      expect(goodUser.isEmailVerified, false);
    });

    test('Logged in user should be able to get verified', () async {
      await provider.sendEmailVerification();

      final AuthUser? user = provider.currentUser;

      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('Should be able to logout and login again', () async {
      await provider.logOut();
      await provider.logIn(email: 'foo@gmail.com', password: 'foobar@123');

      final AuthUser? user = provider.currentUser;

      expect(user, isNotNull);
    });
  });
}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future<void>.delayed(const Duration(seconds: 1));

    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    if (!isInitialized) throw NotInitializedException();
    if (password == 'foobar') throw WrongPasswordAuthException();
    if (email == 'foo@bar.com') throw UserNotFoundAuthException();

    const AuthUser user = AuthUser(isEmailVerified: false, email: 'random@gmail.com', id: 'random_id');

    _user = user;

    return Future<AuthUser>.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();

    await Future<void>.delayed(const Duration(seconds: 1));

    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();

    if (_user == null) throw UserNotFoundAuthException();

    const AuthUser newUser = AuthUser(isEmailVerified: true, email: 'random@gmail.com', id: 'random_id');

    _user = newUser;
  }

  @override
  Future<AuthUser> signUp({required String email, required String password}) async {
    if (!isInitialized) throw NotInitializedException();

    // Fake delay for imitating api call.
    await Future<void>.delayed(const Duration(seconds: 1));

    return logIn(email: email, password: password);
  }

  @override
  Future<void> passwordReset({required String email}) {
    if (!isInitialized) throw NotInitializedException();

    throw UnimplementedError();
  }
}
