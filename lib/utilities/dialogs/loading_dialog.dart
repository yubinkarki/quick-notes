import 'package:okaychata/imports/flutter_imports.dart'
    show BuildContext, AlertDialog, CircularProgressIndicator, Column, Colors, MainAxisSize, showDialog, Navigator;

typedef CloseDialog = void Function();

CloseDialog showLoadingDialog({required BuildContext context}) {
  const dialog = AlertDialog(
    elevation: 0,
    scrollable: false,
    backgroundColor: Colors.transparent,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [CircularProgressIndicator()],
    ),
  );

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => dialog,
    // barrierColor: CustomColors.blackTranslucent,
  );

  return () => Navigator.of(context).pop();
}
