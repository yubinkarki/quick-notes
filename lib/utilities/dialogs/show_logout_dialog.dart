import "package:okaychata/imports/flutter_imports.dart"
    show BuildContext, TextTheme, showDialog, AlertDialog, Text, TextButton, Theme, Navigator;

Future<bool> showLogoutDialog(BuildContext context) {
  final TextTheme textTheme = Theme.of(context).textTheme;

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Logout", style: textTheme.labelLarge),
        content: Text(
          "Are you sure you want to log out?",
          style: textTheme.labelMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text("Cancel", style: textTheme.labelMedium),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text("Logout", style: textTheme.labelMedium),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
