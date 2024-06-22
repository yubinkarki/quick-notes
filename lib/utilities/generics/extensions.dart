import 'package:okaychata/imports/flutter_imports.dart' show BuildContext, ModalRoute;

// Returns a Stream of List of type T.
extension Filter<T> on Stream<List<T>> {
  Stream<List<T>> filter(bool Function(T) isCurrentUserNote) {
    return map((List<T> items) => items.where(isCurrentUserNote).toList());
  }
}

extension GetArgument on BuildContext {
  T? getArgument<T>() {
    final ModalRoute<dynamic>? modalRoute = ModalRoute.of(this); // 'this' refers to the BuildContext.

    if (modalRoute != null) {
      final Object? args = modalRoute.settings.arguments;

      if (args != null && args is T) {
        return args as T;
      }
    }

    return null;
  }
}

extension Count<T extends Iterable<dynamic>> on Stream<T> {
  Stream<int> get getLength => map((T event) => event.length);
}
