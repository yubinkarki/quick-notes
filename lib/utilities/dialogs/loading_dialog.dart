import 'package:okaychata/constants/common_imports.dart';

typedef CloseDialog = void Function();

CloseDialog showLoadingDialog({required BuildContext context}) {
  const dialog = AlertDialog(
    scrollable: false,
    elevation: 0,
    backgroundColor: Colors.transparent,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [CircularProgressIndicator()],
    ),
  );

  showDialog(
    context: context,
    barrierDismissible: false,
    // barrierColor: CustomColors.blackTranslucent,
    builder: (context) => dialog,
  );

  return () => Navigator.of(context).pop();
}
