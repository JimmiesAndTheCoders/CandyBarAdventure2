package states;

import entities.Player;
import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.sound.FlxSound;

class PlayState extends FlxState{
	var player:Player;
	var level:Level;
	var particlePool:FlxGroup;
	var sfxJump:FlxSound;
	var overrideData:Array<Int>;

	static inline var MAX_PARTICLES:Int = 50;

	#if debug
	var debugDisplay:DebugDisplay;

	var startX:Float;
	var startY:Float;
	#end

	public function new(?customData:Array<Int>) {
		super();
		this.overrideData = customData;
	}

	override public function create():Void {
		FlxG.mouse.visible = false;
		super.create();
		bgColor = 0x1f2349;
		
		level = new Level(overrideData);
		add(level);

		particlePool = new FlxGroup();
		for (i in 0...MAX_PARTICLES) {
			particlePool.add(cast(new DustParticle(), DustParticle));
		}
		add(particlePool);

		sfxJump = FlxG.sound.load(AssetPaths.jump__wav);

		player = new Player(50, 50);
		player.particleManager = this;
		player.jumpSound = sfxJump;
		add(player);

		FlxG.camera.follow(player, LOCKON, 1);
		FlxG.camera.setScrollBoundsRect(0, 0, level.width, level.height, true);

		#if debug
		FlxG.debugger.drawDebug = true;
		debugDisplay = new DebugDisplay(player);
		add(debugDisplay);

		startX = player.x;
		startY = player.y;
		#end
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		FlxG.collide(player, level);

		#if debug
		if (FlxG.keys.justPressed.H) {
			FlxG.debugger.drawDebug = !FlxG.debugger.drawDebug;
		}

		if (FlxG.keys.justPressed.R) {
			player.setPosition(startX, startY);
			player.velocity.set(0, 0);
		}

		if (FlxG.keys.justPressed.G) {
			if (player.acceleration.y != 0) {
				player.acceleration.y = 0;
				player.velocity.y = 0;
				player.color = 0x601477;
			} else {
				player.acceleration.y = 600;
				player.color = FlxColor.ORANGE;
			}
		}

		if (player.acceleration.y == 0) {
			if (FlxG.keys.pressed.W || FlxG.keys.pressed.UP) {
				player.velocity.y = -300;
			} else if (FlxG.keys.pressed.S || FlxG.keys.pressed.DOWN) {
				player.velocity.y = 300;
			} else {
				player.velocity.y = 0;
			}
		}
		#end

		StateController.checkToggle();

		if (FlxG.keys.justPressed.ENTER) {
			FlxG.switchState(() -> new PlayState(overrideData));
		}
	}

	public function spawnDustBurst(
		x:Float,
		y:Float,
		count:Int,
		minX:Float,
		maxX:Float,
		minY:Float,
		maxY:Float
	):Void {
		for (i in 0...count) {
			var particle = cast(particlePool.getFirstDead(), DustParticle);
			if (particle != null) {
				var xVel = FlxG.random.float(minX, maxX);
				var yVel = FlxG.random.float(minY, maxY);
				particle.resetParticle(x, y, xVel, yVel);
			}
		}
	}
	public function spawnDustTrail(x:Float, y:Float):Void {
		var particle = cast(particlePool.getFirstDead(), DustParticle);
		if (particle != null) {
			var xVel = FlxG.random.float(-10, 10);
			var yVel = FlxG.random.float(-30, 10);
			particle.resetParticle(x, y, xVel, yVel);
		}
	}
}