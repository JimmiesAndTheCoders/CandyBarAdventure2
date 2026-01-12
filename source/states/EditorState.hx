package states;

import openfl.net.FileFilter;
import openfl.Assets;
import level.LevelGraphics;
import level.Level;
import ui.Notification;
import data.StateController;
import level.MapGenerator;
import flixel.FlxG;
import flixel.FlxState;
import flixel.tile.FlxTilemap;
import openfl.net.FileReference;
import utils.LevelPacker;
import openfl.events.Event;
import haxe.io.Bytes;
import haxe.Json;

class EditorState extends FlxState {
    var map:FlxTilemap;
    var data:Array<Int>;
    var currentTile:Int = 1;
    var _fileRef:FileReference;
    var notice:Notification;

    override public function create() {
        FlxG.mouse.visible = true;
        FlxG.debugger.drawDebug = false;
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

    function saveLevel():Void {
        var csv = Assets.getText("assets/data/level_data.csv");
        var metaRaw = Assets.getText("assets/data/metadata.json");
        var meta = Json.parse(metaRaw);
        meta.lastModified = Date.now().toString();
        
        var packedBytes = LevelPacker.packLevel(csv, meta);

        _fileRef = new FileReference();
        _fileRef.addEventListener(Event.COMPLETE, onSaveComplete);

        var fileName = (meta.title != null) ? meta.title + ".fcba2lvl" : "level.fcba2lvl";
        _fileRef.save(packedBytes.getData(), fileName);
    }

    public function onSaveComplete(event:Event):Void {
        trace("File saved successfully.");
        notice = new Notification("Level file saved successfully!");
        notice.show(this);
    }

    public function loadLevel():Void {
        _fileRef = new FileReference();
        _fileRef.addEventListener(Event.SELECT, onFileSelected);
        _fileRef.addEventListener(Event.COMPLETE, onLoadComplete);

        var filter = new FileFilter("Firey's Candy Bar Adventure 2 Level", "*.fcba2lvl");
        _fileRef.browse([filter]);
    }

    function onFileSelected(e:Event):Void {
        _fileRef.load();
    }

    function onLoadComplete(e:Event):Void {
        var rawBytes = Bytes.ofData(_fileRef.data);
        var unpacked = LevelPacker.unpack(rawBytes);

        trace("Loaded level:", unpacked.meta.title);
        trace("Map data length:", unpacked.csv.length);

        var notice = new Notification("Level loaded: " + unpacked.meta.title);
        notice.show(this);
    }
}