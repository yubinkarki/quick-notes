import 'package:okaychata/imports/flutter_imports.dart';

import 'package:okaychata/imports/third_party_imports.dart' show BlocListener, ReadContext;

import 'package:okaychata/imports/first_party_imports.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _passwordVisible = false;

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

    final String email = _email.text;
    final String password = _password.text;

    await Future<void>.delayed(const Duration(milliseconds: 150));

    if (!context.mounted) return;

    context.read<AuthBloc>().add(AuthEventLogin(email, password));
  }

  Future<void> _handleNavigateToRegister(BuildContext context) async {
    _dismissKeyboard(context);

    await Future<void>.delayed(const Duration(milliseconds: 150));

    if (!context.mounted) return;

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
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorTheme = Theme.of(context).colorScheme;

    return BlocListener<AuthBloc, AuthState>(
      listener: (BuildContext context, AuthState state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context: context, text: AppStrings.noUser);
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context: context, text: AppStrings.incorrectPassword);
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context: context, text: AppStrings.authError);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.login, style: textTheme.titleLarge?.copyWith(color: Colors.white)),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => _dismissKeyboard(context),
          child: Container(
            color: colorTheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(AppPadding.p20),
              child: Column(
                children: <Widget>[
                  AppSize.s20.sizedBoxHeight,
                  TextField(
                    controller: _email,
                    autocorrect: false,
                    enableSuggestions: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: AppStrings.enterEmail, helperText: AppStrings.empty),
                  ),
                  TextField(
                    autocorrect: false,
                    controller: _password,
                    enableSuggestions: false,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      helperText: AppStrings.empty,
                      labelText: AppStrings.enterPassword,
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                        icon: Icon(size: AppSize.s22, _passwordVisible ? Icons.visibility_off : Icons.visibility),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: AppMargin.m50),
                    child: TextButton(
                      onPressed: () => _handleLogin(context),
                      child: Padding(
                        padding: const EdgeInsets.all(AppPadding.p8),
                        child: Text(AppStrings.login, style: textTheme.labelMedium),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => context.read<AuthBloc>().add(const AuthEventForgotPassword()),
                    child: Padding(
                      padding: const EdgeInsets.all(AppPadding.p8),
                      child: Text(AppStrings.forgotPassword, style: textTheme.labelMedium),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => _handleNavigateToRegister(context),
                    child: Padding(
                      padding: const EdgeInsets.all(AppPadding.p8),
                      child: Text(AppStrings.goToRegister, style: textTheme.labelMedium),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
}
