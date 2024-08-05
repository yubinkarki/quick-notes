import 'package:okaychata/imports/flutter_imports.dart'
    show
        Text,
        Theme,
        Padding,
        TextTheme,
        Navigator,
        showDialog,
        TextButton,
        EdgeInsets,
        AlertDialog,
        ColorScheme,
        BuildContext;

import 'package:okaychata/imports/first_party_imports.dart' show AppPadding, StringExtension;

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T> showGenericDialog<T>({
  required String title,
  required String content,
  required BuildContext context,
  required DialogOptionBuilder<T> optionsBuilder,
}) {
  final Map<String, dynamic> options = optionsBuilder();
  final TextTheme textTheme = Theme.of(context).textTheme;
  final ColorScheme colorTheme = Theme.of(context).colorScheme;

  return showDialog<T>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        elevation: 0.0,
        backgroundColor: colorTheme.surface,
        content: Text(content, style: textTheme.labelMedium),
        title: Text(title.titleCase, style: textTheme.labelMedium),
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p10, vertical: AppPadding.p5),
              child: Text(optionTitle, style: textTheme.labelMedium),
            ),
          );
        }).toList(),
      );
    },
  ).then((dynamic value) => value ?? false);
}
