import 'package:okaychata/constants/common_imports.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool _passwordVisible = false;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  void _handleRegister(BuildContext context) async {
    _dismissKeyboard(context);

    final email = _email.text;
    final password = _password.text;

    await Future.delayed(const Duration(milliseconds: 200));

    if (!mounted) return;

    context.read<AuthBloc>().add(AuthEventRegister(email, password));
  }

  void _handleNavigateToLogin(BuildContext context) async {
    _dismissKeyboard(context);

    await Future.delayed(const Duration(milliseconds: 150));

    if (!mounted) return;

    context.read<AuthBloc>().add(const AuthEventLogout());
  }

  void _dismissKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return BlocListener<AuthBloc, AuthState>(
      listener: (BuildContext context, AuthState state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, "Weak password");
          } else if (state.exception is EmailAlreadyUsedAuthException) {
            await showErrorDialog(context, "Email is already used");
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, "Invalid email");
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, "Failed to register");
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Register", style: textTheme.titleLarge),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _dismissKeyboard(context),
          child: Container(
            color: Theme.of(context).colorScheme.background,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(hintText: AppStrings.enterEmail),
                  ),
                  TextField(
                    controller: _password,
                    obscureText: !_passwordVisible,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: AppStrings.enterPassword,
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                        icon: Icon(
                          _passwordVisible ? Icons.visibility_off : Icons.visibility,
                          size: 22.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 50),
                    child: TextButton(
                      onPressed: () => _handleRegister(context),
                      child: Text("Register", style: textTheme.labelMedium),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => _handleNavigateToLogin(context),
                    child: Text("Go to Login", style: textTheme.labelMedium),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
