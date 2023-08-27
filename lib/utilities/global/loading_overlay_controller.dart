import 'package:flutter/foundation.dart' show immutable;

typedef CloseLoadingScreen = bool Function();
typedef UpdateLoadingScreen = bool Function(String text);

@immutable
class LoadingOverlayController {
  final CloseLoadingScreen close;
  final UpdateLoadingScreen update;

  const LoadingOverlayController({required this.close, required this.update});
}
