package utils;

import openfl.net.FileReference;
import openfl.net.FileFilter;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import haxe.io.Bytes;
import level.Level;
import utils.LevelPacker;

class LevelIO {
    var _fileRef:FileReference;
    var _onLoadCallback:(Array<Int>, String) -> Void;
    var _onStatus:(String) -> Void;

    public function new(onLoad:(Array<Int>, String) -> Void, onStatus:(String) -> Void) {
        _onLoadCallback = onLoad;
        _onStatus = onStatus;
    }

    public function save(data:Array<Int>, title:String = "Custom Level"):Void {
        var csvRows = [];
        for (y in 0...Level.LEVEL_HEIGHT) {
            var row = data.slice(y * Level.LEVEL_WIDTH, (y + 1) * Level.LEVEL_WIDTH);
            csvRows.push(row.join(","));
        }
        var csvString = csvRows.join("\n");

        var meta = {
            title: title,
            lastModified: Date.now().toString(),
            width: Level.LEVEL_WIDTH,
            height: Level.LEVEL_HEIGHT
        };

        try {
            var packedBytes = LevelPacker.packLevel(csvString, meta);
            _fileRef = new FileReference();
            _fileRef.addEventListener(Event.COMPLETE, (e) -> _onStatus("File saved!"));
            _fileRef.addEventListener(IOErrorEvent.IO_ERROR, (e) -> _onStatus("File IO Error!"));
            _fileRef.save(packedBytes.getData(), "level.fcba2lvl");
        } catch (e:Dynamic) {
            _onStatus("Error packing level!");
        }
    }

    public function load():Void {
        _fileRef = new FileReference();
        _fileRef.addEventListener(Event.SELECT, (e) -> _fileRef.load());
        _fileRef.addEventListener(IOErrorEvent.IO_ERROR, (e) -> _onStatus("Load Error!"));
        _fileRef.addEventListener(Event.COMPLETE, onDataLoaded);

        var filter = new FileFilter("Firey's Level", "*.fcba2lvl");
        _fileRef.browse([filter]);
    }

    function onDataLoaded(e:Event):Void {
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
                _onLoadCallback(newData, unpacked.meta.title);
            }
        } catch (e:Dynamic) {
            _onStatus("Failed to parse level file!");
        }
    }
}