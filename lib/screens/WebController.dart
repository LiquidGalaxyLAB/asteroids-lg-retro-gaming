import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WebController extends StatefulWidget {
  const WebController({Key? key}) : super(key: key);

  @override
  _WebControllerState createState() => _WebControllerState();
}

class _WebControllerState extends State<WebController> {
  bool hasLoaded = false;
  late String? snakePort;
  late String? pongPort;
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
                    "${currentGame == 'pong' ? 'https' : 'http'}://$serverIp:${currentGame == 'pong' ? pongPort : snakePort}/controller",
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
      snakePort = dotenv.env['SNAKE_PORT'];
      pongPort = dotenv.env['PONG_PORT'];
      hasLoaded = true;
    });
  }
}
