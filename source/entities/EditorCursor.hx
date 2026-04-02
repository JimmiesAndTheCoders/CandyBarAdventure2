package entities;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.FlxG;
import level.Level;

class EditorCursor extends FlxSprite {
    public var gridX:Int = 0;
    public var gridY:Int = 0;

    var lerpSpeed:Float = 25;
    var firstFrame:Bool = true;

    public function new() {
        super();

        makeGraphic(Level.TILE_SIZE, Level.TILE_SIZE, FlxColor.WHITE);
        alpha = 0.4;
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        var mouseWorldX = FlxG.mouse.getWorldPosition().x;
        var mouseWorldY = FlxG.mouse.getWorldPosition().y;

        gridX = Math.floor(mouseWorldX / Level.TILE_SIZE);
        gridY = Math.floor(mouseWorldY / Level.TILE_SIZE);

        gridX = Std.int(FlxMath.bound(gridX, 0, Level.LEVEL_WIDTH - 1));
        gridY = Std.int(FlxMath.bound(gridY, 0, Level.LEVEL_HEIGHT - 1));

        var targetX:Float = gridX * Level.TILE_SIZE;
        var targetY:Float = gridY * Level.TILE_SIZE;

        if (firstFrame) {
            setPosition(targetX, targetY);
            firstFrame = false;
        } else {
            x = FlxMath.lerp(x, targetX, FlxMath.bound(elapsed * lerpSpeed, 0, 1));
            y = FlxMath.lerp(y, targetY, FlxMath.bound(elapsed * lerpSpeed, 0, 1));
        }

        visible = (mouseWorldX >= 0 && mouseWorldX < Level.LEVEL_WIDTH * Level.TILE_SIZE &&
                   mouseWorldY >= 0 && mouseWorldY < Level.LEVEL_HEIGHT * Level.TILE_SIZE);
    }
}