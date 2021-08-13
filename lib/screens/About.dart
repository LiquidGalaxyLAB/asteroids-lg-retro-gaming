import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// List of images
final List<String> images = [
  'assets/gsoc.png',
  'assets/LGLogo.png',
  'assets/LGRG_Logo.png',
  'assets/LGLab_Logo.png',
  'assets/LogoLGEU.png',
  'assets/TIC_Logo.png',
  'assets/pcital.png'
];

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          actions: [
            TextButton(
              onPressed:() => pushToUrl(
                  'https://github.com/LiquidGalaxyLAB/lg-retro-gaming'),
              child: Text(
                'GITHUB',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () => pushToUrl('https://www.liquidgalaxy.eu/'),
              child: Text(
                'LIQUID GALAXY',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Center(
                  child: Image.asset(
                    'assets/LGRG_Logo.png',
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
                        'assets/tic_logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    width: screenSize.width / 5,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void pushToUrl(String url) async {
    try {
      await launch(url);
    } catch(err) {
      throw 'Could not launch $url';
    }
  }
}
