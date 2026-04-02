package editor;

class EditorHistory {
    var undoStack:Array<Array<Int>> = [];
    var redoStack:Array<Array<Int>> = [];
    var maxHistory:Int = 30;

    public function new() {}

    public function save(data:Array<Int>):Void {
        if (undoStack.length > 0 && compare(data, undoStack[undoStack.length - 1])) return;

        undoStack.push(data.copy());
        if (undoStack.length > maxHistory) undoStack.shift();
        
        redoStack = [];
    }

    public function undo(currentData:Array<Int>):Array<Int> {
        if (undoStack.length == 0) return currentData;
        
        redoStack.push(currentData.copy());
        return undoStack.pop();
    }

    public function redo(currentData:Array<Int>):Array<Int> {
        if (redoStack.length == 0) return currentData;
        
        undoStack.push(currentData.copy());
        return redoStack.pop();
    }

    function compare(a:Array<Int>, b:Array<Int>):Bool {
        if (a.length != b.length) return false;
        for (i in 0...a.length) if (a[i] != b[i]) return false;
        return true;
    }
}