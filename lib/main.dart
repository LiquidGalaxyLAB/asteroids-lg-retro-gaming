import 'package:flutter/material.dart';
import 'package:lg_retro_gaming/screens/Controller.dart';
import 'package:lg_retro_gaming/screens/Home.dart';
import 'package:lg_retro_gaming/screens/WebController.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/controller': (context) => Controller(),
        '/webcontroller': (context) => WebController()
      },
    );
  }
}
