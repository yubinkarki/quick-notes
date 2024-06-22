import 'package:okaychata/imports/flutter_imports.dart'
    show BuildContext, TextTheme, showDialog, AlertDialog, Text, TextButton, Theme, Navigator;

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required String title,
  required String content,
  required BuildContext context,
  required DialogOptionBuilder<T> optionsBuilder,
}) {
  final TextTheme textTheme = Theme.of(context).textTheme;
  final Map<String, dynamic> options = optionsBuilder();

  return showDialog<T>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title, style: textTheme.labelLarge),
        content: Text(content, style: textTheme.labelMedium),
        actions: options.keys.map((String optionTitle) {
          final T value = options[optionTitle];

          return TextButton(
            onPressed: () {
              if (value != null) {
                Navigator.of(context).pop(value);
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Text(optionTitle),
          );
        }).toList(),
      );
    },
  );
}
