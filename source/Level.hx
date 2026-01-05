package;

import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;

class Level extends FlxTilemap {
	static inline var TILE_SIZE:Int = 16;
	static inline var LEVEL_WIDTH:Int = 40;
	static inline var LEVEL_HEIGHT:Int = 30;

	public function new() {
		super();

		// 1. Generate the map data (CSV format)
		var mapData:Array<Int> = generateMapData();

		// 2. Generate a tileset image in memory
		var tilesetBitmap = new BitmapData(TILE_SIZE * 2, TILE_SIZE, true, 0x00000000);
		
		var rect = new Rectangle(TILE_SIZE, 0, TILE_SIZE, TILE_SIZE);
		tilesetBitmap.fillRect(rect, FlxColor.BLACK);

		// 3. Load the map using the data and the generated bitmap
		loadMapFromArray(mapData, LEVEL_WIDTH, LEVEL_HEIGHT, tilesetBitmap, TILE_SIZE, TILE_SIZE, null, 0, 1, 1);
	}

	function generateMapData():Array<Int> {
		var data:Array<Int> = [];

		for (y in 0...LEVEL_HEIGHT) {
			for (x in 0...LEVEL_WIDTH) {
				var tileIndex = 0;

				if (x == 0 || x == LEVEL_WIDTH - 1 || y == 0 || y == LEVEL_HEIGHT - 1) {
					tileIndex = 1;
				} else if (y == LEVEL_HEIGHT - 5 && x > 5 && x < LEVEL_WIDTH - 5) {
					tileIndex = 1;
				} else if (y == LEVEL_HEIGHT - 10 && x > 10 && x < 15) {
					tileIndex = 1;
				}

				data.push(tileIndex);
			}
		}
		return data;
	}
}