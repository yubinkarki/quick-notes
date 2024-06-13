import 'package:okaychata/imports/flutter_imports.dart' show Size, BuildContext, MediaQuery;

class GlobalMediaQuery {
  static double? screenWidth;
  static double? screenHeight;
  static Size? _mediaQuerySize;

  static void init(BuildContext context) {
    _mediaQuerySize = MediaQuery.of(context).size;

    screenWidth = _mediaQuerySize?.width;
    screenHeight = _mediaQuerySize?.height;
  }
}
