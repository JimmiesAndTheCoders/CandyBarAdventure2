package;

import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState{
	var player:Player;
	var level:Level;

	override public function create():Void {
		super.create();
		bgColor = 0x1f2349;
		
		level = new Level();
		add(level);

		player = new Player(50, 50);
		add(player);

		FlxG.camera.follow(player, TOPDOWN, 1);
		FlxG.camera.setScrollBoundsRect(0, 0, level.width, level.height, true);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// 4. Collision Logic
		// Check collision between the player and the tilemap
		FlxG.collide(player, level);
	}
}