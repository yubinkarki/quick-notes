import 'package:okaychata/imports/flutter_imports.dart' show BuildContext;

import 'package:okaychata/imports/first_party_imports.dart' show showGenericDialog, AppStrings;

Future<void> showCannotShareEmptyDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: AppStrings.sharing,
    content: AppStrings.invalidNoteShare,
    optionsBuilder: () => <String, dynamic>{AppStrings.ok: null},
  );
}
