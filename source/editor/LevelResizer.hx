package editor;

class LevelResizer {
    public static function resize(oldData:Array<Int>, oldW:Int, oldH:Int, newW:Int, newH:Int):Array<Int> {
        var newData:Array<Int> = [];
        
        for (i in 0...(newW * newH)) {
            newData.push(0);
        }

        var copyW = Std.int(Math.min(oldW, newW));
        var copyH = Std.int(Math.min(oldH, newH));

        for (row in 0...copyH) {
            for (col in 0...copyW) {
                var oldIndex = row * oldW + col;
                var newIndex = row * newW + col;
                newData[newIndex] = oldData[oldIndex];
            }
        }

        return newData;
    }
}