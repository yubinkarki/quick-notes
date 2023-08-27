import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext, BlocConsumer;

import 'login_view.dart' show LoginView;
import 'package:okaychata/bloc/auth/auth_state.dart';
import 'verify_email_view.dart' show VerifyEmailView;
import 'package:okaychata/bloc/auth/auth_bloc.dart' show AuthBloc;
import 'package:okaychata/views/note/notes_view.dart' show NotesView;
import 'package:okaychata/views/auth/register_view.dart' show RegisterView;
import 'package:okaychata/bloc/auth/auth_event.dart' show AuthEventInitialize;
import 'package:okaychata/utilities/global/loading_overlay.dart' show LoadingOverlay;

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading ?? false) {
          // LoadingOverlay().show(context: context, text: state.loadingText ?? "Please wait...");
          debugPrint("${state.isLoading}");
        } else {
          LoadingOverlay().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return spinner();
        }
      },
    );
  }

  Scaffold spinner() {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
