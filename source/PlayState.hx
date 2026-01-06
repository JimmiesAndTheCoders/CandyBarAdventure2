package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.sound.FlxSound;

class PlayState extends FlxState{
	var player:Player;
	var level:Level;
	var particlePool:FlxGroup;

	static inline var MAX_PARTICLES:Int = 50;

	var sfxJump:FlxSound;

	override public function create():Void {
		super.create();
		bgColor = 0x1f2349;
		
		level = new Level();
		add(level);

		particlePool = new FlxGroup();
		for (i in 0...MAX_PARTICLES) {
			particlePool.add(cast(new DustParticle(), DustParticle));
		}
		add(particlePool);

		sfxJump = FlxG.sound.load("assets/sounds/jump.wav");

		player = new Player(50, 50);
		player.particleManager = this;
		player.jumpSound = sfxJump;
		add(player);

		FlxG.camera.follow(player, TOPDOWN, 1);
		FlxG.camera.setScrollBoundsRect(0, 0, level.width, level.height, true);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		FlxG.collide(player, level);
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