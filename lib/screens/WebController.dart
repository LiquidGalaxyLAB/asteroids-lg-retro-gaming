import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WebController extends StatefulWidget {
  const WebController({Key? key}) : super(key: key);

  @override
  _WebControllerState createState() => _WebControllerState();
}

class _WebControllerState extends State<WebController> {
  // Is set to true once everything is loaded (set in loadEnv method)
  bool hasLoaded = false; 

  // Will contain all the ports e.g. ports['pacman'] is pacman game port (set in loadEnv method)
  late Map<String, String?> ports = {};

  // Will contain server Ip (set in loadEnv method)
  late String? serverIp;

  @override
  void initState() {
    super.initState();
    loadEnv();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    final String currentGame = arguments['currentGame'];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          // leading: new IconButton(
          //   icon: new Icon(Icons.arrow_back),
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          // ),
        ),
        body: hasLoaded
            ? WebView(
                initialUrl:
                    "${currentGame == 'pong' ? 'https' : 'http'}://$serverIp:${ports[currentGame]}/controller",
                javascriptMode: JavascriptMode.unrestricted,
                onWebResourceError: (_) {
                  Navigator.of(context).pushNamed('errorPage');
                },
              )
            : Container(
                child: Center(
                  child: Text('Loading Controller'),
                ),
              ),
      ),
    );
  }

  void loadEnv() async {
    await dotenv.load(fileName: ".env");

    setState(() {
      serverIp = dotenv.env['SERVER_IP'];
      ports['pacman'] = dotenv.env['PACMAN_PORT'];
      ports['pong'] = dotenv.env['PONG_PORT'];
      ports['snake'] = dotenv.env['SNAKE_PORT'];
      hasLoaded = true;
    });
  }
}
