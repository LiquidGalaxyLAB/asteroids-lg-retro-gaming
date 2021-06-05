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
        body: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return orientation == Orientation.portrait
                ? portraiMode(screenSize)
                : landscapeMode(screenSize);
          },
        ),
      ),
    );
  }

  Widget portraiMode(Size screenSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
      ],
    );
  }

  Widget landscapeMode(Size screenSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(children: <Widget>[
          CarouselSlider(
            items: imageSliders,
            options: CarouselOptions(
                enlargeCenterPage: true, height: screenSize.height * 0.5),
            carouselController: _controller,
          ),
          Positioned(
            bottom: screenSize.height * 0.15,
            left: screenSize.width * 0.1,
            child: IconButton(
              iconSize: screenSize.height * 0.2,
              splashRadius: 0.1,
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                _controller.previousPage();
              },
            ),
          ),
          Positioned(
            bottom: screenSize.height * 0.15,
            right: screenSize.width * 0.1,
            child: IconButton(
              iconSize: screenSize.height * 0.2,
              splashRadius: 0.1,
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                _controller.nextPage();
              },
            ),
          ),
        ]),
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
}
