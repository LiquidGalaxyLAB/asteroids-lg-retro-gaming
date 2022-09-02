import 'package:flutter/material.dart';
import 'package:lg_retro_gaming/screens/About.dart';
import 'package:lg_retro_gaming/screens/Home.dart';
import 'package:lg_retro_gaming/screens/Settings.dart';
import 'package:lg_retro_gaming/screens/SplashScreen.dart';
import 'package:lg_retro_gaming/screens/WebController.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Asteroids Liquid Galaxy Retro Gaming',
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/': (context) => Home(),
        '/webcontroller': (context) => WebController(),
        '/settings': (context) => Settings(),
        '/about': (context) => About(),
      },
    );
  }
}
