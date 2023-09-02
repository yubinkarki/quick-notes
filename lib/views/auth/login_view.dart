import 'package:okaychata/constants/common_imports.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  Future<void> _handleLogin(BuildContext context) async {
    _dismissKeyboard(context);

    final email = _email.text;
    final password = _password.text;

    await Future.delayed(const Duration(milliseconds: 150));

    if (!mounted) return;

    context.read<AuthBloc>().add(AuthEventLogin(email, password));
  }

  Future<void> _handleNavigateToRegister(BuildContext context) async {
    _dismissKeyboard(context);

    await Future.delayed(const Duration(milliseconds: 150));

    if (!mounted) return;

    context.read<AuthBloc>().add(const AuthEventShouldRegister());

    // Navigator.of(context).pushNamedAndRemoveUntil(
    //   registerRoute,
    //   (route) => false,
    // );
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
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, AppStrings.noUser);
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, AppStrings.incorrectPassword);
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, AppStrings.authError);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.login, style: textTheme.titleLarge),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => _dismissKeyboard(context),
          child: Container(
            color: Theme.of(context).colorScheme.background,
            child: Padding(
              padding: const EdgeInsets.only(
                left: AppPadding.p20,
                top: AppPadding.p20,
                right: AppPadding.p20,
                bottom: AppPadding.p20,
              ),
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
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(hintText: AppStrings.enterPassword),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: AppMargin.m50),
                    child: TextButton(
                      onPressed: () => _handleLogin(context),
                      child: Text(AppStrings.login, style: textTheme.labelMedium),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => context.read<AuthBloc>().add(const AuthEventForgotPassword()),
                    child: Text(AppStrings.forgotPassword, style: textTheme.labelMedium),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => _handleNavigateToRegister(context),
                    child: Text(AppStrings.goToRegister, style: textTheme.labelMedium),
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
