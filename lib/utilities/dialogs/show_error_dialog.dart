import 'package:okaychata/imports/flutter_imports.dart' show BuildContext;

import 'package:okaychata/imports/first_party_imports.dart' show AppStrings, AppExceptions, showGenericDialog;

Future<void> showErrorDialog({required String text, required BuildContext context}) {
  return showGenericDialog<void>(
    content: text,
    context: context,
    title: AppExceptions.somethingWentWrongException,
    optionsBuilder: () => <String, dynamic>{AppStrings.ok: null},
  );
}
