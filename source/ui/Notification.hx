package ui;

import level.Level;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;

class Notification extends FlxText {
    public function new(message:String) {
        super(0, Level.LEVEL_HEIGHT * Level.TILE_SIZE - 30, 0, message, 16);
        setFormat(null, 16, FlxColor.YELLOW, CENTER);
        screenCenter(X);
        scrollFactor.set(0, 0);
    }

    public function show(parent:flixel.FlxState):Void {
        parent.add(this);
        FlxTween.tween(this, {alpha: 0, y: y - 20}, 2, {onComplete: function(_) {
            this.destroy();
        }});
    }
}