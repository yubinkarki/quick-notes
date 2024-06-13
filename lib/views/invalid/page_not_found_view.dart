import 'package:okaychata/imports/flutter_imports.dart'
    show StatelessWidget, Key, Widget, BuildContext, Scaffold, Center, Text;

class PageNotFoundView extends StatelessWidget {
  const PageNotFoundView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Oops! Page not found'),
      ),
    );
  }
}
