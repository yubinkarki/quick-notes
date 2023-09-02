import 'package:okaychata/constants/common_imports.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();

            await showPasswordResetDialog(context);
          }

          if (!mounted) return;

          if (state.exception != null) {
            if (state.exception is InvalidEmailAuthException) {
              await showErrorDialog(context, "Invalid Auth Exception");
            } else if (state.exception is UserNotFoundAuthException) {
              await showErrorDialog(context, "User Not Found Exception");
            } else {
              await showErrorDialog(context, "Generic");
            }
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Forgot Password"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppPadding.p16),
          child: Column(
            children: [
              const Text(AppStrings.resetPasswordMessage),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                autofocus: true,
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: "Your email address...",
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final email = _controller.text;

                  context.read<AuthBloc>().add(AuthEventForgotPassword(email: email));
                },
                child: const Text("Send password reset link"),
              ),
              ElevatedButton(
                onPressed: () => context.read<AuthBloc>().add(const AuthEventLogout()),
                child: const Text("Back to Login"),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
