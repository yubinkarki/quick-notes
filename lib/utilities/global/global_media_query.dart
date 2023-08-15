import 'package:flutter/material.dart' show Size, BuildContext, MediaQuery;

class GlobalMediaQuery {
  static Size? _mediaQuerySize;
  static double? screenWidth;
  static double? screenHeight;

  static void init(BuildContext context) {
    _mediaQuerySize = MediaQuery.of(context).size;

    screenWidth = _mediaQuerySize?.width;
    screenHeight = _mediaQuerySize?.height;
  }
}
