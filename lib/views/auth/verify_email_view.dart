import 'package:okaychata/imports/flutter_imports.dart';

import 'package:okaychata/imports/third_party_imports.dart' show ReadContext;

import 'package:okaychata/imports/first_party_imports.dart'
    show AppStrings, AuthBloc, AuthEventSendEmailVerification, AuthEventLogout;

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verify your email',
          style: textTheme.titleLarge,
        ),
      ),
      body: ColoredBox(
        color: Theme.of(context).colorScheme.surface,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Flexible>[
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Container>[
                  Container(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      AppStrings.emailVerificationConfirmation,
                      textAlign: TextAlign.center,
                      style: textTheme.labelSmall,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    child: Text(
                      AppStrings.resendEmailVerification,
                      textAlign: TextAlign.center,
                      style: textTheme.labelSmall,
                    ),
                  ),
                  Container(
                    width: 260.0,
                    height: 60.0,
                    margin: const EdgeInsets.only(top: 60),
                    child: OutlinedButton(
                      onPressed: () => context.read<AuthBloc>().add(const AuthEventSendEmailVerification()),
                      child: Text(
                        AppStrings.sendEmailVerification,
                        style: textTheme.labelMedium,
                      ),
                    ),
                  ),
                  Container(
                    width: 260.0,
                    height: 60.0,
                    margin: const EdgeInsets.only(top: 20),
                    child: OutlinedButton(
                      onPressed: () => context.read<AuthBloc>().add(const AuthEventLogout()),
                      child: Text(
                        AppStrings.goToLogin,
                        style: textTheme.labelMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
