import 'package:okaychata/constants/value_manager.dart';
import 'package:okaychata/imports/flutter_imports.dart';

import 'package:okaychata/imports/third_party_imports.dart' show ReadContext;

import 'package:okaychata/imports/first_party_imports.dart'
    show AppStrings, AuthBloc, AuthEventSendEmailVerification, AuthEventLogout, StringExtension;

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.verifyEmail.titleCase, style: textTheme.titleLarge?.copyWith(color: Colors.white)),
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
                    margin: const EdgeInsets.only(bottom: AppMargin.m20),
                    padding: const EdgeInsets.symmetric(horizontal: AppPadding.p50),
                    child: Text(
                      AppStrings.emailVerificationConfirmation,
                      textAlign: TextAlign.center,
                      style: textTheme.labelSmall,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppPadding.p50),
                    child: Text(
                      AppStrings.resendEmailVerification,
                      textAlign: TextAlign.center,
                      style: textTheme.labelSmall,
                    ),
                  ),
                  Container(
                    width: AppSize.s260,
                    height: AppSize.s60,
                    margin: const EdgeInsets.only(top: AppMargin.m40),
                    child: OutlinedButton(
                      onPressed: () => context.read<AuthBloc>().add(const AuthEventSendEmailVerification()),
                      child: Text(
                        AppStrings.sendEmailVerification,
                        style: textTheme.labelMedium,
                      ),
                    ),
                  ),
                  Container(
                    width: AppSize.s260,
                    height: AppSize.s60,
                    margin: const EdgeInsets.only(top: AppMargin.m20),
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
