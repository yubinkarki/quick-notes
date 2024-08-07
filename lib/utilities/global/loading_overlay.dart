import 'package:okaychata/imports/dart_imports.dart' show StreamController;

import 'package:okaychata/imports/flutter_imports.dart';

import 'package:okaychata/imports/first_party_imports.dart' show LoadingOverlayController;

class LoadingOverlay {
  factory LoadingOverlay() => _shared;
  static final LoadingOverlay _shared = LoadingOverlay._sharedInstance();
  LoadingOverlay._sharedInstance();

  LoadingOverlayController? controller;

  void hide() {
    controller?.close();
    controller = null;
  }

  void show({required BuildContext context, required String text}) {
    if (controller?.update(text) ?? false) {
      return;
    } else {
      controller = showOverlay(context: context, text: text);
    }
  }

  LoadingOverlayController showOverlay({required String text, required BuildContext context}) {
    final StreamController<String> streamText = StreamController<String>();
    streamText.add(text);

    final OverlayState state = Overlay.of(context);
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;

    final OverlayEntry overlay = OverlayEntry(
      builder: (BuildContext context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.8,
                maxHeight: size.height * 0.8,
                minWidth: size.width * 0.5,
              ),
              decoration: const BoxDecoration(color: Colors.transparent),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 10),
                      const CircularProgressIndicator(),
                      const SizedBox(height: 40),
                      StreamBuilder<String>(
                        stream: streamText.stream,
                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                          if (snapshot.hasData) {
                            return Text(snapshot.data as String, textAlign: TextAlign.center);
                          } else {
                            return const Placeholder(color: Colors.transparent);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    state.insert(overlay);

    return LoadingOverlayController(
      close: () {
        streamText.close();
        overlay.remove();

        return true;
      },
      update: (String text) {
        streamText.add(text);

        return true;
      },
    );
  }
}
