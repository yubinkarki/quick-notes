import 'package:flutter/foundation.dart' show immutable;

import 'package:equatable/equatable.dart' show EquatableMixin;

import 'package:okaychata/services/auth/auth_user.dart' show AuthUser;

@immutable
abstract class AuthState {
  final bool? isLoading;
  final String? loadingText;

  const AuthState({this.isLoading = false, this.loadingText = "Please wait..."});
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({bool isLoading = false}) : super(isLoading: isLoading);
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;

  const AuthStateRegistering({this.exception, bool isLoading = false}) : super(isLoading: isLoading);
}

class AuthStateForgotPassword extends AuthState {
  final Exception? exception;
  final bool hasSentEmail;

  const AuthStateForgotPassword({
    required this.exception,
    required this.hasSentEmail,
    bool isLoading = false,
  }) : super(isLoading: isLoading);
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;

  const AuthStateLoggedIn(this.user, {bool isLoading = false}) : super(isLoading: isLoading);
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({bool isLoading = false}) : super(isLoading: isLoading);
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;

  const AuthStateLoggedOut({required this.exception, bool isLoading = false}) : super(isLoading: isLoading);

  @override
  List<Object?> get props => [exception, isLoading];
}
