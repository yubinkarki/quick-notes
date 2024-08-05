import 'package:okaychata/imports/flutter_imports.dart' show BuildContext;

import 'package:okaychata/imports/first_party_imports.dart' show AppStrings, showGenericDialog;

Future<bool> showLogoutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: AppStrings.logout,
    content: AppStrings.logoutConfirmation,
    optionsBuilder: () => <String, bool>{AppStrings.cancel: false, AppStrings.logout: true},
  );
}
