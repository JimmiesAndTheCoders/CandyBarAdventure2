package ui;

import entities.Player;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class DebugDisplay extends FlxSpriteGroup {
    var _statsText:FlxText;
    var _playerRef:Player;

    public function new(player:Player) {
        super();
        _playerRef = player;

        var bg = new flixel.FlxSprite().makeGraphic(220, 115, FlxColor.BLACK);
        bg.alpha = 0.6;
        add(bg);

        _statsText = new FlxText(10, 10, 200, "", 12);
        _statsText.color = FlxColor.WHITE;
        _statsText.setFormat("assets/fonts/lounge.ttf");
        add(_statsText);

        scrollFactor.set(0, 0);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        var gravityStatus = (_playerRef.acceleration.y == 0) ? "OFF" : "ON";

        if (FlxG.keys.justPressed.F3) {
            this.visible = !this.visible;
        }

        if (this.visible) {
            var fps = FlxG.drawFramerate;
            var px = Math.floor(_playerRef.x);
            var py = Math.floor(_playerRef.y);

            _statsText.text = "DEBUG MODE\n" +
                          "FPS: " + fps + "\n" +
                          "Player X: " + px + "\n" +
                          "Player Y: " + py + "\n" +
                          "Gravity (G)" + gravityStatus + "\n" +
                          "Teleport (R): Reset Pos";
        }
    }
}