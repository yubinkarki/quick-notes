import 'package:okaychata/imports/flutter_imports.dart'
    show BuildContext, TextTheme, showDialog, AlertDialog, Text, TextButton, Navigator, Theme;

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  final TextTheme textTheme = Theme.of(context).textTheme;

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        elevation: 0,
        title: Text('An error occurred', style: textTheme.labelLarge),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Ok', style: textTheme.labelMedium),
          ),
        ],
      );
    },
  );
}
