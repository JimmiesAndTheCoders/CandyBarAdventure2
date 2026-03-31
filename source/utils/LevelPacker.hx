package utils;

import haxe.io.BytesInput;
import haxe.Json;
import haxe.crypto.Crc32;
import haxe.io.Bytes;
import haxe.zip.Entry;
import haxe.zip.Reader;
import haxe.zip.Writer;
import haxe.io.BytesOutput;

class LevelPacker {
    public static function packLevel(csv:String, meta:Dynamic):Bytes {
        var out = new BytesOutput();
        var writer = new Writer(out);
        var entries = new List<Entry>();

        var metaString = Json.stringify(meta);
        var metaBytes = Bytes.ofString(metaString);
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
            dataSize: data.length, 
            data: data,
            crc32: Crc32.make(data),
            compressed: false, 
            fileTime: Date.now(),
            extraFields: null
        };
    }

    public static function unpack(bytes:Bytes):{csv:String, meta:Dynamic} {
        try {
            var input = new BytesInput(bytes);
            var reader = new Reader(input);
            var entries = reader.read();

            var result = {csv: "", meta: null};

            for (entry in entries) {
                var content:String = "";
                
                if (entry.compressed) {
                    content = haxe.zip.Uncompress.run(entry.data).toString();
                } else {
                    content = entry.data.toString();
                }

                if (entry.fileName == "data.csv") {
                    result.csv = content;
                } else if (entry.fileName == "meta.json") {
                    result.meta = Json.parse(content);
                }
            }
            return result;
        } catch (e:Dynamic) {
            trace("Error unpacking level: " + e);
            return null;
        }
    }
}
