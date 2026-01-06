package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

class Player extends FlxSprite {
    // Physics Constants
    public static inline var SPEED:Float = 200;
    public static inline var GRAVITY:Float = 600;
    public static inline var JUMP_FORCE:Float = 250;

    public var particleManager:PlayState;
    private var wasTouchingFloor:Bool;

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

        wasTouchingFloor = isTouching(FLOOR);
    }

    override public function update(elapsed:Float):Void {
        handleInput();
        handleDustEffects();

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
            FlxG.sound.play("assets/sounds/jump.wav");

            if (particleManager != null) {
                particleManager.spawnDustBurst(
                    x + width / 2,
                    y + height,
                    8,
                    -10, 10,
                    -100, -50
                );
            }
        }
    }

    function handleDustEffects():Void {
        if (particleManager == null) return;

        var isTouchingNow = isTouching(FLOOR);
        var isMoving = velocity.x != 0 && Math.abs(velocity.x) > 10;

        if (isMoving && isTouchingNow && FlxG.random.float() < 0.25) {
            particleManager.spawnDustTrail(
                x + width / 2,
                y + height - 1
            );
        }

        if (!wasTouchingFloor && isTouchingNow) {
            particleManager.spawnDustBurst(
                x + width / 2,
                y + height,
                10,
                -50, 50,
                -120, -80
            );
        }

        wasTouchingFloor = isTouchingNow;
    }
}