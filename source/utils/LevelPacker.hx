package utils;

import openfl.Assets;
import haxe.io.BytesInput;
import haxe.Json;
import haxe.crypto.Crc32;
import haxe.io.Bytes;
import haxe.zip.Entry;
import haxe.zip.Reader;
import haxe.zip.Writer;

class LevelPacker {
	public static function packFromAssets(csvPath:String, metaPath:String):Bytes {
		var csv:String = Assets.getText(csvPath);
		var meta:String = Assets.getText(metaPath);

		return packLevel(csv, meta);
	}

	public static function packLevel(csv:String, meta:Dynamic):Bytes {
		var out = new haxe.io.BytesOutput();
		var writer = new Writer(out);
		var entries = new List<Entry>();

		var metaBytes = Bytes.ofString(meta);
		entries.add(createEntry("meta.json", metaBytes));

		var csvBytes = Bytes.ofString(csv);
		entries.add(createEntry("data.csv", csvBytes));

		writer.write(entries);
		return out.getBytes();
    }

	public static function createEntry(name:String, data:Bytes):Entry {
		return {
			fileName: name,
			fileSize: data.length,
			dataSize: 0,
			data: data,
			crc32: Crc32.make(data),
			compressed: true,
			fileTime: Date.now()
		};
	}

    public static function unpack(bytes:Bytes):{csv:String, meta:Dynamic} {
        var input = new BytesInput(bytes);
        var reader = new Reader(input);
        var entries = reader.read();

        var result = {csv: "", meta: null};

        for (entry in entries) {
            if (entry.fileName == "data.csv") result.csv = entry.data.toString();
            else if (entry.fileName == "meta.json") result.meta = Json.parse(entry.data.toString());
        }

        return result;
    }
}