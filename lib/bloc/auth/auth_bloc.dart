import 'package:okaychata/imports/third_party_imports.dart' show Bloc, Emitter;

import 'package:okaychata/imports/first_party_imports.dart'
    show
        AuthUser,
        AuthState,
        AuthEvent,
        AuthProvider,
        AuthEventLogin,
        AuthEventLogout,
        AuthEventRegister,
        AuthStateLoggedIn,
        AuthStateLoggedOut,
        AuthEventInitialize,
        AuthStateRegistering,
        AuthStateUninitialized,
        AuthEventShouldRegister,
        AuthStateForgotPassword,
        AuthEventForgotPassword,
        AuthStateNeedsVerification,
        AuthEventSendEmailVerification;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthProvider provider;

  // Providing 'AuthStateUninitialized' as the initial state for this bloc.
  AuthBloc(this.provider) : super(const AuthStateUninitialized()) {
    on<AuthEventLogin>(_login);
    on<AuthEventLogout>(_logout);
    on<AuthEventRegister>(_register);
    on<AuthEventInitialize>(_checkAuthState);
    on<AuthEventShouldRegister>(_shouldRegister);
    on<AuthEventForgotPassword>(_forgotPassword);
    on<AuthEventSendEmailVerification>(_sendEmailVerification);
  }

  Future<void> _checkAuthState(
    AuthEventInitialize event,
    Emitter<AuthState> emit,
  ) async {
    await provider.initialize();

    final AuthUser? user = provider.currentUser;

    if (user == null) {
      emit(const AuthStateLoggedOut(exception: null, isLoading: false));
    } else if (!user.isEmailVerified) {
      emit(const AuthStateNeedsVerification());
    } else {
      emit(AuthStateLoggedIn(user));
    }
  }

  void _shouldRegister(
    AuthEventShouldRegister event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthStateRegistering(exception: null));
  }

  Future<void> _sendEmailVerification(
    AuthEventSendEmailVerification event,
    Emitter<AuthState> emit,
  ) async {
    await provider.sendEmailVerification();

    emit(state);
  }

  Future<void> _login(
    AuthEventLogin event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthStateLoggedOut(exception: null, isLoading: true));

    try {
      final AuthUser user = await provider.logIn(email: event.email, password: event.password);

      if (!user.isEmailVerified) {
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
        emit(const AuthStateNeedsVerification());
      } else {
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
        emit(AuthStateLoggedIn(user));
      }
    } on Exception catch (e) {
      emit(AuthStateLoggedOut(exception: e, isLoading: false));
    }
  }

  Future<void> _register(
    AuthEventRegister event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await provider.signUp(email: event.email, password: event.password);
      await provider.sendEmailVerification();

      emit(const AuthStateNeedsVerification());
    } on Exception catch (e) {
      emit(AuthStateRegistering(exception: e));
    }
  }

  Future<void> _logout(
    AuthEventLogout event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await provider.logOut();

      emit(const AuthStateLoggedOut(exception: null, isLoading: false));
    } on Exception catch (e) {
      emit(AuthStateLoggedOut(exception: e, isLoading: false));
    }
  }

  Future<void> _forgotPassword(
    AuthEventForgotPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthStateForgotPassword(exception: null, hasSentEmail: false));

    final String? email = event.email;

    if (email == null) return; // User wants to go to forgot-password screen.

    emit(const AuthStateForgotPassword(exception: null, hasSentEmail: false, isLoading: true));

    bool didSendEmail;
    Exception? exception;

    try {
      await provider.passwordReset(email: email);

      didSendEmail = true;
      exception = null;
    } on Exception catch (e) {
      didSendEmail = false;
      exception = e;
    }

    emit(AuthStateForgotPassword(exception: exception, hasSentEmail: didSendEmail, isLoading: false));
  }
}
