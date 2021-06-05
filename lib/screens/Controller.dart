import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Controller extends StatefulWidget {
  @override
  _ControllerState createState() => _ControllerState();
}

class _ControllerState extends State<Controller> {
  late Socket socket;
  late String? ip;
  late String? port;
  bool hasConnected = false;

  @override
  void initState() {
    super.initState();
    connectToServer();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    final String currentGame = arguments['currentGame'];

    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    icon: Icon(Icons.arrow_upward),
                    onPressed: () {
                      socket.emit("update-player", "up");
                    }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      socket.emit("update-player", "left");
                    }),
                IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: () {
                      socket.emit("update-player", "right");
                    }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    icon: Icon(Icons.arrow_downward),
                    onPressed: () {
                      socket.emit("update-player", "down");
                    }),
              ],
            ),
            TextButton(
                onPressed: hasConnected
                    ? () {
                        socket.emit("close-game", currentGame);
                        Navigator.pop(context);
                      }
                    : null,
                child: Text("Close Game"))
          ],
        ),
      ),
    );
  }

  void connectToServer() async {
    await dotenv.load(fileName: ".env");
    try {
      //get variables from .env file
      ip = dotenv.env['SERVER_IP'];
      port = dotenv.env['SERVER_PORT'];
      print('ip: $ip port: $port');

      // Configure socket to connect with server ip
      socket = io('http://$ip:$port', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      socket.connect();

      socket.on(
          'connect',
          (_) => setState(() {
                hasConnected = true;
                print('Connect to socket with id: ${socket.id}');
              }));
      setState(() {
        hasConnected = true;
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
