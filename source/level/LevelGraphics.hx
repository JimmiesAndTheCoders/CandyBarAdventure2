package level;

import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import flixel.util.FlxColor;

class LevelGraphics {
    public static function createTileset():BitmapData {
        var bitmap = new BitmapData(Level.TILE_SIZE * 2, Level.TILE_SIZE, true, 0x000000);
        var rect = new Rectangle(Level.TILE_SIZE, 0, Level.TILE_SIZE, Level.TILE_SIZE);
        bitmap.fillRect(rect, FlxColor.BLACK);
        return bitmap;
    }
}