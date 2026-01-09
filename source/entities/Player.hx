package entities;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.sound.FlxSound;
import states.PlayState;

class Player extends FlxSprite {
    // Physics Constants
    static inline var BASE_SPEED:Float = 200;
    static inline var SPRINT_SPEED:Float = 350;
    static inline var GRAVITY:Float = 600;
    static inline var JUMP_FORCE:Float = 250;
    static inline var MAX_JUMPS:Int = 1;
    static inline var WALL_SLIDE_Y_MAX:Float = 60;
    static inline var WALL_JUMP_X:Float = 300;
    static inline var WALL_JUMP_Y:Float = 280;
    static inline var WALL_SLIDE_GRACE_TIME:Float = 0.2;

    public var particleManager:PlayState;
    public var jumpSound:FlxSound;

    private var wasTouchingFloor:Bool;
    private var jumpsLeft:Int;
    private var isWallSliding:Bool;
    private var currentSpeed:Float;
    private var _wallJumpTimer:Float = 0;

    public function new(X:Float, Y:Float) {
        super(X, Y);

        this.x = X;
		this.y = Y;

        // Player placeholder
        makeGraphic(16, 16, FlxColor.ORANGE);

        // Init state
        jumpsLeft = MAX_JUMPS;
        currentSpeed = BASE_SPEED;

        // Setup physics
        drag.x = BASE_SPEED * 4;
        acceleration.y = GRAVITY;
        maxVelocity.set(currentSpeed, GRAVITY);

        wasTouchingFloor = isTouching(FLOOR);
    }

    override public function update(elapsed:Float):Void {
        if (_wallJumpTimer > 0) {
            _wallJumpTimer -= elapsed;
        }

        handleWallSlide();
        handleInput();
        handleDustEffects();

        if (isTouching(FLOOR)) {
            jumpsLeft = MAX_JUMPS;
        }

        super.update(elapsed);
    }

    function handleWallSlide():Void {
        if (_wallJumpTimer > 0) {
            isWallSliding = false;
            maxVelocity.y = GRAVITY;
            return;
        }

        var wallContact = isTouching(LEFT) || isTouching(RIGHT);
        var isMovingDown = velocity.y > 0;

        var pressingLeft = FlxG.keys.pressed.A || FlxG.keys.pressed.LEFT;
        var pressingRight = FlxG.keys.pressed.D || FlxG.keys.pressed.RIGHT;
        var horizontalInput = pressingLeft || pressingRight;

        isWallSliding = wallContact && isMovingDown && horizontalInput;

        if (isWallSliding) {
            if (velocity.y > WALL_SLIDE_Y_MAX) {
                velocity.y = WALL_SLIDE_Y_MAX;
            }
            jumpsLeft = MAX_JUMPS;
        }
        maxVelocity.y = isWallSliding ? WALL_SLIDE_Y_MAX : GRAVITY;
    }

    function handleInput():Void {
        var isSprinting = FlxG.keys.pressed.SHIFT;
        currentSpeed = isSprinting ? SPRINT_SPEED : BASE_SPEED;

        // Reset horizontal acceleration
        maxVelocity.x = currentSpeed;
        acceleration.x = 0;

        // Move left / right
        var pressingLeft = FlxG.keys.pressed.A || FlxG.keys.pressed.LEFT;
        var pressingRight = FlxG.keys.pressed.D || FlxG.keys.pressed.RIGHT;
        if (pressingLeft) {
            acceleration.x = -currentSpeed * 4;
            flipX = true;
        } else if (pressingRight) {
            acceleration.x = currentSpeed * 4;
            flipX = false;
        }

        // Jumping (only if on the ground)
        var jumpPressed = FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.UP || FlxG.keys.justPressed.W;
        if (jumpPressed) {
            if (isWallSliding) {
                var pushDirection = isTouching(LEFT) ? 1 : -1;
                velocity.x = pushDirection * WALL_JUMP_X;
                velocity.y = -WALL_JUMP_Y;
                jumpsLeft = MAX_JUMPS;
                isWallSliding = false;
                _wallJumpTimer = WALL_SLIDE_GRACE_TIME;
                if (jumpSound != null && !jumpSound.playing) jumpSound.play(true);
            } else if (jumpsLeft > 0) {
                velocity.y = -JUMP_FORCE;
                jumpsLeft--;
                if (jumpSound != null && !jumpSound.playing) jumpSound.play(true);
            }

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

        if (isWallSliding && FlxG.random.float() < 0.2) {
            var spawnX = isTouching(LEFT) ? x : x + width;

            particleManager.spawnDustTrail(
                spawnX,
                y + height / 2 + FlxG.random.float(-5, 5)
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