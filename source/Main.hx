package;

import flixel.FlxSprite;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite {
	public function new() {
		super();
		FlxSprite.defaultAntialiasing = true;
		addChild(new FlxGame(0, 0, states.PlayState, 60, 60, true));
	}
}
