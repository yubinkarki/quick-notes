import 'package:okaychata/imports/flutter_imports.dart'
    show
        Widget,
        Center,
        Scaffold,
        Threshold,
        Animation,
        debugPrint,
        BuildContext,
        FadeTransition,
        StatelessWidget,
        AnimatedSwitcher,
        CircularProgressIndicator;

import 'package:okaychata/imports/third_party_imports.dart' show ReadContext, BlocConsumer, FlutterNativeSplash;

import 'package:okaychata/imports/first_party_imports.dart'
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
  const HomeView({super.key});

  Future<void> closeSplash() async {
    await Future<void>.delayed(const Duration(seconds: 2));

    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    closeSplash();

    context.read<AuthBloc>().add(const AuthEventInitialize());

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (BuildContext context, AuthState state) {
        if (state.isLoading ?? false) {
          debugPrint('${state.isLoading}');
        } else {
          LoadingOverlay().hide();
        }
      },
      builder: (BuildContext context, AuthState state) => AnimatedSwitcher(
        switchOutCurve: const Threshold(0),
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        child: buildScreen(state),
      ),
    );
  }

  Widget buildScreen(AuthState state) {
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
  }

  Scaffold spinner() => const Scaffold(body: Center(child: CircularProgressIndicator()));
}
