import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ssh/ssh.dart';

final store = GetStorage();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Socket variable used for emiting and listening for events -> is set in connectToServer method
  late Socket socket;
  String? ip = store.read('serverIp');
  String? port = store.read('serverPort');

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
        backgroundColor: Color(0xFF2D2D2D),
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
                    color: const Color(0xFF3AA1FF),
                    size: screenSize.height * 0.05,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => pushToSettings(context),
                child: Icon(
                  Icons.settings,
                  color: const Color(0xFF3AA1FF),
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
                "Asteroids Liquid Galaxy Retro Gaming",
                style: TextStyle(
                  fontFamily: 'RetroFont',
                  fontSize: screenSize.height * 0.035,
                  color: const Color(0xFF3AA1FF),
                ),
              ),
            ),
            Stack(children: <Widget>[
              Container(
                child: Center(
                  child: Image.asset(
                    'assets/asteroids.png',
                    fit: BoxFit.contain,
                  ),
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
                        _installing ? Color(0xFF3AA1FF).withOpacity(0.5) : null,
                    colorBlendMode: _installing ? BlendMode.modulate : null,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: screenSize.height * 0.05),
              child: GestureDetector(
                onTap: () {
                  if (_installing) {
                    return;
                  }

                  installGame(context);
                },
                child: _installing
                    ? CircularProgressIndicator(color: const Color(0xFF3AA1FF))
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
                    color: const Color(0xFF3AA1FF),
                    size: screenSize.height * 0.08,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => pushToSettings(context),
                child: Icon(
                  Icons.settings,
                  color: const Color(0xFF3AA1FF),
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
              "Asteroids Liquid Galaxy Retro Gaming",
              style: TextStyle(
                fontFamily: 'RetroFont',
                fontSize: screenSize.width * 0.03,
                color: const Color(0xFF3AA1FF),
              ),
            ),
            Stack(children: <Widget>[
              Container(
                child: Center(
                  child: Image.asset(
                    'assets/asteroids.png',
                    fit: BoxFit.contain,
                  ),
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
                      _installing ? Color(0xFF3AA1FF).withOpacity(0.5) : null,
                  colorBlendMode: _installing ? BlendMode.modulate : null,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (_installing) {
                  return;
                }

                installGame(context);
              },
              child: _installing
                  ? CircularProgressIndicator(color: const Color(0xFF3AA1FF))
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
      store.write('serverPort', '3124');
      store.write('asteroidsPort', '8129');
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
    final String game = 'asteroids';

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

      await client
          .execute('echo lq | sudo -S rm -rf asteroids-lg-retro-gaming');
      await client.execute('echo lq | sudo -S rm -rf galaxy-asteroids');

      await client.execute(
          'echo lq | sudo -S git clone https://github.com/LiquidGalaxyLAB/asteroids-lg-retro-gaming');
      await client.execute(
          'echo lq | sudo -S git clone https://github.com/LiquidGalaxyLAB/galaxy-asteroids');

      await client.execute(
          'cd ~/asteroids-lg-retro-gaming && bash ~/asteroids-lg-retro-gaming/install.sh lq');
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
