package editor;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import level.Level;

class GridOverlay extends FlxSprite {
    public function new() {
        super();
        refresh();
    }

    public function refresh():Void {
        makeGraphic(Level.LEVEL_WIDTH * Level.TILE_SIZE, Level.LEVEL_HEIGHT * Level.TILE_SIZE, FlxColor.TRANSPARENT, true);
        
        var lineStyle = {thickness: 0.3, color: FlxColor.WHITE, alpha: 0.2};
        
        for (i in 0...Level.LEVEL_WIDTH + 1) {
            FlxSpriteUtil.drawLine(this, i * Level.TILE_SIZE, 0, i * Level.TILE_SIZE, height, lineStyle);
        }
        for (i in 0...Level.LEVEL_HEIGHT + 1) {
            FlxSpriteUtil.drawLine(this, 0, i * Level.TILE_SIZE, width, i * Level.TILE_SIZE, lineStyle);
        }
    }
}