import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
    return Scaffold(
      body: Center(
        child: Text("Liquid Galaxy Retro Gaming"),
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
          'connect', (_) => print('Connect to socket with id: ${socket.id}'));
      setState(() {
        hasConnected = true;
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
