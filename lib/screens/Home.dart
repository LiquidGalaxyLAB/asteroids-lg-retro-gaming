import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get_storage/get_storage.dart';

final store = GetStorage();

// List of images with their respective gameName (must be the same name as in games.json)
final List<Map<String, dynamic>> imgList = [
  {'image': 'assets/pacman.png', 'gameName': 'pacman'},
  {'image': 'assets/pong.png', 'gameName': 'pong'},
  {'image': 'assets/snake.png', 'gameName': 'snake'}
];

// Create list of widgets for carrousel display
final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Center(
            child: Image.asset(item['image'], fit: BoxFit.contain),
          ),
        ))
    .toList();

// Current page index -> Used for getting correct gameName from imgList variable
int currentPage = 0;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Socket variable used for emiting and listening for events -> is set in connectToServer method
  late Socket socket;
  String? ip = store.read('serverIp');
  String? port = store.read('serverPort');
  // Carrousel controller -> used for changing pages in the image carrousel
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();
    // connect to server
    connectToServer();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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

  // Layout for portrait mode
  // "screenSize" is used to calculate widgets sizes based on screen size
  // "context" is used for pushing Navigator
  Widget portraiMode(Size screenSize, BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: screenSize.height * 0.01,
          right: screenSize.height * 0.01,
          child: GestureDetector(
            onTap: () => pushToSettings(context),
            child: Icon(
              Icons.settings,
              size: screenSize.height * 0.05,
            ),
          ),
        ),
        Column(
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
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentPage = index;
                    });
                  },
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
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
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
        ),
      ],
    );
  }

  // Layout for landscape mode
  // "screenSize" is used to calculate widgets sizes based on screen size
  // "context" is used for pushing Navigator
  Widget landscapeMode(Size screenSize, BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: screenSize.height * 0.01,
          right: screenSize.height * 0.01,
          child: GestureDetector(
            onTap: () => pushToSettings(context),
            child: Icon(
              Icons.settings,
              size: screenSize.height * 0.08,
            ),
          ),
        ),
        Column(
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
                  enlargeCenterPage: true,
                  height: screenSize.height * 0.5,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                ),
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
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
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
          ],
        ),
      ],
    );
  }

  void connectToServer() async {
    try {
      // Configure socket to connect with server ip
      socket = io('http://$ip:$port', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      socket.connect();

      socket.on(
          'connect',
          (_) => setState(() {
                print('Connected to socket with id: ${socket.id}');
              }));
    } catch (e) {
      print(e.toString());
    }
  }

  // Open game based on current page index
  // "context" is used for pushing Navigator
  void openGame(BuildContext context) {
    // Get game name based on current page
    final String game = imgList[currentPage]['gameName'];

    // Emit for socket to open game
    socket.emit('open-game', game);
    print('open: ' + game);

    Navigator.pushNamed(
      context,
      '/webcontroller',
      arguments: {'currentGame': game},
    );
  }

  // Push to settings screen and reconnect to socket server when back to main screen
  // "context" is used for pushing Navigator
  void pushToSettings(BuildContext context) async {
    await Navigator.pushNamed(context, '/settings');

    socket.disconnect();
    ip = store.read('serverIp');
    port = store.read('serverPort');
    connectToServer();
  }
}
