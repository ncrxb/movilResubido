// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:movil/app/ui/routes/pages.dart';
import 'package:movil/app/ui/routes/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Routes.SPLASH,
      routes: appRoutes(),
    );
  }
}

