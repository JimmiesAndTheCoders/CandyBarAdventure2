package editor;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.geom.Point;
import level.Level;
import level.LevelGraphics;

class TilePreview extends FlxSprite {
    var tileset:BitmapData;
    var currentTileID:Int = -1;

    public function new() {
        super();
        tileset = LevelGraphics.createTileset();
        alpha = 0.6;
    }

    public function updateTile(tileID:Int):Void {
        if (currentTileID == tileID) return;
        currentTileID = tileID;

        if (tileID <= 0) {
            makeGraphic(Level.TILE_SIZE, Level.TILE_SIZE, FlxColor.TRANSPARENT, true);
        } else {
            var tileBmp = new BitmapData(Level.TILE_SIZE, Level.TILE_SIZE, true, 0);
            var sourceRect = new Rectangle(tileID * Level.TILE_SIZE, 0, Level.TILE_SIZE, Level.TILE_SIZE);
            tileBmp.copyPixels(tileset, sourceRect, new Point(0, 0));
            
            pixels = tileBmp;
        }
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
    }
}