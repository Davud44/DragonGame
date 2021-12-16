import 'dart:math';

import 'package:flame/components.dart';
import 'package:save_life/game/enemy.dart';
import 'package:save_life/game/save_life.dart';

class EnemyManager extends Component with HasGameRef<SaveLife> {
  Random? _random;
  Timer? _timer;
  double? speed = 350;
  double? screenHeight;


  EnemyManager() {
    _random = Random();
    _timer = Timer(4, repeat: true, onTick: () {
      spanRandomEnemy();
    });
  }

  void spanRandomEnemy() {
    final randomY = _random!.nextInt(screenHeight!.toInt());
    final enemy = Enemy(randomY.toDouble() , speed);
    gameRef.add(enemy);
  }

  @override
  void update(double dt) {
    _timer!.update(dt);
    speed = speed! + dt * 10;
    super.update(dt);
  }

@override
  void onGameResize(Vector2 canvasSize) {
    screenHeight = canvasSize.y;

    super.onGameResize(canvasSize);
  }

}
