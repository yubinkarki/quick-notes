import 'package:okaychata/imports/flutter_imports.dart' show BuildContext;

import 'package:okaychata/imports/first_party_imports.dart' show AppStrings, showGenericDialog;

Future<bool> showLDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: AppStrings.delete,
    content: AppStrings.deleteConfirmation,
    optionsBuilder: () => <String, bool>{AppStrings.no: false, AppStrings.yes: true},
  );
}
