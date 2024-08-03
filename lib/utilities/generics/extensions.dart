import 'package:okaychata/imports/flutter_imports.dart' show BuildContext, ModalRoute, Widget, SizedBox;

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

extension DoubleExtension on double? {
  double validateDouble({double value = 0.0}) => this ?? 0.0;

  Widget get sizedBoxWidth => SizedBox(width: this);
  Widget get sizedBoxHeight => SizedBox(height: this);
}

extension StringExtension on String {
  String get capitalizeFirstLetter => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String get titleCase =>
      replaceAll(RegExp(' +'), ' ').split(' ').map((String str) => str.capitalizeFirstLetter).join(' ');
}
