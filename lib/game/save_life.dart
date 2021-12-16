import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:save_life/game/background.dart';
import 'package:save_life/game/enemy.dart';
import 'package:save_life/game/enemy_manager.dart';
import 'package:save_life/game/player.dart';

class SaveLife extends FlameGame
    with HorizontalDragDetector, TapDetector, HasCollidables {
  Player? player;
  EnemyManager? enemyManager;
  double? screenHeight;
  double? screenWidth;
  double? score;
  TextComponent? _textComponent = TextComponent();
  bool? gameStarted = false;
  FlameAudio? flameAudio;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    FlameAudio.bgm.initialize();

    add(BackgroundParallax());

    player = Player();
    add(player!);

    // enemyManager = EnemyManager();
    // add(enemyManager!);

    overlays.add('PauseButton');
    overlays.add('HeroLife');
    overlays.add('StartScreen');

    score = 0;
    _textComponent = TextComponent(text: score.toString(), priority: 1);
    _textComponent!.y = 20;

    add(_textComponent!);
  }

  @override
  void update(double dt) {
    if (gameStarted!) {
      score = score! + dt * 60;
      _textComponent!.text = score!.toInt().toString();
    }

    if (player!.life!.value == 0) {
      stopBgMusic();
      pauseEngine();
      overlays.add('GameOver');
    }

    super.update(dt);
  }

  void changePlayerPosition(var info) {
    if (info.eventPosition.game.y < (screenHeight! - 50)) {
      player!.y = info.eventPosition.game.y - 60;
    }
  }

  void reset() {
    score = 0;
    player!.life!.value = 3;

    for (var element in children.whereType<Enemy>()) {
      element.removeFromParent();
    }
    enemyManager!.removeFromParent();
    player!.removeFromParent();
  }

  void startGame() {
    player = Player();
    enemyManager = EnemyManager();

    add(player!);
    add(enemyManager!);

    resumeEngine();
    resumeBgMusic();
  }

  void addEnemy() {
    enemyManager = EnemyManager();
    add(enemyManager!);
    gameStarted = true;
    startBgMusic();
  }

  @override
  void onHorizontalDragUpdate(DragUpdateInfo info) {
    changePlayerPosition(info);
    super.onHorizontalDragUpdate(info);
  }

  @override
  void onTapDown(TapDownInfo info) {
    changePlayerPosition(info);

    super.onTapDown(info);
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    screenHeight = canvasSize.y;
    screenWidth = canvasSize.x;
    _textComponent!.x = canvasSize.x / 2 - _textComponent!.width / 2;

    super.onGameResize(canvasSize);
  }

  void startBgMusic() {
    FlameAudio.bgm.play('bg_music.wav');
  }

  void stopBgMusic() {
    FlameAudio.bgm.stop();
  }

  void pauseBgMusic() {
    FlameAudio.bgm.pause();
  }

  void resumeBgMusic() {
    FlameAudio.bgm.resume();
  }
}
