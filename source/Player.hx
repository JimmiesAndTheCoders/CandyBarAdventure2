package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

class Player extends FlxSprite {
    // Physics Constants
    public static inline var SPEED:Float = 200;
    public static inline var GRAVITY:Float = 600;
    public static inline var JUMP_FORCE:Float = 250;

    public function new(X:Float, Y:Float) {
        super(X, Y);

        this.x = X;
		this.y = Y;

        // Player placeholder
        makeGraphic(16, 16, FlxColor.ORANGE);

        // Setup physics
        drag.x = SPEED * 4;
        acceleration.y = GRAVITY;
        maxVelocity.set(SPEED, GRAVITY);
    }

    override public function update(elapsed:Float):Void {
        handleInput();
        super.update(elapsed);
    }

    function handleInput():Void {
        // Reset horizontal acceleration
        acceleration.x = 0;

        // Move left / right
        if (FlxG.keys.anyPressed([LEFT, A])) {
            acceleration.x = -SPEED * 4;
            flipX = true;
        } else if (FlxG.keys.anyPressed([RIGHT, D])) {
            acceleration.x = SPEED * 4;
            flipX = false;
        }

        // Jumping (only if on the ground)
        if (FlxG.keys.anyJustPressed([SPACE, UP, W]) && isTouching(FLOOR)) {
            velocity.y = -JUMP_FORCE;
        }
    }
}