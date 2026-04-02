package editor;

import level.Level;

class FloodFill {
    public static function fill(data:Array<Int>, x:Int, y:Int, targetTile:Int, fillTile:Int):Void {
        if (targetTile == fillTile) return;
        if (x < 0 || x >= Level.LEVEL_WIDTH || y < 0 || y >= Level.LEVEL_HEIGHT) return;
        
        var index = y * Level.LEVEL_WIDTH + x;
        if (data[index] != targetTile) return;

        data[index] = fillTile;

        fill(data, x + 1, y, targetTile, fillTile);
        fill(data, x - 1, y, targetTile, fillTile);
        fill(data, x, y + 1, targetTile, fillTile);
        fill(data, x, y - 1, targetTile, fillTile);
    }
}