import 'package:okaychata/imports/flutter_imports.dart' show BuildContext;

import 'package:okaychata/imports/first_party_imports.dart' show showGenericDialog;

Future<void> showCannotShareEmptyDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Sharing',
    content: 'You can not share an empty note.',
    optionsBuilder: () => <String, dynamic>{'OK': null},
  );
}
