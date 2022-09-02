import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lg_retro_gaming/screens/Home.dart';

// List of images
final List<String> images = [
  'assets/gsoc.png',
  'assets/LGLogo.png',
  'assets/app_logo.png',
  'assets/LGLab_Logo.png',
  'assets/LogoLGEU.png',
  'assets/TIC_Logo.png',
  'assets/pcital.png'
];

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    Duration duration = Duration(seconds: 5);

    return Timer(duration, pushToHome);
  }

  pushToHome() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Center(
                  child: Image.asset(
                    'assets/app_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                width: screenSize.width / 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.05),
                    child: Container(
                      child: Center(
                        child: Image.asset(
                          'assets/LGLogo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      width: screenSize.width / 5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.05),
                    child: Container(
                      child: Center(
                        child: Image.asset(
                          'assets/gsoc.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      width: screenSize.width / 5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.05),
                    child: Container(
                      child: Center(
                        child: Image.asset(
                          'assets/facens.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      width: screenSize.width / 5,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: Center(
                      child: Image.asset(
                        'assets/LGLab_Logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    width: screenSize.width / 5,
                  ),
                  Container(
                    child: Center(
                      child: Image.asset(
                        'assets/LogoLGEU.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    width: screenSize.width / 5,
                  ),
                  Container(
                    child: Center(
                      child: Image.asset(
                        'assets/pcital.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    width: screenSize.width / 5,
                  ),
                  Container(
                    child: Center(
                      child: Image.asset(
                        'assets/TIC_Logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    width: screenSize.width / 5,
                  ),
                ],
              ),
              CircularProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }
}
