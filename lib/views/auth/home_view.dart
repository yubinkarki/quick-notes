import "package:okaychata/imports/flutter_imports.dart"
    show StatelessWidget, Key, Widget, BuildContext, debugPrint, Scaffold, CircularProgressIndicator, Center;

import "package:okaychata/imports/third_party_imports.dart" show ReadContext, BlocConsumer, FlutterNativeSplash;

import "package:okaychata/imports/first_party_imports.dart"
    show
        AuthBloc,
        AuthState,
        LoginView,
        NotesView,
        RegisterView,
        LoadingOverlay,
        VerifyEmailView,
        AuthStateLoggedIn,
        AuthStateLoggedOut,
        ForgotPasswordView,
        AuthEventInitialize,
        AuthStateRegistering,
        AuthStateForgotPassword,
        AuthStateNeedsVerification;

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  Future<void> closeSplash() async {
    await Future.delayed(const Duration(seconds: 2));

    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    closeSplash();

    context.read<AuthBloc>().add(const AuthEventInitialize());

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading ?? false) {
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
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
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
