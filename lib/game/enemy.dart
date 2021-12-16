import 'package:flame/assets.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:save_life/game/save_life.dart';

class Enemy extends SpriteAnimationComponent
    with HasGameRef<SaveLife>, HasHitboxes, Collidable {
  double? screenHeight;
  double? screenWidth;
  double? enemyY;
  double? spped;

  Enemy(this.enemyY, this.spped);

  @override
  Future<void>? onLoad() async {
    final imagesLoader = Images();
    Image playerImage = await imagesLoader.load('character.png');

    SpriteSheet spriteSheet =
        SpriteSheet.fromColumnsAndRows(image: playerImage, columns: 3, rows: 4);

    final flyAnimation =
        spriteSheet.createAnimation(row: 3, stepTime: 0.15, from: 0, to: 2);

    animation = flyAnimation;
    width = 150;
    height = 150;
    x = screenWidth!;
    y = enemyY!;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    x -= dt * spped!;

    if (x < (-width)) {
      removeFromParent();
    }
    super.update(dt);
  }

  @override
  void onMount() {
    final shape = HitboxPolygon([
      Vector2(0, 1),
      Vector2(1, 0),
      Vector2(0, -0.2),
      Vector2(-1, 0),
    ]);
    ;

    addHitbox(shape);
    super.onMount();
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    screenHeight = canvasSize.y;
    screenWidth = canvasSize.x;

    super.onGameResize(canvasSize);
  }
}
