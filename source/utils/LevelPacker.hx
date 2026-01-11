package utils;

import haxe.io.Bytes;
import haxe.zip.Entry;
import haxe.zip.Writer;
import sys.io.File;
import haxe.io.BytesOutput;
import haxe.crypto.Crc32;

class LevelPacker {
    public static function saveLevel(fileName:String, csvContent:String, metaContent:String):Bool {
        if (fileName == null || csvContent == null || metaContent == null) return false;

        if (!StringTools.endsWith(fileName, ".fcba2lvl")) {
            fileName += ".fcba2lvl";
        }

        try {
            var entries:List<Entry> = new List<Entry>();

            var csvBytes = Bytes.ofString(csvContent);
            var csvEntry:Entry = {
                fileName: "level_data.csv",
                fileSize: csvBytes.length,
                fileTime: Date.now(),
                compressed: false,
                dataSize: csvBytes.length,
                data: csvBytes,
                crc32: Crc32.make(csvBytes)
            };
            entries.add(csvEntry);

            var metaBytes = Bytes.ofString(metaContent);
            var metaEntry:Entry = {
                fileName: "metadata.json",
                fileSize: metaBytes.length,
                fileTime: Date.now(),
                compressed: false,
                dataSize: metaBytes.length,
                data: metaBytes,
                crc32: Crc32.make(metaBytes)
            };
            entries.add(metaEntry);

            var output = new BytesOutput();
            var writer = new Writer(output);

            writer.write(entries);

            // Only for desktop/mobile targets, not web targets like HTML5
            File.saveBytes(fileName, output.getBytes());

            trace("Successfully saved level pack to: " + fileName);
            return true;
        } catch (e:Dynamic) {
            trace("Error saving level pack: " + e);
            return false;
        }
    }
}