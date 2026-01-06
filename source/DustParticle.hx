package;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class DustParticle extends FlxSprite {
    public function new() {
        super();
        makeGraphic(3, 3, FlxColor.GRAY);

        this.immovable = true;
        this.solid = false;

        drag.x = 200;
        drag.y = 200;
    }

    public function resetParticle(SpawnX:Float, SpawnY:Float, XVel:Float, YVel:Float):Void {
        x = SpawnX;
        y = SpawnY;
        velocity.set(XVel, YVel);
        alpha = 1.0;

        revive();
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        alpha -= elapsed * 2.5;
        if (alpha <= 0) {
            kill();
        }
    }
}