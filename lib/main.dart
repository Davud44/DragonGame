import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:save_life/game/save_life.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var saveLife = SaveLife();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(game: saveLife, overlayBuilderMap: {
        'PauseButton': (context, savelife) {
          return GestureDetector(
            onTap: () {
              saveLife.pauseEngine();
              saveLife.overlays.add('PauseMenu');
              saveLife.pauseBgMusic();
            },
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Icon(
                Icons.pause,
                color: Colors.white,
                size: 30,
              ),
            ),
          );
        },
        'HeroLife': (context, savelife) {
          return Positioned(
            right: 20,
            top: 20,
            child: ValueListenableBuilder(
                valueListenable: saveLife.player!.life!,
                builder: (context, int value, Widget? child) {
                  final list = <Widget>[];

                  for (int i = 0; i < 3; i++) {
                    list.add(Icon(
                        (i < value) ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red));
                  }

                  return Row(children: list);
                }),
          );
        },
        'PauseMenu': (context, savelife) {
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                  color: const Color(0xCC000000),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'Game Paused',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w700),
                  ),
                  GestureDetector(
                    onTap: () {
                      saveLife.resumeEngine();
                      saveLife.overlays.remove('PauseMenu');
                      saveLife.resumeBgMusic();
                    },
                    behavior: HitTestBehavior.opaque,
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
        'GameOver': (context, savelife) {
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                  color: const Color(0xCC000000),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'Game over',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Your score is : ' + saveLife.score!.toInt().toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                  GestureDetector(
                    onTap: () {
                      saveLife.overlays.remove('GameOver');
                      saveLife.reset();
                      saveLife.startGame();
                    },
                    behavior: HitTestBehavior.opaque,
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Icon(
                        Icons.restart_alt_rounded,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
        'StartScreen': (context, savelife) {
          return GestureDetector(
            onTap: () {
              saveLife.overlays.remove('StartScreen');
              saveLife.addEnemy();
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(color: Color(0x80000000)),
              child: const Center(child: Text(
                    'Tap to play',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w700),
                  ),)
            ),
          );
        },
      }),
    );
  }
}
