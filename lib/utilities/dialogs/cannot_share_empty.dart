import 'package:flutter/material.dart';

import 'package:okaychata/utilities/dialogs/show_generic_dialog.dart' show showGenericDialog;

Future<void> showCannotShareEmptyDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: "Sharing",
    content: "You can not share an empty note.",
    optionsBuilder: () => {"OK": null},
  );
}
