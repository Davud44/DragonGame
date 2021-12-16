import 'dart:io';

import 'package:flame/assets.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart' as Cupertino;
import 'package:save_life/game/enemy.dart';
import 'package:save_life/game/save_life.dart';

class Player extends SpriteAnimationComponent
    with HasGameRef<SaveLife>, HasHitboxes, Collidable {
  bool isHit = true;
  final Timer _hitTimer = Timer(1);
  Cupertino.ValueNotifier<int>? life;

  @override
  Future<void>? onLoad() async {
    life = Cupertino.ValueNotifier(3);

    final imagesLoader = Images();
    Image playerImage = await imagesLoader.load('character.png');

    SpriteSheet spriteSheet =
        SpriteSheet.fromColumnsAndRows(image: playerImage, columns: 3, rows: 4);

    final flyAnimation =
        spriteSheet.createAnimation(row: 1, stepTime: 0.15, from: 0, to: 2);

    animation = flyAnimation;
    width = 150;
    height = 150;
    x = 100;
    y = 100;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _hitTimer.update(dt);
    super.update(dt);
  }

  @override
  void onMount() {
    final shape = HitboxRectangle(relation: Vector2(0.8, 0.6));
    addHitbox(shape);

    _hitTimer.onTick = () {
      isHit = true;
    };
    super.onMount();
  }

  @override
  Future<void> onCollision(
      Set<Vector2> intersectionPoints, Collidable other) async {
    if (other is Enemy && isHit) {
      hit();
    }
    super.onCollision(intersectionPoints, other);
  }

  void hit() {
    isHit = false;
    _hitTimer.start();
    life!.value -= 1;
    FlameAudio.play('hurt.wav');
    if (life!.value > 0) {
      gameRef.camera.shake(intensity: 20);
    }
  }
}
