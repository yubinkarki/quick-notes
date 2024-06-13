import 'package:okaychata/imports/flutter_imports.dart' show BuildContext, ModalRoute;

extension GetArgument on BuildContext {
  T? getArgument<T>() {
    final modalRoute = ModalRoute.of(this); // 'this' refers to the BuildContext.

    if (modalRoute != null) {
      final args = modalRoute.settings.arguments;

      if (args != null && args is T) {
        return args as T;
      }
    }

    return null;
  }
}
