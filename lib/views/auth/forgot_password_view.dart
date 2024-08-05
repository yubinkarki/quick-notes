import 'package:okaychata/imports/flutter_imports.dart';

import 'package:okaychata/imports/third_party_imports.dart' show BlocListener, ReadContext;

import 'package:okaychata/imports/first_party_imports.dart'
    show
        AuthBloc,
        AppMargin,
        AuthState,
        Validator,
        AppStrings,
        AppPadding,
        AppExceptions,
        DoubleExtension,
        AuthEventLogout,
        showErrorDialog,
        StringExtension,
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
  late final TextEditingController _emailController;
  final GlobalKey _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
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
    final String email = _emailController.text;
    await Future<void>.delayed(const Duration(milliseconds: 150));

    if (!context.mounted) return;

    if ((_formKey.currentState as FormState).validate()) {
      context.read<AuthBloc>().add(AuthEventForgotPassword(email: email));
    }
  }

  Future<void> _handleBackToLogin(BuildContext context) async {
    _dismissKeyboard(context);
    await Future<void>.delayed(const Duration(milliseconds: 200));

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
            _emailController.clear();
            await showPasswordResetDialog(context);
          }

          if (!context.mounted) return;

          if (state.exception != null) {
            if (state.exception is InvalidEmailAuthException) {
              await showErrorDialog(context: context, text: AppExceptions.invalidAuthException);
            } else if (state.exception is UserNotFoundAuthException) {
              await showErrorDialog(context: context, text: AppExceptions.userNotFoundException);
            } else {
              await showErrorDialog(context: context, text: AppExceptions.somethingWentWrongException);
            }
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.forgotPassword.titleCase, style: textTheme.labelLarge?.copyWith(color: Colors.white)),
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
                    AppMargin.m12.sizedBoxHeight,
                    Text(AppStrings.resetPasswordMessage, style: textTheme.labelMedium),
                    const SizedBox(height: AppMargin.m40),
                    TextFormField(
                      autofocus: true,
                      autocorrect: false,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: AppStrings.email, helperText: AppStrings.empty),
                      validator: (String? value) => Validator.emptyValidation(value, AppStrings.email.toLowerCase()),
                    ),
                    AppMargin.m40.sizedBoxHeight,
                    OutlinedButton.icon(
                      icon: const Padding(
                        padding: EdgeInsets.only(left: AppPadding.p10),
                        child: Icon(Icons.email),
                      ),
                      onPressed: () => _handleSendResetLink(context),
                      label: Padding(
                        padding: const EdgeInsets.only(
                          top: AppPadding.p14,
                          right: AppPadding.p10,
                          bottom: AppPadding.p14,
                        ),
                        child: Text(AppStrings.sendPasswordResetLink, style: textTheme.labelSmall),
                      ),
                    ),
                    AppMargin.m20.sizedBoxHeight,
                    OutlinedButton.icon(
                      icon: const Padding(
                        padding: EdgeInsets.only(left: AppPadding.p4),
                        child: Icon(Icons.arrow_back),
                      ),
                      onPressed: () => _handleBackToLogin(context),
                      label: Padding(
                        padding: const EdgeInsets.only(
                          top: AppPadding.p14,
                          right: AppPadding.p4,
                          bottom: AppPadding.p14,
                        ),
                        child: Text(AppStrings.backToLogin, style: textTheme.labelSmall),
                      ),
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

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
