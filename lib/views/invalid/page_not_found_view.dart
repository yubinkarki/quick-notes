import 'package:flutter/material.dart';

class PageNotFoundView extends StatelessWidget {
  const PageNotFoundView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Oops! Page not found"),
      ),
    );
  }
}
