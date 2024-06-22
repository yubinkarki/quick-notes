import 'package:okaychata/imports/flutter_imports.dart' show BuildContext;

import 'package:okaychata/imports/first_party_imports.dart' show AppStrings;

import 'show_generic_dialog.dart' show showGenericDialog;

Future<void> showPasswordResetDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: AppStrings.passwordReset,
    content: AppStrings.passwordResetSubtitle,
    optionsBuilder: () => <String, dynamic>{'OK': null},
  );
}
