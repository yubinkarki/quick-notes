import 'package:flutter/material.dart';

import 'package:okaychata/constants/routes.dart';
import 'package:okaychata/navigation/app_router.dart' show AppRouter;

void main() {
  // To call native code by Firebase before running application.
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: homeRoute,
    );
  }
}
