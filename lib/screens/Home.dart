import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ssh/ssh.dart';

final store = GetStorage();

// List of images with their respective gameName (must be the same name as in games.json)
final List<Map<String, dynamic>> imgList = [
  {'image': 'assets/asteroids.png', 'gameName': 'asteroids'},
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

  bool _installing = false;

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
        backgroundColor: Color(0xff161616),
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
          child: Row(
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: screenSize.width * 0.01),
                child: GestureDetector(
                  onTap: () => pushToAbout(context),
                  child: Icon(
                    Icons.info_outline,
                    color: const Color(0xFF00FF05),
                    size: screenSize.height * 0.05,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => pushToSettings(context),
                child: Icon(
                  Icons.settings,
                  color: const Color(0xFF00FF05),
                  size: screenSize.height * 0.05,
                ),
              ),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: screenSize.height * 0.1),
              child: Text(
                "Liquid Galaxy Retro Gaming",
                style: TextStyle(
                  fontFamily: 'RetroFont',
                  fontSize: screenSize.height * 0.035,
                  color: const Color(0xFF00FF05),
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
                  color: const Color(0xFF00FF05),
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
                  color: const Color(0xFF00FF05),
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
              padding: EdgeInsets.only(top: screenSize.height * 0.05),
              child: GestureDetector(
                onTap: () {
                  if (_installing) {
                    return;
                  }

                  openGame(context);
                },
                child: Container(
                  height: screenSize.height * 0.07,
                  child: Image.asset(
                    'assets/openBtn.png',
                    fit: BoxFit.fill,
                    color:
                        _installing ? Color(0xFF00FF05).withOpacity(0.5) : null,
                    colorBlendMode: _installing ? BlendMode.modulate : null,
                  ),
                ),
              ),
            ),
            imgList[currentPage]['gameName'] != 'asteroids'
                ? Container()
                : Padding(
                    padding: EdgeInsets.only(bottom: screenSize.height * 0.05),
                    child: GestureDetector(
                      onTap: () {
                        if (_installing) {
                          return;
                        }

                        installGame(context);
                      },
                      child: _installing
                          ? CircularProgressIndicator(
                              color: const Color(0xFF00FF05))
                          : Container(
                              height: screenSize.height * 0.07,
                              child: Image.asset(
                                'assets/installBtn.png',
                                fit: BoxFit.fill,
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
          child: Row(
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: screenSize.width * 0.01),
                child: GestureDetector(
                  onTap: () => pushToAbout(context),
                  child: Icon(
                    Icons.info_outline,
                    color: const Color(0xFF00FF05),
                    size: screenSize.height * 0.08,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => pushToSettings(context),
                child: Icon(
                  Icons.settings,
                  color: const Color(0xFF00FF05),
                  size: screenSize.height * 0.08,
                ),
              ),
            ],
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
                color: const Color(0xFF00FF05),
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
                  color: const Color(0xFF00FF05),
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
                  color: const Color(0xFF00FF05),
                  iconSize: screenSize.height * 0.15,
                  splashRadius: 0.1,
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    _controller.nextPage();
                  },
                ),
              ),
            ]),
            GestureDetector(
              onTap: () {
                if (_installing) {
                  return;
                }

                openGame(context);
              },
              child: Container(
                height: screenSize.height * 0.1,
                child: Image.asset(
                  'assets/openBtn.png',
                  fit: BoxFit.fill,
                  color:
                      _installing ? Color(0xFF00FF05).withOpacity(0.5) : null,
                  colorBlendMode: _installing ? BlendMode.modulate : null,
                ),
              ),
            ),
            imgList[currentPage]['gameName'] != 'asteroids'
                ? Container()
                : GestureDetector(
                    onTap: () {
                      if (_installing) {
                        return;
                      }

                      installGame(context);
                    },
                    child: _installing
                        ? CircularProgressIndicator(
                            color: const Color(0xFF00FF05))
                        : Container(
                            height: screenSize.height * 0.1,
                            child: Image.asset(
                              'assets/installBtn.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                  ),
          ],
        ),
      ],
    );
  }

  void connectToServer() async {
    ip = store.read('serverIp');
    port = store.read('serverPort');
    if (ip == null) {
      // set default values for variables
      store.write('serverIp', '192.168.0.123');
      store.write('serverPort', '3123');
      store.write('asteroidsPort', '8129');
      store.write('pacmanPort', '8128');
      store.write('snakePort', '8114');
      store.write('pongPort', '8112');
    }
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
        }),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  // Open game based on current page index
  // "context" is used for pushing Navigator
  void openGame(BuildContext context) {
    // Get game name based on current page
    final String game = imgList[currentPage]['gameName'];

    socket.emit('open-game', game);
    print('open: ' + game);

    Navigator.pushNamed(
      context,
      '/webcontroller',
      arguments: {'currentGame': game},
    );
  }

  // Installs the game based on its repository and install script.
  void installGame(BuildContext context) async {
    setState(() {
      _installing = true;
    });

    try {
      final String? serverIp = store.read('serverIp');

      if (serverIp == null) {
        return;
      }

      final client = SSHClient(
          host: serverIp, port: 22, username: 'lg', passwordOrKey: 'lq');

      await client.connect();

      await client.execute('echo lq | sudo -S apt install git-all');

      await client.execute(
          'echo lq | sudo -S git clone -b installer https://github.com/LiquidGalaxyLAB/lg-retro-gaming');
      await client.execute(
          'echo lq | sudo -S git clone -b develop https://github.com/LiquidGalaxyLAB/galaxy-asteroids');

      await client.execute(
          'cd ~/lg-retro-gaming && bash ~/lg-retro-gaming/install.sh lq');
      await client.execute(
          'cd ~/galaxy-asteroids && bash ~/galaxy-asteroids/install.sh lq');

      showError('Game successfully installed');
    } catch (e) {
      showError('An error occured while installing the game');
      print(e);
      setState(() {
        _installing = false;
      });
    } finally {
      setState(() {
        _installing = false;
      });
    }
  }

  // Push to settings screen and reconnect to socket server when back to main screen
  // "context" is used for pushing Navigator
  void pushToSettings(BuildContext context) async {
    await Navigator.pushNamed(context, '/settings');

    if (ip != null && port != null) {
      socket.disconnect();
    }
    ip = store.read('serverIp');
    port = store.read('serverPort');
    connectToServer();
  }

  void pushToAbout(BuildContext context) async {
    await Navigator.pushNamed(context, '/about');
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      margin: const EdgeInsets.fromLTRB(16, 5, 16, 16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.horizontal,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      backgroundColor: Colors.grey.shade100.withOpacity(0.95),
    ));
  }
}
