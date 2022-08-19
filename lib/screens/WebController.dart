import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:get_storage/get_storage.dart';

final store = GetStorage();

class WebController extends StatefulWidget {
  const WebController({Key? key}) : super(key: key);

  @override
  _WebControllerState createState() => _WebControllerState();
}

class _WebControllerState extends State<WebController> {
  // Is set to true once everything is loaded (set in loadEnv method)

  // Will contain all the ports e.g. ports['pacman'] is pacman game port (set in loadEnv method)
  final Map<String, String?> ports = {
    'asteroids': store.read('asteroidsPort'),
    'pacman': store.read('pacmanPort'),
    'snake': store.read('snakePort'),
    'pong': store.read('pongPort')
  };

  // Will contain server Ip (set in loadEnv method)
  final String? serverIp = store.read('serverIp');
  final String? serverPort = store.read('serverPort');
  late Socket socket;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    connectToServer();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    final String currentGame = arguments['currentGame'];
    Size screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              socket.emit('close-game');
              Navigator.pop(context);
            },
          ),
          actions: [
            currentGame == "asteroids"
                ? Container()
                : IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Center(
                              child: Card(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    QrImage(
                                      size: screenSize.height * 0.5,
                                      data:
                                          "http://$serverIp:${ports[currentGame]}/controller",
                                    ),
                                    // Text(
                                    //   "http://$serverIp:${ports[currentGame]}/controller",
                                    //   style: TextStyle(
                                    //     fontSize: screenSize.height * 0.05,
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    icon: Icon(Icons.qr_code_2))
          ],
        ),
        body: WebView(
          initialUrl: currentGame == "asteroids"
              ? "http://$serverIp:${ports[currentGame]}/"
              : "http://$serverIp:${ports[currentGame]}/controller",
          javascriptMode: JavascriptMode.unrestricted,
          onWebResourceError: (_) {
            Navigator.of(context).pushNamed('errorPage');
          },
        ),
      ),
    );
  }

  void connectToServer() async {
    try {
      // Configure socket to connect with server ip
      socket = io('http://$serverIp:$serverPort', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      socket.connect();

      socket.on(
          'connect',
          (_) => setState(() {
                print('Connect to socket with id: ${socket.id}');
              }));
    } catch (e) {
      print(e.toString());
    }
  }
}
