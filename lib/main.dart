import 'package:flutter/material.dart';
import 'package:forward/app.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Forward',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: new App(),
    );
  }
}
