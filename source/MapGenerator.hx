package;

class MapGenerator {
    public static function generateDefaultArray():Array<Int> {
        var data:Array<Int> = [];
        for (y in 0...Level.LEVEL_HEIGHT) {
            for (x in 0...Level.LEVEL_WIDTH) {
                var tileIndex = 0;

                if (x == 0 || x == Level.LEVEL_WIDTH - 1 || y == 0 || y == Level.LEVEL_HEIGHT - 1) {
                    tileIndex = 1;
                } else if (y == Level.LEVEL_HEIGHT - 5 && x > 5 && x < Level.LEVEL_WIDTH - 5) {
                    tileIndex = 1;
                } else if (y == Level.LEVEL_HEIGHT - 10 && x > 10 && x < 15) {
                    tileIndex = 1;
                }
                data.push(tileIndex);
            }
        }
        return data;
    }

    public static function arrayToCSV(data:Array<Int>, width:Int):String {
        var csv = "";
        for (i in 0...data.length) {
            csv += data[i];
            if ((i + 1) % width == 0) csv += "\n";
            else csv += ",";
        }
        return csv;
    }
}