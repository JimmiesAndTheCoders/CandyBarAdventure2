package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.tile.FlxTilemap;
import openfl.net.FileReference;

class EditorState extends FlxState {
    var map:FlxTilemap;
    var data:Array<Int>;
    var currentTile:Int = 1;

    override public function create() {
        FlxG.mouse.visible = true;
        bgColor = 0x141730;

        data = MapGenerator.generateDefaultArray();

        map = new FlxTilemap();
        updateMap();
        add(map);

        super.create();
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        StateController.checkToggle();

        if (FlxG.mouse.pressed) {
            modifyTile(currentTile);
        }

        if (FlxG.mouse.pressedRight) {
            modifyTile(0);
        }

        if (FlxG.keys.justPressed.S) {
            saveLevel();
            var notice = new Notification("Level saved to map.csv!");
            notice.show(this);
        }
    }

    function modifyTile(tileValue:Int):Void {
        var tx = Math.floor(FlxG.mouse.x / Level.TILE_SIZE);
        var ty = Math.floor(FlxG.mouse.y / Level.TILE_SIZE);
        var index:Int = ty * Level.LEVEL_WIDTH + tx;

        if (tx >= 0 && tx < Level.LEVEL_WIDTH && ty >= 0 && ty < Level.LEVEL_HEIGHT) {
            data[index] = tileValue;
            updateMap();
        }
    }

    function updateMap() {
        var tileset = LevelGraphics.createTileset();
        map.loadMapFromArray(
            data,
            Level.LEVEL_WIDTH,
            Level.LEVEL_HEIGHT,
            tileset, Level.TILE_SIZE,
            Level.TILE_SIZE,
            null, 0, 1, 1
        );
    }

    function saveLevel() {
        var csvContent = MapGenerator.arrayToCSV(data, Level.LEVEL_WIDTH);
        var fr = new FileReference();
        fr.save(csvContent, "map.csv");
    }
}