import 'package:flame/components.dart';
import 'package:flame/src/parallax.dart';
import 'package:save_life/game/save_life.dart';

class BackgroundParallax extends ParallaxComponent {
  @override
  Future<void> onLoad() async {
    parallax = await gameRef.loadParallax(
      [
        ParallaxImageData('bg.png'),
        ParallaxImageData('buildings.png'),
        ParallaxImageData('far-buildings.png'),
        ParallaxImageData('skill-foreground.png'),
      ],
      baseVelocity: Vector2(20, 0),
      
      velocityMultiplierDelta: Vector2(1.8, 1.0),
    );
  }
}
