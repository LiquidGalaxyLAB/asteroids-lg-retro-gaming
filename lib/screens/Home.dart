import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';

final List<String> imgList = [
  'assets/pacman.png',
  'assets/pong.png',
  'assets/snake.png'
];

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Center(
            child: Image.asset(item, fit: BoxFit.contain),
          ),
        ))
    .toList();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Socket socket;
  late String? ip;
  late String? port;
  bool hasConnected = false;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();
    connectToServer();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade100,
        body: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return orientation == Orientation.portrait
                ? portraiMode(screenSize, context)
                : landscapeMode(screenSize, context);
          },
        ),
      ),
    );
  }

  Widget portraiMode(Size screenSize, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: screenSize.height * 0.1),
          child: Text(
            "Liquid Galaxy Retro Gaming",
            style: TextStyle(
              fontFamily: 'RetroFont',
              fontSize: screenSize.height * 0.035,
            ),
          ),
        ),
        Stack(children: <Widget>[
          CarouselSlider(
            items: imageSliders,
            options: CarouselOptions(
              enlargeCenterPage: true,
              height: screenSize.height * 0.3,
            ),
            carouselController: _controller,
          ),
          Positioned(
            bottom: screenSize.height * 0.12,
            left: screenSize.width * 0.01,
            child: IconButton(
              iconSize: screenSize.height * 0.05,
              splashRadius: 0.1,
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                _controller.previousPage();
              },
            ),
          ),
          Positioned(
            bottom: screenSize.height * 0.12,
            right: screenSize.width * 0.01,
            child: IconButton(
              iconSize: screenSize.height * 0.05,
              splashRadius: 0.1,
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                _controller.nextPage();
              },
            ),
          ),
        ]),
        Padding(
          padding: EdgeInsets.only(top: screenSize.height * 0.1),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(screenSize.height * 0.1),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 4,
                  offset: Offset(3, 3), // changes position of shadow
                ),
              ],
            ),
            child: TextButton(
              onPressed: () => openGame(context),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "OPEN GAME",
                  style: TextStyle(
                    fontFamily: 'RetroFont',
                    fontSize: screenSize.height * 0.025,
                  ),
                ),
              ),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(screenSize.height * 0.1),
                    side: BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget landscapeMode(Size screenSize, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          "Liquid Galaxy Retro Gaming",
          style: TextStyle(
            fontFamily: 'RetroFont',
            fontSize: screenSize.height * 0.075,
          ),
        ),
        Stack(children: <Widget>[
          CarouselSlider(
            items: imageSliders,
            options: CarouselOptions(
                enlargeCenterPage: true, height: screenSize.height * 0.5),
            carouselController: _controller,
          ),
          Positioned(
            bottom: screenSize.height * 0.16,
            left: screenSize.width * 0.1,
            child: IconButton(
              iconSize: screenSize.height * 0.15,
              splashRadius: 0.1,
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                _controller.previousPage();
              },
            ),
          ),
          Positioned(
            bottom: screenSize.height * 0.16,
            right: screenSize.width * 0.1,
            child: IconButton(
              iconSize: screenSize.height * 0.15,
              splashRadius: 0.1,
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                _controller.nextPage();
              },
            ),
          ),
        ]),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(screenSize.height * 0.1),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 4,
                offset: Offset(3, 3), // changes position of shadow
              ),
            ],
          ),
          child: TextButton(
            onPressed: () => openGame(context),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "OPEN GAME",
                style: TextStyle(
                  fontFamily: 'RetroFont',
                  fontSize: screenSize.height * 0.035,
                ),
              ),
            ),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenSize.height * 0.1),
                  side: BorderSide(color: Colors.black),
                ),
              ),
            ),
          ),
        ),
      ],
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

  void openGame(BuildContext context) {
    socket.emit('open-game', 'gameName');
    Navigator.pushNamed(
      context,
      '/controller',
      arguments: {'currentGame': 'gameName'},
    );
  }
}
