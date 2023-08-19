import 'package:okaychata/constants/common_imports.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  void _handleRegister(context) async {
    _dismissKeyboard(context);

    final email = _email.text;
    final password = _password.text;

    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    try {
      final firebaseAuthService = AuthService.factoryFirebase();

      await firebaseAuthService.signUp(
        email: email,
        password: password,
      );

      await firebaseAuthService.sendEmailVerification();

      // Don't use 'BuildContext's across async gaps.
      if (!mounted) return;

      Navigator.of(context).pushNamed(verifyEmailRoute);
    } on WeakPasswordAuthException {
      await showErrorDialog(
        context,
        "Weak password",
      );
    } on EmailAlreadyUsedAuthException {
      await showErrorDialog(
        context,
        "Email is already used",
      );
    } on InvalidEmailAuthException {
      await showErrorDialog(
        context,
        "Invalid email",
      );
    } on GenericAuthException {
      await showErrorDialog(
        context,
        "Failed to register",
      );
    }
  }

  void _handleNavigateToLogin(context) async {
    _dismissKeyboard(context);

    await Future.delayed(const Duration(milliseconds: 150));

    if (!mounted) return;

    Navigator.of(context).pushNamedAndRemoveUntil(
      loginRoute,
      (route) => false,
    );
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

    return Scaffold(
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
                  decoration: const InputDecoration(hintText: "Enter your email"),
                ),
                TextField(
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(hintText: "Enter your password"),
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
    );
  }
}
