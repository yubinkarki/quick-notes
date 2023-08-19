import 'package:bloc/bloc.dart' show Bloc, Emitter;

import 'package:okaychata/bloc/auth/auth_event.dart';
import 'package:okaychata/bloc/auth/auth_state.dart';
import 'package:okaychata/services/auth/auth_provider.dart' show AuthProvider;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthProvider provider;

  // Providing 'AuthStateLoading' as the initial state for this bloc.
  AuthBloc(this.provider) : super(const AuthStateLoading()) {
    on<AuthEventInitialize>(_checkAuthState);
    on<AuthEventLogin>(_login);
    on<AuthEventLogout>(_logout);
  }

  Future<void> _checkAuthState(
    AuthEventInitialize event,
    Emitter<AuthState> emit,
  ) async {
    await provider.initialize();

    final user = provider.currentUser;

    if (user == null) {
      emit(const AuthStateLoggedOut());
    } else if (!user.isEmailVerified) {
      emit(const AuthStateNeedsVerification());
    } else {
      emit(AuthStateLoggedIn(user));
    }
  }

  Future<void> _login(
    AuthEventLogin event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthStateLoading());

    try {
      final user = await provider.logIn(email: event.email, password: event.password);

      emit(AuthStateLoggedIn(user));
    } on Exception catch (e) {
      emit(AuthStateLoginFailure(e));
    }
  }

  Future<void> _logout(
    AuthEventLogout event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthStateLoading());

      await provider.logOut();

      emit(const AuthStateLoggedOut());
    } on Exception catch (e) {
      emit(AuthStateLogoutFailure(e));
    }
  }
}
