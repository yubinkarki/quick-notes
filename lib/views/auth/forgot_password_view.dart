import 'package:okaychata/imports/flutter_imports.dart';

import 'package:okaychata/imports/third_party_imports.dart' show BlocListener, ReadContext;

import 'package:okaychata/imports/first_party_imports.dart'
    show
        AppSize,
        AuthBloc,
        AppMargin,
        AuthState,
        Validator,
        AppStrings,
        AppPadding,
        showErrorDialog,
        AuthEventLogout,
        AuthEventForgotPassword,
        showPasswordResetDialog,
        AuthStateForgotPassword,
        InvalidEmailAuthException,
        UserNotFoundAuthException;

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;
  final GlobalKey _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  void _dismissKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  Future<void> _handleSendResetLink(BuildContext context) async {
    _dismissKeyboard(context);
    final String email = _controller.text;
    await Future<void>.delayed(const Duration(milliseconds: 150));

    if (!context.mounted) return;

    if ((_formKey.currentState as FormState).validate()) {
      context.read<AuthBloc>().add(AuthEventForgotPassword(email: email));
    }
  }

  Future<void> _handleBackToLogin(BuildContext context) async {
    _dismissKeyboard(context);
    await Future<void>.delayed(const Duration(milliseconds: 150));

    if (!context.mounted) return;

    context.read<AuthBloc>().add(const AuthEventLogout());
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorTheme = Theme.of(context).colorScheme;

    return BlocListener<AuthBloc, AuthState>(
      listener: (BuildContext context, AuthState state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetDialog(context);
          }

          if (!context.mounted) return;

          if (state.exception != null) {
            if (state.exception is InvalidEmailAuthException) {
              await showErrorDialog(context, 'Invalid Auth Exception');
            } else if (state.exception is UserNotFoundAuthException) {
              await showErrorDialog(context, 'User Not Found Exception');
            } else {
              await showErrorDialog(context, 'Something went wrong');
            }
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Forgot Password'),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => _dismissKeyboard(context),
          child: Container(
            height: double.infinity,
            color: colorTheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(AppPadding.p20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: AppMargin.m12),
                    Text(AppStrings.resetPasswordMessage, style: textTheme.labelMedium),
                    const SizedBox(height: AppMargin.m40),
                    TextFormField(
                      autofocus: true,
                      autocorrect: false,
                      controller: _controller,
                      keyboardType: TextInputType.emailAddress,
                      decoration: inputDecoration(colorTheme: colorTheme),
                      validator: (String? value) => Validator.emptyValidation(value, 'email'),
                    ),
                    const SizedBox(height: AppMargin.m40),
                    OutlinedButton.icon(
                      label: Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppPadding.p14),
                        child: Text(AppStrings.sendPasswordResetLink, style: textTheme.labelSmall),
                      ),
                      icon: const Icon(Icons.email),
                      onPressed: () => _handleSendResetLink(context),
                    ),
                    const SizedBox(height: AppMargin.m20),
                    OutlinedButton.icon(
                      label: Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppPadding.p14),
                        child: Text(AppStrings.backToLogin, style: textTheme.labelSmall),
                      ),
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => _handleBackToLogin(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration({required ColorScheme colorTheme}) {
    return InputDecoration(
      labelText: AppStrings.email,
      helperText: AppStrings.empty,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 1, color: Colors.grey),
        borderRadius: BorderRadius.circular(AppSize.s10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: colorTheme.outline),
        borderRadius: BorderRadius.circular(AppSize.s10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: colorTheme.error),
        borderRadius: BorderRadius.circular(AppSize.s10),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: colorTheme.error),
        borderRadius: BorderRadius.circular(AppSize.s10),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
