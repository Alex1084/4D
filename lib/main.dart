import 'package:flutter/material.dart';
import 'ihm/HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: EcranHome(),
      theme: ThemeData(
        primaryColor: Colors.yellow[200],
        //accentColor: Colors.black
          //brightness: Brightness.dark,
      ),
    );
  }
}
