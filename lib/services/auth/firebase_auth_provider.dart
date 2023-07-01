import "package:firebase_core/firebase_core.dart" show Firebase;
import "package:firebase_auth/firebase_auth.dart" show FirebaseAuth, FirebaseAuthException;

import "package:okaychata/services/auth/auth_exceptions.dart";
import "package:okaychata/services/auth/auth_user.dart" show AuthUser;
import "package:okaychata/firebase_options.dart" show DefaultFirebaseOptions; // Created by Firebase CLI.
import "package:okaychata/services/auth/auth_provider.dart" show AuthProvider;

// Implementing the abstract class. Needs to fulfill the contract of the interface.
class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Calling the factory constructor. Returns 'emailVerified' boolean.
      return AuthUser.firebaseCheck(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

      final user = currentUser;

      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        throw WeakPasswordAuthException();
      } else if (e.code == "email-already-in-use") {
        throw EmailAlreadyUsedAuthException();
      } else if (e.code == "invalid-email") {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = currentUser;

      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        throw UserNotFoundAuthException();
      } else if (e.code == "wrong-password") {
        throw WrongPasswordAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }
}
