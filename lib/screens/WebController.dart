import 'dart:io';

import 'package:flutter/material.dart';
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

  // Will contain all the ports
  final Map<String, String?> ports = {
    'asteroids': store.read('asteroidsPort'),
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

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF2D2D2D),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              socket.emit('close-game');
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Joystick',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: WebView(
          initialUrl: 'http://$serverIp:${ports[currentGame]}/',
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
