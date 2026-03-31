package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.tile.FlxTilemap;
import openfl.net.FileReference;
import openfl.net.FileFilter;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import haxe.io.Bytes;
import level.LevelGraphics;
import level.Level;
import ui.Notification;
import data.StateController;
import level.MapGenerator;
import utils.LevelPacker;

class EditorState extends FlxState {
    var map:FlxTilemap;
    var data:Array<Int>;
    var currentTile:Int = 1;
    var _fileRef:FileReference;

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

        if (FlxG.mouse.pressed) modifyTile(currentTile);
        if (FlxG.mouse.pressedRight) modifyTile(0);

        if (FlxG.keys.justPressed.S) saveLevel();
        if (FlxG.keys.justPressed.L) loadLevel();
    }

    function modifyTile(tileValue:Int):Void {
        var tx = Math.floor(FlxG.mouse.x / Level.TILE_SIZE);
        var ty = Math.floor(FlxG.mouse.y / Level.TILE_SIZE);
        
        if (tx >= 0 && tx < Level.LEVEL_WIDTH && ty >= 0 && ty < Level.LEVEL_HEIGHT) {
            var index:Int = ty * Level.LEVEL_WIDTH + tx;
            if (data[index] != tileValue) {
                data[index] = tileValue;
                updateMap();
            }
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

    function saveLevel():Void {
        var csvRows = [];
        for (y in 0...Level.LEVEL_HEIGHT) {
            var row = data.slice(y * Level.LEVEL_WIDTH, (y + 1) * Level.LEVEL_WIDTH);
            csvRows.push(row.join(","));
        }
        var csvString = csvRows.join("\n");

        var meta = {
            title: "Custom Level",
            lastModified: Date.now().toString(),
            width: Level.LEVEL_WIDTH,
            height: Level.LEVEL_HEIGHT
        };

        try {
            var packedBytes = LevelPacker.packLevel(csvString, meta);

            _fileRef = new FileReference();
            _fileRef.addEventListener(Event.COMPLETE, onSaveComplete);
            _fileRef.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);

            var fileName = "level.fcba2lvl";
            _fileRef.save(packedBytes.getData(), fileName);
        } catch (e:Dynamic) {
            showNotice("Error packing level!");
        }
    }

    function loadLevel():Void {
        _fileRef = new FileReference();
        _fileRef.addEventListener(Event.SELECT, onFileSelected);
        _fileRef.addEventListener(Event.COMPLETE, onLoadComplete);
        _fileRef.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);

        var filter = new FileFilter("Firey's Candy Bar Adventure 2 Level", "*.fcba2lvl");
        _fileRef.browse([filter]);
    }

    function onFileSelected(e:Event):Void {
        _fileRef.load();
    }

    function onLoadComplete(e:Event):Void {
        try {
            var rawBytes = Bytes.ofData(_fileRef.data);
            var unpacked = LevelPacker.unpack(rawBytes);

            if (unpacked != null) {
                var lines = unpacked.csv.split("\n");
                var newData = [];
                for (line in lines) {
                    var vals = line.split(",");
                    for (v in vals) newData.push(Std.parseInt(v));
                }
                
                this.data = newData;
                updateMap();
                showNotice("Loaded: " + unpacked.meta.title);
            }
        } catch (e:Dynamic) {
            showNotice("Failed to parse level file!");
        }
    }

    function onSaveComplete(e:Event) showNotice("File saved!");
    function onSaveError(e:IOErrorEvent) showNotice("File IO Error!");

    function showNotice(msg:String) {
        var notice = new Notification(msg);
        notice.show(this);
    }
}
