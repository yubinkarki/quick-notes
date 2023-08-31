import 'package:flutter/material.dart';

import 'show_generic_dialog.dart' show showGenericDialog;
import 'package:okaychata/constants/static_strings.dart' show AppStrings;

Future<void> showPasswordResetDialog(BuildContext context, String text) {
  return showGenericDialog(
    context: context,
    title: AppStrings.passwordReset,
    content: AppStrings.passwordResetSubtitle,
    optionsBuilder: () => {"OK": null},
  );
}
