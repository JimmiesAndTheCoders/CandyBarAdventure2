package level;

import flixel.tile.FlxTilemap;
import openfl.utils.Assets;

class Level extends FlxTilemap {
	public static inline var TILE_SIZE:Int = 16;
	public static inline var LEVEL_WIDTH:Int = 40;
	public static inline var LEVEL_HEIGHT:Int = 30;

	public function new(?passedData:Array<Int>) {
		super();

		var csvPath:String = "assets/data/map.csv";
		var tileset = LevelGraphics.createTileset();

		if (passedData != null) {
			loadMapFromArray(
				passedData,
				LEVEL_WIDTH,
				LEVEL_HEIGHT,
				tileset,
				TILE_SIZE,
				TILE_SIZE,
				null, 0, 1, 1
			);
		} else if (Assets.exists(csvPath)) {
			loadMapFromCSV(Assets.getText(csvPath), tileset, TILE_SIZE, TILE_SIZE);
		} else {
			var dataArray = MapGenerator.generateDefaultArray();
			loadMapFromArray(dataArray, LEVEL_WIDTH, LEVEL_HEIGHT, tileset, TILE_SIZE, TILE_SIZE, null, 0, 1, 1);
		}
	}
}