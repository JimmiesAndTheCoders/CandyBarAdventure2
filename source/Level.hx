package;

import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.utils.Assets;

class Level extends FlxTilemap {
	static inline var TILE_SIZE:Int = 16;
	static inline var LEVEL_WIDTH:Int = 40;
	static inline var LEVEL_HEIGHT:Int = 30;

	public function new() {
		super();

		var mapDataString:String = "";
		var csvPath:String = "assets/data/map.csv";

		if (Assets.exists(csvPath)) {
			mapDataString = Assets.getText(csvPath);
		} else {
			var dataArray:Array<Int> = generateMapData();
		}

		var tilesetBitmap = new BitmapData(TILE_SIZE * 2, TILE_SIZE, true, 0x00000000);
		var rect = new Rectangle(TILE_SIZE, 0, TILE_SIZE, TILE_SIZE);
		tilesetBitmap.fillRect(rect, FlxColor.BLACK);

		if (Assets.exists(csvPath)) {
			loadMapFromCSV(mapDataString, tilesetBitmap, TILE_SIZE, TILE_SIZE);
		} else {
			var mapDataArray:Array<Int> = generateMapData();
			loadMapFromArray(mapDataArray, LEVEL_WIDTH, LEVEL_HEIGHT, tilesetBitmap, TILE_SIZE, TILE_SIZE, null, 0, 1, 1);
		}
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